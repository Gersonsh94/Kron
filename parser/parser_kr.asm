; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_parser_TOK_EOF: dq 0
section .text
section .data
__g_parser_TOK_IDENTIFIER: dq 1
section .text
section .data
__g_parser_TOK_INTEGER: dq 2
section .text
section .data
__g_parser_TOK_FLOAT: dq 3
section .text
section .data
__g_parser_TOK_STRING: dq 4
section .text
section .data
__g_parser_TOK_HEX: dq 5
section .text
section .data
__g_parser_TOK_BOOLEAN: dq 6
section .text
section .data
__g_parser_TOK_EXPECT_EXPR: dq 98
section .text
section .data
__g_parser_TOK_LBRACE: dq 10
section .text
section .data
__g_parser_TOK_RBRACE: dq 11
section .text
section .data
__g_parser_TOK_LPAREN: dq 12
section .text
section .data
__g_parser_TOK_RPAREN: dq 13
section .text
section .data
__g_parser_TOK_LBRACKET: dq 14
section .text
section .data
__g_parser_TOK_RBRACKET: dq 15
section .text
section .data
__g_parser_TOK_SEMICOLON: dq 16
section .text
section .data
__g_parser_TOK_COLON: dq 17
section .text
section .data
__g_parser_TOK_COMMA: dq 18
section .text
section .data
__g_parser_TOK_DOT: dq 19
section .text
section .data
__g_parser_TOK_ASSIGN: dq 20
section .text
section .data
__g_parser_TOK_ARROW: dq 21
section .text
section .data
__g_parser_TOK_DOUBLE_COLON: dq 22
section .text
section .data
__g_parser_TOK_PLUS: dq 30
section .text
section .data
__g_parser_TOK_MINUS: dq 31
section .text
section .data
__g_parser_TOK_STAR: dq 32
section .text
section .data
__g_parser_TOK_SLASH: dq 33
section .text
section .data
__g_parser_TOK_PERCENT: dq 34
section .text
section .data
__g_parser_TOK_AMPERSAND: dq 35
section .text
section .data
__g_parser_TOK_PIPE: dq 36
section .text
section .data
__g_parser_TOK_CARET: dq 37
section .text
section .data
__g_parser_TOK_TILDE: dq 38
section .text
section .data
__g_parser_TOK_LSHIFT: dq 39
section .text
section .data
__g_parser_TOK_RSHIFT: dq 40
section .text
section .data
__g_parser_TOK_EQ: dq 41
section .text
section .data
__g_parser_TOK_NEQ: dq 42
section .text
section .data
__g_parser_TOK_LT: dq 43
section .text
section .data
__g_parser_TOK_GT: dq 44
section .text
section .data
__g_parser_TOK_LTE: dq 45
section .text
section .data
__g_parser_TOK_GTE: dq 46
section .text
section .data
__g_parser_TOK_AND: dq 47
section .text
section .data
__g_parser_TOK_OR: dq 48
section .text
section .data
__g_parser_TOK_NOT: dq 49
section .text
section .data
__g_parser_TOK_URSHIFT: dq 50
section .text
section .data
__g_parser_TOK_PLUS_ASSIGN: dq 51
section .text
section .data
__g_parser_TOK_MINUS_ASSIGN: dq 52
section .text
section .data
__g_parser_TOK_STAR_ASSIGN: dq 53
section .text
section .data
__g_parser_TOK_SLASH_ASSIGN: dq 54
section .text
section .data
__g_parser_TOK_XOR_ASSIGN: dq 55
section .text
section .data
__g_parser_KW_VAR: dq 100
section .text
section .data
__g_parser_KW_CONST: dq 101
section .text
section .data
__g_parser_KW_FN: dq 102
section .text
section .data
__g_parser_KW_RETURN: dq 103
section .text
section .data
__g_parser_KW_IF: dq 104
section .text
section .data
__g_parser_KW_ELSE: dq 105
section .text
section .data
__g_parser_KW_LOOP: dq 106
section .text
section .data
__g_parser_KW_IN: dq 107
section .text
section .data
__g_parser_KW_WHILE: dq 108
section .text
section .data
__g_parser_KW_BREAK: dq 109
section .text
section .data
__g_parser_KW_CONTINUE: dq 110
section .text
section .data
__g_parser_KW_PRINT: dq 111
section .text
section .data
__g_parser_KW_RANGE: dq 112
section .text
section .data
__g_parser_KW_TRUE: dq 113
section .text
section .data
__g_parser_KW_FALSE: dq 114
section .text
section .data
__g_parser_KW_NULL: dq 115
section .text
section .data
__g_parser_KW_IMPORT: dq 116
section .text
section .data
__g_parser_KW_FROM: dq 117
section .text
section .data
__g_parser_KW_MODULE: dq 118
section .text
section .data
__g_parser_KW_STRUCT: dq 119
section .text
section .data
__g_parser_KW_ENUM: dq 120
section .text
section .data
__g_parser_KW_NEW: dq 121
section .text
section .data
__g_parser_KW_DELETE: dq 122
section .text
section .data
__g_parser_KW_FOR: dq 123
section .text
section .data
__g_parser_KW_PRINTC: dq 124
section .text
section .data
__g_parser_KW_U8: dq 130
section .text
section .data
__g_parser_KW_U16: dq 131
section .text
section .data
__g_parser_KW_U32: dq 132
section .text
section .data
__g_parser_KW_U64: dq 133
section .text
section .data
__g_parser_KW_I8: dq 134
section .text
section .data
__g_parser_KW_I16: dq 135
section .text
section .data
__g_parser_KW_I32: dq 136
section .text
section .data
__g_parser_KW_I64: dq 137
section .text
section .data
__g_parser_KW_F32: dq 138
section .text
section .data
__g_parser_KW_F64: dq 139
section .text
section .data
__g_parser_KW_BOOL: dq 140
section .text
section .data
__g_parser_KW_STR: dq 141
section .text
section .data
__g_parser_KW_VOID: dq 142
section .text
section .data
__g_parser_KW_BOOT_SEQUENCE: dq 200
section .text
section .data
__g_parser_KW_MMU_CONFIGURATION: dq 201
section .text
section .data
__g_parser_KW_SCHEDULER_DOMAIN: dq 202
section .text
section .data
__g_parser_KW_SYSCALL_DISPATCH: dq 203
section .text
section .data
__g_parser_KW_FILESYSTEM_VOLUME: dq 204
section .text
section .data
__g_parser_KW_NETWORK_KERNEL: dq 205
section .text
section .data
__g_parser_KW_HARDWARE_DRIVER: dq 206
section .text
section .data
__g_parser_KW_INTERRUPT_SERVICE: dq 207
section .text
section .data
__g_parser_KW_DMA_CHANNEL: dq 208
section .text
section .data
__g_parser_KW_SECURITY_RING: dq 209
section .text
section .data
__g_parser_KW_KRON3D_CONTEXT: dq 301
section .text
section .data
__g_parser_KW_KRON_ISA: dq 500
section .text
section .data
__g_parser_KW_EXECUTION_MODEL: dq 502
section .text
section .data
__g_parser_KW_KERNEL_ARCHITECTURE: dq 503
section .text
section .data
__g_parser_KW_SECURITY_MODEL: dq 504
section .text
section .data
__g_parser_KW_KRON_HYPERVISOR: dq 505
section .text
section .data
__g_parser_KW_DEPLOYMENT_MODEL: dq 506
section .text
section .data
__g_parser_KW_HUMAN_MACHINE: dq 507
section .text
section .data
__g_parser_KW_POWER_MANAGER: dq 508
section .text
section .data
__g_parser_KW_PACKAGE_MANAGER: dq 509
section .text
section .data
__g_parser_KW_GLOBAL_VISIBLE: dq 510
section .text
section .data
__g_parser_KW_DOMAIN_ISOLATED: dq 511
section .text
section .data
__g_parser_KW_INTER_CLUSTER_EXPORT: dq 513
section .text
section .data
__g_parser_KW_OUTB: dq 520
section .text
section .data
__g_parser_KW_INB: dq 521
section .text
section .data
__g_parser_KW_POKE: dq 522
section .text
section .data
__g_parser_KW_PEEK: dq 523
section .text
section .data
__g_parser_KW_ASM: dq 524
section .text
section .data
__g_parser_KW_POKE8: dq 525
section .text
section .data
__g_parser_KW_POKE16: dq 526
section .text
section .data
__g_parser_KW_POKE32: dq 527
section .text
section .data
__g_parser_KW_PEEK8: dq 528
section .text
section .data
__g_parser_KW_PEEK16: dq 529
section .text
section .data
__g_parser_KW_PEEK32: dq 530
section .text
section .data
__g_parser_KW_EXECUTABLE_LOADER: dq 531
section .text
section .data
__g_parser_KW_PTR: dq 532
section .text
section .data
__g_parser_KW_CALL: dq 533
section .text
section .data
__g_parser_KW_TRUNC: dq 534
section .text
section .data
__g_parser_KW_SAVEFILE: dq 535
section .text
section .data
__g_parser_KW_READKEY: dq 536
section .text
section .data
__g_parser_KW_BEEP: dq 537
section .text
section .data
__g_parser_KW_READMOUSE: dq 538
section .text
section .data
__g_parser_KW_MOUSEX: dq 539
section .text
section .data
__g_parser_KW_MOUSEY: dq 540
section .text
section .data
__g_parser_KW_ARENA_TOKEN: dq 541
section .text
section .data
__g_parser_KW_ROTL: dq 542
section .text
section .data
__g_parser_KW_ROTR: dq 543
section .text
section .data
__g_parser_KW_INVCACHE: dq 544
section .text
section .data
__g_parser_KW_PREFETCH0: dq 545
section .text
section .data
__g_parser_KW_KRON_PROGRAM: dq 546
section .text
section .data
__g_parser_KW_KRON_IMPORTS: dq 547
section .text
section .data
__g_parser_KW_KRON_DEFINITIONS: dq 548
section .text
section .data
__g_parser_KW_KRON_DOMAIN: dq 549
section .text
section .data
__g_parser_KW_EPOCH: dq 550
section .text
section .data
__g_parser_KW_ALIASED: dq 551
section .text
section .data
__g_parser_KW_SWITCH: dq 552
section .text
section .data
__g_parser_KW_CASE: dq 553
section .text
section .data
__g_parser_KW_DEFAULT: dq 554
section .text
section .data
__g_parser_KW_AS: dq 555
section .text
section .data
__g_parser_KW_FAIL: dq 556
section .text
section .data
__g_parser_KW_HINT: dq 557
section .text
section .data
__g_parser_KW_FAILED: dq 558
section .text
section .data
__g_parser_KW_PRINTFAIL: dq 559
section .text
section .data
__g_parser_KW_SIZEOF: dq 560
section .text
section .data
__g_parser_KW_VEC2_LOAD: dq 561
section .text
section .data
__g_parser_KW_VEC2_STORE: dq 562
section .text
section .data
__g_parser_KW_VEC2_ADD: dq 563
section .text
section .data
__g_parser_KW_VEC2_SUB: dq 564
section .text
section .data
__g_parser_KW_VEC2_MUL: dq 565
section .text
section .data
__g_parser_KW_LOADFILE: dq 566
section .text
section .data
__g_parser_KW_THREAD_START: dq 567
section .text
section .data
__g_parser_KW_THREAD_WAIT: dq 568
section .text
section .data
__g_parser_KW_LOCK_INIT: dq 569
section .text
section .data
__g_parser_KW_LOCK_TAKE: dq 570
section .text
section .data
__g_parser_KW_LOCK_GIVE: dq 571
section .text
section .data
__g_parser_KW_CPU_COUNT: dq 572
section .text
section .data
__g_parser_KW_TICKS: dq 573
section .text
section .data
__g_parser_KW_TICKS_PER_SEC: dq 574
section .text
section .data
__g_parser_KW_RAW: dq 575
section .text
section .data
__g_parser_KW_SLICE: dq 576
section .text
section .data
__g_parser_KW_THREAD_YIELD: dq 577
section .text
section .data
__g_parser_KW_SHARED: dq 578
section .text
section .data
__g_parser_KW_DLL_LOAD: dq 579
section .text
section .data
__g_parser_KW_DLL_PROC: dq 580
section .text
section .data
__g_parser_KW_ARG_COUNT: dq 581
section .text
section .data
__g_parser_KW_ARG_GET: dq 582
section .text
section .data
__g_parser_KW_TARGET_OS: dq 583
section .text
section .data
__g_parser_KW_EXTERN: dq 584
section .text
section .data
__g_parser_AST_NODE_SIZE: dq 56
section .text
section .data
__g_parser_VIS_DEFAULT: dq 0
section .text
section .data
__g_parser_VIS_EXPORTED: dq 1
section .text
section .data
__g_parser_AST_PROGRAM: dq 1000
section .text
section .data
__g_parser_AST_FUNCTION: dq 1001
section .text
section .data
__g_parser_AST_BLOCK: dq 1002
section .text
section .data
__g_parser_AST_VAR_DECL: dq 1003
section .text
section .data
__g_parser_AST_ASSIGN: dq 1005
section .text
section .data
__g_parser_AST_BINOP: dq 1006
section .text
section .data
__g_parser_AST_UNOP: dq 1007
section .text
section .data
__g_parser_AST_CALL: dq 1008
section .text
section .data
__g_parser_AST_RETURN: dq 1009
section .text
section .data
__g_parser_AST_IF: dq 1010
section .text
section .data
__g_parser_AST_WHILE: dq 1011
section .text
section .data
__g_parser_AST_BREAK: dq 1013
section .text
section .data
__g_parser_AST_CONTINUE: dq 1014
section .text
section .data
__g_parser_AST_IDENTIFIER: dq 1015
section .text
section .data
__g_parser_AST_INTEGER_LIT: dq 1016
section .text
section .data
__g_parser_AST_FLOAT_LIT: dq 1017
section .text
section .data
__g_parser_AST_STRING_LIT: dq 1018
section .text
section .data
__g_parser_AST_BOOL_LIT: dq 1019
section .text
section .data
__g_parser_AST_STRUCT_DEF: dq 1020
section .text
section .data
__g_parser_AST_ENUM_DEF: dq 1021
section .text
section .data
__g_parser_AST_HARDWARE_BLOCK: dq 1024
section .text
section .data
__g_parser_AST_PRINT: dq 1025
section .text
section .data
__g_parser_AST_PRINTC: dq 1061
section .text
section .data
__g_parser_AST_ISA_DEF: dq 1030
section .text
section .data
__g_parser_AST_ISA_ENTRY: dq 1031
section .text
section .data
__g_parser_AST_BOOT_DEF: dq 1032
section .text
section .data
__g_parser_AST_BOOT_REG: dq 1033
section .text
section .data
__g_parser_AST_MMU_DEF: dq 1034
section .text
section .data
__g_parser_AST_MMU_LEVEL: dq 1035
section .text
section .data
__g_parser_AST_ISR_DEF: dq 1036
section .text
section .data
__g_parser_AST_CFG_DEF: dq 1037
section .text
section .data
__g_parser_AST_CFG_ENTRY: dq 1038
section .text
section .data
__g_parser_AST_SCHED_DEF: dq 1039
section .text
section .data
__g_parser_AST_SYS_DEF: dq 1040
section .text
section .data
__g_parser_AST_SYS_ENTRY: dq 1041
section .text
section .data
__g_parser_AST_OUTB: dq 1042
section .text
section .data
__g_parser_AST_INB: dq 1043
section .text
section .data
__g_parser_AST_POKE: dq 1044
section .text
section .data
__g_parser_AST_PEEK: dq 1045
section .text
section .data
__g_parser_AST_TRUNC: dq 1062
section .text
section .data
__g_parser_AST_SAVEFILE: dq 1063
section .text
section .data
__g_parser_AST_READKEY: dq 1064
section .text
section .data
__g_parser_AST_BEEP: dq 1065
section .text
section .data
__g_parser_AST_READMOUSE: dq 1066
section .text
section .data
__g_parser_AST_MOUSEX: dq 1067
section .text
section .data
__g_parser_AST_MOUSEY: dq 1068
section .text
section .data
__g_parser_AST_ASM: dq 1046
section .text
section .data
__g_parser_AST_INDEX: dq 1047
section .text
section .data
__g_parser_AST_ADDR_OF: dq 1048
section .text
section .data
__g_parser_AST_DEREF: dq 1049
section .text
section .data
__g_parser_AST_POKE8: dq 1050
section .text
section .data
__g_parser_AST_POKE16: dq 1051
section .text
section .data
__g_parser_AST_POKE32: dq 1052
section .text
section .data
__g_parser_AST_PEEK8: dq 1053
section .text
section .data
__g_parser_AST_PEEK16: dq 1054
section .text
section .data
__g_parser_AST_PEEK32: dq 1055
section .text
section .data
__g_parser_AST_PARAM: dq 1056
section .text
section .data
__g_parser_AST_ARG: dq 1057
section .text
section .data
__g_parser_AST_FIELD: dq 1058
section .text
section .data
__g_parser_AST_MEMBER: dq 1059
section .text
section .data
__g_parser_AST_CALL_INDIRECT: dq 1060
section .text
section .data
__g_parser_AST_ARENA_ENTRY: dq 1069
section .text
section .data
__g_parser_ARENA_GROWTH_FIXED: dq 0
section .text
section .data
__g_parser_ARENA_GROWTH_DOUBLING: dq 1
section .text
section .data
__g_parser_ARENA_GROWTH_LINEAR: dq 2
section .text
section .data
__g_parser_ARENA_GROWTH_LAZY: dq 3
section .text
section .data
__g_parser_AST_MMU_ENTRY: dq 1070
section .text
section .data
__g_parser_MMU_ENTRY_CACHE: dq 0
section .text
section .data
__g_parser_MMU_ENTRY_NUMA: dq 1
section .text
section .data
__g_parser_MMU_ENTRY_GC: dq 2
section .text
section .data
__g_parser_MMU_ENTRY_PGFAULT: dq 3
section .text
section .data
__g_parser_MMU_ENTRY_OOM: dq 4
section .text
section .data
__g_parser_MMU_ENTRY_POOL: dq 5
section .text
section .data
__g_parser_AST_POOL_DIR: dq 1071
section .text
section .data
__g_parser_POOL_DIR_CLASS: dq 0
section .text
section .data
__g_parser_POOL_DIR_COMPACT: dq 1
section .text
section .data
__g_parser_POOL_DIR_GRAN: dq 2
section .text
section .data
__g_parser_POOL_DIR_ONALLOC: dq 3
section .text
section .data
__g_parser_POOL_DIR_ONFREE: dq 4
section .text
section .data
__g_parser_ALLOC_BUDDY: dq 0
section .text
section .data
__g_parser_ALLOC_SLAB: dq 1
section .text
section .data
__g_parser_ALLOC_BUMP: dq 2
section .text
section .data
__g_parser_ALLOC_FREELIST: dq 3
section .text
section .data
__g_parser_ALLOC_PREDICTIVE: dq 4
section .text
section .data
__g_parser_AST_BOOT_ENTRY: dq 1072
section .text
section .data
__g_parser_AST_CAST: dq 1073
section .text
section .data
__g_parser_AST_STRUCT_LIT: dq 1074
section .text
section .data
__g_parser_AST_FINIT: dq 1075
section .text
section .data
__g_parser_AST_FAIL: dq 1076
section .text
section .data
__g_parser_AST_FAILED: dq 1077
section .text
section .data
__g_parser_AST_PRINTFAIL: dq 1078
section .text
section .data
__g_parser_AST_SIZEOF: dq 1079
section .text
section .data
__g_parser_AST_ARRAY_LIT: dq 1080
section .text
section .data
__g_parser_AST_VEC2_LOAD: dq 1081
section .text
section .data
__g_parser_AST_VEC2_STORE: dq 1082
section .text
section .data
__g_parser_AST_VEC2_ADD: dq 1083
section .text
section .data
__g_parser_AST_VEC2_SUB: dq 1084
section .text
section .data
__g_parser_AST_VEC2_MUL: dq 1085
section .text
section .data
__g_parser_AST_LOADFILE: dq 1086
section .text
section .data
__g_parser_AST_THREAD_START: dq 1087
section .text
section .data
__g_parser_AST_THREAD_WAIT: dq 1088
section .text
section .data
__g_parser_AST_LOCK_INIT: dq 1089
section .text
section .data
__g_parser_AST_LOCK_TAKE: dq 1090
section .text
section .data
__g_parser_AST_LOCK_GIVE: dq 1091
section .text
section .data
__g_parser_AST_CPU_COUNT: dq 1092
section .text
section .data
__g_parser_AST_TICKS: dq 1093
section .text
section .data
__g_parser_AST_TICKS_PER_SEC: dq 1094
section .text
section .data
__g_parser_AST_THREAD_YIELD: dq 1095
section .text
section .data
__g_parser_AST_DLL_LOAD: dq 1096
section .text
section .data
__g_parser_AST_DLL_PROC: dq 1097
section .text
section .data
__g_parser_AST_ARG_COUNT: dq 1098
section .text
section .data
__g_parser_AST_ARG_GET: dq 1099
section .text
section .data
__g_parser_AST_TARGET_OS: dq 1100
section .text
section .data
__g_parser_AST_LAMBDA: dq 1102
section .text
section .data
__g_parser_AST_EXTERN: dq 1103
section .text
section .data
__g_parser_AST_MULTI: dq 1101
section .text
section .data
__g_parser_BLOCK_SPLICE: dq 0x53504C
section .text
section .data
__g_parser_PGFLAG_RW_KERNEL: dq 0
section .text
section .data
__g_parser_PGFLAG_RO_USER: dq 1
section .text
section .data
__g_parser_PGFLAG_EXEC_DIS: dq 2
section .text
section .data
__g_parser_PGFLAG_CACHE_BYPASS: dq 3
section .text
section .data
__g_parser_CACHE_WRITE_BACK: dq 0
section .text
section .data
__g_parser_CACHE_WRITE_THROUGH: dq 1
section .text
section .data
__g_parser_GC_MANUAL_ONLY: dq 0
section .text
section .data
__g_parser_GC_REF_COUNTED: dq 1
section .text
section .data
__g_parser_GC_MARK_SWEEP: dq 2
section .text
section .data
__g_parser_GC_GENERATIONAL: dq 3
section .text
section .data
__g_parser_CFG_HANDLER_MARK: dq 0xFFFF
section .text
section .data
__g_parser_BLOCK_RAW: dq 0x524157
section .text
section .data
__g_parser_SLICE_GET_MARK: dq 0x534C4943
section .text
section .data
__g_parser_AST_SYSCALL: dq 29
section .text
section .data
__g_parser_PRS_TOK: dq 24
section .text
section .data
__g_parser_par_tokens: dq 0
section .text
section .data
__g_parser_par_token_count: dq 0
section .text
section .data
__g_parser_par_pos: dq 0
section .text
section .data
__g_parser_par_ast_buf: dq 0
section .text
section .data
__g_parser_par_arena_ptr: dq 0
section .text
section .data
__g_parser_par_arena_end: dq 0
section .text
section .data
__g_parser_par_ast_root: dq 0
section .text
section .data
__g_parser_par_last_array_len: dq 0
section .text
section .data
__g_parser_par_last_row_len: dq 0
section .text
section .data
__g_parser_par_last_arr_elem: dq 0
section .text
section .data
__g_parser_par_last_ptr_elem: dq 0
section .text
section .data
__g_parser_par_last_ptr_tok: dq 0
section .text
section .data
__g_parser_par_last_is_float: dq 0
section .text
section .data
__g_parser_par_last_is_unsigned: dq 0
section .text
section .data
__g_parser_par_last_is_slice: dq 0
section .text
section .data
__g_parser_par_last_vtag: dq 0
section .text
section .data
__g_parser_par_last_coll_stok: dq 0
section .text
section .data
__g_parser_par_fn_rettok: dq 0
section .text
section .data
__g_parser_pending_ret_float: dq 0
section .text
section .data
__g_parser_par_multi: dq 0
section .text
section .data
__g_parser_par_in_fn: dq 0
section .text
section .data
__g_parser_par_decl_typed: dq 0
section .text
section .data
__g_parser_par_extern_mode: dq 0
section .text
section .data
__g_parser_par_variadic: dq 0
section .text
section .data
__g_parser_mt_first_float: dq 0
section .text
section .data
__g_parser_mt_first_uns: dq 0
section .text
section .data
__g_parser_par_expected: dq 0
section .text
section .data
__g_parser_par_custom_msg: dq 0
section .text
section .bss
__g_parser_tn_kwbuf: resq 8
section .text
section .data
__g_parser_par_cfg_depth: dq 0
section .text
section .data
__g_parser_par_thread_node: dq 0
section .text
section .data
__g_parser_par_no_slit: dq 0
section .text
section .data
__g_parser_par_stmt_kw: dq 0
section .text
section .data
__g_parser_par_hdr_phase: dq 0
section .text
section .data
__g_parser_par_arn_tail: dq 0
section .text
section .data
__g_parser_par_mmu_tail: dq 0
section .text
section .data
__g_parser_par_pool_tail: dq 0
section .text
section .data
__g_parser_par_pool_node: dq 0
section .text
section .data
__g_parser_par_pool_kind: dq 0
section .text
section .data
__g_parser_par_boot_tail: dq 0
section .text
section .data
__g_parser_prs_mmu_levels: dq 0
section .text
section .data
__g_parser_prs_chain_head: dq 0
section .text
section .data
__g_parser_prs_chain_tail: dq 0
section .text
section .bss
__g_parser_par_slice_toks: resq 64
section .text
section .bss
__g_parser_par_slice_kind: resq 64
section .text
section .bss
__g_parser_par_slice_stok: resq 64
section .text
section .data
__g_parser_par_slice_n: dq 0
section .text
section .bss
__g_parser_par_gcoll_toks: resq 256
section .text
section .bss
__g_parser_par_gcoll_kind: resq 256
section .text
section .bss
__g_parser_par_gcoll_stok: resq 256
section .text
section .data
__g_parser_par_gcoll_n: dq 0
section .text
section .data
__g_parser_par_coll_stok: dq 0
section .text
section .data
__g_parser_par_fi_stok: dq 0
section .text
section .bss
__g_parser_par_ps_decl: resq 8192
section .text
section .bss
__g_parser_par_ps_type: resq 8192
section .text
section .data
__g_parser_par_ps_n: dq 0
section .text
section .bss
__g_parser_par_ls_decl: resq 8192
section .text
section .bss
__g_parser_par_ls_type: resq 8192
section .text
section .data
__g_parser_par_ls_n: dq 0
section .text
section .data
__g_parser_par_used_slice: dq 0
section .text
section .data
__g_parser_par_used_text: dq 0
section .text
section .data
__g_parser_par_used_list: dq 0
section .text
section .data
__g_parser_par_used_map: dq 0
section .text
section .bss
__g_parser_par_fnvt_toks: resq 2048
section .text
section .bss
__g_parser_par_fnvt_tags: resq 2048
section .text
section .data
__g_parser_par_fnvt_n: dq 0
section .text
section .data
__g_parser_par_for_n: dq 0
section .text
section .bss
__g_parser_par_for_toks: resq 12288
section .text
section .bss
__g_parser_par_for_names: resq 8192
section .text
section .data
__g_parser_par_lam_n: dq 0
section .text
section .bss
__g_parser_par_lam_toks: resq 12288
section .text
section .bss
__g_parser_par_lam_names: resq 8192
section .text
section .bss
__g_parser_prs_names: resq 54
section .text
section .bss
__g_parser_prs_eof: resq 3
section .text
section .data
__g_parser_prs_ready: dq 0
section .text
section .data
__g_parser_prs_arg_input: dq 0
section .text
section .data
__g_parser_prs_src_buffer: dq 0
section .text
section .data
__g_parser_prs_lmap_out: dq 0
section .text
section .data
__g_parser_prs_lmap_file: dq 0
section .text
section .data
__g_parser_prs_lmap_count: dq 0
section .text
section .data
__g_parser_PT_SLICE_GET: dq 0
section .text
section .data
__g_parser_PT_SLICE_SET: dq 1
section .text
section .data
__g_parser_PT_SLICER_GET: dq 2
section .text
section .data
__g_parser_PT_SLICER_SET: dq 3
section .text
section .data
__g_parser_PT_LIST_GET: dq 4
section .text
section .data
__g_parser_PT_LIST_SET: dq 5
section .text
section .data
__g_parser_PT_LISTR_GET: dq 6
section .text
section .data
__g_parser_PT_LISTR_SET: dq 7
section .text
section .data
__g_parser_PT_MAP_GET: dq 8
section .text
section .data
__g_parser_PT_MAP_SET: dq 9
section .text
section .data
__g_parser_PT_MAPR_GET: dq 10
section .text
section .data
__g_parser_PT_MAPR_SET: dq 11
section .text
section .data
__g_parser_PT_LISTS_GET: dq 12
section .text
section .data
__g_parser_PT_LISTS_SET: dq 13
section .text
section .data
__g_parser_PT_LIST_LEN: dq 14
section .text
section .data
__g_parser_PT_ONE: dq 15
section .text
section .data
__g_parser_PT_ZERO: dq 16
section .text
section .data
__g_parser_NG_MAXDECL: dq 16384
section .text
section .data
__g_parser_NG_MAXMOD: dq 72
section .text
section .data
__g_parser_NG_MAXT: dq 512
section .text
section .data
__g_parser_NG_MAXI: dq 4096
section .text
section .data
__g_parser_NG_MAXTOK: dq 349500
section .text
section .data
__g_parser_NG_ARGTOK: dq 65536
section .text
section .data
__g_parser_NG_TEXT: dq 1048576
section .text
section .data
__g_parser_ng_tok: dq 0
section .text
section .data
__g_parser_ng_cnt: dq 0
section .text
section .data
__g_parser_ng_err_tok: dq 0
section .text
section .data
__g_parser_ng_err_msg: dq 0
section .text
section .bss
__g_parser_ng_mod_name: resq 72
section .text
section .bss
__g_parser_ng_mod_len: resq 72
section .text
section .bss
__g_parser_ng_mod_alias: resq 72
section .text
section .bss
__g_parser_ng_mod_alen: resq 72
section .text
section .data
__g_parser_ng_nmod: dq 0
section .text
section .bss
__g_parser_ng_tokmod: resq 43688
section .text
section .bss
__g_parser_ng_tokflag: resq 349500
section .text
section .bss
__g_parser_ng_d_tok: resq 16384
section .text
section .bss
__g_parser_ng_d_mod: resq 16384
section .text
section .bss
__g_parser_ng_d_kind: resq 16384
section .text
section .bss
__g_parser_ng_d_dup: resq 16384
section .text
section .data
__g_parser_ng_nd: dq 0
section .text
section .data
__g_parser_ng_anydup: dq 0
section .text
section .bss
__g_parser_ng_t_name: resq 512
section .text
section .bss
__g_parser_ng_t_start: resq 512
section .text
section .bss
__g_parser_ng_t_lt: resq 512
section .text
section .bss
__g_parser_ng_t_body: resq 512
section .text
section .bss
__g_parser_ng_t_end: resq 512
section .text
section .bss
__g_parser_ng_t_np: resq 512
section .text
section .bss
__g_parser_ng_t_par: resq 4096
section .text
section .bss
__g_parser_ng_t_mod: resq 512
section .text
section .bss
__g_parser_ng_t_isfn: resq 512
section .text
section .data
__g_parser_ng_nt: dq 0
section .text
section .bss
__g_parser_ng_i_t: resq 4096
section .text
section .bss
__g_parser_ng_i_name: resq 4096
section .text
section .bss
__g_parser_ng_i_nlen: resq 4096
section .text
section .bss
__g_parser_ng_i_argb: resq 32768
section .text
section .bss
__g_parser_ng_i_argn: resq 32768
section .text
section .bss
__g_parser_ng_i_bodyb: resq 4096
section .text
section .bss
__g_parser_ng_i_bodyn: resq 4096
section .text
section .data
__g_parser_ng_ni: dq 0
section .text
section .bss
__g_parser_ng_args: resq 196608
section .text
section .data
__g_parser_ng_nargs: dq 0
section .text
section .bss
__g_parser_ng_itok: resq 1048500
section .text
section .data
__g_parser_ng_nitok: dq 0
section .text
section .bss
__g_parser_ng_sub: resq 1048500
section .text
section .data
__g_parser_ng_nsub: dq 0
section .text
section .bss
__g_parser_ng_out: resq 1048500
section .text
section .data
__g_parser_ng_nout: dq 0
section .text
section .bss
__g_parser_ng_text: resq 131072
section .text
section .data
__g_parser_ng_ntext: dq 0
section .text
section .data
__g_parser_ng_src: dq 0
section .text
section .data
__g_parser_ng_srcn: dq 0
section .text
section .data
__g_parser_ng_main: dq 0
section .text
section .data
__g_parser_ng_round: dq 0
section .text
section .data
__g_parser_ng_ctxmod: dq 0
section .text
section .data
__g_parser_ng_dst: dq 0
section .text
section .data
__g_parser_ng_dstn: dq 0
section .text
section .bss
__g_parser_ng_mbuf: resq 64
section .text
section .bss
__g_parser_ng_ab: resq 16
section .text
section .data
__g_parser_ng_use_at: dq 0
section .text
section .data
__g_parser_ng_bn_len: dq 0
section .text
section .data
__g_parser_ng_keep_len: dq 0
section .text
section .data
__g_parser_ng_dn_len: dq 0
section .text
section .data
__g_parser_ng_use_next: dq 0
section .text
prs_fu_bits:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_parser_par_last_is_float]
    and rax, 1
    push rax
    mov rax, [rel __g_parser_par_last_is_unsigned]
    and rax, 1
    shl rax, 1
    mov rcx, rax
    pop rax
    or rax, rcx
    jmp .__ret_0
.__ret_0:
    mov rsp, rbp
    pop rbp
    ret
prs_vtag_col:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_parser_par_last_vtag]
    and rax, 255
    shl rax, 8
    jmp .__ret_1
.__ret_1:
    mov rsp, rbp
    pop rbp
    ret
prs_function:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov rax, [rel __g_parser_VIS_DEFAULT]
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_par_fn_rettok], rax
    mov rax, 0
    mov [rel __g_parser_par_slice_n], rax
    mov rax, 1
    mov [rel __g_parser_par_in_fn], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_GLOBAL_VISIBLE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L5
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_INTER_CLUSTER_EXPORT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L5
    mov rax, 0
    jmp .L6
.L5:
    mov rax, 1
.L6:
    test rax, rax
    jz .L3
    mov rax, [rel __g_parser_VIS_EXPORTED]
    mov r14, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L4
.L3:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_DOMAIN_ISOLATED]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L7
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L8
.L7:
.L8:
.L4:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L9
    mov rax, 0
    jmp .__ret_2
    jmp .L10
.L9:
.L10:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r13, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L11
    mov rax, 0
    jmp .__ret_2
    jmp .L12
.L11:
.L12:
    sub rsp, 32
    call prs_param_list
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L13
    mov rax, 0
    jmp .__ret_2
    jmp .L14
.L13:
.L14:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_ARROW]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L17
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_COLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L17
    mov rax, 0
    jmp .L18
.L17:
    mov rax, 1
.L18:
    test rax, rax
    jz .L15
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    mov rax, 0
    mov [rel __g_parser_par_multi], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L19
    sub rsp, 32
    call prs_multi_type
    add rsp, 32
    cmp rax, 0
    jne .L21
    mov rax, 0
    jmp .__ret_2
    jmp .L22
.L21:
.L22:
    jmp .L20
.L19:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L23
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rel __g_parser_par_fn_rettok], rax
    jmp .L24
.L23:
.L24:
    mov rax, r14
    push rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    shl rax, 16
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r14, rax
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L25
    mov rax, 0
    jmp .__ret_2
    jmp .L26
.L25:
.L26:
.L20:
    sub rsp, 32
    call prs_fu_bits
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call prs_vtag_col
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    mov [rel __g_parser_pending_ret_float], rax
    mov rax, [rel __g_parser_par_last_vtag]
    mov rcx, 0xFFFFFFFF
    and rax, rcx
    cmp rax, 0
    je .L27
    mov rax, [rel __g_parser_par_fnvt_n]
    cmp rax, 2048
    jge .L29
    lea rax, [rel __g_parser_par_fnvt_toks]
    push rax
    mov rax, [rel __g_parser_par_fnvt_n]
    push rax
    pop rdx
    pop rcx
    mov r8, r13
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_par_fnvt_tags]
    push rax
    mov rax, [rel __g_parser_par_fnvt_n]
    push rax
    mov rax, [rel __g_parser_par_last_vtag]
    mov rcx, 0xFFFFFFFF
    and rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, [rel __g_parser_par_fnvt_n]
    add rax, 1
    mov [rel __g_parser_par_fnvt_n], rax
    jmp .L30
.L29:
.L30:
    jmp .L28
.L27:
.L28:
    jmp .L16
.L15:
.L16:
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L31
    mov rax, 0
    jmp .__ret_2
    jmp .L32
.L31:
.L32:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L33
    mov rax, 0
    jmp .__ret_2
    jmp .L34
.L33:
.L34:
    mov rax, [rel __g_parser_AST_FUNCTION]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L35
    mov rax, 0
    jmp .__ret_2
    jmp .L36
.L35:
.L36:
    mov rax, r13
    mov rdx, [rbp-40]
    add rdx, 24
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    mov rax, r14
    mov rdx, [rbp-40]
    add rdx, 40
    mov [rdx], rax
    mov rax, [rel __g_parser_pending_ret_float]
    mov rdx, [rbp-40]
    add rdx, 38
    mov [rdx], ax
    mov rax, 0
    mov [rel __g_parser_pending_ret_float], rax
    mov rax, [rel __g_parser_par_multi]
    mov rdx, [rbp-40]
    add rdx, 32
    mov [rdx], eax
    mov rax, 0
    mov [rel __g_parser_par_multi], rax
    mov rax, [rel __g_parser_par_fn_rettok]
    mov rdx, [rbp-40]
    add rdx, 48
    mov [rdx], rax
    mov rax, 0
    mov [rel __g_parser_par_fn_rettok], rax
    mov rax, 0
    mov [rel __g_parser_par_in_fn], rax
    mov rax, [rbp-40]
    jmp .__ret_2
.__ret_2:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
prs_param_list:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L38:
    mov rax, 1
    cmp rax, 1
    jne .L39
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L41
    jmp .L39
    jmp .L42
.L41:
.L42:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L43
    mov rax, 1
    neg rax
    jmp .__ret_37
    jmp .L44
.L43:
.L44:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_DOT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L45
section .data
.str47: db 46,46,46,32,99,111,109,101,115,32,108,97,115,116,32,105,110,32,116,104,101,32,112,97,114,97,109,101,116,101,114,115,32,111,102,32,97,110,32,101,120,116,101,114,110,32,102,110,44,32,97,110,100,32,111,110,108,121,32,116,104,101,114,101
    db 0
section .text
    lea rax, [rel .str47]
    mov [rel __g_parser_par_custom_msg], rax
    mov rax, [rel __g_parser_par_extern_mode]
    cmp rax, 0
    jne .L48
    mov rax, 1
    neg rax
    jmp .__ret_37
    jmp .L49
.L48:
.L49:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_DOT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L50
    mov rax, 1
    neg rax
    jmp .__ret_37
    jmp .L51
.L50:
.L51:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_DOT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L52
    mov rax, 1
    neg rax
    jmp .__ret_37
    jmp .L53
.L52:
.L53:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L54
    mov rax, 1
    neg rax
    jmp .__ret_37
    jmp .L55
.L54:
.L55:
    mov rax, 0
    mov [rel __g_parser_par_custom_msg], rax
    mov rax, 1
    mov [rel __g_parser_par_variadic], rax
    jmp .L39
    jmp .L46
.L45:
.L46:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L56
    mov rax, 1
    neg rax
    jmp .__ret_37
    jmp .L57
.L56:
.L57:
    add r12, 1
    cmp r12, 16
    jle .L58
section .data
.str60: db 97,32,102,117,110,99,116,105,111,110,32,116,97,107,101,115,32,97,116,32,109,111,115,116,32,49,54,32,112,97,114,97,109,101,116,101,114,115,0
section .text
    lea rax, [rel .str60]
    mov [rel __g_parser_par_custom_msg], rax
    mov rax, 1
    neg rax
    jmp .__ret_37
    jmp .L59
.L58:
.L59:
    mov rax, [rel __g_parser_AST_PARAM]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L61
    mov rax, 1
    neg rax
    jmp .__ret_37
    jmp .L62
.L61:
.L62:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L63
    mov rax, [rbp-24]
    mov r13, rax
    jmp .L64
.L63:
    mov rax, [rbp-24]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
.L64:
    mov rax, [rbp-24]
    mov [rbp-16], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L65
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_STR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L69
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L69
    mov rax, 0
    jmp .L70
.L69:
    mov rax, 1
.L70:
    test rax, rax
    jz .L67
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    jmp .L68
.L67:
.L68:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 48
    mov [rdx], rax
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L71
    mov rax, 1
    neg rax
    jmp .__ret_37
    jmp .L72
.L71:
.L72:
    mov rdx, [rbp-16]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call par_note_pstruct
    add rsp, 32
    sub rsp, 32
    call prs_fu_bits
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_par_last_arr_elem]
    and rax, 15
    shl rax, 4
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    sub rsp, 32
    call prs_vtag_col
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rdx, [rbp-16]
    add rdx, 38
    mov [rdx], ax
    mov rdx, [rbp-16]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call par_coll_of_vtag
    add rsp, 32
    mov rax, [rel __g_parser_par_last_array_len]
    mov rdx, [rbp-16]
    add rdx, 40
    mov [rdx], rax
    mov rax, [rel __g_parser_par_last_ptr_elem]
    mov rdx, [rbp-16]
    add rdx, 32
    mov [rdx], eax
    mov rax, [rel __g_parser_par_last_is_slice]
    cmp rax, 0
    je .L73
    mov rdx, [rbp-16]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call par_slice_add
    add rsp, 32
    jmp .L74
.L73:
.L74:
    jmp .L66
.L65:
.L66:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L75
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L76
.L75:
.L76:
.L40:
    jmp .L38
.L39:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, r13
    jmp .__ret_37
.__ret_37:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_arg_list:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L78:
    mov rax, 1
    cmp rax, 1
    jne .L79
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L81
    jmp .L79
    jmp .L82
.L81:
.L82:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L83
    mov rax, 1
    neg rax
    jmp .__ret_77
    jmp .L84
.L83:
.L84:
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L85
    mov rax, 1
    neg rax
    jmp .__ret_77
    jmp .L86
.L85:
.L86:
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L87
    mov rax, 1
    neg rax
    jmp .__ret_77
    jmp .L88
.L87:
.L88:
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L89
    mov rax, [rbp-32]
    mov r12, rax
    jmp .L90
.L89:
    mov rax, [rbp-32]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
.L90:
    mov rax, [rbp-32]
    mov [rbp-16], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L91
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L92
.L91:
.L92:
.L80:
    jmp .L78
.L79:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, r12
    jmp .__ret_77
.__ret_77:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
prs_multi_type:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L94:
    mov rax, 1
    cmp rax, 1
    jne .L95
    cmp r14, 4
    jl .L97
    mov rax, 0
    jmp .__ret_93
    jmp .L98
.L97:
.L98:
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L99
    mov rax, 0
    jmp .__ret_93
    jmp .L100
.L99:
.L100:
    cmp r14, 0
    jne .L101
    mov rax, [rel __g_parser_par_last_is_unsigned]
    mov [rel __g_parser_mt_first_uns], rax
    mov rax, [rel __g_parser_par_last_is_float]
    mov [rel __g_parser_mt_first_float], rax
    mov rax, [rel __g_parser_par_last_vtag]
    mov r12, rax
    jmp .L102
.L101:
.L102:
    mov rax, [rel __g_parser_par_last_is_float]
    cmp rax, 0
    je .L103
    mov rax, 16
    mov rcx, r14
    shl rax, cl
    mov rcx, 0xFFFFFFFF
    and rax, rcx
    mov rcx, rax
    mov rax, r13
    or rax, rcx
    mov r13, rax
    jmp .L104
.L103:
.L104:
    mov rax, [rel __g_parser_par_last_vtag]
    and rax, 3
    push rax
    mov rax, [rel __g_parser_par_last_vtag]
    mov rcx, 0xFFFFFFFF
    and rax, rcx
    sar rax, 4
    and rax, 3
    shl rax, 2
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    add rax, 8
    mov rcx, rax
    mov rax, rbx
    shl rax, cl
    mov rcx, 0xFFFFFFFF
    and rax, rcx
    mov rcx, rax
    mov rax, r13
    or rax, rcx
    mov r13, rax
    add r14, 1
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L105
    jmp .L95
    jmp .L106
.L105:
.L106:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L96:
    jmp .L94
.L95:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L107
    mov rax, 0
    jmp .__ret_93
    jmp .L108
.L107:
.L108:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    or r13, r14
    cmp r14, 1
    jle .L109
    mov rax, r13
    mov [rel __g_parser_par_multi], rax
    jmp .L110
.L109:
.L110:
    mov rax, [rel __g_parser_mt_first_float]
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, [rel __g_parser_mt_first_uns]
    mov [rel __g_parser_par_last_is_unsigned], rax
    mov rax, r12
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 1
    jmp .__ret_93
.__ret_93:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
par_note_pstruct:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_parser_par_last_ptr_tok]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L114
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L114
    mov rax, 0
    jmp .L115
.L114:
    mov rax, 1
.L115:
    test rax, rax
    jz .L112
    mov rax, 0
    jmp .__ret_111
    jmp .L113
.L112:
.L113:
    mov rax, [rel __g_parser_par_ps_n]
    cmp rax, 8192
    jge .L116
    lea rax, [rel __g_parser_par_ps_decl]
    push rax
    mov rax, [rel __g_parser_par_ps_n]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_par_ps_type]
    push rax
    mov rax, [rel __g_parser_par_ps_n]
    push rax
    mov rax, [rel __g_parser_par_last_ptr_tok]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, [rel __g_parser_par_ps_n]
    add rax, 1
    mov [rel __g_parser_par_ps_n], rax
    jmp .L117
.L116:
.L117:
    mov rax, 0
    jmp .__ret_111
.__ret_111:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_block:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L119
    mov rax, 0
    jmp .__ret_118
    jmp .L120
.L119:
.L120:
    mov rax, r12
    mov [rbp-16], rax
.L121:
    mov rax, 1
    cmp rax, 1
    jne .L122
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L124
    jmp .L122
    jmp .L125
.L124:
.L125:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L126
    mov rax, 0
    jmp .__ret_118
    jmp .L127
.L126:
.L127:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-40], rax
    mov rdx, [rbp-40]
    add rdx, 20
    movzx eax, word [rdx]
    mov rbx, rax
    sub rsp, 32
    call prs_statement
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L128
    mov rax, 0
    jmp .__ret_118
    jmp .L129
.L128:
.L129:
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 36
    mov [rdx], ax
    mov rdx, [rbp-24]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_AST_BLOCK]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L132
    mov rdx, [rbp-24]
    add rdx, 40
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_BLOCK_SPLICE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L132
    mov rax, 1
    jmp .L133
.L132:
    mov rax, 0
.L133:
    test rax, rax
    jz .L130
    mov rax, 0
    mov rdx, [rbp-24]
    add rdx, 40
    mov [rdx], rax
    mov rdx, [rbp-16]
    add rdx, 8
    mov rax, [rdx]
    cmp rax, 0
    jne .L134
    mov rdx, [rbp-24]
    add rdx, 8
    mov rax, [rdx]
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    mov rdx, [rbp-24]
    add rdx, 16
    mov rax, [rdx]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    jmp .L135
.L134:
    mov rax, [rbp-24]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-24]
    mov [rbp-16], rax
.L135:
.L136:
    mov rdx, [rbp-16]
    add rdx, 16
    mov rax, [rdx]
    cmp rax, 0
    je .L137
    mov rdx, [rbp-16]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-16], rax
.L138:
    jmp .L136
.L137:
    jmp .L131
.L130:
    mov rdx, [rbp-16]
    add rdx, 8
    mov rax, [rdx]
    cmp rax, 0
    jne .L139
    mov rax, [rbp-24]
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    jmp .L140
.L139:
    mov rax, [rel __g_parser_AST_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L141
    mov rax, 0
    jmp .__ret_118
    jmp .L142
.L141:
.L142:
    mov rax, [rbp-24]
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-32]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-32]
    mov [rbp-16], rax
.L140:
.L131:
.L123:
    jmp .L121
.L122:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, r12
    jmp .__ret_118
.__ret_118:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
prs_statement_no_semi:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jne .L144
    mov rax, 0
    jmp .__ret_143
    jmp .L145
.L144:
.L145:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L146
    mov rax, r12
    jmp .__ret_143
    jmp .L147
.L146:
.L147:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L148
    mov rax, 0
    jmp .__ret_143
    jmp .L149
.L148:
.L149:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call par_make_assign
    add rsp, 32
    jmp .__ret_143
.__ret_143:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
prs_statement:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_VAR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L153
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_CONST]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L153
    mov rax, 0
    jmp .L154
.L153:
    mov rax, 1
.L154:
    test rax, rax
    jz .L151
    sub rsp, 32
    call prs_var
    add rsp, 32
    jmp .__ret_150
    jmp .L152
.L151:
.L152:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_OUTB]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L155
    mov rax, [rel __g_parser_AST_OUTB]
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call prs_args_stmt
    add rsp, 32
    jmp .__ret_150
    jmp .L156
.L155:
.L156:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_POKE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L157
    mov rax, [rel __g_parser_AST_POKE]
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call prs_args_stmt
    add rsp, 32
    jmp .__ret_150
    jmp .L158
.L157:
.L158:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_BEEP]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L159
    mov rax, [rel __g_parser_AST_BEEP]
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call prs_args_stmt
    add rsp, 32
    jmp .__ret_150
    jmp .L160
.L159:
.L160:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_SAVEFILE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L161
    mov rax, [rel __g_parser_AST_SAVEFILE]
    push rax
    pop rcx
    mov rdx, 3
    sub rsp, 32
    call prs_args_stmt
    add rsp, 32
    jmp .__ret_150
    jmp .L162
.L161:
.L162:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_POKE8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L163
    mov rax, [rel __g_parser_AST_POKE8]
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call prs_args_stmt
    add rsp, 32
    jmp .__ret_150
    jmp .L164
.L163:
.L164:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_POKE16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L165
    mov rax, [rel __g_parser_AST_POKE16]
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call prs_args_stmt
    add rsp, 32
    jmp .__ret_150
    jmp .L166
.L165:
.L166:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_POKE32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L167
    mov rax, [rel __g_parser_AST_POKE32]
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call prs_args_stmt
    add rsp, 32
    jmp .__ret_150
    jmp .L168
.L167:
.L168:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_ASM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L169
    sub rsp, 32
    call prs_asm
    add rsp, 32
    jmp .__ret_150
    jmp .L170
.L169:
.L170:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_IF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L171
    sub rsp, 32
    call prs_if
    add rsp, 32
    jmp .__ret_150
    jmp .L172
.L171:
.L172:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_SWITCH]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L173
    sub rsp, 32
    call prs_switch
    add rsp, 32
    jmp .__ret_150
    jmp .L174
.L173:
.L174:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_WHILE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L175
    sub rsp, 32
    call prs_while
    add rsp, 32
    jmp .__ret_150
    jmp .L176
.L175:
.L176:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_FOR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L177
    sub rsp, 32
    call prs_for
    add rsp, 32
    jmp .__ret_150
    jmp .L178
.L177:
.L178:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_RAW]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L179
    sub rsp, 32
    call prs_raw
    add rsp, 32
    jmp .__ret_150
    jmp .L180
.L179:
.L180:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_LOOP]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L181
    sub rsp, 32
    call prs_loop
    add rsp, 32
    jmp .__ret_150
    jmp .L182
.L181:
.L182:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_RETURN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L183
    sub rsp, 32
    call prs_return
    add rsp, 32
    jmp .__ret_150
    jmp .L184
.L183:
.L184:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_PRINT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L185
    mov rax, [rel __g_parser_AST_PRINT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_print
    add rsp, 32
    jmp .__ret_150
    jmp .L186
.L185:
.L186:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_PRINTC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L187
    mov rax, [rel __g_parser_AST_PRINTC]
    push rax
    pop rcx
    sub rsp, 32
    call prs_print
    add rsp, 32
    jmp .__ret_150
    jmp .L188
.L187:
.L188:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_FAIL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L189
    sub rsp, 32
    call prs_fail
    add rsp, 32
    jmp .__ret_150
    jmp .L190
.L189:
.L190:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_VEC2_STORE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L191
    sub rsp, 32
    call prs_vec2_store
    add rsp, 32
    jmp .__ret_150
    jmp .L192
.L191:
.L192:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_THREAD_WAIT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L193
    mov rax, [rel __g_parser_AST_THREAD_WAIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_thread_one
    add rsp, 32
    jmp .__ret_150
    jmp .L194
.L193:
.L194:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_THREAD_YIELD]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L195
    sub rsp, 32
    call prs_expr_stmt
    add rsp, 32
    jmp .__ret_150
    jmp .L196
.L195:
.L196:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_LOCK_INIT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L197
    mov rax, [rel __g_parser_AST_LOCK_INIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_thread_one
    add rsp, 32
    jmp .__ret_150
    jmp .L198
.L197:
.L198:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_LOCK_TAKE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L199
    mov rax, [rel __g_parser_AST_LOCK_TAKE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_thread_one
    add rsp, 32
    jmp .__ret_150
    jmp .L200
.L199:
.L200:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_LOCK_GIVE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L201
    mov rax, [rel __g_parser_AST_LOCK_GIVE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_thread_one
    add rsp, 32
    jmp .__ret_150
    jmp .L202
.L201:
.L202:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_PRINTFAIL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L203
    sub rsp, 32
    call prs_printfail
    add rsp, 32
    jmp .__ret_150
    jmp .L204
.L203:
.L204:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_BREAK]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L205
    mov rax, [rel __g_parser_AST_BREAK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_jump
    add rsp, 32
    jmp .__ret_150
    jmp .L206
.L205:
.L206:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_CONTINUE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L207
    mov rax, [rel __g_parser_AST_CONTINUE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_jump
    add rsp, 32
    jmp .__ret_150
    jmp .L208
.L207:
.L208:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L209
    sub rsp, 32
    call prs_block
    add rsp, 32
    jmp .__ret_150
    jmp .L210
.L209:
.L210:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L211
    mov rax, [rel __g_parser_par_pos]
    add rax, 1
    push rax
    mov rax, [rel __g_parser_par_token_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L213
    mov rax, [rel __g_parser_par_pos]
    add rax, 1
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_parser_par_tokens]
    add rax, rcx
    mov [rbp-16], rax
    mov rdx, [rbp-16]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L215
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-16], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, [rbp-16]
    mov rdx, 0
    sub rsp, 32
    call prs_multi_assign
    add rsp, 32
    jmp .__ret_150
    jmp .L216
.L215:
.L216:
    jmp .L214
.L213:
.L214:
    sub rsp, 32
    call prs_expr_stmt
    add rsp, 32
    jmp .__ret_150
    jmp .L212
.L211:
.L212:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_STAR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L217
    sub rsp, 32
    call prs_expr_stmt
    add rsp, 32
    jmp .__ret_150
    jmp .L218
.L217:
.L218:
    mov rax, 0
    jmp .__ret_150
.__ret_150:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_var:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L220
    mov rax, 0
    jmp .__ret_219
    jmp .L221
.L220:
.L221:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r13, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L222
    mov rcx, r13
    mov rdx, 1
    sub rsp, 32
    call prs_multi_assign
    add rsp, 32
    jmp .__ret_219
    jmp .L223
.L222:
.L223:
    mov rax, 0
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    mov rax, 0
    mov [rel __g_parser_par_last_arr_elem], rax
    mov rax, 0
    mov [rel __g_parser_par_last_row_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    mov [rel __g_parser_par_decl_typed], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L224
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_F32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L228
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_F64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L228
    mov rax, 0
    jmp .L229
.L228:
    mov rax, 1
.L229:
    test rax, rax
    jz .L226
    mov rax, 1
    mov [rel __g_parser_par_last_is_float], rax
    jmp .L227
.L226:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_STR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L232
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L232
    mov rax, 0
    jmp .L233
.L232:
    mov rax, 1
.L233:
    test rax, rax
    jz .L230
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r12, rax
    jmp .L231
.L230:
.L231:
.L227:
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L234
    mov rax, 0
    jmp .__ret_219
    jmp .L235
.L234:
.L235:
    mov rcx, r13
    sub rsp, 32
    call par_note_pstruct
    add rsp, 32
    mov rax, 1
    mov [rel __g_parser_par_decl_typed], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L236
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_par_last_array_len]
    mov rbx, rax
    mov rax, [rel __g_parser_AST_VAR_DECL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L238
    mov rax, 0
    jmp .__ret_219
    jmp .L239
.L238:
.L239:
    mov rax, r13
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    mov rax, 0
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 40
    mov [rdx], rax
    mov rax, [rel __g_parser_par_last_row_len]
    mov rdx, [rbp-32]
    add rdx, 48
    mov [rdx], rax
    mov rax, [rel __g_parser_par_last_ptr_elem]
    mov rdx, [rbp-32]
    add rdx, 32
    mov [rdx], eax
    mov rax, [rel __g_parser_par_last_is_slice]
    cmp rax, 0
    je .L240
    mov rcx, r13
    sub rsp, 32
    call par_slice_add
    add rsp, 32
    jmp .L241
.L240:
.L241:
    sub rsp, 32
    call prs_decl_col
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 38
    mov [rdx], ax
    mov rcx, r13
    sub rsp, 32
    call par_coll_of_vtag
    add rsp, 32
    mov rax, [rbp-32]
    jmp .__ret_219
    jmp .L237
.L236:
.L237:
    jmp .L225
.L224:
.L225:
    mov rax, [rel __g_parser_TOK_ASSIGN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L242
    mov rax, 0
    jmp .__ret_219
    jmp .L243
.L242:
.L243:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L244
    mov rax, 0
    jmp .__ret_219
    jmp .L245
.L244:
.L245:
    mov rax, [rel __g_parser_par_decl_typed]
    cmp rax, 0
    jne .L246
    mov rcx, rbx
    sub rsp, 32
    call par_infer_vtag
    add rsp, 32
    jmp .L247
.L246:
.L247:
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L248
    mov rax, 0
    jmp .__ret_219
    jmp .L249
.L248:
.L249:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_VAR_DECL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L250
    mov rax, 0
    jmp .__ret_219
    jmp .L251
.L250:
.L251:
    mov rax, r13
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_par_last_ptr_elem]
    mov rdx, [rbp-32]
    add rdx, 32
    mov [rdx], eax
    mov rax, [rel __g_parser_par_last_is_slice]
    cmp rax, 0
    je .L252
    mov rcx, r13
    sub rsp, 32
    call par_slice_add
    add rsp, 32
    jmp .L253
.L252:
.L253:
    sub rsp, 32
    call prs_decl_col
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 38
    mov [rdx], ax
    mov rcx, r13
    sub rsp, 32
    call par_coll_of_vtag
    add rsp, 32
    mov rax, r12
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rel __g_parser_par_last_array_len]
    mov rdx, [rbp-32]
    add rdx, 40
    mov [rdx], rax
    mov rax, [rel __g_parser_par_last_row_len]
    mov rdx, [rbp-32]
    add rdx, 48
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-32]
    jmp .__ret_219
.__ret_219:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_decl_col:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call prs_fu_bits
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_par_last_arr_elem]
    and rax, 15
    shl rax, 4
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    sub rsp, 32
    call prs_vtag_col
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, [rel __g_parser_par_decl_typed]
    shl rax, 3
    and rax, 0xFFFF
    mov rcx, rax
    pop rax
    or rax, rcx
    jmp .__ret_254
.__ret_254:
    mov rsp, rbp
    pop rbp
    ret
par_infer_vtag:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov [rbp-8], rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rdx, [rbp-8]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_AST_CALL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L256
    mov rax, 0
    jmp .__ret_255
    jmp .L257
.L256:
.L257:
    mov rdx, [rbp-8]
    add rdx, 38
    movzx eax, word [rdx]
    shr rax, 8
    mov r12, rax
    cmp r12, 0
    je .L258
    mov rax, r12
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    jmp .__ret_255
    jmp .L259
.L258:
.L259:
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    mov r12, rax
    cmp r12, 0
    jne .L260
    mov rax, 0
    jmp .__ret_255
    jmp .L261
.L260:
.L261:
.L262:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_par_fnvt_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L263
    lea rax, [rel __g_parser_par_fnvt_toks]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call prs_tok_same
    add rsp, 32
    cmp rax, 1
    jne .L265
    lea rax, [rel __g_parser_par_fnvt_tags]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    jmp .__ret_255
    jmp .L266
.L265:
.L266:
    add rbx, 1
.L264:
    jmp .L262
.L263:
    mov rax, 0
    jmp .__ret_255
.__ret_255:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_multi_assign:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov r12, rcx
    mov r14, rdx
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov [rbp-64], rax
    mov rax, 0
    mov [rbp-72], rax
    mov rax, r12
    mov [rbp-80], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_prs_chain_head], rax
    mov rax, 0
    mov [rel __g_parser_prs_chain_tail], rax
.L268:
    mov rax, 1
    cmp rax, 1
    jne .L269
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L271
    mov rax, 0
    jmp .__ret_267
    jmp .L272
.L271:
.L272:
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L273
    mov rax, rbx
    mov r13, rax
    jmp .L274
.L273:
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
.L274:
    mov rax, rbx
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    mov rdx, [rbp-80]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 1
    jne .L275
    mov rdx, [rbp-80]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    mov rbx, rax
    jmp .L276
.L275:
.L276:
    cmp rbx, 95
    je .L277
    mov rax, [rel __g_parser_AST_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L279
    mov rax, 0
    jmp .__ret_267
    jmp .L280
.L279:
.L280:
    mov rax, [rbp-80]
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-48]
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    cmp r14, 0
    je .L281
    mov rax, [rel __g_parser_AST_VAR_DECL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-56], rax
    mov rax, [rbp-56]
    cmp rax, 0
    jne .L283
    mov rax, 0
    jmp .__ret_267
    jmp .L284
.L283:
.L284:
    mov rax, [rbp-80]
    mov rdx, [rbp-56]
    add rdx, 24
    mov [rdx], rax
    mov rcx, [rbp-56]
    sub rsp, 32
    call prs_chain
    add rsp, 32
    jmp .L282
.L281:
.L282:
    jmp .L278
.L277:
.L278:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L285
    jmp .L269
    jmp .L286
.L285:
.L286:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L287
    mov rax, 0
    jmp .__ret_267
    jmp .L288
.L287:
.L288:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-80], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L270:
    jmp .L268
.L269:
    mov rax, [rel __g_parser_TOK_ASSIGN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L289
    mov rax, 0
    jmp .__ret_267
    jmp .L290
.L289:
.L290:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_prs_chain_head]
    mov r12, rax
    mov rax, [rel __g_parser_prs_chain_tail]
    mov rbx, rax
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov [rbp-64], rax
    mov rax, r12
    mov [rel __g_parser_prs_chain_head], rax
    mov rax, rbx
    mov [rel __g_parser_prs_chain_tail], rax
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L291
    mov rax, 0
    jmp .__ret_267
    jmp .L292
.L291:
.L292:
    mov rdx, [rbp-64]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_AST_CALL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L293
section .data
.str295: db 97,44,32,98,32,61,32,46,46,46,32,116,97,107,101,115,32,116,104,101,32,114,101,115,117,108,116,115,32,111,102,32,97,32,102,117,110,99,116,105,111,110,32,99,97,108,108,0
section .text
    lea rax, [rel .str295]
    mov [rel __g_parser_par_custom_msg], rax
    mov rax, 0
    jmp .__ret_267
    jmp .L294
.L293:
.L294:
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L296
    mov rax, 0
    jmp .__ret_267
    jmp .L297
.L296:
.L297:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_MULTI]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-72], rax
    mov rax, [rbp-72]
    cmp rax, 0
    jne .L298
    mov rax, 0
    jmp .__ret_267
    jmp .L299
.L298:
.L299:
    mov rax, r13
    mov rdx, [rbp-72]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-64]
    mov rdx, [rbp-72]
    add rdx, 16
    mov [rdx], rax
    mov rax, r14
    mov rdx, [rbp-72]
    add rdx, 24
    mov [rdx], rax
    cmp r14, 0
    jne .L300
    mov rax, [rbp-72]
    jmp .__ret_267
    jmp .L301
.L300:
.L301:
    mov rax, [rel __g_parser_par_in_fn]
    cmp rax, 0
    jne .L302
section .data
.str304: db 118,97,114,32,97,44,32,98,32,61,32,102,40,41,32,105,115,32,102,111,114,32,105,110,115,105,100,101,32,97,32,102,117,110,99,116,105,111,110,0
section .text
    lea rax, [rel .str304]
    mov [rel __g_parser_par_custom_msg], rax
    mov rax, 0
    jmp .__ret_267
    jmp .L303
.L302:
.L303:
    mov rcx, [rbp-72]
    sub rsp, 32
    call prs_chain
    add rsp, 32
    mov rax, [rel __g_parser_prs_chain_head]
    mov [rbp-56], rax
    mov rax, [rel __g_parser_BLOCK_SPLICE]
    mov rdx, [rbp-56]
    add rdx, 40
    mov [rdx], rax
    mov rax, [rbp-56]
    jmp .__ret_267
.__ret_267:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov rsp, rbp
    pop rbp
    ret
prs_chain:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov rbx, rcx
    mov rax, [rel __g_parser_AST_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L306
    mov rax, 0
    jmp .__ret_305
    jmp .L307
.L306:
.L307:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rel __g_parser_prs_chain_tail]
    cmp rax, 0
    je .L308
    mov rax, [rel __g_parser_prs_chain_tail]
    mov [rbp-24], rax
    mov rax, [rbp-16]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-16]
    mov [rel __g_parser_prs_chain_tail], rax
    mov rax, 0
    jmp .__ret_305
    jmp .L309
.L308:
.L309:
    mov rax, [rbp-16]
    mov [rel __g_parser_prs_chain_head], rax
    mov rax, [rbp-16]
    mov [rel __g_parser_prs_chain_tail], rax
    mov rax, 0
    jmp .__ret_305
.__ret_305:
    mov rbx, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_if:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-32], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_opt_paren_expr
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L311
    mov rax, 0
    jmp .__ret_310
    jmp .L312
.L311:
.L312:
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L313
    mov rax, 0
    jmp .__ret_310
    jmp .L314
.L313:
.L314:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L315
    mov rax, 0
    jmp .__ret_310
    jmp .L316
.L315:
.L316:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_KW_ELSE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L317
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_KW_IF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L319
    sub rsp, 32
    call prs_statement
    add rsp, 32
    mov rbx, rax
    jmp .L320
.L319:
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L321
    mov rax, 0
    jmp .__ret_310
    jmp .L322
.L321:
.L322:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
.L320:
    cmp rbx, 0
    jne .L323
    mov rax, 0
    jmp .__ret_310
    jmp .L324
.L323:
.L324:
    jmp .L318
.L317:
.L318:
    mov rax, [rel __g_parser_AST_IF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L325
    mov rax, 0
    jmp .__ret_310
    jmp .L326
.L325:
.L326:
    mov rax, r13
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-32]
    jmp .__ret_310
.__ret_310:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_switch:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-64], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L328
    mov rax, 0
    jmp .__ret_327
    jmp .L329
.L328:
.L329:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r13, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L330
    mov rax, 0
    jmp .__ret_327
    jmp .L331
.L330:
.L331:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L332:
    mov rax, 1
    cmp rax, 1
    jne .L333
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_CASE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L335
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L337
    mov rax, 0
    jmp .__ret_327
    jmp .L338
.L337:
.L338:
    mov rax, r13
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L339
    mov rax, 0
    jmp .__ret_327
    jmp .L340
.L339:
.L340:
    mov rax, [rel __g_parser_AST_BINOP]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L341
    mov rax, 0
    jmp .__ret_327
    jmp .L342
.L341:
.L342:
    mov rax, [rbp-32]
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_TOK_EQ]
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L343
    mov rax, 0
    jmp .__ret_327
    jmp .L344
.L343:
.L344:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L345
    mov rax, 0
    jmp .__ret_327
    jmp .L346
.L345:
.L346:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L347
    mov rax, 0
    jmp .__ret_327
    jmp .L348
.L347:
.L348:
    mov rax, [rel __g_parser_AST_IF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-64], rax
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L349
    mov rax, 0
    jmp .__ret_327
    jmp .L350
.L349:
.L350:
    mov rax, [rbp-48]
    mov rdx, [rbp-64]
    add rdx, 24
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-64]
    add rdx, 8
    mov [rdx], rax
    mov rax, 0
    mov rdx, [rbp-64]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L351
    mov rax, [rbp-64]
    mov r12, rax
    jmp .L352
.L351:
    mov rax, [rbp-64]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L352:
    mov rax, [rbp-64]
    mov [rbp-24], rax
    jmp .L336
.L335:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_DEFAULT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L353
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_COLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L355
    mov rax, 0
    jmp .__ret_327
    jmp .L356
.L355:
.L356:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L357
    mov rax, 0
    jmp .__ret_327
    jmp .L358
.L357:
.L358:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L359
    mov rax, 0
    jmp .__ret_327
    jmp .L360
.L359:
.L360:
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L361
    mov rax, 0
    jmp .__ret_327
    jmp .L362
.L361:
.L362:
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L363
    mov rax, 0
    jmp .__ret_327
    jmp .L364
.L363:
.L364:
    jmp .L333
    jmp .L354
.L353:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L365
    jmp .L333
    jmp .L366
.L365:
    mov rax, 0
    jmp .__ret_327
.L366:
.L354:
.L336:
.L334:
    jmp .L332
.L333:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    cmp r12, 0
    jne .L367
    mov rax, 0
    jmp .__ret_327
    jmp .L368
.L367:
.L368:
    mov rax, r12
    jmp .__ret_327
.__ret_327:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
prs_while:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_opt_paren_expr
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L370
    mov rax, 0
    jmp .__ret_369
    jmp .L371
.L370:
.L371:
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L372
    mov rax, 0
    jmp .__ret_369
    jmp .L373
.L372:
.L373:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L374
    mov rax, 0
    jmp .__ret_369
    jmp .L375
.L374:
.L375:
    mov rax, [rel __g_parser_AST_WHILE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L376
    mov rax, 0
    jmp .__ret_369
    jmp .L377
.L376:
.L377:
    mov rax, r12
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-24]
    jmp .__ret_369
.__ret_369:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_loop:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-16], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L379
    mov rax, 0
    jmp .__ret_378
    jmp .L380
.L379:
.L380:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L381
    mov rax, 0
    jmp .__ret_378
    jmp .L382
.L381:
.L382:
    mov rax, [rel __g_parser_AST_WHILE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L383
    mov rax, 0
    jmp .__ret_378
    jmp .L384
.L383:
.L384:
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-16]
    jmp .__ret_378
.__ret_378:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_raw:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L386
    mov rax, 0
    jmp .__ret_385
    jmp .L387
.L386:
.L387:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L388
    mov rax, 0
    jmp .__ret_385
    jmp .L389
.L388:
.L389:
    mov rax, [rel __g_parser_AST_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L390
    mov rax, 0
    jmp .__ret_385
    jmp .L391
.L390:
.L391:
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 8
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_BLOCK_RAW]
    mov rdx, [rbp-24]
    add rdx, 40
    mov [rdx], rax
    mov rax, [rbp-24]
    jmp .__ret_385
.__ret_385:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_for:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov rax, 0
    mov [rbp-8], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov [rbp-64], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L395
    mov rax, [rel __g_parser_par_pos]
    add rax, 1
    push rax
    mov rax, [rel __g_parser_par_token_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L395
    mov rax, 1
    jmp .L396
.L395:
    mov rax, 0
.L396:
    test rax, rax
    jz .L393
    mov rax, [rel __g_parser_par_pos]
    add rax, 1
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_parser_par_tokens]
    add rax, rcx
    mov [rbp-8], rax
    mov rdx, [rbp-8]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_KW_IN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L397
    sub rsp, 32
    call prs_for_in
    add rsp, 32
    jmp .__ret_392
    jmp .L398
.L397:
.L398:
    jmp .L394
.L393:
.L394:
    sub rsp, 32
    call prs_statement
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L399
    mov rax, 0
    jmp .__ret_392
    jmp .L400
.L399:
.L400:
    mov rax, [rel __g_parser_par_no_slit]
    add rax, 1
    mov [rel __g_parser_par_no_slit], rax
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_parser_par_no_slit]
    sub rax, 1
    mov [rel __g_parser_par_no_slit], rax
    cmp r13, 0
    jne .L401
    mov rax, 0
    jmp .__ret_392
    jmp .L402
.L401:
.L402:
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L403
    mov rax, 0
    jmp .__ret_392
    jmp .L404
.L403:
.L404:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_par_no_slit]
    add rax, 1
    mov [rel __g_parser_par_no_slit], rax
    sub rsp, 32
    call prs_statement_no_semi
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_parser_par_no_slit]
    sub rax, 1
    mov [rel __g_parser_par_no_slit], rax
    cmp r12, 0
    jne .L405
    mov rax, 0
    jmp .__ret_392
    jmp .L406
.L405:
.L406:
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L407
    mov rax, 0
    jmp .__ret_392
    jmp .L408
.L407:
.L408:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L409
    mov rax, 0
    jmp .__ret_392
    jmp .L410
.L409:
.L410:
    mov rax, [rel __g_parser_AST_WHILE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L411
    mov rax, 0
    jmp .__ret_392
    jmp .L412
.L411:
.L412:
    mov rax, r13
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-56], rax
    mov rax, [rbp-56]
    cmp rax, 0
    jne .L413
    mov rax, 0
    jmp .__ret_392
    jmp .L414
.L413:
.L414:
    mov rax, r14
    mov rdx, [rbp-56]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-64], rax
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L415
    mov rax, 0
    jmp .__ret_392
    jmp .L416
.L415:
.L416:
    mov rax, [rbp-48]
    mov rdx, [rbp-64]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-64]
    mov rdx, [rbp-56]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-56]
    jmp .__ret_392
.__ret_392:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
prs_make_name:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov r14, rdx
    mov r13, r8
    mov rbx, r9
    mov rax, 0
    mov r12, rax
    mov rax, rbx
    mov rbx, rax
.L418:
    cmp r12, r13
    jge .L419
    mov rax, r15
    add rax, r12
    push rax
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call bset
    add rsp, 32
    add r12, 1
.L420:
    jmp .L418
.L419:
    mov rax, 3
    mov r12, rax
.L421:
    cmp r12, 0
    jl .L422
    mov rax, r15
    add rax, r13
    add rax, r12
    push rax
    mov rax, rbx
    mov rcx, 10
    cqo
    idiv rcx
    mov rax, rdx
    mov rcx, rax
    mov rax, 48
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call bset
    add rsp, 32
    mov rax, rbx
    mov rcx, 10
    cqo
    idiv rcx
    mov rbx, rax
    sub r12, 1
.L423:
    jmp .L421
.L422:
    mov rax, 0
    jmp .__ret_417
.__ret_417:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_for_in:
    push rbp
    mov rbp, rsp
    sub rsp, 288
    mov [rbp-256], rbx
    mov [rbp-248], r12
    mov [rbp-240], r13
    mov [rbp-232], r14
    mov [rbp-224], r15
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-8], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-72], rax
    mov rax, 0
    mov [rbp-80], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-96], rax
    mov rax, 0
    mov [rbp-104], rax
    mov rax, 0
    mov [rbp-112], rax
    mov rax, 0
    mov [rbp-120], rax
    mov rax, 0
    mov [rbp-128], rax
    mov rax, 0
    mov [rbp-136], rax
    mov rax, 0
    mov [rbp-144], rax
    mov rax, 0
    mov [rbp-152], rax
    mov rax, 0
    mov [rbp-160], rax
    mov rax, 0
    mov [rbp-168], rax
    mov rax, 0
    mov [rbp-176], rax
    mov rax, 0
    mov [rbp-184], rax
    mov rax, 0
    mov [rbp-192], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L425
    mov rax, 0
    jmp .__ret_424
    jmp .L426
.L425:
.L426:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r14, rax
    mov rcx, r14
    sub rsp, 32
    call par_is_slice
    add rsp, 32
    mov r15, rax
    mov rax, r15
    and rax, 255
    mov r13, rax
    mov rax, r13
    mov rcx, 7
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L429
    mov rax, r13
    mov rcx, 2
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L431
    mov rax, r13
    mov rcx, 3
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L431
    mov rax, 0
    jmp .L432
.L431:
    mov rax, 1
.L432:
    test rax, rax
    jz .L429
    mov rax, 1
    jmp .L430
.L429:
    mov rax, 0
.L430:
    test rax, rax
    jz .L427
section .data
.str433: db 102,111,114,32,120,32,105,110,32,108,58,32,108,32,104,97,115,32,116,111,32,98,101,32,97,32,108,105,115,116,60,84,62,32,100,101,99,108,97,114,101,100,32,98,101,102,111,114,101,0
section .text
    lea rax, [rel .str433]
    mov [rel __g_parser_par_custom_msg], rax
    mov rax, 0
    jmp .__ret_424
    jmp .L428
.L427:
.L428:
    mov rax, [rel __g_parser_par_coll_stok]
    mov [rel __g_parser_par_fi_stok], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L434
    mov rax, 0
    jmp .__ret_424
    jmp .L435
.L434:
.L435:
    mov rax, [rel __g_parser_par_for_n]
    mov r12, rax
    cmp r12, 4096
    jl .L436
    mov rax, 0
    jmp .__ret_424
    jmp .L437
.L436:
.L437:
    mov rax, r12
    add rax, 1
    mov [rel __g_parser_par_for_n], rax
    lea rax, [rel __g_parser_par_for_names]
    push rax
    mov rax, r12
    mov rcx, 16
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str438: db 95,95,102,111,114,95,0
section .text
    lea rax, [rel .str438]
    push rax
    pop rdx
    pop rcx
    mov r8, 6
    mov r9, r12
    sub rsp, 32
    call prs_make_name
    add rsp, 32
    lea rax, [rel __g_parser_par_for_toks]
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-56], rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rdx, [rbp-56]
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-56]
    add rdx, 8
    mov [rdx], rax
    mov rax, 10
    mov rdx, [rbp-56]
    add rdx, 16
    mov [rdx], eax
    mov rdx, [rbp-8]
    add rdx, 20
    movzx eax, word [rdx]
    mov rdx, [rbp-56]
    add rdx, 20
    mov [rdx], ax
    mov rax, 0
    mov rdx, [rbp-56]
    add rdx, 22
    mov [rdx], ax
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L439
    mov rax, 0
    jmp .__ret_424
    jmp .L440
.L439:
.L440:
    mov rax, [rel __g_parser_AST_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-72], rax
    mov rax, [rbp-72]
    cmp rax, 0
    jne .L441
    mov rax, 0
    jmp .__ret_424
    jmp .L442
.L441:
.L442:
    mov rax, [rbp-56]
    mov rdx, [rbp-72]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_INDEX]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-80], rax
    mov rax, [rbp-80]
    cmp rax, 0
    jne .L443
    mov rax, 0
    jmp .__ret_424
    jmp .L444
.L443:
.L444:
    mov rax, [rbp-72]
    mov rdx, [rbp-80]
    add rdx, 16
    mov [rdx], rax
    mov rax, r14
    mov rdx, [rbp-80]
    add rdx, 24
    mov [rdx], rax
    mov rcx, [rbp-80]
    mov rdx, r15
    sub rsp, 32
    call par_slice_get_call
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L445
    mov rax, 0
    jmp .__ret_424
    jmp .L446
.L445:
.L446:
    mov rax, [rel __g_parser_AST_VAR_DECL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-96], rax
    mov rax, [rbp-96]
    cmp rax, 0
    jne .L447
    mov rax, 0
    jmp .__ret_424
    jmp .L448
.L447:
.L448:
    mov rax, [rbp-8]
    mov rdx, [rbp-96]
    add rdx, 24
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-96]
    add rdx, 16
    mov [rdx], rax
    cmp r13, 7
    jne .L449
    mov rax, [rel __g_parser_par_fi_stok]
    mov rdx, [rbp-96]
    add rdx, 8
    mov [rdx], rax
    jmp .L450
.L449:
.L450:
    mov rax, r15
    and rax, 0xFF00
    or rax, 8
    mov rbx, rax
    cmp r13, 3
    jne .L451
    or rbx, 1
    jmp .L452
.L451:
.L452:
    mov rax, rbx
    mov rdx, [rbp-96]
    add rdx, 38
    mov [rdx], ax
    mov rax, [rel __g_parser_AST_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-104], rax
    mov rax, [rbp-104]
    cmp rax, 0
    jne .L453
    mov rax, 0
    jmp .__ret_424
    jmp .L454
.L453:
.L454:
    mov rax, [rbp-96]
    mov rdx, [rbp-104]
    add rdx, 8
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-104]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-72], rax
    mov rax, [rbp-72]
    cmp rax, 0
    jne .L455
    mov rax, 0
    jmp .__ret_424
    jmp .L456
.L455:
.L456:
    mov rax, r14
    mov rdx, [rbp-72]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-112], rax
    mov rax, [rbp-112]
    cmp rax, 0
    jne .L457
    mov rax, 0
    jmp .__ret_424
    jmp .L458
.L457:
.L458:
    mov rax, [rbp-72]
    mov rdx, [rbp-112]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_CALL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-120], rax
    mov rax, [rbp-120]
    cmp rax, 0
    jne .L459
    mov rax, 0
    jmp .__ret_424
    jmp .L460
.L459:
.L460:
    mov rax, [rbp-112]
    mov rdx, [rbp-120]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_PT_LIST_LEN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    mov rdx, [rbp-120]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-128], rax
    mov rax, [rbp-128]
    cmp rax, 0
    jne .L461
    mov rax, 0
    jmp .__ret_424
    jmp .L462
.L461:
.L462:
    mov rax, [rbp-56]
    mov rdx, [rbp-128]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_BINOP]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-136], rax
    mov rax, [rbp-136]
    cmp rax, 0
    jne .L463
    mov rax, 0
    jmp .__ret_424
    jmp .L464
.L463:
.L464:
    mov rax, [rbp-128]
    mov rdx, [rbp-136]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-120]
    mov rdx, [rbp-136]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_TOK_LT]
    mov rdx, [rbp-136]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-72], rax
    mov rax, [rbp-72]
    cmp rax, 0
    jne .L465
    mov rax, 0
    jmp .__ret_424
    jmp .L466
.L465:
.L466:
    mov rax, [rbp-56]
    mov rdx, [rbp-72]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_INTEGER_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-144], rax
    mov rax, [rbp-144]
    cmp rax, 0
    jne .L467
    mov rax, 0
    jmp .__ret_424
    jmp .L468
.L467:
.L468:
    mov rax, [rel __g_parser_PT_ONE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    mov rdx, [rbp-144]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_BINOP]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-152], rax
    mov rax, [rbp-152]
    cmp rax, 0
    jne .L469
    mov rax, 0
    jmp .__ret_424
    jmp .L470
.L469:
.L470:
    mov rax, [rbp-72]
    mov rdx, [rbp-152]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-144]
    mov rdx, [rbp-152]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_TOK_PLUS]
    mov rdx, [rbp-152]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-128], rax
    mov rax, [rbp-128]
    cmp rax, 0
    jne .L471
    mov rax, 0
    jmp .__ret_424
    jmp .L472
.L471:
.L472:
    mov rax, [rbp-56]
    mov rdx, [rbp-128]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_ASSIGN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-160], rax
    mov rax, [rbp-160]
    cmp rax, 0
    jne .L473
    mov rax, 0
    jmp .__ret_424
    jmp .L474
.L473:
.L474:
    mov rax, [rbp-128]
    mov rdx, [rbp-160]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-152]
    mov rdx, [rbp-160]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_WHILE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-168], rax
    mov rax, [rbp-168]
    cmp rax, 0
    jne .L475
    mov rax, 0
    jmp .__ret_424
    jmp .L476
.L475:
.L476:
    mov rax, [rbp-160]
    mov rdx, [rbp-168]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-136]
    mov rdx, [rbp-168]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-104]
    mov rdx, [rbp-168]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_INTEGER_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-176], rax
    mov rax, [rbp-176]
    cmp rax, 0
    jne .L477
    mov rax, 0
    jmp .__ret_424
    jmp .L478
.L477:
.L478:
    mov rax, [rel __g_parser_PT_ZERO]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    mov rdx, [rbp-176]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_VAR_DECL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-96], rax
    mov rax, [rbp-96]
    cmp rax, 0
    jne .L479
    mov rax, 0
    jmp .__ret_424
    jmp .L480
.L479:
.L480:
    mov rax, [rbp-56]
    mov rdx, [rbp-96]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-176]
    mov rdx, [rbp-96]
    add rdx, 16
    mov [rdx], rax
    mov rax, 8
    mov rdx, [rbp-96]
    add rdx, 38
    mov [rdx], ax
    mov rax, [rel __g_parser_AST_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-184], rax
    mov rax, [rbp-184]
    cmp rax, 0
    jne .L481
    mov rax, 0
    jmp .__ret_424
    jmp .L482
.L481:
.L482:
    mov rax, [rbp-96]
    mov rdx, [rbp-184]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-192], rax
    mov rax, [rbp-192]
    cmp rax, 0
    jne .L483
    mov rax, 0
    jmp .__ret_424
    jmp .L484
.L483:
.L484:
    mov rax, [rbp-168]
    mov rdx, [rbp-192]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-192]
    mov rdx, [rbp-184]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-184]
    jmp .__ret_424
.__ret_424:
    mov rbx, [rbp-256]
    mov r12, [rbp-248]
    mov r13, [rbp-240]
    mov r14, [rbp-232]
    mov r15, [rbp-224]
    mov rsp, rbp
    pop rbp
    ret
prs_return:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov [rbp-48], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L486
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_RETURN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    jmp .__ret_485
    jmp .L487
.L486:
.L487:
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L488
    mov rax, 0
    jmp .__ret_485
    jmp .L489
.L488:
.L489:
.L490:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L491
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L493
    mov rax, 0
    jmp .__ret_485
    jmp .L494
.L493:
.L494:
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L495
    mov rax, 0
    jmp .__ret_485
    jmp .L496
.L495:
.L496:
    mov rax, rbx
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L497
    mov rax, [rbp-40]
    mov r12, rax
    jmp .L498
.L497:
    mov rax, [rbp-40]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L498:
    mov rax, [rbp-40]
    mov [rbp-24], rax
.L492:
    jmp .L490
.L491:
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L499
    mov rax, 0
    jmp .__ret_485
    jmp .L500
.L499:
.L500:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_RETURN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L501
    mov rax, 0
    jmp .__ret_485
    jmp .L502
.L501:
.L502:
    mov rax, r13
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-48]
    jmp .__ret_485
.__ret_485:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_print:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L504
    mov rax, 0
    jmp .__ret_503
    jmp .L505
.L504:
.L505:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L506
    mov rax, 0
    jmp .__ret_503
    jmp .L507
.L506:
.L507:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L508
    mov rax, 0
    jmp .__ret_503
    jmp .L509
.L508:
.L509:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L510
    mov rax, 0
    jmp .__ret_503
    jmp .L511
.L510:
.L511:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L512
    mov rax, 0
    jmp .__ret_503
    jmp .L513
.L512:
.L513:
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-24]
    jmp .__ret_503
.__ret_503:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_thread_one:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, r12
    mov [rel __g_parser_par_thread_node], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L515
    mov rax, 0
    jmp .__ret_514
    jmp .L516
.L515:
.L516:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L517
    mov rax, 0
    jmp .__ret_514
    jmp .L518
.L517:
.L518:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L519
    mov rax, 0
    jmp .__ret_514
    jmp .L520
.L519:
.L520:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L521
    mov rax, 0
    jmp .__ret_514
    jmp .L522
.L521:
.L522:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_par_thread_node]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L523
    mov rax, 0
    jmp .__ret_514
    jmp .L524
.L523:
.L524:
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-24]
    jmp .__ret_514
.__ret_514:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_vec2_store:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L526
    mov rax, 0
    jmp .__ret_525
    jmp .L527
.L526:
.L527:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L528
    mov rax, 0
    jmp .__ret_525
    jmp .L529
.L528:
.L529:
    mov rax, [rel __g_parser_TOK_COMMA]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L530
    mov rax, 0
    jmp .__ret_525
    jmp .L531
.L530:
.L531:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L532
    mov rax, 0
    jmp .__ret_525
    jmp .L533
.L532:
.L533:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L534
    mov rax, 0
    jmp .__ret_525
    jmp .L535
.L534:
.L535:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L536
    mov rax, 0
    jmp .__ret_525
    jmp .L537
.L536:
.L537:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_VEC2_STORE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L538
    mov rax, 0
    jmp .__ret_525
    jmp .L539
.L538:
.L539:
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-24]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-24]
    jmp .__ret_525
.__ret_525:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_fail:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov rax, 0
    mov [rbp-8], rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_STRING]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L541
    mov rax, 0
    jmp .__ret_540
    jmp .L542
.L541:
.L542:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_parser_AST_STRING_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-8], rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L543
    mov rax, 0
    jmp .__ret_540
    jmp .L544
.L543:
.L544:
    mov rax, rbx
    mov rdx, [rbp-8]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_FAIL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L545
    mov rax, 0
    jmp .__ret_540
    jmp .L546
.L545:
.L546:
    mov rax, [rbp-8]
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_KW_HINT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L547
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_STRING]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L549
    mov rax, 0
    jmp .__ret_540
    jmp .L550
.L549:
.L550:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_parser_AST_STRING_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L551
    mov rax, 0
    jmp .__ret_540
    jmp .L552
.L551:
.L552:
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-24]
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L548
.L547:
.L548:
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L553
    mov rax, 0
    jmp .__ret_540
    jmp .L554
.L553:
.L554:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-16]
    jmp .__ret_540
.__ret_540:
    mov rbx, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_printfail:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L556
    mov rax, 0
    jmp .__ret_555
    jmp .L557
.L556:
.L557:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L558
    mov rax, 0
    jmp .__ret_555
    jmp .L559
.L558:
.L559:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L560
    mov rax, 0
    jmp .__ret_555
    jmp .L561
.L560:
.L561:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_PRINTFAIL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    jmp .__ret_555
.__ret_555:
    mov rsp, rbp
    pop rbp
    ret
prs_jump:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L563
    mov rax, 0
    jmp .__ret_562
    jmp .L564
.L563:
.L564:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call prs_new
    add rsp, 32
    jmp .__ret_562
.__ret_562:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_args_stmt:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov r14, rdx
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-48], rax
    cmp r14, 2
    jne .L566
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rel __g_parser_par_stmt_kw], rax
    jmp .L567
.L566:
.L567:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L568
    mov rax, 0
    jmp .__ret_565
    jmp .L569
.L568:
.L569:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L570
    mov rax, 0
    jmp .__ret_565
    jmp .L571
.L570:
.L571:
    mov rax, [rel __g_parser_TOK_COMMA]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L572
    mov rax, 0
    jmp .__ret_565
    jmp .L573
.L572:
.L573:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L574
    mov rax, 0
    jmp .__ret_565
    jmp .L575
.L574:
.L575:
    cmp r14, 3
    jne .L576
    mov rax, [rel __g_parser_TOK_COMMA]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L578
    mov rax, 0
    jmp .__ret_565
    jmp .L579
.L578:
.L579:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L580
    mov rax, 0
    jmp .__ret_565
    jmp .L581
.L580:
.L581:
    jmp .L577
.L576:
.L577:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L582
    mov rax, 0
    jmp .__ret_565
    jmp .L583
.L582:
.L583:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L584
    mov rax, 0
    jmp .__ret_565
    jmp .L585
.L584:
.L585:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r15
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L586
    mov rax, 0
    jmp .__ret_565
    jmp .L587
.L586:
.L587:
    mov rax, r13
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    cmp r14, 3
    jne .L588
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    jmp .L589
.L588:
    mov rax, [rel __g_parser_par_stmt_kw]
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
.L589:
    mov rax, [rbp-48]
    jmp .__ret_565
.__ret_565:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_asm:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov rax, 0
    mov [rbp-8], rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L591
    mov rax, 0
    jmp .__ret_590
    jmp .L592
.L591:
.L592:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_ASM]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-8], rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L593
    mov rax, 0
    jmp .__ret_590
    jmp .L594
.L593:
.L594:
.L595:
    mov rax, 1
    cmp rax, 1
    jne .L596
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L598
    jmp .L596
    jmp .L599
.L598:
.L599:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L600
    mov rax, 0
    jmp .__ret_590
    jmp .L601
.L600:
.L601:
    mov rax, [rel __g_parser_TOK_STRING]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L602
    mov rax, 0
    jmp .__ret_590
    jmp .L603
.L602:
.L603:
    mov rax, [rel __g_parser_AST_STRING_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L604
    mov rax, 0
    jmp .__ret_590
    jmp .L605
.L604:
.L605:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L606
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L607
.L606:
.L607:
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L608
    mov rax, [rbp-24]
    mov rdx, [rbp-8]
    add rdx, 16
    mov [rdx], rax
    jmp .L609
.L608:
    mov rax, [rbp-24]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
.L609:
    mov rax, [rbp-24]
    mov [rbp-16], rax
.L597:
    jmp .L595
.L596:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_590
.__ret_590:
    mov rbx, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_expr_stmt:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 0
    jne .L611
    mov rax, 0
    jmp .__ret_610
    jmp .L612
.L611:
.L612:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L613
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L615
    mov rax, 0
    jmp .__ret_610
    jmp .L616
.L615:
.L616:
    jmp .L614
.L613:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_PLUS_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L617
    mov rax, [rel __g_parser_TOK_PLUS]
    mov rbx, rax
    jmp .L618
.L617:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_MINUS_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L619
    mov rax, [rel __g_parser_TOK_MINUS]
    mov rbx, rax
    jmp .L620
.L619:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_STAR_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L621
    mov rax, [rel __g_parser_TOK_STAR]
    mov rbx, rax
    jmp .L622
.L621:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_SLASH_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L623
    mov rax, [rel __g_parser_TOK_SLASH]
    mov rbx, rax
    jmp .L624
.L623:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_XOR_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L625
    mov rax, [rel __g_parser_TOK_CARET]
    mov rbx, rax
    jmp .L626
.L625:
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L627
    mov rax, 0
    jmp .__ret_610
    jmp .L628
.L627:
.L628:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, r13
    jmp .__ret_610
.L626:
.L624:
.L622:
.L620:
.L618:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L629
    mov rax, 0
    jmp .__ret_610
    jmp .L630
.L629:
.L630:
    mov rax, [rel __g_parser_AST_BINOP]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L631
    mov rax, 0
    jmp .__ret_610
    jmp .L632
.L631:
.L632:
    mov rax, r13
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
.L614:
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L633
    mov rax, 0
    jmp .__ret_610
    jmp .L634
.L633:
.L634:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r13
    mov rdx, [rbp-16]
    sub rsp, 32
    call par_make_assign
    add rsp, 32
    jmp .__ret_610
.__ret_610:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_opt_paren_expr:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_parser_par_no_slit]
    add rax, 1
    mov [rel __g_parser_par_no_slit], rax
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_parser_par_no_slit]
    sub rax, 1
    mov [rel __g_parser_par_no_slit], rax
    mov rax, rbx
    jmp .__ret_635
.__ret_635:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_struct:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L637
    mov rax, 0
    jmp .__ret_636
    jmp .L638
.L637:
.L638:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L639
    mov rax, 0
    jmp .__ret_636
    jmp .L640
.L639:
.L640:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_STRUCT_DEF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L641
    mov rax, 0
    jmp .__ret_636
    jmp .L642
.L641:
.L642:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
.L643:
    mov rax, 1
    cmp rax, 1
    jne .L644
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L646
    jmp .L644
    jmp .L647
.L646:
.L647:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L648
    mov rax, 0
    jmp .__ret_636
    jmp .L649
.L648:
.L649:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov [rel __g_parser_par_expected], rax
    mov rcx, rbx
    sub rsp, 32
    call prs_is_field_name
    add rsp, 32
    cmp rax, 0
    jne .L650
    mov rax, 0
    jmp .__ret_636
    jmp .L651
.L650:
.L651:
    mov rax, [rel __g_parser_AST_FIELD]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L652
    mov rax, 0
    jmp .__ret_636
    jmp .L653
.L652:
.L653:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L654
    mov rax, [rbp-32]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    jmp .L655
.L654:
    mov rax, [rbp-32]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L655:
    mov rax, [rbp-32]
    mov [rbp-24], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L656
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rdx, [rbp-24]
    add rdx, 40
    mov [rdx], rax
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-24]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L658
    mov rax, 0
    jmp .__ret_636
    jmp .L659
.L658:
.L659:
    sub rsp, 32
    call prs_vtag_col
    add rsp, 32
    mov rdx, [rbp-24]
    add rdx, 38
    mov [rdx], ax
    jmp .L657
.L656:
.L657:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L660
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L661
.L660:
.L661:
.L645:
    jmp .L643
.L644:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-16]
    jmp .__ret_636
.__ret_636:
    mov rbx, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_enum:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L663
    mov rax, 0
    jmp .__ret_662
    jmp .L664
.L663:
.L664:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L665
    mov rax, 0
    jmp .__ret_662
    jmp .L666
.L665:
.L666:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_ENUM_DEF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L667
    mov rax, 0
    jmp .__ret_662
    jmp .L668
.L667:
.L668:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
.L669:
    mov rax, 1
    cmp rax, 1
    jne .L670
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L672
    jmp .L670
    jmp .L673
.L672:
.L673:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L674
    mov rax, 0
    jmp .__ret_662
    jmp .L675
.L674:
.L675:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov [rel __g_parser_par_expected], rax
    mov rcx, rbx
    sub rsp, 32
    call prs_is_field_name
    add rsp, 32
    cmp rax, 0
    jne .L676
    mov rax, 0
    jmp .__ret_662
    jmp .L677
.L676:
.L677:
    mov rax, [rel __g_parser_AST_FIELD]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L678
    mov rax, 0
    jmp .__ret_662
    jmp .L679
.L678:
.L679:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L680
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_INTEGER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L684
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_HEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L684
    mov rax, 1
    jmp .L685
.L684:
    mov rax, 0
.L685:
    test rax, rax
    jz .L682
    mov rax, 0
    jmp .__ret_662
    jmp .L683
.L682:
.L683:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_tok_uint
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L681
.L680:
.L681:
    mov rax, r12
    mov rdx, [rbp-32]
    add rdx, 40
    mov [rdx], rax
    add r12, 1
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L686
    mov rax, [rbp-32]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    jmp .L687
.L686:
    mov rax, [rbp-32]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L687:
    mov rax, [rbp-32]
    mov [rbp-24], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L688
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L689
.L688:
.L689:
.L671:
    jmp .L669
.L670:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-16]
    jmp .__ret_662
.__ret_662:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
prs_struct_lit:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov r13, rcx
    mov rax, [rel __g_parser_AST_STRUCT_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L691
    mov rax, 0
    jmp .__ret_690
    jmp .L692
.L691:
.L692:
    mov rax, r13
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L693:
    mov rax, 1
    cmp rax, 1
    jne .L694
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L696
    jmp .L694
    jmp .L697
.L696:
.L697:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L698
    mov rax, 0
    jmp .__ret_690
    jmp .L699
.L698:
.L699:
    mov rax, [rel __g_parser_AST_FINIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L700
    mov rax, 0
    jmp .__ret_690
    jmp .L701
.L700:
.L701:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L704
    sub rsp, 32
    call prs_peek_next
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L704
    mov rax, 1
    jmp .L705
.L704:
    mov rax, 0
.L705:
    test rax, rax
    jz .L702
    cmp r12, 2
    jne .L706
    mov rax, 0
    jmp .__ret_690
    jmp .L707
.L706:
.L707:
    mov rax, 1
    mov r12, rax
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L703
.L702:
    cmp r12, 1
    jne .L708
    mov rax, 0
    jmp .__ret_690
    jmp .L709
.L708:
.L709:
    mov rax, 2
    mov r12, rax
.L703:
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L710
    mov rax, 0
    jmp .__ret_690
    jmp .L711
.L710:
.L711:
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L712
    mov rax, [rbp-32]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    jmp .L713
.L712:
    mov rax, [rbp-32]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L713:
    mov rax, [rbp-32]
    mov [rbp-24], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L714
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L715
.L714:
.L715:
.L695:
    jmp .L693
.L694:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-16]
    jmp .__ret_690
.__ret_690:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
prs_extern:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L717:
    mov rax, 1
    cmp rax, 1
    jne .L718
    mov rax, [rel __g_parser_TOK_STRING]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L720
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L721
.L720:
.L721:
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L722
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L723
.L722:
.L723:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L724
    mov rax, [rbp-24]
    mov r14, rax
    jmp .L725
.L724:
    mov rax, [rbp-24]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
.L725:
    mov rax, [rbp-24]
    mov [rbp-16], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L726
    jmp .L718
    jmp .L727
.L726:
.L727:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L719:
    jmp .L717
.L718:
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L728
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L729
.L728:
.L729:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L730:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L731
    mov rax, [rel __g_parser_KW_FN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L733
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L734
.L733:
.L734:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L735
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L736
.L735:
.L736:
    mov rax, [rel __g_parser_AST_EXTERN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L737
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L738
.L737:
.L738:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, r14
    mov rdx, [rbp-48]
    add rdx, 48
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L739
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L740
.L739:
.L740:
    mov rax, 1
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    mov [rel __g_parser_par_variadic], rax
    sub rsp, 32
    call prs_param_list
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L741
    mov rax, 0
    jmp .__ret_716
    jmp .L742
.L741:
.L742:
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rel __g_parser_par_variadic]
    mov rdx, [rbp-48]
    add rdx, 38
    mov [rdx], ax
    mov rax, 0
    mov rdx, [rbp-48]
    add rdx, 32
    mov [rdx], eax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_TOK_ARROW]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L745
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_TOK_COLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L745
    mov rax, 0
    jmp .L746
.L745:
    mov rax, 1
.L746:
    test rax, rax
    jz .L743
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_I32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L747
    mov rax, 1
    mov rbx, rax
    jmp .L748
.L747:
.L748:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_U32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L749
    mov rax, 2
    mov rbx, rax
    jmp .L750
.L749:
.L750:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_U8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L753
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_BOOL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L753
    mov rax, 0
    jmp .L754
.L753:
    mov rax, 1
.L754:
    test rax, rax
    jz .L751
    mov rax, 3
    mov rbx, rax
    jmp .L752
.L751:
.L752:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_U16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L755
    mov rax, 4
    mov rbx, rax
    jmp .L756
.L755:
.L756:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_I16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L757
    mov rax, 5
    mov rbx, rax
    jmp .L758
.L757:
.L758:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_I8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L759
    mov rax, 6
    mov rbx, rax
    jmp .L760
.L759:
.L760:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_F64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L761
    mov rax, 8
    mov rbx, rax
    jmp .L762
.L761:
.L762:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_F32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L763
    mov rax, 9
    mov rbx, rax
    jmp .L764
.L763:
.L764:
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 32
    mov [rdx], eax
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L765
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L766
.L765:
.L766:
    jmp .L744
.L743:
.L744:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L767
section .data
.str769: db 97,110,32,101,120,116,101,114,110,32,102,110,32,104,97,115,32,110,111,32,98,111,100,121,58,32,105,116,115,32,99,111,100,101,32,105,115,32,105,110,32,116,104,101,32,108,105,98,114,97,114,121,32,45,45,32,101,110,100,32,105,116,32,119
    db 105,116,104,32,59,0
section .text
    lea rax, [rel .str769]
    mov [rel __g_parser_par_custom_msg], rax
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L768
.L767:
.L768:
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L770
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L771
.L770:
.L771:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L772
    mov rax, [rbp-48]
    mov r13, rax
    jmp .L773
.L772:
    mov rax, [rbp-48]
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
.L773:
    mov rax, [rbp-48]
    mov [rbp-40], rax
.L732:
    jmp .L730
.L731:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    cmp r13, 0
    jne .L774
    mov rax, [rel __g_parser_AST_EXTERN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L776
    mov rax, 0
    mov [rel __g_parser_par_extern_mode], rax
    mov rax, 0
    jmp .__ret_716
    jmp .L777
.L776:
.L777:
    jmp .L775
.L774:
.L775:
    mov rax, r13
    jmp .__ret_716
.__ret_716:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov rsp, rbp
    pop rbp
    ret
par_builtin_type:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
section .data
.str781: db 109,97,112,0
section .text
    lea rax, [rel .str781]
    push rax
    pop rdx
    pop rcx
    mov r8, 3
    sub rsp, 32
    call prs_tok_is
    add rsp, 32
    cmp rax, 1
    jne .L779
    mov rax, 3
    jmp .__ret_778
    jmp .L780
.L779:
.L780:
    mov rax, rbx
    push rax
section .data
.str784: db 116,101,120,116,0
section .text
    lea rax, [rel .str784]
    push rax
    pop rdx
    pop rcx
    mov r8, 4
    sub rsp, 32
    call prs_tok_is
    add rsp, 32
    cmp rax, 1
    jne .L782
    mov rax, 1
    jmp .__ret_778
    jmp .L783
.L782:
.L783:
    mov rax, rbx
    push rax
section .data
.str787: db 108,105,115,116,0
section .text
    lea rax, [rel .str787]
    push rax
    pop rdx
    pop rcx
    mov r8, 4
    sub rsp, 32
    call prs_tok_is
    add rsp, 32
    cmp rax, 1
    jne .L785
    mov rax, 2
    jmp .__ret_778
    jmp .L786
.L785:
.L786:
    mov rax, 0
    jmp .__ret_778
.__ret_778:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_type_width:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L793
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_I8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L793
    mov rax, 0
    jmp .L794
.L793:
    mov rax, 1
.L794:
    test rax, rax
    jnz .L791
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_BOOL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L791
    mov rax, 0
    jmp .L792
.L791:
    mov rax, 1
.L792:
    test rax, rax
    jz .L789
    mov rax, 1
    jmp .__ret_788
    jmp .L790
.L789:
.L790:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L797
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_I16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L797
    mov rax, 0
    jmp .L798
.L797:
    mov rax, 1
.L798:
    test rax, rax
    jz .L795
    mov rax, 2
    jmp .__ret_788
    jmp .L796
.L795:
.L796:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L803
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_I32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L803
    mov rax, 0
    jmp .L804
.L803:
    mov rax, 1
.L804:
    test rax, rax
    jnz .L801
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_F32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L801
    mov rax, 0
    jmp .L802
.L801:
    mov rax, 1
.L802:
    test rax, rax
    jz .L799
    mov rax, 4
    jmp .__ret_788
    jmp .L800
.L799:
.L800:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L809
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_I64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L809
    mov rax, 0
    jmp .L810
.L809:
    mov rax, 1
.L810:
    test rax, rax
    jnz .L807
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_F64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L807
    mov rax, 0
    jmp .L808
.L807:
    mov rax, 1
.L808:
    test rax, rax
    jz .L805
    mov rax, 8
    jmp .__ret_788
    jmp .L806
.L805:
.L806:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L811
    mov rax, 8
    jmp .__ret_788
    jmp .L812
.L811:
.L812:
    mov rax, 0
    jmp .__ret_788
.__ret_788:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_tok_uint:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov [rbp-8], rcx
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    mov r14, rax
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 0
    jne .L814
    mov rax, 0
    jmp .__ret_813
    jmp .L815
.L814:
.L815:
    mov rax, r13
    mov rcx, 2
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L818
    mov rcx, r14
    sub rsp, 32
    call bget
    add rsp, 32
    mov rcx, 48
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L818
    mov rax, 1
    jmp .L819
.L818:
    mov rax, 0
.L819:
    test rax, rax
    jz .L816
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L822
    mov rax, rbx
    mov rcx, 88
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L822
    mov rax, 0
    jmp .L823
.L822:
    mov rax, 1
.L823:
    test rax, rax
    jz .L820
    add r14, 2
    sub r13, 2
.L824:
    cmp r13, 0
    jle .L825
    mov rcx, r14
    sub rsp, 32
    call bget
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L829
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L829
    mov rax, 1
    jmp .L830
.L829:
    mov rax, 0
.L830:
    test rax, rax
    jz .L827
    sub rbx, 48
    jmp .L828
.L827:
    or rbx, 32
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L833
    mov rax, rbx
    mov rcx, 102
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L833
    mov rax, 0
    jmp .L834
.L833:
    mov rax, 1
.L834:
    test rax, rax
    jz .L831
    mov rax, r12
    jmp .__ret_813
    jmp .L832
.L831:
.L832:
    sub rbx, 87
.L828:
    mov rax, r12
    shl rax, 4
    add rax, rbx
    mov r12, rax
    add r14, 1
    sub r13, 1
.L826:
    jmp .L824
.L825:
    mov rax, r12
    jmp .__ret_813
    jmp .L821
.L820:
.L821:
    jmp .L817
.L816:
.L817:
.L835:
    cmp r13, 0
    jle .L836
    mov rcx, r14
    sub rsp, 32
    call bget
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L840
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L840
    mov rax, 0
    jmp .L841
.L840:
    mov rax, 1
.L841:
    test rax, rax
    jz .L838
    mov rax, r12
    jmp .__ret_813
    jmp .L839
.L838:
.L839:
    mov rax, r12
    mov rcx, 10
    imul rax, rcx
    push rax
    mov rax, rbx
    sub rax, 48
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    add r14, 1
    sub r13, 1
.L837:
    jmp .L835
.L836:
    mov rax, r12
    jmp .__ret_813
.__ret_813:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
prs_type:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_tok], rax
    mov rax, 0
    mov [rel __g_parser_par_last_coll_stok], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    mov rax, 0
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_slice], rax
    mov rax, 0
    mov [rel __g_parser_par_last_arr_elem], rax
    mov rax, 0
    mov [rel __g_parser_par_last_vtag], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L843
    sub rsp, 32
    call prs_type_array
    add rsp, 32
    jmp .__ret_842
    jmp .L844
.L843:
.L844:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_PTR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L845
    sub rsp, 32
    call prs_type_ptr
    add rsp, 32
    jmp .__ret_842
    jmp .L846
.L845:
.L846:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_SLICE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L847
    sub rsp, 32
    call prs_type_slice
    add rsp, 32
    jmp .__ret_842
    jmp .L848
.L847:
.L848:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_ARENA_TOKEN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L849
    sub rsp, 32
    call prs_type_arena_tok
    add rsp, 32
    jmp .__ret_842
    jmp .L850
.L849:
.L850:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_FN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L851
    sub rsp, 32
    call prs_type_fn
    add rsp, 32
    jmp .__ret_842
    jmp .L852
.L851:
.L852:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L853
    sub rsp, 32
    call prs_cur
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call par_builtin_type
    add rsp, 32
    mov rbx, rax
    cmp rbx, 1
    jne .L855
    mov rax, 1
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 1
    mov [rel __g_parser_par_used_text], rax
    jmp .L856
.L855:
    cmp rbx, 0
    je .L857
    mov rcx, rbx
    sub rsp, 32
    call prs_type_coll
    add rsp, 32
    jmp .__ret_842
    jmp .L858
.L857:
.L858:
.L856:
    sub rsp, 32
    call prs_type_scalar
    add rsp, 32
    jmp .__ret_842
    jmp .L854
.L853:
.L854:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L865
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L865
    mov rax, 0
    jmp .L866
.L865:
    mov rax, 1
.L866:
    test rax, rax
    jnz .L863
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L863
    mov rax, 0
    jmp .L864
.L863:
    mov rax, 1
.L864:
    test rax, rax
    jnz .L861
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L861
    mov rax, 0
    jmp .L862
.L861:
    mov rax, 1
.L862:
    test rax, rax
    jz .L859
    sub rsp, 32
    call prs_type_scalar
    add rsp, 32
    jmp .__ret_842
    jmp .L860
.L859:
.L860:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_I8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L873
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_I16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L873
    mov rax, 0
    jmp .L874
.L873:
    mov rax, 1
.L874:
    test rax, rax
    jnz .L871
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_I32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L871
    mov rax, 0
    jmp .L872
.L871:
    mov rax, 1
.L872:
    test rax, rax
    jnz .L869
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_I64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L869
    mov rax, 0
    jmp .L870
.L869:
    mov rax, 1
.L870:
    test rax, rax
    jz .L867
    sub rsp, 32
    call prs_type_scalar
    add rsp, 32
    jmp .__ret_842
    jmp .L868
.L867:
.L868:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_F32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L883
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_F64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L883
    mov rax, 0
    jmp .L884
.L883:
    mov rax, 1
.L884:
    test rax, rax
    jnz .L881
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_BOOL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L881
    mov rax, 0
    jmp .L882
.L881:
    mov rax, 1
.L882:
    test rax, rax
    jnz .L879
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_STR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L879
    mov rax, 0
    jmp .L880
.L879:
    mov rax, 1
.L880:
    test rax, rax
    jnz .L877
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_VOID]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L877
    mov rax, 0
    jmp .L878
.L877:
    mov rax, 1
.L878:
    test rax, rax
    jz .L875
    sub rsp, 32
    call prs_type_scalar
    add rsp, 32
    jmp .__ret_842
    jmp .L876
.L875:
.L876:
    mov rax, 0
    jmp .__ret_842
.__ret_842:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_type_scalar:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_F32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L888
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_F64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L888
    mov rax, 0
    jmp .L889
.L888:
    mov rax, 1
.L889:
    test rax, rax
    jz .L886
    mov rax, 1
    mov [rel __g_parser_par_last_is_float], rax
    jmp .L887
.L886:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L896
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L896
    mov rax, 0
    jmp .L897
.L896:
    mov rax, 1
.L897:
    test rax, rax
    jnz .L894
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L894
    mov rax, 0
    jmp .L895
.L894:
    mov rax, 1
.L895:
    test rax, rax
    jnz .L892
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_U64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L892
    mov rax, 0
    jmp .L893
.L892:
    mov rax, 1
.L893:
    test rax, rax
    jz .L890
    mov rax, 1
    mov [rel __g_parser_par_last_is_unsigned], rax
    jmp .L891
.L890:
.L891:
.L887:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_885
.__ret_885:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_type_coll:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L899
    mov rax, 0
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    jmp .__ret_898
    jmp .L900
.L899:
.L900:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L901
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call par_builtin_type
    add rsp, 32
    cmp rax, 0
    jne .L903
    mov rax, r12
    mov r13, rax
    jmp .L904
.L903:
.L904:
    jmp .L902
.L901:
.L902:
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L905
    mov rax, 0
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    jmp .__ret_898
    jmp .L906
.L905:
.L906:
    mov rax, r13
    mov [rel __g_parser_par_last_coll_stok], rax
    cmp r13, 0
    je .L907
    mov rax, 3
    mov rbx, rax
    jmp .L908
.L907:
    mov rax, [rel __g_parser_par_last_is_float]
    cmp rax, 0
    je .L909
    mov rax, 2
    mov rbx, rax
    jmp .L910
.L909:
    mov rax, [rel __g_parser_par_last_vtag]
    cmp rax, 1
    jne .L911
    mov rax, 1
    mov rbx, rax
    jmp .L912
.L911:
.L912:
.L910:
.L908:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_GT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L913
    mov rax, 0
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    jmp .__ret_898
    jmp .L914
.L913:
.L914:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, rbx
    shl rax, 4
    mov rcx, rax
    mov rax, r14
    or rax, rcx
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    mov rax, 0
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    mov [rel __g_parser_par_last_arr_elem], rax
    cmp r14, 2
    jne .L915
    mov rax, 1
    mov [rel __g_parser_par_used_list], rax
    jmp .L916
.L915:
    mov rax, 1
    mov [rel __g_parser_par_used_map], rax
.L916:
    mov rax, 1
    jmp .__ret_898
.__ret_898:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_type_fn:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L918
    mov rax, 0
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    jmp .__ret_917
    jmp .L919
.L918:
.L919:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L920:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L921
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L923
    mov rax, 0
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    jmp .__ret_917
    jmp .L924
.L923:
.L924:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L925
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L926
.L925:
.L926:
.L922:
    jmp .L920
.L921:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_ARROW]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L927
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L929
    mov rax, 0
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    jmp .__ret_917
    jmp .L930
.L929:
.L930:
    mov rax, [rel __g_parser_par_last_is_float]
    cmp rax, 0
    je .L931
    mov rax, 2
    mov rbx, rax
    jmp .L932
.L931:
    mov rax, [rel __g_parser_par_last_vtag]
    cmp rax, 1
    jne .L933
    mov rax, 1
    mov rbx, rax
    jmp .L934
.L933:
.L934:
.L932:
    jmp .L928
.L927:
.L928:
    mov rax, rbx
    shl rax, 4
    or rax, 5
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    mov rax, 0
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    mov [rel __g_parser_par_last_arr_elem], rax
    mov rax, 1
    jmp .__ret_917
.__ret_917:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_type_ptr:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L936
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_tok], rax
    mov rax, 0
    jmp .__ret_935
    jmp .L937
.L936:
.L937:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L938
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r12, rax
    jmp .L939
.L938:
.L939:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_type_width
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L940
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_tok], rax
    mov rax, 0
    jmp .__ret_935
    jmp .L941
.L940:
.L941:
    mov rax, rbx
    mov [rel __g_parser_par_last_ptr_elem], rax
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L942
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_tok], rax
    mov rax, 0
    jmp .__ret_935
    jmp .L943
.L942:
.L943:
    mov rax, r12
    mov [rel __g_parser_par_last_ptr_tok], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_GT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L944
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_tok], rax
    mov rax, 0
    jmp .__ret_935
    jmp .L945
.L944:
.L945:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_935
.__ret_935:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
prs_type_slice:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L947
    mov rax, 0
    jmp .__ret_946
    jmp .L948
.L947:
.L948:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L949
    mov rax, 0
    jmp .__ret_946
    jmp .L950
.L949:
.L950:
    mov rax, [rel __g_parser_par_last_is_float]
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_GT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L951
    mov rax, 0
    jmp .__ret_946
    jmp .L952
.L951:
.L952:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, 1
    mov [rel __g_parser_par_last_is_slice], rax
    cmp rbx, 0
    je .L953
    mov rax, 2
    mov [rel __g_parser_par_last_is_slice], rax
    jmp .L954
.L953:
.L954:
    mov rax, 1
    jmp .__ret_946
.__ret_946:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_type_arena_tok:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L956
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    jmp .__ret_955
    jmp .L957
.L956:
.L957:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L958
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    jmp .__ret_955
    jmp .L959
.L958:
.L959:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_GT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L960
    mov rax, 0
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, 0
    jmp .__ret_955
    jmp .L961
.L960:
.L961:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 1
    jmp .__ret_955
.__ret_955:
    mov rsp, rbp
    pop rbp
    ret
prs_type_array:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_row_len], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_F32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L965
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_F64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L965
    mov rax, 0
    jmp .L966
.L965:
    mov rax, 1
.L966:
    test rax, rax
    jz .L963
    mov rax, 1
    mov [rel __g_parser_par_last_is_float], rax
    jmp .L964
.L963:
.L964:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L967
    mov rcx, rbx
    sub rsp, 32
    call prs_type_width
    add rsp, 32
    mov r13, rax
    jmp .L968
.L967:
.L968:
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L969
    mov rax, 0
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_row_len], rax
    mov rax, 0
    jmp .__ret_962
    jmp .L970
.L969:
.L970:
    mov rax, [rel __g_parser_par_last_vtag]
    cmp rax, 1
    jne .L971
    mov rax, 0x14
    mov [rel __g_parser_par_last_vtag], rax
    jmp .L972
.L971:
    mov rax, 0
    mov [rel __g_parser_par_last_vtag], rax
.L972:
    cmp r13, 0
    je .L973
    mov rax, r13
    mov [rel __g_parser_par_last_arr_elem], rax
    jmp .L974
.L973:
.L974:
    mov rax, [rel __g_parser_par_last_array_len]
    mov r12, rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L975
    mov rax, 0
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_row_len], rax
    mov rax, 0
    jmp .__ret_962
    jmp .L976
.L975:
.L976:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_INTEGER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L979
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_HEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L979
    mov rax, 1
    jmp .L980
.L979:
    mov rax, 0
.L980:
    test rax, rax
    jz .L977
    mov rax, 0
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_row_len], rax
    mov rax, 0
    jmp .__ret_962
    jmp .L978
.L977:
.L978:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_tok_uint
    add rsp, 32
    mov rbx, rax
    cmp r12, 0
    je .L981
    mov rax, r12
    mov [rel __g_parser_par_last_row_len], rax
    imul rbx, r12
    jmp .L982
.L981:
.L982:
    mov rax, rbx
    mov [rel __g_parser_par_last_array_len], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L983
    mov rax, 0
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, 0
    mov [rel __g_parser_par_last_row_len], rax
    mov rax, 0
    jmp .__ret_962
    jmp .L984
.L983:
.L984:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_962
.__ret_962:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_expression:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call prs_logical
    add rsp, 32
    jmp .__ret_985
.__ret_985:
    mov rsp, rbp
    pop rbp
    ret
prs_binop:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, [rel __g_parser_AST_BINOP]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L987
    mov rax, 0
    jmp .__ret_986
    jmp .L988
.L987:
.L988:
    mov rax, r12
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
    mov rax, r13
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-32]
    jmp .__ret_986
.__ret_986:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_logical:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call prs_bitor
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 0
    jne .L990
    mov rax, 0
    jmp .__ret_989
    jmp .L991
.L990:
.L991:
.L992:
    mov rax, 1
    cmp rax, 1
    jne .L993
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_AND]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L997
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_OR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L997
    mov rax, 1
    jmp .L998
.L997:
    mov rax, 0
.L998:
    test rax, rax
    jz .L995
    mov rax, r13
    jmp .__ret_989
    jmp .L996
.L995:
.L996:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_comparison
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L999
    mov rax, 0
    jmp .__ret_989
    jmp .L1000
.L999:
.L1000:
    mov rcx, rbx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call prs_binop
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1001
    mov rax, 0
    jmp .__ret_989
    jmp .L1002
.L1001:
.L1002:
.L994:
    jmp .L992
.L993:
    mov rax, r13
    jmp .__ret_989
.__ret_989:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_bitor:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    sub rsp, 32
    call prs_bitxor
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jne .L1004
    mov rax, 0
    jmp .__ret_1003
    jmp .L1005
.L1004:
.L1005:
.L1006:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_PIPE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1007
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_bitxor
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1009
    mov rax, 0
    jmp .__ret_1003
    jmp .L1010
.L1009:
.L1010:
    mov rax, [rel __g_parser_TOK_PIPE]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call prs_binop
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1011
    mov rax, 0
    jmp .__ret_1003
    jmp .L1012
.L1011:
.L1012:
.L1008:
    jmp .L1006
.L1007:
    mov rax, r12
    jmp .__ret_1003
.__ret_1003:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
prs_bitxor:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    sub rsp, 32
    call prs_bitand
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jne .L1014
    mov rax, 0
    jmp .__ret_1013
    jmp .L1015
.L1014:
.L1015:
.L1016:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_CARET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1017
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_bitand
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1019
    mov rax, 0
    jmp .__ret_1013
    jmp .L1020
.L1019:
.L1020:
    mov rax, [rel __g_parser_TOK_CARET]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call prs_binop
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1021
    mov rax, 0
    jmp .__ret_1013
    jmp .L1022
.L1021:
.L1022:
.L1018:
    jmp .L1016
.L1017:
    mov rax, r12
    jmp .__ret_1013
.__ret_1013:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
prs_bitand:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    sub rsp, 32
    call prs_comparison
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jne .L1024
    mov rax, 0
    jmp .__ret_1023
    jmp .L1025
.L1024:
.L1025:
.L1026:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_AMPERSAND]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1027
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_bitor
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1029
    mov rax, 0
    jmp .__ret_1023
    jmp .L1030
.L1029:
.L1030:
    mov rax, [rel __g_parser_TOK_AMPERSAND]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call prs_binop
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1031
    mov rax, 0
    jmp .__ret_1023
    jmp .L1032
.L1031:
.L1032:
.L1028:
    jmp .L1026
.L1027:
    mov rax, r12
    jmp .__ret_1023
.__ret_1023:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
prs_is_comparison:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EQ]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1038
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_NEQ]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1038
    mov rax, 0
    jmp .L1039
.L1038:
    mov rax, 1
.L1039:
    test rax, rax
    jnz .L1036
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1036
    mov rax, 0
    jmp .L1037
.L1036:
    mov rax, 1
.L1037:
    test rax, rax
    jz .L1034
    mov rax, 1
    jmp .__ret_1033
    jmp .L1035
.L1034:
.L1035:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_GT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1044
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LTE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1044
    mov rax, 0
    jmp .L1045
.L1044:
    mov rax, 1
.L1045:
    test rax, rax
    jnz .L1042
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_GTE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1042
    mov rax, 0
    jmp .L1043
.L1042:
    mov rax, 1
.L1043:
    test rax, rax
    jz .L1040
    mov rax, 1
    jmp .__ret_1033
    jmp .L1041
.L1040:
.L1041:
    mov rax, 0
    jmp .__ret_1033
.__ret_1033:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_comparison:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call prs_shift
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 0
    jne .L1047
    mov rax, 0
    jmp .__ret_1046
    jmp .L1048
.L1047:
.L1048:
.L1049:
    mov rax, 1
    cmp rax, 1
    jne .L1050
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call prs_is_comparison
    add rsp, 32
    cmp rax, 0
    jne .L1052
    mov rax, r13
    jmp .__ret_1046
    jmp .L1053
.L1052:
.L1053:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_shift
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1054
    mov rax, 0
    jmp .__ret_1046
    jmp .L1055
.L1054:
.L1055:
    mov rcx, rbx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call prs_binop
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1056
    mov rax, 0
    jmp .__ret_1046
    jmp .L1057
.L1056:
.L1057:
.L1051:
    jmp .L1049
.L1050:
    mov rax, r13
    jmp .__ret_1046
.__ret_1046:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_is_shift:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LSHIFT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1063
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RSHIFT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1063
    mov rax, 0
    jmp .L1064
.L1063:
    mov rax, 1
.L1064:
    test rax, rax
    jnz .L1061
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_URSHIFT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1061
    mov rax, 0
    jmp .L1062
.L1061:
    mov rax, 1
.L1062:
    test rax, rax
    jz .L1059
    mov rax, 1
    jmp .__ret_1058
    jmp .L1060
.L1059:
.L1060:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_ROTL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1067
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_ROTR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1067
    mov rax, 0
    jmp .L1068
.L1067:
    mov rax, 1
.L1068:
    test rax, rax
    jz .L1065
    mov rax, 1
    jmp .__ret_1058
    jmp .L1066
.L1065:
.L1066:
    mov rax, 0
    jmp .__ret_1058
.__ret_1058:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_shift:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call prs_additive
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 0
    jne .L1070
    mov rax, 0
    jmp .__ret_1069
    jmp .L1071
.L1070:
.L1071:
.L1072:
    mov rax, 1
    cmp rax, 1
    jne .L1073
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call prs_is_shift
    add rsp, 32
    cmp rax, 0
    jne .L1075
    mov rax, r13
    jmp .__ret_1069
    jmp .L1076
.L1075:
.L1076:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_additive
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1077
    mov rax, 0
    jmp .__ret_1069
    jmp .L1078
.L1077:
.L1078:
    mov rcx, rbx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call prs_binop
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1079
    mov rax, 0
    jmp .__ret_1069
    jmp .L1080
.L1079:
.L1080:
.L1074:
    jmp .L1072
.L1073:
    mov rax, r13
    jmp .__ret_1069
.__ret_1069:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_additive:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call prs_multiplicative
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 0
    jne .L1082
    mov rax, 0
    jmp .__ret_1081
    jmp .L1083
.L1082:
.L1083:
.L1084:
    mov rax, 1
    cmp rax, 1
    jne .L1085
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_PLUS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1089
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_MINUS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1089
    mov rax, 1
    jmp .L1090
.L1089:
    mov rax, 0
.L1090:
    test rax, rax
    jz .L1087
    mov rax, r13
    jmp .__ret_1081
    jmp .L1088
.L1087:
.L1088:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_multiplicative
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1091
    mov rax, 0
    jmp .__ret_1081
    jmp .L1092
.L1091:
.L1092:
    mov rcx, rbx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call prs_binop
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1093
    mov rax, 0
    jmp .__ret_1081
    jmp .L1094
.L1093:
.L1094:
.L1086:
    jmp .L1084
.L1085:
    mov rax, r13
    jmp .__ret_1081
.__ret_1081:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_multiplicative:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call prs_cast
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 0
    jne .L1096
    mov rax, 0
    jmp .__ret_1095
    jmp .L1097
.L1096:
.L1097:
.L1098:
    mov rax, 1
    cmp rax, 1
    jne .L1099
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_STAR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1105
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_SLASH]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1105
    mov rax, 1
    jmp .L1106
.L1105:
    mov rax, 0
.L1106:
    test rax, rax
    jz .L1103
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_PERCENT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1103
    mov rax, 1
    jmp .L1104
.L1103:
    mov rax, 0
.L1104:
    test rax, rax
    jz .L1101
    mov rax, r13
    jmp .__ret_1095
    jmp .L1102
.L1101:
.L1102:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_cast
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1107
    mov rax, 0
    jmp .__ret_1095
    jmp .L1108
.L1107:
.L1108:
    mov rcx, rbx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call prs_binop
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1109
    mov rax, 0
    jmp .__ret_1095
    jmp .L1110
.L1109:
.L1110:
.L1100:
    jmp .L1098
.L1099:
    mov rax, r13
    jmp .__ret_1095
.__ret_1095:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_cast:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    sub rsp, 32
    call prs_unary
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jne .L1112
    mov rax, 0
    jmp .__ret_1111
    jmp .L1113
.L1112:
.L1113:
.L1114:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_KW_AS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1115
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_type_width
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L1117
    mov rax, 0
    jmp .__ret_1111
    jmp .L1118
.L1117:
.L1118:
    mov rax, [rel __g_parser_AST_CAST]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1119
    mov rax, 0
    jmp .__ret_1111
    jmp .L1120
.L1119:
.L1120:
    mov rax, r12
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 40
    mov [rdx], rax
    sub rsp, 32
    call prs_fu_bits
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 38
    mov [rdx], ax
    mov rax, [rbp-16]
    mov r12, rax
.L1116:
    jmp .L1114
.L1115:
    mov rax, r12
    jmp .__ret_1111
.__ret_1111:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_unary:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_TOK_MINUS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1130
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_TOK_NOT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1130
    mov rax, 0
    jmp .L1131
.L1130:
    mov rax, 1
.L1131:
    test rax, rax
    jnz .L1128
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_TOK_TILDE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1128
    mov rax, 0
    jmp .L1129
.L1128:
    mov rax, 1
.L1129:
    test rax, rax
    jnz .L1126
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_KW_INVCACHE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1126
    mov rax, 0
    jmp .L1127
.L1126:
    mov rax, 1
.L1127:
    test rax, rax
    jnz .L1124
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_KW_PREFETCH0]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1124
    mov rax, 0
    jmp .L1125
.L1124:
    mov rax, 1
.L1125:
    test rax, rax
    jz .L1122
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_unary
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1132
    mov rax, 0
    jmp .__ret_1121
    jmp .L1133
.L1132:
.L1133:
    mov rax, [rel __g_parser_AST_UNOP]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L1134
    mov rax, 0
    jmp .__ret_1121
    jmp .L1135
.L1134:
.L1135:
    mov rax, r12
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
    mov rax, r14
    mov rdx, [rbp-40]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-40]
    jmp .__ret_1121
    jmp .L1123
.L1122:
.L1123:
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_TOK_AMPERSAND]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1136
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1138
    mov rax, 0
    jmp .__ret_1121
    jmp .L1139
.L1138:
.L1139:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r13, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1140
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1142
    mov rax, 0
    jmp .__ret_1121
    jmp .L1143
.L1142:
.L1143:
    mov rax, [rel __g_parser_TOK_RBRACKET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1144
    mov rax, 0
    jmp .__ret_1121
    jmp .L1145
.L1144:
.L1145:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_ADDR_OF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L1146
    mov rax, 0
    jmp .__ret_1121
    jmp .L1147
.L1146:
.L1147:
    mov rax, rbx
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
    mov rax, r13
    mov rdx, [rbp-40]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-40]
    jmp .__ret_1121
    jmp .L1141
.L1140:
.L1141:
    mov rax, [rel __g_parser_AST_ADDR_OF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L1148
    mov rax, 0
    jmp .__ret_1121
    jmp .L1149
.L1148:
.L1149:
    mov rax, r13
    mov rdx, [rbp-40]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-40]
    jmp .__ret_1121
    jmp .L1137
.L1136:
.L1137:
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_TOK_STAR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1150
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r13, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_unary
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1152
    mov rax, 0
    jmp .__ret_1121
    jmp .L1153
.L1152:
.L1153:
    mov rax, [rel __g_parser_AST_DEREF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L1154
    mov rax, 0
    jmp .__ret_1121
    jmp .L1155
.L1154:
.L1155:
    mov rax, r12
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
    mov rax, r13
    mov rdx, [rbp-40]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-40]
    jmp .__ret_1121
    jmp .L1151
.L1150:
.L1151:
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_KW_CALL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1156
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_primary
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1158
    mov rax, 0
    jmp .__ret_1121
    jmp .L1159
.L1158:
.L1159:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1160
    mov rax, 0
    jmp .__ret_1121
    jmp .L1161
.L1160:
.L1161:
    sub rsp, 32
    call prs_arg_list
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1162
    mov rax, 0
    jmp .__ret_1121
    jmp .L1163
.L1162:
.L1163:
    mov rax, [rel __g_parser_AST_CALL_INDIRECT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L1164
    mov rax, 0
    jmp .__ret_1121
    jmp .L1165
.L1164:
.L1165:
    mov rax, rbx
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-40]
    jmp .__ret_1121
    jmp .L1157
.L1156:
.L1157:
    sub rsp, 32
    call prs_postfix
    add rsp, 32
    jmp .__ret_1121
.__ret_1121:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
prs_postfix:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    sub rsp, 32
    call prs_primary
    add rsp, 32
    mov [rbp-8], rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L1167
    mov rax, 0
    jmp .__ret_1166
    jmp .L1168
.L1167:
.L1168:
.L1169:
    mov rax, 1
    cmp rax, 1
    jne .L1170
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1172
    mov rdx, [rbp-8]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_AST_MEMBER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1174
section .data
.str1176: db 97,32,102,117,110,99,116,105,111,110,32,107,101,112,116,32,105,110,32,97,32,102,105,101,108,100,32,105,115,32,99,97,108,108,101,100,32,116,104,114,111,117,103,104,32,97,32,118,97,114,105,97,98,108,101,58,32,118,97,114,32,102,32,61
    db 32,115,46,102,105,101,108,100,59,32,102,40,46,46,46,41,0
section .text
    lea rax, [rel .str1176]
    mov [rel __g_parser_par_custom_msg], rax
    mov rax, 0
    jmp .__ret_1166
    jmp .L1175
.L1174:
.L1175:
    sub rsp, 32
    call prs_arg_list
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1177
    mov rax, 0
    jmp .__ret_1166
    jmp .L1178
.L1177:
.L1178:
    mov rax, [rel __g_parser_AST_CALL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1179
    mov rax, 0
    jmp .__ret_1166
    jmp .L1180
.L1179:
.L1180:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-16]
    mov [rbp-8], rax
    jmp .L1173
.L1172:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1181
    sub rsp, 32
    call prs_balanced_brackets
    add rsp, 32
    cmp rax, 0
    jne .L1183
    mov rax, 0
    jmp .__ret_1166
    jmp .L1184
.L1183:
.L1184:
    jmp .L1182
.L1181:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_DOT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1185
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov [rel __g_parser_par_expected], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_is_field_name
    add rsp, 32
    cmp rax, 0
    jne .L1187
    mov rax, 0
    jmp .__ret_1166
    jmp .L1188
.L1187:
.L1188:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_MEMBER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1189
    mov rax, 0
    jmp .__ret_1166
    jmp .L1190
.L1189:
.L1190:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    mov rdx, [rbp-8]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_AST_MEMBER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1191
    mov rax, [rbp-8]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    jmp .L1192
.L1191:
.L1192:
    mov rax, [rbp-16]
    mov [rbp-8], rax
    jmp .L1186
.L1185:
    mov rax, [rbp-8]
    jmp .__ret_1166
.L1186:
.L1182:
.L1173:
.L1171:
    jmp .L1169
.L1170:
    mov rax, [rbp-8]
    jmp .__ret_1166
.__ret_1166:
    mov rbx, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_noarg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1194
    mov rax, 0
    jmp .__ret_1193
    jmp .L1195
.L1194:
.L1195:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1196
    mov rax, 0
    jmp .__ret_1193
    jmp .L1197
.L1196:
.L1197:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call prs_new
    add rsp, 32
    jmp .__ret_1193
.__ret_1193:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_vec2:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-40], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1199
    mov rax, 0
    jmp .__ret_1198
    jmp .L1200
.L1199:
.L1200:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1201
    mov rax, 0
    jmp .__ret_1198
    jmp .L1202
.L1201:
.L1202:
    cmp r13, 0
    jne .L1203
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1205
    mov rax, 0
    jmp .__ret_1198
    jmp .L1206
.L1205:
.L1206:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L1207
    mov rax, 0
    jmp .__ret_1198
    jmp .L1208
.L1207:
.L1208:
    mov rax, r12
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-40]
    jmp .__ret_1198
    jmp .L1204
.L1203:
.L1204:
    mov rax, [rel __g_parser_TOK_COMMA]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1209
    mov rax, 0
    jmp .__ret_1198
    jmp .L1210
.L1209:
.L1210:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1211
    mov rax, 0
    jmp .__ret_1198
    jmp .L1212
.L1211:
.L1212:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1213
    mov rax, 0
    jmp .__ret_1198
    jmp .L1214
.L1213:
.L1214:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L1215
    mov rax, 0
    jmp .__ret_1198
    jmp .L1216
.L1215:
.L1216:
    mov rax, rbx
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-40]
    jmp .__ret_1198
.__ret_1198:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
prs_one_arg:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-32], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1218
    mov rax, 0
    jmp .__ret_1217
    jmp .L1219
.L1218:
.L1219:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1220
    mov rax, 0
    jmp .__ret_1217
    jmp .L1221
.L1220:
.L1221:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1222
    mov rax, 0
    jmp .__ret_1217
    jmp .L1223
.L1222:
.L1223:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L1224
    mov rax, 0
    jmp .__ret_1217
    jmp .L1225
.L1224:
.L1225:
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-32]
    jmp .__ret_1217
.__ret_1217:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_primary:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov [rbp-64], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_is_syscall
    add rsp, 32
    cmp rax, 1
    jne .L1227
    sub rsp, 32
    call prs_syscall
    add rsp, 32
    jmp .__ret_1226
    jmp .L1228
.L1227:
.L1228:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_FN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1229
    sub rsp, 32
    call prs_lambda
    add rsp, 32
    jmp .__ret_1226
    jmp .L1230
.L1229:
.L1230:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_ARG_COUNT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1231
    mov rax, [rel __g_parser_AST_ARG_COUNT]
    mov [rel __g_parser_par_thread_node], rax
    mov rax, [rel __g_parser_par_thread_node]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1232
.L1231:
.L1232:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_TARGET_OS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1233
    mov rax, [rel __g_parser_AST_TARGET_OS]
    mov [rel __g_parser_par_thread_node], rax
    mov rax, [rel __g_parser_par_thread_node]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1234
.L1233:
.L1234:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_ARG_GET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1235
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1237
    mov rax, 0
    jmp .__ret_1226
    jmp .L1238
.L1237:
.L1238:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1239
    mov rax, 0
    jmp .__ret_1226
    jmp .L1240
.L1239:
.L1240:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1241
    mov rax, 0
    jmp .__ret_1226
    jmp .L1242
.L1241:
.L1242:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_ARG_GET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L1243
    mov rax, 0
    jmp .__ret_1226
    jmp .L1244
.L1243:
.L1244:
    mov rax, r13
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-48]
    jmp .__ret_1226
    jmp .L1236
.L1235:
.L1236:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_FAILED]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1245
    mov rax, [rel __g_parser_AST_FAILED]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1246
.L1245:
.L1246:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_SIZEOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1247
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1249
    mov rax, 0
    jmp .__ret_1226
    jmp .L1250
.L1249:
.L1250:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L1251
    mov rax, 0
    jmp .__ret_1226
    jmp .L1252
.L1251:
.L1252:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1253
    mov rax, 0
    jmp .__ret_1226
    jmp .L1254
.L1253:
.L1254:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_SIZEOF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L1255
    mov rax, 0
    jmp .__ret_1226
    jmp .L1256
.L1255:
.L1256:
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_par_last_array_len]
    mov rdx, [rbp-48]
    add rdx, 40
    mov [rdx], rax
    mov rax, [rel __g_parser_par_last_arr_elem]
    mov rdx, [rbp-48]
    add rdx, 32
    mov [rdx], eax
    mov rax, [rbp-48]
    jmp .__ret_1226
    jmp .L1248
.L1247:
.L1248:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_LOADFILE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1257
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1259
    mov rax, 0
    jmp .__ret_1226
    jmp .L1260
.L1259:
.L1260:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1261
    mov rax, 0
    jmp .__ret_1226
    jmp .L1262
.L1261:
.L1262:
    mov rax, [rel __g_parser_TOK_COMMA]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1263
    mov rax, 0
    jmp .__ret_1226
    jmp .L1264
.L1263:
.L1264:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1265
    mov rax, 0
    jmp .__ret_1226
    jmp .L1266
.L1265:
.L1266:
    mov rax, [rel __g_parser_TOK_COMMA]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1267
    mov rax, 0
    jmp .__ret_1226
    jmp .L1268
.L1267:
.L1268:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1269
    mov rax, 0
    jmp .__ret_1226
    jmp .L1270
.L1269:
.L1270:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1271
    mov rax, 0
    jmp .__ret_1226
    jmp .L1272
.L1271:
.L1272:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_LOADFILE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L1273
    mov rax, 0
    jmp .__ret_1226
    jmp .L1274
.L1273:
.L1274:
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    mov rax, r13
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-48]
    jmp .__ret_1226
    jmp .L1258
.L1257:
.L1258:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_THREAD_START]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1275
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1277
    mov rax, 0
    jmp .__ret_1226
    jmp .L1278
.L1277:
.L1278:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1279
    mov rax, 0
    jmp .__ret_1226
    jmp .L1280
.L1279:
.L1280:
    mov rax, [rel __g_parser_TOK_COMMA]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1281
    mov rax, 0
    jmp .__ret_1226
    jmp .L1282
.L1281:
.L1282:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1283
    mov rax, 0
    jmp .__ret_1226
    jmp .L1284
.L1283:
.L1284:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1285
    mov rax, 0
    jmp .__ret_1226
    jmp .L1286
.L1285:
.L1286:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_THREAD_START]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L1287
    mov rax, 0
    jmp .__ret_1226
    jmp .L1288
.L1287:
.L1288:
    mov rax, r12
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, r13
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-48]
    jmp .__ret_1226
    jmp .L1276
.L1275:
.L1276:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_CPU_COUNT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1289
    mov rax, [rel __g_parser_AST_CPU_COUNT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1290
.L1289:
.L1290:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_THREAD_YIELD]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1291
    mov rax, [rel __g_parser_AST_THREAD_YIELD]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1292
.L1291:
.L1292:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_DLL_LOAD]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1293
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1295
    mov rax, 0
    jmp .__ret_1226
    jmp .L1296
.L1295:
.L1296:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1297
    mov rax, 0
    jmp .__ret_1226
    jmp .L1298
.L1297:
.L1298:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1299
    mov rax, 0
    jmp .__ret_1226
    jmp .L1300
.L1299:
.L1300:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_DLL_LOAD]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L1301
    mov rax, 0
    jmp .__ret_1226
    jmp .L1302
.L1301:
.L1302:
    mov rax, r13
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-48]
    jmp .__ret_1226
    jmp .L1294
.L1293:
.L1294:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_DLL_PROC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1303
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1305
    mov rax, 0
    jmp .__ret_1226
    jmp .L1306
.L1305:
.L1306:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1307
    mov rax, 0
    jmp .__ret_1226
    jmp .L1308
.L1307:
.L1308:
    mov rax, [rel __g_parser_TOK_COMMA]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1309
    mov rax, 0
    jmp .__ret_1226
    jmp .L1310
.L1309:
.L1310:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1311
    mov rax, 0
    jmp .__ret_1226
    jmp .L1312
.L1311:
.L1312:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1313
    mov rax, 0
    jmp .__ret_1226
    jmp .L1314
.L1313:
.L1314:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_DLL_PROC]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L1315
    mov rax, 0
    jmp .__ret_1226
    jmp .L1316
.L1315:
.L1316:
    mov rax, r12
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, r13
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-48]
    jmp .__ret_1226
    jmp .L1304
.L1303:
.L1304:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_TICKS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1317
    mov rax, [rel __g_parser_AST_TICKS]
    mov [rel __g_parser_par_thread_node], rax
    mov rax, [rel __g_parser_par_thread_node]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1318
.L1317:
.L1318:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_TICKS_PER_SEC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1319
    mov rax, [rel __g_parser_AST_TICKS_PER_SEC]
    mov [rel __g_parser_par_thread_node], rax
    mov rax, [rel __g_parser_par_thread_node]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1320
.L1319:
.L1320:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_VEC2_LOAD]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1321
    mov rax, [rel __g_parser_AST_VEC2_LOAD]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call prs_vec2
    add rsp, 32
    jmp .__ret_1226
    jmp .L1322
.L1321:
.L1322:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_VEC2_ADD]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1323
    mov rax, [rel __g_parser_AST_VEC2_ADD]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call prs_vec2
    add rsp, 32
    jmp .__ret_1226
    jmp .L1324
.L1323:
.L1324:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_VEC2_SUB]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1325
    mov rax, [rel __g_parser_AST_VEC2_SUB]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call prs_vec2
    add rsp, 32
    jmp .__ret_1226
    jmp .L1326
.L1325:
.L1326:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_VEC2_MUL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1327
    mov rax, [rel __g_parser_AST_VEC2_MUL]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call prs_vec2
    add rsp, 32
    jmp .__ret_1226
    jmp .L1328
.L1327:
.L1328:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1329
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_ARRAY_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L1331
    mov rax, 0
    jmp .__ret_1226
    jmp .L1332
.L1331:
.L1332:
.L1333:
    mov rax, 1
    cmp rax, 1
    jne .L1334
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1336
    jmp .L1334
    jmp .L1337
.L1336:
.L1337:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1338
    mov rax, 0
    jmp .__ret_1226
    jmp .L1339
.L1338:
.L1339:
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1340
    mov rax, 0
    jmp .__ret_1226
    jmp .L1341
.L1340:
.L1341:
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-56], rax
    mov rax, [rbp-56]
    cmp rax, 0
    jne .L1342
    mov rax, 0
    jmp .__ret_1226
    jmp .L1343
.L1342:
.L1343:
    mov rax, r13
    mov rdx, [rbp-56]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L1344
    mov rax, [rbp-56]
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    jmp .L1345
.L1344:
    mov rax, [rbp-56]
    mov rdx, [rbp-64]
    add rdx, 16
    mov [rdx], rax
.L1345:
    mov rax, [rbp-56]
    mov [rbp-64], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1346
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L1347
.L1346:
.L1347:
.L1335:
    jmp .L1333
.L1334:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-48]
    jmp .__ret_1226
    jmp .L1330
.L1329:
.L1330:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_READKEY]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1348
    mov rax, [rel __g_parser_AST_READKEY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1349
.L1348:
.L1349:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_READMOUSE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1350
    mov rax, [rel __g_parser_AST_READMOUSE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1351
.L1350:
.L1351:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_MOUSEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1352
    mov rax, [rel __g_parser_AST_MOUSEX]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1353
.L1352:
.L1353:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_MOUSEY]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1354
    mov rax, [rel __g_parser_AST_MOUSEY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_noarg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1355
.L1354:
.L1355:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_INB]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1356
    mov rax, [rel __g_parser_AST_INB]
    push rax
    pop rcx
    sub rsp, 32
    call prs_one_arg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1357
.L1356:
.L1357:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_PEEK]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1358
    mov rax, [rel __g_parser_AST_PEEK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_one_arg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1359
.L1358:
.L1359:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_TRUNC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1360
    mov rax, [rel __g_parser_AST_TRUNC]
    push rax
    pop rcx
    sub rsp, 32
    call prs_one_arg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1361
.L1360:
.L1361:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_PEEK8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1362
    mov rax, [rel __g_parser_AST_PEEK8]
    push rax
    pop rcx
    sub rsp, 32
    call prs_one_arg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1363
.L1362:
.L1363:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_PEEK16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1364
    mov rax, [rel __g_parser_AST_PEEK16]
    push rax
    pop rcx
    sub rsp, 32
    call prs_one_arg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1365
.L1364:
.L1365:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_PEEK32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1366
    mov rax, [rel __g_parser_AST_PEEK32]
    push rax
    pop rcx
    sub rsp, 32
    call prs_one_arg
    add rsp, 32
    jmp .__ret_1226
    jmp .L1367
.L1366:
.L1367:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_INTEGER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1370
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_HEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1370
    mov rax, 0
    jmp .L1371
.L1370:
    mov rax, 1
.L1371:
    test rax, rax
    jz .L1368
    mov rax, [rel __g_parser_AST_INTEGER_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_literal
    add rsp, 32
    jmp .__ret_1226
    jmp .L1369
.L1368:
.L1369:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_FLOAT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1372
    mov rax, [rel __g_parser_AST_FLOAT_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_literal
    add rsp, 32
    jmp .__ret_1226
    jmp .L1373
.L1372:
.L1373:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_STRING]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1374
    mov rax, [rel __g_parser_AST_STRING_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_literal
    add rsp, 32
    jmp .__ret_1226
    jmp .L1375
.L1374:
.L1375:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_BOOLEAN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1376
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_BOOL_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    jmp .__ret_1226
    jmp .L1377
.L1376:
.L1377:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_TRUE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1380
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_FALSE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1380
    mov rax, 0
    jmp .L1381
.L1380:
    mov rax, 1
.L1381:
    test rax, rax
    jz .L1378
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_BOOL_LIT]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L1382
    mov rax, 0
    jmp .__ret_1226
    jmp .L1383
.L1382:
.L1383:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_TRUE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1384
    mov rax, 1
    mov rdx, [rbp-48]
    add rdx, 40
    mov [rdx], rax
    jmp .L1385
.L1384:
    mov rax, 0
    mov rdx, [rbp-48]
    add rdx, 40
    mov [rdx], rax
.L1385:
    mov rax, [rbp-48]
    jmp .__ret_1226
    jmp .L1379
.L1378:
.L1379:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1386
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_par_no_slit]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1390
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1390
    mov rax, 1
    jmp .L1391
.L1390:
    mov rax, 0
.L1391:
    test rax, rax
    jz .L1388
    mov rcx, rbx
    sub rsp, 32
    call prs_struct_lit
    add rsp, 32
    jmp .__ret_1226
    jmp .L1389
.L1388:
.L1389:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1392
    mov rax, [rel __g_parser_AST_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L1394
    mov rax, 0
    jmp .__ret_1226
    jmp .L1395
.L1394:
.L1395:
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-48]
    jmp .__ret_1226
    jmp .L1393
.L1392:
.L1393:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1396
    mov rax, 0
    jmp .__ret_1226
    jmp .L1397
.L1396:
.L1397:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1398
    mov rax, 0
    jmp .__ret_1226
    jmp .L1399
.L1398:
.L1399:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_INDEX]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L1400
    mov rax, 0
    jmp .__ret_1226
    jmp .L1401
.L1400:
.L1401:
    mov rax, r13
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rcx, rbx
    sub rsp, 32
    call par_is_slice
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1402
    mov rcx, [rbp-48]
    mov rdx, rbx
    sub rsp, 32
    call par_slice_get_call
    add rsp, 32
    jmp .__ret_1226
    jmp .L1403
.L1402:
.L1403:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1404
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1406
    mov rax, 0
    jmp .__ret_1226
    jmp .L1407
.L1406:
.L1407:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1408
    mov rax, 0
    jmp .__ret_1226
    jmp .L1409
.L1408:
.L1409:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, r12
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    jmp .L1405
.L1404:
.L1405:
    mov rax, [rbp-48]
    jmp .__ret_1226
    jmp .L1387
.L1386:
.L1387:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1410
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1412
    mov rax, 0
    jmp .__ret_1226
    jmp .L1413
.L1412:
.L1413:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1414
    mov rax, 0
    jmp .__ret_1226
    jmp .L1415
.L1414:
.L1415:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, r13
    jmp .__ret_1226
    jmp .L1411
.L1410:
.L1411:
    mov rax, [rel __g_parser_TOK_EXPECT_EXPR]
    mov [rel __g_parser_par_expected], rax
    mov rax, 0
    jmp .__ret_1226
.__ret_1226:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
prs_literal:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L1417
    mov rax, 0
    jmp .__ret_1416
    jmp .L1418
.L1417:
.L1418:
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-24]
    jmp .__ret_1416
.__ret_1416:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_is_syscall:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1420
    mov rax, 0
    jmp .__ret_1419
    jmp .L1421
.L1420:
.L1421:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    push rax
section .data
.str1422: db 115,121,115,99,97,108,108,0
section .text
    lea rax, [rel .str1422]
    push rax
    pop rdx
    pop rcx
    mov r8, 7
    sub rsp, 32
    call prs_tok_is
    add rsp, 32
    jmp .__ret_1419
.__ret_1419:
    mov rsp, rbp
    pop rbp
    ret
prs_syscall:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-40], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1424
    mov rax, 0
    jmp .__ret_1423
    jmp .L1425
.L1424:
.L1425:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_SYSCALL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1426
    mov rax, 0
    jmp .__ret_1423
    jmp .L1427
.L1426:
.L1427:
    mov rax, r12
    mov rdx, [rbp-16]
    add rdx, 40
    mov [rdx], rax
.L1428:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_RPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1429
    sub rsp, 32
    call prs_expression
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1431
    mov rax, 0
    jmp .__ret_1423
    jmp .L1432
.L1431:
.L1432:
    mov rax, [rel __g_parser_AST_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L1433
    mov rax, 0
    jmp .__ret_1423
    jmp .L1434
.L1433:
.L1434:
    mov rax, rbx
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L1435
    mov rax, [rbp-40]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    jmp .L1436
.L1435:
    mov rax, [rbp-40]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L1436:
    mov rax, [rbp-40]
    mov [rbp-24], rax
    mov rdx, [rbp-16]
    add rdx, 24
    mov rax, [rdx]
    add rax, 1
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1437
    jmp .L1429
    jmp .L1438
.L1437:
.L1438:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1430:
    jmp .L1428
.L1429:
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1439
    mov rax, 0
    jmp .__ret_1423
    jmp .L1440
.L1439:
.L1440:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 24
    mov rax, [rdx]
    mov rcx, 7
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1443
    mov rdx, [rbp-16]
    add rdx, 24
    mov rax, [rdx]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1443
    mov rax, 0
    jmp .L1444
.L1443:
    mov rax, 1
.L1444:
    test rax, rax
    jz .L1441
    mov rax, 0
    jmp .__ret_1423
    jmp .L1442
.L1441:
.L1442:
    mov rax, [rbp-16]
    jmp .__ret_1423
.__ret_1423:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
prs_lambda:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rax, [rel __g_parser_par_last_is_float]
    mov [rbp-8], rax
    mov rax, [rel __g_parser_par_last_is_unsigned]
    mov [rbp-16], rax
    mov rax, [rel __g_parser_par_last_vtag]
    mov [rbp-24], rax
    mov rax, [rel __g_parser_par_last_array_len]
    mov [rbp-32], rax
    mov rax, [rel __g_parser_par_last_ptr_elem]
    mov [rbp-40], rax
    mov rax, [rel __g_parser_par_last_arr_elem]
    mov r15, rax
    mov rax, [rel __g_parser_par_last_row_len]
    mov r14, rax
    mov rax, [rel __g_parser_par_last_is_slice]
    mov r13, rax
    mov rax, [rel __g_parser_par_decl_typed]
    mov rcx, 0xFFFFFFFF
    and rax, rcx
    mov r12, rax
    sub rsp, 32
    call prs_lambda_parse
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov [rel __g_parser_par_decl_typed], rax
    mov rax, r13
    mov [rel __g_parser_par_last_is_slice], rax
    mov rax, r14
    mov [rel __g_parser_par_last_row_len], rax
    mov rax, r15
    mov [rel __g_parser_par_last_arr_elem], rax
    mov rax, [rbp-40]
    mov [rel __g_parser_par_last_ptr_elem], rax
    mov rax, [rbp-32]
    mov [rel __g_parser_par_last_array_len], rax
    mov rax, [rbp-24]
    mov [rel __g_parser_par_last_vtag], rax
    mov rax, [rbp-16]
    mov [rel __g_parser_par_last_is_unsigned], rax
    mov rax, [rbp-8]
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, rbx
    jmp .__ret_1445
.__ret_1445:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
prs_lambda_parse:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
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
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov [rbp-56], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1447
    mov rax, 0
    jmp .__ret_1446
    jmp .L1448
.L1447:
.L1448:
    sub rsp, 32
    call prs_param_list
    add rsp, 32
    mov r15, rax
    mov rax, r15
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1449
    mov rax, 0
    jmp .__ret_1446
    jmp .L1450
.L1449:
.L1450:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_ARROW]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1451
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_last_is_float], rax
    mov rax, 0
    mov [rel __g_parser_par_last_is_unsigned], rax
    sub rsp, 32
    call prs_type
    add rsp, 32
    cmp rax, 0
    jne .L1453
    mov rax, 0
    jmp .__ret_1446
    jmp .L1454
.L1453:
.L1454:
    sub rsp, 32
    call prs_fu_bits
    add rsp, 32
    push rax
    sub rsp, 32
    call prs_vtag_col
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r14, rax
    jmp .L1452
.L1451:
.L1452:
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1455
    mov rax, 0
    jmp .__ret_1446
    jmp .L1456
.L1455:
.L1456:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1457
    mov rax, 0
    jmp .__ret_1446
    jmp .L1458
.L1457:
.L1458:
    mov rax, [rel __g_parser_par_lam_n]
    mov r12, rax
    cmp r12, 4096
    jl .L1459
    mov rax, 0
    jmp .__ret_1446
    jmp .L1460
.L1459:
.L1460:
    mov rax, r12
    add rax, 1
    mov [rel __g_parser_par_lam_n], rax
    lea rax, [rel __g_parser_par_lam_names]
    push rax
    mov rax, r12
    mov rcx, 16
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str1461: db 95,95,108,97,109,98,100,97,95,0
section .text
    lea rax, [rel .str1461]
    push rax
    pop rdx
    pop rcx
    mov r8, 9
    mov r9, r12
    sub rsp, 32
    call prs_make_name
    add rsp, 32
    lea rax, [rel __g_parser_par_lam_toks]
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-48], rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rdx, [rbp-48]
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    mov rax, 13
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], eax
    mov rax, 0
    mov rdx, [rbp-48]
    add rdx, 20
    mov [rdx], ax
    mov rax, 0
    mov rdx, [rbp-48]
    add rdx, 22
    mov [rdx], ax
    mov rax, [rel __g_parser_AST_LAMBDA]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-56], rax
    mov rax, [rbp-56]
    cmp rax, 0
    jne .L1462
    mov rax, 0
    jmp .__ret_1446
    jmp .L1463
.L1462:
.L1463:
    mov rax, [rbp-48]
    mov rdx, [rbp-56]
    add rdx, 24
    mov [rdx], rax
    mov rax, r15
    mov rdx, [rbp-56]
    add rdx, 8
    mov [rdx], rax
    mov rax, r13
    mov rdx, [rbp-56]
    add rdx, 16
    mov [rdx], rax
    mov rax, r14
    mov rdx, [rbp-56]
    add rdx, 38
    mov [rdx], ax
    mov rax, [rbp-56]
    jmp .__ret_1446
.__ret_1446:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
prs_generic_decl:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
.L1465:
    mov rax, 1
    cmp rax, 1
    jne .L1466
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1470
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1470
    mov rax, 0
    jmp .L1471
.L1470:
    mov rax, 1
.L1471:
    test rax, rax
    jz .L1468
    mov rax, 0
    jmp .__ret_1464
    jmp .L1469
.L1468:
.L1469:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1472
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    jmp .__ret_1464
    jmp .L1473
.L1472:
.L1473:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1474
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_1464
    jmp .L1475
.L1474:
.L1475:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1476
    sub rsp, 32
    call prs_balanced_parens
    add rsp, 32
    cmp rax, 0
    jne .L1478
    mov rax, 0
    jmp .__ret_1464
    jmp .L1479
.L1478:
.L1479:
    jmp .L1477
.L1476:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1480
    sub rsp, 32
    call prs_balanced_brackets
    add rsp, 32
    cmp rax, 0
    jne .L1482
    mov rax, 0
    jmp .__ret_1464
    jmp .L1483
.L1482:
.L1483:
    jmp .L1481
.L1480:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1481:
.L1477:
.L1467:
    jmp .L1465
.L1466:
    mov rax, 0
    jmp .__ret_1464
.__ret_1464:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_generic_block:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1485:
    mov rax, 1
    cmp rax, 1
    jne .L1486
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1488
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_1484
    jmp .L1489
.L1488:
.L1489:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1490
    mov rax, 0
    jmp .__ret_1484
    jmp .L1491
.L1490:
.L1491:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1492
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    cmp rax, 0
    jne .L1494
    mov rax, 0
    jmp .__ret_1484
    jmp .L1495
.L1494:
.L1495:
    jmp .L1493
.L1492:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1496
    sub rsp, 32
    call prs_balanced_parens
    add rsp, 32
    cmp rax, 0
    jne .L1498
    mov rax, 0
    jmp .__ret_1484
    jmp .L1499
.L1498:
.L1499:
    jmp .L1497
.L1496:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1500
    sub rsp, 32
    call prs_balanced_brackets
    add rsp, 32
    cmp rax, 0
    jne .L1502
    mov rax, 0
    jmp .__ret_1484
    jmp .L1503
.L1502:
.L1503:
    jmp .L1501
.L1500:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1501:
.L1497:
.L1493:
.L1487:
    jmp .L1485
.L1486:
    mov rax, 0
    jmp .__ret_1484
.__ret_1484:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_balanced_parens:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1505:
    mov rax, 1
    cmp rax, 1
    jne .L1506
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1508
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_1504
    jmp .L1509
.L1508:
.L1509:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1510
    mov rax, 0
    jmp .__ret_1504
    jmp .L1511
.L1510:
.L1511:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1512
    sub rsp, 32
    call prs_balanced_parens
    add rsp, 32
    cmp rax, 0
    jne .L1514
    mov rax, 0
    jmp .__ret_1504
    jmp .L1515
.L1514:
.L1515:
    jmp .L1513
.L1512:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1516
    sub rsp, 32
    call prs_balanced_brackets
    add rsp, 32
    cmp rax, 0
    jne .L1518
    mov rax, 0
    jmp .__ret_1504
    jmp .L1519
.L1518:
.L1519:
    jmp .L1517
.L1516:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1520
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    cmp rax, 0
    jne .L1522
    mov rax, 0
    jmp .__ret_1504
    jmp .L1523
.L1522:
.L1523:
    jmp .L1521
.L1520:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1521:
.L1517:
.L1513:
.L1507:
    jmp .L1505
.L1506:
    mov rax, 0
    jmp .__ret_1504
.__ret_1504:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_balanced_brackets:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1525:
    mov rax, 1
    cmp rax, 1
    jne .L1526
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1528
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_1524
    jmp .L1529
.L1528:
.L1529:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1530
    mov rax, 0
    jmp .__ret_1524
    jmp .L1531
.L1530:
.L1531:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACKET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1532
    sub rsp, 32
    call prs_balanced_brackets
    add rsp, 32
    cmp rax, 0
    jne .L1534
    mov rax, 0
    jmp .__ret_1524
    jmp .L1535
.L1534:
.L1535:
    jmp .L1533
.L1532:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1536
    sub rsp, 32
    call prs_balanced_parens
    add rsp, 32
    cmp rax, 0
    jne .L1538
    mov rax, 0
    jmp .__ret_1524
    jmp .L1539
.L1538:
.L1539:
    jmp .L1537
.L1536:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1540
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    cmp rax, 0
    jne .L1542
    mov rax, 0
    jmp .__ret_1524
    jmp .L1543
.L1542:
.L1543:
    jmp .L1541
.L1540:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1541:
.L1537:
.L1533:
.L1527:
    jmp .L1525
.L1526:
    mov rax, 0
    jmp .__ret_1524
.__ret_1524:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_is_cfg_value:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_HEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1551
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_INTEGER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1551
    mov rax, 0
    jmp .L1552
.L1551:
    mov rax, 1
.L1552:
    test rax, rax
    jnz .L1549
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1549
    mov rax, 0
    jmp .L1550
.L1549:
    mov rax, 1
.L1550:
    test rax, rax
    jnz .L1547
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_STRING]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1547
    mov rax, 0
    jmp .L1548
.L1547:
    mov rax, 1
.L1548:
    test rax, rax
    jz .L1545
    mov rax, 1
    jmp .__ret_1544
    jmp .L1546
.L1545:
.L1546:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_TRUE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1555
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_FALSE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1555
    mov rax, 0
    jmp .L1556
.L1555:
    mov rax, 1
.L1556:
    test rax, rax
    jz .L1553
    mov rax, 1
    jmp .__ret_1544
    jmp .L1554
.L1553:
.L1554:
    mov rax, 0
    jmp .__ret_1544
.__ret_1544:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_cur_is:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    sub rsp, 32
    call prs_cur
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call prs_tok_is
    add rsp, 32
    jmp .__ret_1557
.__ret_1557:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
prs_is_num:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_INTEGER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1561
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_HEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1561
    mov rax, 0
    jmp .L1562
.L1561:
    mov rax, 1
.L1562:
    test rax, rax
    jz .L1559
    mov rax, 1
    jmp .__ret_1558
    jmp .L1560
.L1559:
.L1560:
    mov rax, 0
    jmp .__ret_1558
.__ret_1558:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_sys:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1564
    mov rax, 0
    jmp .__ret_1563
    jmp .L1565
.L1564:
.L1565:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1566
    mov rax, 0
    jmp .__ret_1563
    jmp .L1567
.L1566:
.L1567:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_SYS_DEF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1568
    mov rax, 0
    jmp .__ret_1563
    jmp .L1569
.L1568:
.L1569:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
.L1570:
    mov rax, 1
    cmp rax, 1
    jne .L1571
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1573
    jmp .L1571
    jmp .L1574
.L1573:
.L1574:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1575
    mov rax, 0
    jmp .__ret_1563
    jmp .L1576
.L1575:
.L1576:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1577
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1579
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    cmp rax, 0
    jne .L1581
    mov rax, 0
    jmp .__ret_1563
    jmp .L1582
.L1581:
.L1582:
    jmp .L1580
.L1579:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1580:
    jmp .L1578
.L1577:
section .data
.str1585: db 115,101,114,118,105,99,101,0
section .text
    lea rax, [rel .str1585]
    push rax
    pop rcx
    mov rdx, 7
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    cmp rax, 1
    jne .L1583
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_is_num
    add rsp, 32
    cmp rax, 0
    jne .L1586
    mov rax, 0
    jmp .__ret_1563
    jmp .L1587
.L1586:
.L1587:
    mov rax, [rel __g_parser_AST_SYS_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L1588
    mov rax, 0
    jmp .__ret_1563
    jmp .L1589
.L1588:
.L1589:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1590
    mov rax, 0
    jmp .__ret_1563
    jmp .L1591
.L1590:
.L1591:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1592
    mov rax, 0
    jmp .__ret_1563
    jmp .L1593
.L1592:
.L1593:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1594
    mov rax, 0
    jmp .__ret_1563
    jmp .L1595
.L1594:
.L1595:
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L1596
    mov rax, [rbp-32]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    jmp .L1597
.L1596:
    mov rax, [rbp-32]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L1597:
    mov rax, [rbp-32]
    mov [rbp-24], rax
    jmp .L1584
.L1583:
    sub rsp, 32
    call prs_sys_is_mechanism
    add rsp, 32
    cmp rax, 1
    jne .L1598
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1600
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1602
section .data
.str1606: db 115,121,115,99,97,108,108,95,102,97,115,116,0
section .text
    lea rax, [rel .str1606]
    push rax
    pop rcx
    mov rdx, 12
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    cmp rax, 1
    jne .L1604
    mov rax, 1
    mov rdx, [rbp-16]
    add rdx, 40
    mov [rdx], rax
    jmp .L1605
.L1604:
.L1605:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L1603
.L1602:
.L1603:
    jmp .L1601
.L1600:
.L1601:
    jmp .L1599
.L1598:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1607
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    cmp rax, 0
    jne .L1609
    mov rax, 0
    jmp .__ret_1563
    jmp .L1610
.L1609:
.L1610:
    jmp .L1608
.L1607:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1608:
.L1599:
.L1584:
.L1578:
.L1572:
    jmp .L1570
.L1571:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-16]
    jmp .__ret_1563
.__ret_1563:
    mov rbx, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
prs_sys_is_mechanism:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-8], rax
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 9
    je .L1612
    mov rax, 0
    jmp .__ret_1611
    jmp .L1613
.L1612:
.L1613:
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
section .data
.str1616: db 109,101,99,104,0
section .text
    lea rax, [rel .str1616]
    push rax
    pop rdx
    pop rcx
    mov r8, 4
    sub rsp, 32
    call prs_memeq
    add rsp, 32
    cmp rax, 0
    jne .L1614
    mov rax, 0
    jmp .__ret_1611
    jmp .L1615
.L1614:
.L1615:
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    add rax, 5
    push rax
section .data
.str1617: db 110,105,115,109,0
section .text
    lea rax, [rel .str1617]
    push rax
    pop rdx
    pop rcx
    mov r8, 4
    sub rsp, 32
    call prs_memeq
    add rsp, 32
    jmp .__ret_1611
.__ret_1611:
    mov rsp, rbp
    pop rbp
    ret
prs_sched:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1619
    mov rax, 0
    jmp .__ret_1618
    jmp .L1620
.L1619:
.L1620:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1621:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1622
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1624
    mov rax, 0
    jmp .__ret_1618
    jmp .L1625
.L1624:
.L1625:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1623:
    jmp .L1621
.L1622:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_SCHED_DEF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1626
    mov rax, 0
    jmp .__ret_1618
    jmp .L1627
.L1626:
.L1627:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
.L1628:
    mov rax, 1
    cmp rax, 1
    jne .L1629
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1631
    jmp .L1629
    jmp .L1632
.L1631:
.L1632:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1633
    mov rax, 0
    jmp .__ret_1618
    jmp .L1634
.L1633:
.L1634:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1635
    mov rax, [rel __g_parser_AST_CFG_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L1637
    mov rax, 0
    jmp .__ret_1618
    jmp .L1638
.L1637:
.L1638:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1639
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call prs_is_cfg_value
    add rsp, 32
    cmp rax, 0
    jne .L1641
    mov rax, 0
    jmp .__ret_1618
    jmp .L1642
.L1641:
.L1642:
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 40
    mov [rdx], rax
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1643
    mov rax, 0
    jmp .__ret_1618
    jmp .L1644
.L1643:
.L1644:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L1645
    mov rax, [rbp-32]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    jmp .L1646
.L1645:
    mov rax, [rbp-32]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L1646:
    mov rax, [rbp-32]
    mov [rbp-24], rax
    jmp .L1640
.L1639:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1647
    mov rdx, [rbp-16]
    add rdx, 8
    mov rax, [rdx]
    cmp rax, 0
    jne .L1649
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1651
    mov rax, 0
    jmp .__ret_1618
    jmp .L1652
.L1651:
.L1652:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    jmp .L1650
.L1649:
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    cmp rax, 0
    jne .L1653
    mov rax, 0
    jmp .__ret_1618
    jmp .L1654
.L1653:
.L1654:
.L1650:
    jmp .L1648
.L1647:
.L1648:
.L1640:
    jmp .L1636
.L1635:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1655
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    cmp rax, 0
    jne .L1657
    mov rax, 0
    jmp .__ret_1618
    jmp .L1658
.L1657:
.L1658:
    jmp .L1656
.L1655:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1659
    sub rsp, 32
    call prs_balanced_parens
    add rsp, 32
    cmp rax, 0
    jne .L1661
    mov rax, 0
    jmp .__ret_1618
    jmp .L1662
.L1661:
.L1662:
    jmp .L1660
.L1659:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1660:
.L1656:
.L1636:
.L1630:
    jmp .L1628
.L1629:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-16]
    jmp .__ret_1618
.__ret_1618:
    mov rbx, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_config:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1664
    mov rax, 0
    jmp .__ret_1663
    jmp .L1665
.L1664:
.L1665:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1666
    mov rax, 0
    jmp .__ret_1663
    jmp .L1667
.L1666:
.L1667:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_CFG_DEF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L1668
    mov rax, 0
    jmp .__ret_1663
    jmp .L1669
.L1668:
.L1669:
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-24]
    add rdx, 8
    mov [rdx], rax
    mov rax, 0
    mov [rel __g_parser_par_cfg_depth], rax
.L1670:
    mov rax, 1
    cmp rax, 1
    jne .L1671
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1673
    mov rax, [rel __g_parser_par_cfg_depth]
    cmp rax, 0
    jne .L1675
    jmp .L1671
    jmp .L1676
.L1675:
.L1676:
    mov rax, [rel __g_parser_par_cfg_depth]
    sub rax, 1
    mov [rel __g_parser_par_cfg_depth], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L1674
.L1673:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1677
    mov rax, 0
    jmp .__ret_1663
    jmp .L1678
.L1677:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1679
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1681
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_par_cfg_depth]
    add rax, 1
    mov [rel __g_parser_par_cfg_depth], rax
    jmp .L1682
.L1681:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1683
    sub rsp, 32
    call prs_balanced_parens
    add rsp, 32
    cmp rax, 0
    jne .L1685
    mov rax, 0
    jmp .__ret_1663
    jmp .L1686
.L1685:
.L1686:
    jmp .L1684
.L1683:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1684:
.L1682:
    jmp .L1680
.L1679:
    mov rax, [rel __g_parser_AST_CFG_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L1687
    mov rax, 0
    jmp .__ret_1663
    jmp .L1688
.L1687:
.L1688:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-40]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1689
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call prs_is_cfg_value
    add rsp, 32
    cmp rax, 0
    jne .L1691
    mov rax, 0
    jmp .__ret_1663
    jmp .L1692
.L1691:
.L1692:
    mov rax, rbx
    mov rdx, [rbp-40]
    add rdx, 40
    mov [rdx], rax
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1693
    mov rax, 0
    jmp .__ret_1663
    jmp .L1694
.L1693:
.L1694:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L1695
    mov rax, [rbp-40]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
    jmp .L1696
.L1695:
    mov rax, [rbp-40]
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
.L1696:
    mov rax, [rbp-40]
    mov [rbp-32], rax
    jmp .L1690
.L1689:
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1697
    sub rsp, 32
    call prs_balanced_parens
    add rsp, 32
    cmp rax, 0
    jne .L1699
    mov rax, 0
    jmp .__ret_1663
    jmp .L1700
.L1699:
.L1700:
    mov rax, 1
    mov rbx, rax
    jmp .L1698
.L1697:
    mov rdx, [rbp-40]
    add rdx, 24
    mov rax, [rdx]
    mov [rbp-56], rax
    mov rdx, [rbp-56]
    add rdx, 16
    mov eax, dword [rdx]
    mov rcx, 3
    cmp rax, rcx
    setae al
    movzx rax, al
    test rax, rax
    jz .L1707
    mov rdx, [rbp-56]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    mov rcx, 111
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1707
    mov rax, 1
    jmp .L1708
.L1707:
    mov rax, 0
.L1708:
    test rax, rax
    jz .L1705
    mov rdx, [rbp-56]
    add rdx, 8
    mov rax, [rdx]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    mov rcx, 110
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1705
    mov rax, 1
    jmp .L1706
.L1705:
    mov rax, 0
.L1706:
    test rax, rax
    jz .L1703
    mov rdx, [rbp-56]
    add rdx, 8
    mov rax, [rdx]
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    mov rcx, 95
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1703
    mov rax, 1
    jmp .L1704
.L1703:
    mov rax, 0
.L1704:
    test rax, rax
    jz .L1701
    mov rax, 1
    mov rbx, rax
    jmp .L1702
.L1701:
.L1702:
.L1698:
    cmp rbx, 1
    jne .L1709
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1711
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1713
    mov rax, 0
    jmp .__ret_1663
    jmp .L1714
.L1713:
.L1714:
    mov rax, rbx
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rel __g_parser_CFG_HANDLER_MARK]
    mov rdx, [rbp-40]
    add rdx, 40
    mov [rdx], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L1715
    mov rax, [rbp-40]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
    jmp .L1716
.L1715:
    mov rax, [rbp-40]
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
.L1716:
    mov rax, [rbp-40]
    mov [rbp-32], rax
    jmp .L1712
.L1711:
.L1712:
    jmp .L1710
.L1709:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1717
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_par_cfg_depth]
    add rax, 1
    mov [rel __g_parser_par_cfg_depth], rax
    jmp .L1718
.L1717:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1719
    sub rsp, 32
    call prs_balanced_parens
    add rsp, 32
    cmp rax, 0
    jne .L1721
    mov rax, 0
    jmp .__ret_1663
    jmp .L1722
.L1721:
.L1722:
    jmp .L1720
.L1719:
.L1720:
.L1718:
.L1710:
.L1690:
.L1680:
.L1678:
.L1674:
.L1672:
    jmp .L1670
.L1671:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-24]
    jmp .__ret_1663
.__ret_1663:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov rsp, rbp
    pop rbp
    ret
prs_isr:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1724
    mov rax, 0
    jmp .__ret_1723
    jmp .L1725
.L1724:
.L1725:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r13, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1726:
    mov rax, 1
    cmp rax, 1
    jne .L1727
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1729
    jmp .L1727
    jmp .L1730
.L1729:
.L1730:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1731
    mov rax, 0
    jmp .__ret_1723
    jmp .L1732
.L1731:
.L1732:
    mov rcx, rbx
    sub rsp, 32
    call prs_is_num
    add rsp, 32
    cmp rax, 1
    jne .L1733
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r12, rax
    jmp .L1734
.L1733:
.L1734:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1728:
    jmp .L1726
.L1727:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1735
    mov rax, 0
    jmp .__ret_1723
    jmp .L1736
.L1735:
.L1736:
    mov rax, [rel __g_parser_AST_ISR_DEF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L1737
    mov rax, 0
    jmp .__ret_1723
    jmp .L1738
.L1737:
.L1738:
    mov rax, r13
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-32]
    jmp .__ret_1723
.__ret_1723:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_mmu_push:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_par_mmu_tail]
    cmp rax, 0
    jne .L1740
    mov rax, [rbp-16]
    mov rdx, [rbp-8]
    add rdx, 40
    mov [rdx], rax
    jmp .L1741
.L1740:
    mov rax, [rel __g_parser_par_mmu_tail]
    mov [rbp-24], rax
    mov rax, [rbp-16]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L1741:
    mov rax, [rbp-16]
    mov [rel __g_parser_par_mmu_tail], rax
    mov rax, 0
    jmp .__ret_1739
.__ret_1739:
    mov rsp, rbp
    pop rbp
    ret
prs_pool_push:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], rcx
    mov rax, [rel __g_parser_par_pool_node]
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_par_pool_tail]
    cmp rax, 0
    jne .L1743
    mov rax, [rbp-16]
    mov rdx, [rbp-8]
    add rdx, 8
    mov [rdx], rax
    jmp .L1744
.L1743:
    mov rax, [rel __g_parser_par_pool_tail]
    mov [rbp-24], rax
    mov rax, [rbp-16]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L1744:
    mov rax, [rbp-16]
    mov [rel __g_parser_par_pool_tail], rax
    mov rax, 0
    jmp .__ret_1742
.__ret_1742:
    mov rsp, rbp
    pop rbp
    ret
prs_mmu:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1746
    mov rax, 0
    jmp .__ret_1745
    jmp .L1747
.L1746:
.L1747:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1748
    mov rax, 0
    jmp .__ret_1745
    jmp .L1749
.L1748:
.L1749:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_MMU_DEF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1750
    mov rax, 0
    jmp .__ret_1745
    jmp .L1751
.L1750:
.L1751:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    mov rax, 0
    mov [rel __g_parser_prs_mmu_levels], rax
    mov rax, 0
    mov [rel __g_parser_par_mmu_tail], rax
.L1752:
    mov rax, 1
    cmp rax, 1
    jne .L1753
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1755
    jmp .L1753
    jmp .L1756
.L1755:
.L1756:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1757
    mov rax, 0
    jmp .__ret_1745
    jmp .L1758
.L1757:
.L1758:
    mov rax, 2
    mov r12, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1759
    mov rcx, [rbp-16]
    sub rsp, 32
    call prs_mmu_section
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1761
    mov rax, 0
    jmp .__ret_1745
    jmp .L1762
.L1761:
.L1762:
    jmp .L1760
.L1759:
.L1760:
    cmp r12, 2
    jne .L1763
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1765
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    cmp rax, 0
    jne .L1767
    mov rax, 0
    jmp .__ret_1745
    jmp .L1768
.L1767:
.L1768:
    jmp .L1766
.L1765:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1769
    sub rsp, 32
    call prs_balanced_parens
    add rsp, 32
    cmp rax, 0
    jne .L1771
    mov rax, 0
    jmp .__ret_1745
    jmp .L1772
.L1771:
.L1772:
    jmp .L1770
.L1769:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1770:
.L1766:
    jmp .L1764
.L1763:
.L1764:
.L1754:
    jmp .L1752
.L1753:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-16]
    jmp .__ret_1745
.__ret_1745:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_mmu_section:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
section .data
.str1776: db 112,97,103,101,95,116,97,98,108,101,95,104,105,101,114,97,114,99,104,121,0
section .text
    lea rax, [rel .str1776]
    push rax
    pop rcx
    mov rdx, 20
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    cmp rax, 1
    jne .L1774
    mov rcx, rbx
    sub rsp, 32
    call prs_mmu_pages
    add rsp, 32
    jmp .__ret_1773
    jmp .L1775
.L1774:
.L1775:
section .data
.str1779: db 104,101,97,112,95,97,114,101,110,97,95,100,101,102,105,110,105,116,105,111,110,0
section .text
    lea rax, [rel .str1779]
    push rax
    pop rcx
    mov rdx, 21
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    cmp rax, 1
    jne .L1777
    mov rcx, rbx
    sub rsp, 32
    call prs_mmu_arenas
    add rsp, 32
    jmp .__ret_1773
    jmp .L1778
.L1777:
.L1778:
section .data
.str1782: db 99,97,99,104,101,95,112,111,108,105,99,121,0
section .text
    lea rax, [rel .str1782]
    push rax
    pop rcx
    mov rdx, 12
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    cmp rax, 1
    jne .L1780
    mov rcx, rbx
    sub rsp, 32
    call prs_mmu_cache
    add rsp, 32
    jmp .__ret_1773
    jmp .L1781
.L1780:
.L1781:
section .data
.str1785: db 110,117,109,97,95,110,111,100,101,95,97,102,102,105,110,105,116,121,0
section .text
    lea rax, [rel .str1785]
    push rax
    pop rcx
    mov rdx, 18
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    cmp rax, 1
    jne .L1783
    mov rcx, rbx
    sub rsp, 32
    call prs_mmu_numa
    add rsp, 32
    jmp .__ret_1773
    jmp .L1784
.L1783:
.L1784:
section .data
.str1788: db 103,97,114,98,97,103,101,95,99,111,108,108,101,99,116,105,111,110,95,112,111,108,105,99,121,0
section .text
    lea rax, [rel .str1788]
    push rax
    pop rcx
    mov rdx, 25
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    cmp rax, 1
    jne .L1786
    mov rcx, rbx
    sub rsp, 32
    call prs_mmu_gc
    add rsp, 32
    jmp .__ret_1773
    jmp .L1787
.L1786:
.L1787:
section .data
.str1791: db 111,110,95,112,97,103,101,95,102,97,117,108,116,0
section .text
    lea rax, [rel .str1791]
    push rax
    pop rcx
    mov rdx, 13
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    cmp rax, 1
    jne .L1789
    mov rcx, rbx
    sub rsp, 32
    call prs_mmu_pgfault
    add rsp, 32
    jmp .__ret_1773
    jmp .L1790
.L1789:
.L1790:
section .data
.str1794: db 111,110,95,111,117,116,95,111,102,95,109,101,109,111,114,121,95,112,114,101,115,115,117,114,101,0
section .text
    lea rax, [rel .str1794]
    push rax
    pop rcx
    mov rdx, 25
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    cmp rax, 1
    jne .L1792
    mov rcx, rbx
    sub rsp, 32
    call prs_mmu_oom
    add rsp, 32
    jmp .__ret_1773
    jmp .L1793
.L1792:
.L1793:
section .data
.str1797: db 100,121,110,97,109,105,99,95,97,108,108,111,99,97,116,105,111,110,95,112,111,111,108,0
section .text
    lea rax, [rel .str1797]
    push rax
    pop rcx
    mov rdx, 23
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    cmp rax, 1
    jne .L1795
    mov rcx, rbx
    sub rsp, 32
    call prs_mmu_pool
    add rsp, 32
    jmp .__ret_1773
    jmp .L1796
.L1795:
.L1796:
    mov rax, 2
    jmp .__ret_1773
.__ret_1773:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_mmu_pages:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-8], rcx
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1799
    mov rax, 0
    jmp .__ret_1798
    jmp .L1800
.L1799:
.L1800:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1801:
    mov rax, 1
    cmp rax, 1
    jne .L1802
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1804
    jmp .L1802
    jmp .L1805
.L1804:
.L1805:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1806
    mov rax, 0
    jmp .__ret_1798
    jmp .L1807
.L1806:
.L1807:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1808
    mov rax, 0
    jmp .__ret_1798
    jmp .L1809
.L1808:
.L1809:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_is_num
    add rsp, 32
    cmp rax, 0
    jne .L1810
    mov rax, 0
    jmp .__ret_1798
    jmp .L1811
.L1810:
.L1811:
    mov rax, [rel __g_parser_AST_MMU_LEVEL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1812
    mov rax, 0
    jmp .__ret_1798
    jmp .L1813
.L1812:
.L1813:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1814
    mov rax, 0
    jmp .__ret_1798
    jmp .L1815
.L1814:
.L1815:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_is_num
    add rsp, 32
    cmp rax, 0
    jne .L1816
    mov rax, 0
    jmp .__ret_1798
    jmp .L1817
.L1816:
.L1817:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1818
    mov rax, 0
    jmp .__ret_1798
    jmp .L1819
.L1818:
.L1819:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_prs_mmu_levels]
    cmp rax, 0
    jne .L1820
    mov rax, [rbp-16]
    mov rdx, [rbp-8]
    add rdx, 16
    mov [rdx], rax
    jmp .L1821
.L1820:
    mov rax, [rel __g_parser_prs_mmu_levels]
    mov [rbp-24], rax
    mov rax, [rbp-16]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L1821:
    mov rax, [rbp-16]
    mov [rel __g_parser_prs_mmu_levels], rax
.L1803:
    jmp .L1801
.L1802:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_1798
.__ret_1798:
    mov rbx, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_mmu_arenas:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-8], rcx
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1823
    mov rax, 0
    jmp .__ret_1822
    jmp .L1824
.L1823:
.L1824:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_arn_tail], rax
.L1825:
    mov rax, 1
    cmp rax, 1
    jne .L1826
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1828
    jmp .L1826
    jmp .L1829
.L1828:
.L1829:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1830
    mov rax, 0
    jmp .__ret_1822
    jmp .L1831
.L1830:
.L1831:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1832
    mov rax, 0
    jmp .__ret_1822
    jmp .L1833
.L1832:
.L1833:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1834
    mov rax, 0
    jmp .__ret_1822
    jmp .L1835
.L1834:
.L1835:
    mov rax, [rel __g_parser_AST_ARENA_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1836
    mov rax, 0
    jmp .__ret_1822
    jmp .L1837
.L1836:
.L1837:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1838
    mov rax, 0
    jmp .__ret_1822
    jmp .L1839
.L1838:
.L1839:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_is_num
    add rsp, 32
    cmp rax, 0
    jne .L1840
    mov rax, 0
    jmp .__ret_1822
    jmp .L1841
.L1840:
.L1841:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1842
    mov rax, 0
    jmp .__ret_1822
    jmp .L1843
.L1842:
.L1843:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_is_num
    add rsp, 32
    cmp rax, 0
    jne .L1844
    mov rax, 0
    jmp .__ret_1822
    jmp .L1845
.L1844:
.L1845:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 40
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1846
    mov rax, 0
    jmp .__ret_1822
    jmp .L1847
.L1846:
.L1847:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1848
    mov rax, 0
    jmp .__ret_1822
    jmp .L1849
.L1848:
.L1849:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-32], rax
    mov rdx, [rbp-32]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 12
    jne .L1850
    mov rax, [rel __g_parser_ARENA_GROWTH_FIXED]
    mov rbx, rax
    jmp .L1851
.L1850:
    mov rdx, [rbp-32]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 18
    jne .L1852
    mov rax, [rel __g_parser_ARENA_GROWTH_LINEAR]
    mov rbx, rax
    jmp .L1853
.L1852:
    mov rdx, [rbp-32]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 20
    jne .L1854
    mov rax, [rel __g_parser_ARENA_GROWTH_DOUBLING]
    mov rbx, rax
    jmp .L1855
.L1854:
    mov rdx, [rbp-32]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 21
    jne .L1856
    mov rax, [rel __g_parser_ARENA_GROWTH_LAZY]
    mov rbx, rax
    jmp .L1857
.L1856:
    mov rax, 0
    jmp .__ret_1822
.L1857:
.L1855:
.L1853:
.L1851:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 32
    mov [rdx], eax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1858
    mov rax, 0
    jmp .__ret_1822
    jmp .L1859
.L1858:
.L1859:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_par_arn_tail]
    cmp rax, 0
    jne .L1860
    mov rax, [rbp-16]
    mov rdx, [rbp-8]
    add rdx, 8
    mov [rdx], rax
    jmp .L1861
.L1860:
    mov rax, [rel __g_parser_par_arn_tail]
    mov [rbp-24], rax
    mov rax, [rbp-16]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L1861:
    mov rax, [rbp-16]
    mov [rel __g_parser_par_arn_tail], rax
.L1827:
    jmp .L1825
.L1826:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_1822
.__ret_1822:
    mov rbx, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_mmu_cache:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1863
    mov rax, 0
    jmp .__ret_1862
    jmp .L1864
.L1863:
.L1864:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1865:
    mov rax, 1
    cmp rax, 1
    jne .L1866
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1868
    jmp .L1866
    jmp .L1869
.L1868:
.L1869:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1870
    mov rax, 0
    jmp .__ret_1862
    jmp .L1871
.L1870:
.L1871:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_KW_RANGE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1872
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1874
    mov rax, 0
    jmp .__ret_1862
    jmp .L1875
.L1874:
.L1875:
    jmp .L1873
.L1872:
.L1873:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_HEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1876
    mov rax, [rel __g_parser_TOK_INTEGER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1878
    mov rax, 0
    jmp .__ret_1862
    jmp .L1879
.L1878:
.L1879:
    jmp .L1877
.L1876:
.L1877:
    mov rax, [rel __g_parser_AST_MMU_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1880
    mov rax, 0
    jmp .__ret_1862
    jmp .L1881
.L1880:
.L1881:
    mov rax, [rel __g_parser_MMU_ENTRY_CACHE]
    mov rdx, [rbp-16]
    add rdx, 32
    mov [rdx], eax
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1882
    mov rax, 0
    jmp .__ret_1862
    jmp .L1883
.L1882:
.L1883:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1884
    mov rax, 0
    jmp .__ret_1862
    jmp .L1885
.L1884:
.L1885:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-24], rax
    mov rdx, [rbp-24]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 10
    jne .L1886
    mov rax, [rel __g_parser_CACHE_WRITE_BACK]
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    jmp .L1887
.L1886:
    mov rdx, [rbp-24]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 13
    jne .L1888
    mov rax, [rel __g_parser_CACHE_WRITE_THROUGH]
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    jmp .L1889
.L1888:
    mov rax, 0
    jmp .__ret_1862
.L1889:
.L1887:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1890
    mov rax, 0
    jmp .__ret_1862
    jmp .L1891
.L1890:
.L1891:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r12
    mov rdx, [rbp-16]
    sub rsp, 32
    call prs_mmu_push
    add rsp, 32
.L1867:
    jmp .L1865
.L1866:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_1862
.__ret_1862:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_mmu_numa:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1893
    mov rax, 0
    jmp .__ret_1892
    jmp .L1894
.L1893:
.L1894:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L1895:
    mov rax, 1
    cmp rax, 1
    jne .L1896
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1898
    jmp .L1896
    jmp .L1899
.L1898:
.L1899:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1900
    mov rax, 0
    jmp .__ret_1892
    jmp .L1901
.L1900:
.L1901:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1902
    mov rax, 0
    jmp .__ret_1892
    jmp .L1903
.L1902:
.L1903:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_INTEGER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1904
    mov rax, 0
    jmp .__ret_1892
    jmp .L1905
.L1904:
.L1905:
    mov rax, [rel __g_parser_AST_MMU_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1906
    mov rax, 0
    jmp .__ret_1892
    jmp .L1907
.L1906:
.L1907:
    mov rax, [rel __g_parser_MMU_ENTRY_NUMA]
    mov rdx, [rbp-16]
    add rdx, 32
    mov [rdx], eax
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1908
    mov rax, 0
    jmp .__ret_1892
    jmp .L1909
.L1908:
.L1909:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_HEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1910
    mov rax, [rel __g_parser_TOK_INTEGER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1912
    mov rax, 0
    jmp .__ret_1892
    jmp .L1913
.L1912:
.L1913:
    jmp .L1911
.L1910:
.L1911:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1914
    mov rax, 0
    jmp .__ret_1892
    jmp .L1915
.L1914:
.L1915:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_INTEGER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1916
    mov rax, 0
    jmp .__ret_1892
    jmp .L1917
.L1916:
.L1917:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 40
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1918
    mov rax, 0
    jmp .__ret_1892
    jmp .L1919
.L1918:
.L1919:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r12
    mov rdx, [rbp-16]
    sub rsp, 32
    call prs_mmu_push
    add rsp, 32
.L1897:
    jmp .L1895
.L1896:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    jmp .__ret_1892
.__ret_1892:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_mmu_gc:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_ASSIGN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1921
    mov rax, 0
    jmp .__ret_1920
    jmp .L1922
.L1921:
.L1922:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1923
    mov rax, 0
    jmp .__ret_1920
    jmp .L1924
.L1923:
.L1924:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-24], rax
    mov rdx, [rbp-24]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 11
    jne .L1925
    mov rax, [rel __g_parser_GC_MANUAL_ONLY]
    mov rbx, rax
    jmp .L1926
.L1925:
    mov rdx, [rbp-24]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 17
    jne .L1927
    mov rax, [rel __g_parser_GC_REF_COUNTED]
    mov rbx, rax
    jmp .L1928
.L1927:
    mov rdx, [rbp-24]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 19
    jne .L1929
    mov rax, [rel __g_parser_GC_MARK_SWEEP]
    mov rbx, rax
    jmp .L1930
.L1929:
    mov rdx, [rbp-24]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 24
    jne .L1931
    mov rax, [rel __g_parser_GC_GENERATIONAL]
    mov rbx, rax
    jmp .L1932
.L1931:
    mov rax, 0
    jmp .__ret_1920
.L1932:
.L1930:
.L1928:
.L1926:
    mov rax, [rel __g_parser_AST_MMU_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1933
    mov rax, 0
    jmp .__ret_1920
    jmp .L1934
.L1933:
.L1934:
    mov rax, [rel __g_parser_MMU_ENTRY_GC]
    mov rdx, [rbp-16]
    add rdx, 32
    mov [rdx], eax
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1935
    mov rax, 0
    jmp .__ret_1920
    jmp .L1936
.L1935:
.L1936:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r12
    mov rdx, [rbp-16]
    sub rsp, 32
    call prs_mmu_push
    add rsp, 32
    mov rax, 1
    jmp .__ret_1920
.__ret_1920:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_mmu_pgfault:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1938
    mov rax, 0
    jmp .__ret_1937
    jmp .L1939
.L1938:
.L1939:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1940
    mov rax, 0
    jmp .__ret_1937
    jmp .L1941
.L1940:
.L1941:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1942
    mov rax, 0
    jmp .__ret_1937
    jmp .L1943
.L1942:
.L1943:
    mov rax, [rel __g_parser_AST_MMU_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1944
    mov rax, 0
    jmp .__ret_1937
    jmp .L1945
.L1944:
.L1945:
    mov rax, [rel __g_parser_MMU_ENTRY_PGFAULT]
    mov rdx, [rbp-16]
    add rdx, 32
    mov [rdx], eax
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1946
    mov rax, 0
    jmp .__ret_1937
    jmp .L1947
.L1946:
.L1947:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1948
    mov rax, 0
    jmp .__ret_1937
    jmp .L1949
.L1948:
.L1949:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1950
    mov rax, 0
    jmp .__ret_1937
    jmp .L1951
.L1950:
.L1951:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    mov rcx, r12
    mov rdx, [rbp-16]
    sub rsp, 32
    call prs_mmu_push
    add rsp, 32
    mov rax, 1
    jmp .__ret_1937
.__ret_1937:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_mmu_oom:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1953
    mov rax, 0
    jmp .__ret_1952
    jmp .L1954
.L1953:
.L1954:
    mov rax, [rel __g_parser_AST_MMU_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1955
    mov rax, 0
    jmp .__ret_1952
    jmp .L1956
.L1955:
.L1956:
    mov rax, [rel __g_parser_MMU_ENTRY_OOM]
    mov rdx, [rbp-16]
    add rdx, 32
    mov [rdx], eax
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1957
    mov rax, 0
    jmp .__ret_1952
    jmp .L1958
.L1957:
.L1958:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    mov rcx, r12
    mov rdx, [rbp-16]
    sub rsp, 32
    call prs_mmu_push
    add rsp, 32
    mov rax, 1
    jmp .__ret_1952
.__ret_1952:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_mmu_pool:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov r12, rcx
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1960
    mov rax, 0
    jmp .__ret_1959
    jmp .L1961
.L1960:
.L1961:
    mov rax, [rel __g_parser_AST_MMU_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1962
    mov rax, 0
    jmp .__ret_1959
    jmp .L1963
.L1962:
.L1963:
    mov rax, [rel __g_parser_MMU_ENTRY_POOL]
    mov rdx, [rbp-16]
    add rdx, 32
    mov [rdx], eax
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1964
    mov rax, 0
    jmp .__ret_1959
    jmp .L1965
.L1964:
.L1965:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_pool_tail], rax
.L1966:
    mov rax, 1
    cmp rax, 1
    jne .L1967
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1969
    jmp .L1967
    jmp .L1970
.L1969:
.L1970:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1971
    mov rax, 0
    jmp .__ret_1959
    jmp .L1972
.L1971:
.L1972:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1973
    mov rax, 0
    jmp .__ret_1959
    jmp .L1974
.L1973:
.L1974:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-40], rax
    mov rdx, [rbp-40]
    add rdx, 16
    mov eax, dword [rdx]
    mov rbx, rax
    cmp rbx, 15
    jne .L1975
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_ASSIGN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1977
    mov rax, 0
    jmp .__ret_1959
    jmp .L1978
.L1977:
.L1978:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1979
    mov rax, 0
    jmp .__ret_1959
    jmp .L1980
.L1979:
.L1980:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-40], rax
    mov rdx, [rbp-40]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 16
    jne .L1981
    mov rax, [rel __g_parser_ALLOC_SLAB]
    mov rbx, rax
    jmp .L1982
.L1981:
    mov rdx, [rbp-40]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 17
    jne .L1983
    mov rax, [rel __g_parser_ALLOC_BUMP]
    mov rbx, rax
    jmp .L1984
.L1983:
    mov rdx, [rbp-40]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 19
    jne .L1985
    mov rax, [rel __g_parser_ALLOC_BUDDY]
    mov rbx, rax
    jmp .L1986
.L1985:
    mov rdx, [rbp-40]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 20
    jne .L1987
    mov rax, [rel __g_parser_ALLOC_FREELIST]
    mov rbx, rax
    jmp .L1988
.L1987:
    mov rdx, [rbp-40]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 28
    jne .L1989
    mov rax, [rel __g_parser_ALLOC_PREDICTIVE]
    mov rbx, rax
    jmp .L1990
.L1989:
    mov rax, 0
    jmp .__ret_1959
.L1990:
.L1988:
.L1986:
.L1984:
.L1982:
    mov rax, [rel __g_parser_AST_POOL_DIR]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L1991
    mov rax, 0
    jmp .__ret_1959
    jmp .L1992
.L1991:
.L1992:
    mov rax, [rbp-24]
    mov [rel __g_parser_par_pool_node], rax
    mov rax, [rel __g_parser_POOL_DIR_CLASS]
    mov rdx, [rbp-24]
    add rdx, 32
    mov [rdx], eax
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L1993
    mov rax, 0
    jmp .__ret_1959
    jmp .L1994
.L1993:
.L1994:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, [rbp-16]
    sub rsp, 32
    call prs_pool_push
    add rsp, 32
    jmp .L1976
.L1975:
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1997
    mov rax, rbx
    mov rcx, 36
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1997
    mov rax, 0
    jmp .L1998
.L1997:
    mov rax, 1
.L1998:
    test rax, rax
    jz .L1995
    mov rax, [rel __g_parser_POOL_DIR_COMPACT]
    mov [rel __g_parser_par_pool_kind], rax
    cmp rbx, 32
    je .L1999
    mov rax, [rel __g_parser_POOL_DIR_GRAN]
    mov [rel __g_parser_par_pool_kind], rax
    jmp .L2000
.L1999:
.L2000:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_ASSIGN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2001
    mov rax, 0
    jmp .__ret_1959
    jmp .L2002
.L2001:
.L2002:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_INTEGER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2005
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_FLOAT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2005
    mov rax, 1
    jmp .L2006
.L2005:
    mov rax, 0
.L2006:
    test rax, rax
    jz .L2003
    mov rax, [rel __g_parser_TOK_HEX]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2007
    mov rax, 0
    jmp .__ret_1959
    jmp .L2008
.L2007:
.L2008:
    jmp .L2004
.L2003:
.L2004:
    mov rax, [rel __g_parser_AST_POOL_DIR]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L2009
    mov rax, 0
    jmp .__ret_1959
    jmp .L2010
.L2009:
.L2010:
    mov rax, [rbp-24]
    mov [rel __g_parser_par_pool_node], rax
    mov rax, [rel __g_parser_par_pool_kind]
    mov rdx, [rbp-24]
    add rdx, 32
    mov [rdx], eax
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2011
    mov rax, 0
    jmp .__ret_1959
    jmp .L2012
.L2011:
.L2012:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, [rbp-16]
    sub rsp, 32
    call prs_pool_push
    add rsp, 32
    jmp .L1996
.L1995:
    mov rax, rbx
    mov rcx, 21
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2015
    mov rax, rbx
    mov rcx, 23
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2015
    mov rax, 0
    jmp .L2016
.L2015:
    mov rax, 1
.L2016:
    test rax, rax
    jz .L2013
    mov rax, [rel __g_parser_POOL_DIR_ONALLOC]
    mov [rel __g_parser_par_pool_kind], rax
    cmp rbx, 23
    jne .L2017
    mov rax, [rel __g_parser_POOL_DIR_ONFREE]
    mov [rel __g_parser_par_pool_kind], rax
    jmp .L2018
.L2017:
.L2018:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2019
    mov rax, 0
    jmp .__ret_1959
    jmp .L2020
.L2019:
.L2020:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2021
    mov rax, 0
    jmp .__ret_1959
    jmp .L2022
.L2021:
.L2022:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2023
    mov rax, 0
    jmp .__ret_1959
    jmp .L2024
.L2023:
.L2024:
    mov rax, [rel __g_parser_AST_POOL_DIR]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L2025
    mov rax, 0
    jmp .__ret_1959
    jmp .L2026
.L2025:
.L2026:
    mov rax, [rbp-24]
    mov [rel __g_parser_par_pool_node], rax
    mov rax, [rel __g_parser_par_pool_kind]
    mov rdx, [rbp-24]
    add rdx, 32
    mov [rdx], eax
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-24]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2027
    mov rax, 0
    jmp .__ret_1959
    jmp .L2028
.L2027:
.L2028:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2029
    mov rax, 0
    jmp .__ret_1959
    jmp .L2030
.L2029:
.L2030:
    sub rsp, 32
    call prs_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L2031
    mov rax, 0
    jmp .__ret_1959
    jmp .L2032
.L2031:
.L2032:
    mov rax, [rel __g_parser_par_pool_node]
    mov [rbp-24], rax
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 8
    mov [rdx], rax
    mov rcx, [rbp-16]
    sub rsp, 32
    call prs_pool_push
    add rsp, 32
    jmp .L2014
.L2013:
    mov rax, 0
    jmp .__ret_1959
.L2014:
.L1996:
.L1976:
.L1968:
    jmp .L1966
.L1967:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rcx, r12
    mov rdx, [rbp-16]
    sub rsp, 32
    call prs_mmu_push
    add rsp, 32
    mov rax, 1
    jmp .__ret_1959
.__ret_1959:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
prs_boot:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov rax, 0
    mov rbx, rax
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
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2034
    mov rax, 0
    jmp .__ret_2033
    jmp .L2035
.L2034:
.L2035:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2036
    mov rax, 0
    jmp .__ret_2033
    jmp .L2037
.L2036:
.L2037:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_BOOT_DEF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L2038
    mov rax, 0
    jmp .__ret_2033
    jmp .L2039
.L2038:
.L2039:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
.L2040:
    mov rax, 1
    cmp rax, 1
    jne .L2041
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2043
    jmp .L2041
    jmp .L2044
.L2043:
.L2044:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2045
    mov rax, 0
    jmp .__ret_2033
    jmp .L2046
.L2045:
.L2046:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2049
section .data
.str2051: db 99,112,117,95,115,116,97,116,101,95,105,110,105,116,0
section .text
    lea rax, [rel .str2051]
    push rax
    pop rcx
    mov rdx, 14
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2049
    mov rax, 1
    jmp .L2050
.L2049:
    mov rax, 0
.L2050:
    test rax, rax
    jz .L2047
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2052
    mov rax, 0
    jmp .__ret_2033
    jmp .L2053
.L2052:
.L2053:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L2054:
    mov rax, 1
    cmp rax, 1
    jne .L2055
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2057
    jmp .L2055
    jmp .L2058
.L2057:
.L2058:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2059
    mov rax, 0
    jmp .__ret_2033
    jmp .L2060
.L2059:
.L2060:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2061
    mov rax, 0
    jmp .__ret_2033
    jmp .L2062
.L2061:
.L2062:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2063
    mov rax, 0
    jmp .__ret_2033
    jmp .L2064
.L2063:
.L2064:
    mov rax, [rel __g_parser_AST_BOOT_REG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L2065
    mov rax, 0
    jmp .__ret_2033
    jmp .L2066
.L2065:
.L2066:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2067
    mov rax, 0
    jmp .__ret_2033
    jmp .L2068
.L2067:
.L2068:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_is_num
    add rsp, 32
    cmp rax, 0
    jne .L2069
    mov rax, 0
    jmp .__ret_2033
    jmp .L2070
.L2069:
.L2070:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2071
    mov rax, 0
    jmp .__ret_2033
    jmp .L2072
.L2071:
.L2072:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L2073
    mov rax, [rbp-32]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    jmp .L2074
.L2073:
    mov rax, [rbp-32]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L2074:
    mov rax, [rbp-32]
    mov [rbp-24], rax
.L2056:
    jmp .L2054
.L2055:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L2048
.L2047:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2077
section .data
.str2079: db 109,109,117,95,116,97,98,108,101,95,105,110,105,116,0
section .text
    lea rax, [rel .str2079]
    push rax
    pop rcx
    mov rdx, 14
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2077
    mov rax, 1
    jmp .L2078
.L2077:
    mov rax, 0
.L2078:
    test rax, rax
    jz .L2075
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2080
    mov rax, 0
    jmp .__ret_2033
    jmp .L2081
.L2080:
.L2081:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_boot_tail], rax
.L2082:
    mov rax, 1
    cmp rax, 1
    jne .L2083
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2085
    jmp .L2083
    jmp .L2086
.L2085:
.L2086:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2087
    mov rax, 0
    jmp .__ret_2033
    jmp .L2088
.L2087:
.L2088:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2089
    mov rax, 0
    jmp .__ret_2033
    jmp .L2090
.L2089:
.L2090:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_HEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2091
    mov rax, [rel __g_parser_TOK_INTEGER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2093
    mov rax, 0
    jmp .__ret_2033
    jmp .L2094
.L2093:
.L2094:
    jmp .L2092
.L2091:
.L2092:
    mov rax, [rel __g_parser_AST_BOOT_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L2095
    mov rax, 0
    jmp .__ret_2033
    jmp .L2096
.L2095:
.L2096:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2097
    mov rax, 0
    jmp .__ret_2033
    jmp .L2098
.L2097:
.L2098:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2099
    mov rax, 0
    jmp .__ret_2033
    jmp .L2100
.L2099:
.L2100:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-48], rax
    mov rdx, [rbp-48]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 12
    jne .L2101
    mov rax, [rel __g_parser_PGFLAG_CACHE_BYPASS]
    mov rbx, rax
    jmp .L2102
.L2101:
    mov rdx, [rbp-48]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 14
    jne .L2103
    mov rax, [rel __g_parser_PGFLAG_RO_USER]
    mov rbx, rax
    jmp .L2104
.L2103:
    mov rdx, [rbp-48]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 15
    jne .L2105
    mov rax, [rel __g_parser_PGFLAG_EXEC_DIS]
    mov rbx, rax
    jmp .L2106
.L2105:
    mov rdx, [rbp-48]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 17
    jne .L2107
    mov rax, [rel __g_parser_PGFLAG_RW_KERNEL]
    mov rbx, rax
    jmp .L2108
.L2107:
    mov rax, 0
    jmp .__ret_2033
.L2108:
.L2106:
.L2104:
.L2102:
    mov rax, rbx
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2109
    mov rax, 0
    jmp .__ret_2033
    jmp .L2110
.L2109:
.L2110:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_par_boot_tail]
    cmp rax, 0
    jne .L2111
    mov rax, [rbp-32]
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    jmp .L2112
.L2111:
    mov rax, [rel __g_parser_par_boot_tail]
    mov [rbp-40], rax
    mov rax, [rbp-32]
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
.L2112:
    mov rax, [rbp-32]
    mov [rel __g_parser_par_boot_tail], rax
.L2084:
    jmp .L2082
.L2083:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L2076
.L2075:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2115
section .data
.str2117: db 108,111,97,100,95,107,101,114,110,101,108,95,101,108,102,0
section .text
    lea rax, [rel .str2117]
    push rax
    pop rcx
    mov rdx, 15
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2115
    mov rax, 1
    jmp .L2116
.L2115:
    mov rax, 0
.L2116:
    test rax, rax
    jz .L2113
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2118
    mov rax, 0
    jmp .__ret_2033
    jmp .L2119
.L2118:
.L2119:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_STRING]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2120
    mov rax, 0
    jmp .__ret_2033
    jmp .L2121
.L2120:
.L2121:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-16]
    add rdx, 40
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_RPAREN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2122
    mov rax, 0
    jmp .__ret_2033
    jmp .L2123
.L2122:
.L2123:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2124
    mov rax, 0
    jmp .__ret_2033
    jmp .L2125
.L2124:
.L2125:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L2114
.L2113:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2126
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    cmp rax, 0
    jne .L2128
    mov rax, 0
    jmp .__ret_2033
    jmp .L2129
.L2128:
.L2129:
    jmp .L2127
.L2126:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2130
    sub rsp, 32
    call prs_balanced_parens
    add rsp, 32
    cmp rax, 0
    jne .L2132
    mov rax, 0
    jmp .__ret_2033
    jmp .L2133
.L2132:
.L2133:
    jmp .L2131
.L2130:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L2131:
.L2127:
.L2114:
.L2076:
.L2048:
.L2042:
    jmp .L2040
.L2041:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-16]
    jmp .__ret_2033
.__ret_2033:
    mov rbx, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
prs_isa:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2135
    mov rax, 0
    jmp .__ret_2134
    jmp .L2136
.L2135:
.L2136:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2137
    mov rax, 0
    jmp .__ret_2134
    jmp .L2138
.L2137:
.L2138:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_AST_ISA_DEF]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L2139
    mov rax, 0
    jmp .__ret_2134
    jmp .L2140
.L2139:
.L2140:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
.L2141:
    mov rax, 1
    cmp rax, 1
    jne .L2142
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2144
    jmp .L2142
    jmp .L2145
.L2144:
.L2145:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2146
    mov rax, 0
    jmp .__ret_2134
    jmp .L2147
.L2146:
.L2147:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2150
section .data
.str2152: db 111,112,99,111,100,101,95,115,101,116,0
section .text
    lea rax, [rel .str2152]
    push rax
    pop rcx
    mov rdx, 10
    sub rsp, 32
    call prs_cur_is
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2150
    mov rax, 1
    jmp .L2151
.L2150:
    mov rax, 0
.L2151:
    test rax, rax
    jz .L2148
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_LBRACE]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2153
    mov rax, 0
    jmp .__ret_2134
    jmp .L2154
.L2153:
.L2154:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L2155:
    mov rax, 1
    cmp rax, 1
    jne .L2156
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2158
    jmp .L2156
    jmp .L2159
.L2158:
.L2159:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2160
    mov rax, 0
    jmp .__ret_2134
    jmp .L2161
.L2160:
.L2161:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2162
    mov rax, 0
    jmp .__ret_2134
    jmp .L2163
.L2162:
.L2163:
    mov rax, [rel __g_parser_AST_ISA_ENTRY]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L2164
    mov rax, 0
    jmp .__ret_2134
    jmp .L2165
.L2164:
.L2165:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_ASSIGN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2166
    mov rax, 0
    jmp .__ret_2134
    jmp .L2167
.L2166:
.L2167:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_is_num
    add rsp, 32
    cmp rax, 0
    jne .L2168
    mov rax, 0
    jmp .__ret_2134
    jmp .L2169
.L2168:
.L2169:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2170
    mov rax, 0
    jmp .__ret_2134
    jmp .L2171
.L2170:
.L2171:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L2172
    mov rax, [rbp-32]
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    jmp .L2173
.L2172:
    mov rax, [rbp-32]
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], rax
.L2173:
    mov rax, [rbp-32]
    mov [rbp-24], rax
.L2157:
    jmp .L2155
.L2156:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L2149
.L2148:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2174
    sub rsp, 32
    call prs_generic_block
    add rsp, 32
    cmp rax, 0
    jne .L2176
    mov rax, 0
    jmp .__ret_2134
    jmp .L2177
.L2176:
.L2177:
    jmp .L2175
.L2174:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L2175:
.L2149:
.L2143:
    jmp .L2141
.L2142:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rbp-16]
    jmp .__ret_2134
.__ret_2134:
    mov rbx, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ng_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    jmp .__ret_2178
.__ret_2178:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ng_copy_tok:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    push rax
    mov rax, 0
    push rax
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, 1
    push rax
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, 2
    push rax
    mov rcx, rbx
    mov rdx, 2
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, 0
    jmp .__ret_2179
.__ret_2179:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ng_err:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_parser_ng_err_msg]
    cmp rax, 0
    jne .L2181
    mov rax, r12
    mov [rel __g_parser_ng_err_tok], rax
    mov rax, rbx
    mov [rel __g_parser_ng_err_msg], rax
    jmp .L2182
.L2181:
.L2182:
    mov rax, 0
    jmp .__ret_2180
.__ret_2180:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ng_basename:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov rax, rbx
    mov r14, rax
    mov rax, rbx
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call bget
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L2184:
    cmp r12, 0
    je .L2185
    add r13, 1
    mov rax, r12
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2189
    mov rax, r12
    mov rcx, 92
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2189
    mov rax, 0
    jmp .L2190
.L2189:
    mov rax, 1
.L2190:
    test rax, rax
    jz .L2187
    mov rax, r13
    mov r14, rax
    jmp .L2188
.L2187:
.L2188:
    mov rcx, r13
    sub rsp, 32
    call bget
    add rsp, 32
    mov r12, rax
.L2186:
    jmp .L2184
.L2185:
    mov rax, r13
    mov rbx, rax
.L2191:
    cmp rbx, r14
    jle .L2192
    sub rbx, 1
    mov rcx, rbx
    sub rsp, 32
    call bget
    add rsp, 32
    cmp rax, 46
    jne .L2194
    mov rax, rbx
    mov r13, rax
    jmp .L2192
    jmp .L2195
.L2194:
.L2195:
.L2193:
    jmp .L2191
.L2192:
    mov rax, r13
    sub rax, r14
    mov [rel __g_parser_ng_bn_len], rax
    mov rax, r14
    jmp .__ret_2183
.__ret_2183:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
ng_mod_of:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call ng_basename
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_parser_ng_bn_len]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L2197:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_nmod]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2198
    lea rax, [rel __g_parser_ng_mod_len]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    cmp rax, r12
    jne .L2200
    lea rax, [rel __g_parser_ng_mod_name]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call prs_memeq
    add rsp, 32
    cmp rax, 1
    jne .L2202
    mov rax, rbx
    jmp .__ret_2196
    jmp .L2203
.L2202:
.L2203:
    jmp .L2201
.L2200:
.L2201:
    add rbx, 1
.L2199:
    jmp .L2197
.L2198:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_NG_MAXMOD]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2204
    mov rax, 0
    jmp .__ret_2196
    jmp .L2205
.L2204:
.L2205:
    lea rax, [rel __g_parser_ng_mod_name]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r13
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_mod_len]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_mod_alias]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, [rel __g_parser_ng_nmod]
    add rax, 1
    mov [rel __g_parser_ng_nmod], rax
    mov rax, rbx
    jmp .__ret_2196
.__ret_2196:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ng_is_name_char:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 95
    jne .L2207
    mov rax, 1
    jmp .__ret_2206
    jmp .L2208
.L2207:
.L2208:
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2211
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2211
    mov rax, 1
    jmp .L2212
.L2211:
    mov rax, 0
.L2212:
    test rax, rax
    jz .L2209
    mov rax, 1
    jmp .__ret_2206
    jmp .L2210
.L2209:
.L2210:
    mov rax, rbx
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2215
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2215
    mov rax, 1
    jmp .L2216
.L2215:
    mov rax, 0
.L2216:
    test rax, rax
    jz .L2213
    mov rax, 1
    jmp .__ret_2206
    jmp .L2214
.L2213:
.L2214:
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2219
    mov rax, rbx
    mov rcx, 122
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2219
    mov rax, 1
    jmp .L2220
.L2219:
    mov rax, 0
.L2220:
    test rax, rax
    jz .L2217
    mov rax, 1
    jmp .__ret_2206
    jmp .L2218
.L2217:
.L2218:
    mov rax, 0
    jmp .__ret_2206
.__ret_2206:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ng_is_blank:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2224
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2224
    mov rax, 0
    jmp .L2225
.L2224:
    mov rax, 1
.L2225:
    test rax, rax
    jz .L2222
    mov rax, 1
    jmp .__ret_2221
    jmp .L2223
.L2222:
.L2223:
    mov rax, 0
    jmp .__ret_2221
.__ret_2221:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ng_modules:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov [rel __g_parser_ng_nmod], rax
    mov rax, [rel __g_parser_prs_arg_input]
    push rax
    pop rcx
    sub rsp, 32
    call ng_mod_of
    add rsp, 32
    mov rax, [rel __g_parser_prs_lmap_count]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call tget
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    je .L2227
    mov rax, [rel __g_parser_prs_lmap_file]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ng_mod_of
    add rsp, 32
    mov r12, rax
    jmp .L2228
.L2227:
.L2228:
.L2229:
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_ng_cnt]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2232
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_NG_MAXTOK]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2232
    mov rax, 1
    jmp .L2233
.L2232:
    mov rax, 0
.L2233:
    test rax, rax
    jz .L2230
    cmp r15, 0
    je .L2234
    mov rax, [rel __g_parser_ng_tok]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ng_at
    add rsp, 32
    mov [rbp-56], rax
    mov rdx, [rbp-56]
    add rdx, 20
    movzx eax, word [rdx]
    mov [rbp-40], rax
.L2236:
    mov rax, 1
    cmp rax, 1
    jne .L2237
    mov rax, r13
    add rax, 1
    mov rbx, rax
    cmp rbx, r15
    jl .L2239
    jmp .L2237
    jmp .L2240
.L2239:
.L2240:
    mov rax, [rel __g_parser_prs_lmap_out]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, [rbp-40]
    cmp rax, rcx
    jle .L2241
    jmp .L2237
    jmp .L2242
.L2241:
.L2242:
    mov rax, rbx
    mov r13, rax
    mov rax, [rel __g_parser_prs_lmap_file]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ng_mod_of
    add rsp, 32
    mov r12, rax
.L2238:
    jmp .L2236
.L2237:
    jmp .L2235
.L2234:
.L2235:
    lea rax, [rel __g_parser_ng_tokmod]
    add rax, r14
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call bset
    add rsp, 32
    lea rax, [rel __g_parser_ng_tokflag]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, 0
    sub rsp, 32
    call tset
    add rsp, 32
    add r14, 1
.L2231:
    jmp .L2229
.L2230:
    sub rsp, 32
    call ng_aliases
    add rsp, 32
    mov rax, 0
    jmp .__ret_2226
.__ret_2226:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
ng_aliases:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rax, [rel __g_parser_prs_src_buffer]
    mov r15, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L2244:
    mov rax, 1
    cmp rax, 1
    jne .L2245
    mov rcx, r15
    sub rsp, 32
    call bget
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L2247
    mov rax, 0
    jmp .__ret_2243
    jmp .L2248
.L2247:
.L2248:
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L2251
    mov rax, r15
    push rax
section .data
.str2253: db 97,99,113,117,105,114,101,95,100,111,109,97,105,110,0
section .text
    lea rax, [rel .str2253]
    push rax
    pop rdx
    pop rcx
    mov r8, 14
    sub rsp, 32
    call prs_memeq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2251
    mov rax, 0
    jmp .L2252
.L2251:
    mov rax, 1
.L2252:
    test rax, rax
    jz .L2249
    add r15, 1
    jmp .L2250
.L2249:
    add r15, 14
.L2254:
    mov rcx, r15
    sub rsp, 32
    call bget
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ng_is_blank
    add rsp, 32
    cmp rax, 1
    jne .L2255
    add r15, 1
.L2256:
    jmp .L2254
.L2255:
    mov rcx, r15
    sub rsp, 32
    call bget
    add rsp, 32
    cmp rax, 34
    jne .L2257
    add r15, 1
    mov rax, r15
    mov r12, rax
    mov rcx, r15
    sub rsp, 32
    call bget
    add rsp, 32
    mov rbx, rax
.L2259:
    mov rax, rbx
    mov rcx, 34
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2264
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2264
    mov rax, 1
    jmp .L2265
.L2264:
    mov rax, 0
.L2265:
    test rax, rax
    jz .L2262
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2262
    mov rax, 1
    jmp .L2263
.L2262:
    mov rax, 0
.L2263:
    test rax, rax
    jz .L2260
    add r15, 1
    mov rcx, r15
    sub rsp, 32
    call bget
    add rsp, 32
    mov rbx, rax
.L2261:
    jmp .L2259
.L2260:
    cmp rbx, 0
    jne .L2266
    mov rax, 0
    jmp .__ret_2243
    jmp .L2267
.L2266:
.L2267:
    cmp rbx, 34
    jne .L2268
    mov rax, r15
    mov rbx, rax
    add r15, 1
.L2270:
    mov rcx, r15
    sub rsp, 32
    call bget
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ng_is_blank
    add rsp, 32
    cmp rax, 1
    jne .L2271
    add r15, 1
.L2272:
    jmp .L2270
.L2271:
    mov rcx, r15
    sub rsp, 32
    call bget
    add rsp, 32
    mov rcx, 97
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2277
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    mov rcx, 115
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2277
    mov rax, 1
    jmp .L2278
.L2277:
    mov rax, 0
.L2278:
    test rax, rax
    jz .L2275
    mov rax, r15
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ng_is_blank
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2275
    mov rax, 1
    jmp .L2276
.L2275:
    mov rax, 0
.L2276:
    test rax, rax
    jz .L2273
    add r15, 3
.L2279:
    mov rcx, r15
    sub rsp, 32
    call bget
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ng_is_blank
    add rsp, 32
    cmp rax, 1
    jne .L2280
    add r15, 1
.L2281:
    jmp .L2279
.L2280:
    mov rax, r15
    mov r14, rax
.L2282:
    mov rcx, r15
    sub rsp, 32
    call bget
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ng_is_name_char
    add rsp, 32
    cmp rax, 1
    jne .L2283
    add r15, 1
.L2284:
    jmp .L2282
.L2283:
    cmp r15, r14
    je .L2285
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call bset
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ng_basename
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_parser_ng_bn_len]
    mov r12, rax
    mov rcx, rbx
    mov rdx, 34
    sub rsp, 32
    call bset
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L2287:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_nmod]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2288
    lea rax, [rel __g_parser_ng_mod_len]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, r12
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2292
    lea rax, [rel __g_parser_ng_mod_name]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call prs_memeq
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2292
    mov rax, 1
    jmp .L2293
.L2292:
    mov rax, 0
.L2293:
    test rax, rax
    jz .L2290
    lea rax, [rel __g_parser_ng_mod_alias]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r14
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_mod_alen]
    push rax
    mov rax, rbx
    push rax
    mov rax, r15
    sub rax, r14
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    jmp .L2288
    jmp .L2291
.L2290:
.L2291:
    add rbx, 1
.L2289:
    jmp .L2287
.L2288:
    jmp .L2286
.L2285:
.L2286:
    jmp .L2274
.L2273:
.L2274:
    jmp .L2269
.L2268:
.L2269:
    jmp .L2258
.L2257:
.L2258:
.L2250:
.L2246:
    jmp .L2244
.L2245:
    mov rax, 0
    jmp .__ret_2243
.__ret_2243:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
ng_close:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L2295:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_ng_cnt]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2296
    mov rcx, r13
    sub rsp, 32
    call ng_ttype
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2298
    add r12, 1
    jmp .L2299
.L2298:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2300
    sub r12, 1
    cmp r12, 0
    jne .L2302
    mov rax, r13
    add rax, 1
    jmp .__ret_2294
    jmp .L2303
.L2302:
.L2303:
    jmp .L2301
.L2300:
.L2301:
.L2299:
    add r13, 1
.L2297:
    jmp .L2295
.L2296:
    mov rax, [rel __g_parser_ng_cnt]
    jmp .__ret_2294
.__ret_2294:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ng_ttype:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, 0
    mov [rbp-16], rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_cnt]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2305
    mov rax, 0
    jmp .__ret_2304
    jmp .L2306
.L2305:
.L2306:
    mov rax, [rel __g_parser_ng_tok]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ng_at
    add rsp, 32
    mov [rbp-16], rax
    mov rdx, [rbp-16]
    mov rax, [rdx]
    jmp .__ret_2304
.__ret_2304:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ng_add_decl:
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
    mov rax, [rel __g_parser_ng_nd]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_NG_MAXDECL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2308
    mov rax, 0
    jmp .__ret_2307
    jmp .L2309
.L2308:
.L2309:
    lea rax, [rel __g_parser_ng_d_tok]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r14
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_d_mod]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r13
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_d_kind]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_d_dup]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, rbx
    add rax, 1
    mov [rel __g_parser_ng_nd], rax
    mov rax, 0
    jmp .__ret_2307
.__ret_2307:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ng_decls:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_ng_nd], rax
    mov rax, 0
    mov [rel __g_parser_ng_nt], rax
    mov rax, 0
    mov [rel __g_parser_ng_anydup], rax
.L2311:
    mov rax, r15
    push rax
    mov rax, [rel __g_parser_ng_cnt]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2312
    mov rcx, r15
    sub rsp, 32
    call ng_ttype
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov r14, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2314
    mov rax, [rbp-24]
    add rax, 1
    mov [rbp-24], rax
    jmp .L2315
.L2314:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_TOK_RBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2316
    mov rax, [rbp-24]
    sub rax, 1
    mov [rbp-24], rax
    jmp .L2317
.L2316:
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L2318
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_FN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2320
    mov rax, 1
    mov r14, rax
    jmp .L2321
.L2320:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_STRUCT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2322
    mov rax, 2
    mov r14, rax
    jmp .L2323
.L2322:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_ENUM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2328
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_VAR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2328
    mov rax, 0
    jmp .L2329
.L2328:
    mov rax, 1
.L2329:
    test rax, rax
    jnz .L2326
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_KW_CONST]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2326
    mov rax, 0
    jmp .L2327
.L2326:
    mov rax, 1
.L2327:
    test rax, rax
    jz .L2324
    mov rax, 4
    mov r14, rax
    jmp .L2325
.L2324:
.L2325:
.L2323:
.L2321:
    jmp .L2319
.L2318:
.L2319:
.L2317:
.L2315:
    lea rax, [rel __g_parser_ng_tokmod]
    add rax, r15
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    mov rbx, rax
    cmp r14, 4
    jne .L2330
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ng_ttype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2332
    mov rax, [rel __g_parser_ng_tok]
    push rax
    mov rax, r15
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_at
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 2
    sub rsp, 32
    call ng_add_decl
    add rsp, 32
    jmp .L2333
.L2332:
.L2333:
    jmp .L2331
.L2330:
    cmp r14, 0
    je .L2334
    mov rax, r15
    add rax, 1
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call ng_ttype
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2336
    cmp r12, 100
    jge .L2338
    mov rax, 1
    neg rax
    mov r13, rax
    jmp .L2339
.L2338:
    add r13, 1
    mov rcx, r13
    sub rsp, 32
    call ng_ttype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2340
    mov rax, 1
    neg rax
    mov r13, rax
    jmp .L2341
.L2340:
.L2341:
.L2339:
    jmp .L2337
.L2336:
.L2337:
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2342
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ng_ttype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2344
    mov rax, [rel __g_parser_ng_tok]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ng_at
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r14
    sub rsp, 32
    call ng_add_decl
    add rsp, 32
    jmp .L2345
.L2344:
    mov rax, [rel __g_parser_ng_nt]
    push rax
    mov rax, [rel __g_parser_NG_MAXT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2346
    mov rax, [rel __g_parser_ng_nt]
    mov r12, rax
    lea rax, [rel __g_parser_ng_t_start]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r15
    sub rsp, 32
    call tset
    add rsp, 32
    cmp r14, 1
    jne .L2348
    lea rax, [rel __g_parser_ng_t_isfn]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, 1
    sub rsp, 32
    call tset
    add rsp, 32
    jmp .L2349
.L2348:
    lea rax, [rel __g_parser_ng_t_isfn]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call tset
    add rsp, 32
.L2349:
    lea rax, [rel __g_parser_ng_t_name]
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_ng_tok]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ng_at
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_t_mod]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, [rel __g_parser_ng_tok]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ng_at
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 3
    sub rsp, 32
    call ng_add_decl
    add rsp, 32
    lea rax, [rel __g_parser_ng_t_lt]
    push rax
    mov rax, r12
    push rax
    mov rax, r13
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    add r13, 2
.L2350:
    mov rcx, r13
    sub rsp, 32
    call ng_ttype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2353
    mov rax, rbx
    mov rcx, 8
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2353
    mov rax, 1
    jmp .L2354
.L2353:
    mov rax, 0
.L2354:
    test rax, rax
    jz .L2351
    lea rax, [rel __g_parser_ng_t_par]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    add rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_tok]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ng_at
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    add rbx, 1
    add r13, 1
    mov rcx, r13
    sub rsp, 32
    call ng_ttype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2355
    jmp .L2351
    jmp .L2356
.L2355:
.L2356:
    add r13, 1
.L2352:
    jmp .L2350
.L2351:
    mov rcx, r13
    sub rsp, 32
    call ng_ttype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_GT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2357
    add r13, 1
    lea rax, [rel __g_parser_ng_t_np]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_t_body]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r13
    sub rsp, 32
    call tset
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ng_close
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_parser_ng_t_end]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_tokflag]
    push rax
    mov rax, r15
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, [rel __g_parser_ng_nt]
    add rax, 1
    mov [rel __g_parser_ng_nt], rax
    mov rax, rbx
    sub rax, 1
    mov r15, rax
    jmp .L2358
.L2357:
.L2358:
    jmp .L2347
.L2346:
.L2347:
.L2345:
    jmp .L2343
.L2342:
.L2343:
    jmp .L2335
.L2334:
.L2335:
.L2331:
    add r15, 1
.L2313:
    jmp .L2311
.L2312:
    mov rax, 0
    mov r15, rax
.L2359:
    mov rax, r15
    push rax
    mov rax, [rel __g_parser_ng_nd]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2360
    lea rax, [rel __g_parser_ng_d_kind]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call tget
    add rsp, 32
    cmp rax, 1
    jne .L2362
    mov rax, r15
    add rax, 1
    mov rbx, rax
.L2364:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_nd]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2365
    lea rax, [rel __g_parser_ng_d_kind]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2369
    lea rax, [rel __g_parser_ng_d_mod]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    lea rax, [rel __g_parser_ng_d_mod]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2369
    mov rax, 1
    jmp .L2370
.L2369:
    mov rax, 0
.L2370:
    test rax, rax
    jz .L2367
    lea rax, [rel __g_parser_ng_d_tok]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    lea rax, [rel __g_parser_ng_d_tok]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_tok_same
    add rsp, 32
    cmp rax, 1
    jne .L2371
    lea rax, [rel __g_parser_ng_d_dup]
    push rax
    pop rcx
    mov rdx, r15
    mov r8, 1
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_d_dup]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 1
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, 1
    mov [rel __g_parser_ng_anydup], rax
    jmp .L2372
.L2371:
.L2372:
    jmp .L2368
.L2367:
.L2368:
    add rbx, 1
.L2366:
    jmp .L2364
.L2365:
    jmp .L2363
.L2362:
.L2363:
    add r15, 1
.L2361:
    jmp .L2359
.L2360:
    mov rax, 0
    jmp .__ret_2310
.__ret_2310:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
ng_put:
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
.L2374:
    cmp rbx, r12
    jge .L2375
    mov rax, r14
    push rax
    lea rax, [rel __g_parser_ng_mbuf]
    add rax, 500
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2377
    mov rax, r14
    jmp .__ret_2373
    jmp .L2378
.L2377:
.L2378:
    mov rax, r14
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call bset
    add rsp, 32
    add r14, 1
    add rbx, 1
.L2376:
    jmp .L2374
.L2375:
    mov rax, r14
    jmp .__ret_2373
.__ret_2373:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ng_keep:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rax, rbx
    push rax
    lea rax, [rel __g_parser_ng_mbuf]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov r13, rax
    lea rax, [rel __g_parser_ng_text]
    push rax
    mov rax, [rel __g_parser_ng_ntext]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_parser_ng_ntext]
    add rax, r13
    push rax
    mov rax, [rel __g_parser_NG_TEXT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2380
    mov rax, 0
    mov [rel __g_parser_ng_keep_len], rax
    mov rax, 0
    jmp .__ret_2379
    jmp .L2381
.L2380:
.L2381:
    mov rax, [rel __g_parser_ng_ntext]
    add rax, r13
    mov [rel __g_parser_ng_ntext], rax
.L2382:
    cmp rbx, r13
    jge .L2383
    mov rax, r12
    add rax, rbx
    push rax
    lea rax, [rel __g_parser_ng_mbuf]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call bset
    add rsp, 32
    add rbx, 1
.L2384:
    jmp .L2382
.L2383:
    mov rax, r13
    mov [rel __g_parser_ng_keep_len], rax
    mov rax, r12
    jmp .__ret_2379
.__ret_2379:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ng_emit:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_parser_ng_dstn]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call tget
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_NG_MAXTOK]
    sub rax, 2
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2386
    mov rax, r12
    push rax
section .data
.str2388: db 116,111,111,32,109,97,110,121,32,103,101,110,101,114,105,99,32,99,111,112,105,101,115,32,111,114,32,116,111,107,101,110,115,32,40,109,111,114,101,32,116,104,97,110,32,116,104,101,32,99,111,109,112,105,108,101,114,39,115,32,116,97,98,108
    db 101,115,32,104,111,108,100,41,0
section .text
    lea rax, [rel .str2388]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_err
    add rsp, 32
    mov rax, 0
    jmp .__ret_2385
    jmp .L2387
.L2386:
.L2387:
    mov rax, [rel __g_parser_ng_dstn]
    push rax
    mov rax, 0
    push rax
    mov rax, rbx
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_parser_ng_dst]
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call ng_copy_tok
    add rsp, 32
    mov rax, 0
    jmp .__ret_2385
.__ret_2385:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ng_emit_named:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-40], rax
    mov rcx, r14
    sub rsp, 32
    call ng_emit
    add rsp, 32
    mov rax, [rel __g_parser_ng_dstn]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call tget
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L2390
    mov rax, 0
    jmp .__ret_2389
    jmp .L2391
.L2390:
.L2391:
    mov rax, rbx
    sub rax, 1
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_parser_ng_dst]
    add rax, rcx
    mov [rbp-40], rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rdx, [rbp-40]
    mov [rdx], rax
    mov rax, r13
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], eax
    mov rax, 0
    jmp .__ret_2389
.__ret_2389:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
ng_emit_gt:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    mov rcx, r12
    sub rsp, 32
    call ng_emit
    add rsp, 32
    mov rax, [rel __g_parser_ng_dstn]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call tget
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    sub rax, 1
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_parser_ng_dst]
    add rax, rcx
    mov [rbp-24], rax
    mov rax, [rel __g_parser_TOK_GT]
    mov rdx, [rbp-24]
    mov [rdx], rax
section .data
.str2393: db 62,0
section .text
    lea rax, [rel .str2393]
    mov rdx, [rbp-24]
    add rdx, 8
    mov [rdx], rax
    mov rax, 1
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], eax
    mov rax, 0
    jmp .__ret_2392
.__ret_2392:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ng_srct:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L2397
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_srcn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L2397
    mov rax, 0
    jmp .L2398
.L2397:
    mov rax, 1
.L2398:
    test rax, rax
    jz .L2395
    mov rax, 0
    jmp .__ret_2394
    jmp .L2396
.L2395:
.L2396:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_parser_ng_src]
    add rax, rcx
    jmp .__ret_2394
.__ret_2394:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ng_stype:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call ng_srct
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L2400
    mov rax, 0
    jmp .__ret_2399
    jmp .L2401
.L2400:
.L2401:
    mov rdx, [rbp-16]
    mov rax, [rdx]
    jmp .__ret_2399
.__ret_2399:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ng_find_mod:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L2403:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_ng_nmod]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2404
    mov rax, r13
    push rax
    lea rax, [rel __g_parser_ng_mod_name]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    lea rax, [rel __g_parser_ng_mod_len]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_tok_is
    add rsp, 32
    cmp rax, 1
    jne .L2406
    mov rax, r12
    jmp .__ret_2402
    jmp .L2407
.L2406:
.L2407:
    lea rax, [rel __g_parser_ng_mod_alias]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L2408
    mov rax, r13
    push rax
    mov rax, rbx
    push rax
    lea rax, [rel __g_parser_ng_mod_alen]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_tok_is
    add rsp, 32
    cmp rax, 1
    jne .L2410
    mov rax, r12
    jmp .__ret_2402
    jmp .L2411
.L2410:
.L2411:
    jmp .L2409
.L2408:
.L2409:
    add r12, 1
.L2405:
    jmp .L2403
.L2404:
    mov rax, 1
    neg rax
    jmp .__ret_2402
.__ret_2402:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ng_find_decl:
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
.L2413:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_nd]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2414
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2418
    lea rax, [rel __g_parser_ng_d_mod]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, r13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2418
    mov rax, 0
    jmp .L2419
.L2418:
    mov rax, 1
.L2419:
    test rax, rax
    jz .L2416
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2422
    lea rax, [rel __g_parser_ng_d_kind]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2422
    mov rax, 0
    jmp .L2423
.L2422:
    mov rax, 1
.L2423:
    test rax, rax
    jz .L2420
    mov rax, r14
    push rax
    lea rax, [rel __g_parser_ng_d_tok]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_tok_same
    add rsp, 32
    cmp rax, 1
    jne .L2424
    mov rax, rbx
    jmp .__ret_2412
    jmp .L2425
.L2424:
.L2425:
    jmp .L2421
.L2420:
.L2421:
    jmp .L2417
.L2416:
.L2417:
    add rbx, 1
.L2415:
    jmp .L2413
.L2414:
    mov rax, 1
    neg rax
    jmp .__ret_2412
.__ret_2412:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ng_find_t:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
.L2427:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_nt]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2428
    mov rax, r12
    push rax
    lea rax, [rel __g_parser_ng_t_name]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_tok_same
    add rsp, 32
    cmp rax, 1
    jne .L2430
    mov rax, rbx
    jmp .__ret_2426
    jmp .L2431
.L2430:
.L2431:
    add rbx, 1
.L2429:
    jmp .L2427
.L2428:
    mov rax, 1
    neg rax
    jmp .__ret_2426
.__ret_2426:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ng_dupname:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov [rbp-16], rdx
    lea rax, [rel __g_parser_ng_mbuf]
    push rax
    lea rax, [rel __g_parser_ng_mod_name]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    lea rax, [rel __g_parser_ng_mod_len]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_put
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r12
    mov rdx, 95
    sub rsp, 32
    call bset
    add rsp, 32
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call bset
    add rsp, 32
    mov rax, r12
    add rax, 2
    push rax
    mov rdx, [rbp-16]
    add rdx, 8
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-16]
    add rdx, 16
    mov eax, dword [rdx]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_put
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call ng_keep
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_parser_ng_keep_len]
    mov [rel __g_parser_ng_dn_len], rax
    mov rax, rbx
    jmp .__ret_2432
.__ret_2432:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ng_arg_push:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_parser_ng_nargs]
    push rax
    mov rax, [rel __g_parser_NG_ARGTOK]
    sub rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2434
    mov rax, 0
    jmp .__ret_2433
    jmp .L2435
.L2434:
.L2435:
    lea rax, [rel __g_parser_ng_args]
    push rax
    mov rax, [rel __g_parser_ng_nargs]
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ng_copy_tok
    add rsp, 32
    mov rax, [rel __g_parser_ng_nargs]
    add rax, 1
    mov [rel __g_parser_ng_nargs], rax
    mov rax, 1
    jmp .__ret_2433
.__ret_2433:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ng_use:
    push rbp
    mov rbp, rsp
    sub rsp, 240
    mov [rbp-208], rbx
    mov [rbp-200], r12
    mov [rbp-192], r13
    mov [rbp-184], r14
    mov [rbp-176], r15
    mov rbx, rcx
    mov [rbp-16], rdx
    mov rax, [rel __g_parser_ng_nargs]
    mov [rbp-24], rax
    mov rax, 0
    mov r15, rax
    mov rax, rbx
    add rax, 2
    mov r14, rax
    mov rax, 1
    mov [rbp-48], rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov [rbp-64], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-88], rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-112], rax
    mov rax, 0
    mov [rbp-120], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-152], rax
    mov rax, 0
    mov r13, rax
    lea rax, [rel __g_parser_ng_ab]
    push rax
    mov rax, 0
    push rax
    mov rax, [rel __g_parser_ng_nargs]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
.L2437:
    cmp r13, 0
    jne .L2438
    mov rcx, r14
    sub rsp, 32
    call ng_srct
    add rsp, 32
    mov [rbp-64], rax
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L2440
    mov rax, [rbp-24]
    mov [rel __g_parser_ng_nargs], rax
    mov rax, 0
    jmp .__ret_2436
    jmp .L2441
.L2440:
.L2441:
    mov rdx, [rbp-64]
    mov rax, [rdx]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2446
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LBRACE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2446
    mov rax, 0
    jmp .L2447
.L2446:
    mov rax, 1
.L2447:
    test rax, rax
    jnz .L2444
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2444
    mov rax, 0
    jmp .L2445
.L2444:
    mov rax, 1
.L2445:
    test rax, rax
    jz .L2442
    mov rax, [rbp-24]
    mov [rel __g_parser_ng_nargs], rax
    mov rax, 0
    jmp .__ret_2436
    jmp .L2443
.L2442:
.L2443:
    mov rax, 0
    mov r12, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_GT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2448
    mov rax, 1
    mov r12, rax
    jmp .L2449
.L2448:
.L2449:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_RSHIFT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2450
    mov rax, 2
    mov r12, rax
    jmp .L2451
.L2450:
.L2451:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_URSHIFT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2452
    mov rax, 3
    mov r12, rax
    jmp .L2453
.L2452:
.L2453:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_COMMA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2456
    mov rax, [rbp-48]
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2456
    mov rax, 1
    jmp .L2457
.L2456:
    mov rax, 0
.L2457:
    test rax, rax
    jz .L2454
    add r15, 1
    cmp r15, 8
    jl .L2458
    mov rax, [rbp-24]
    mov [rel __g_parser_ng_nargs], rax
    mov rax, 0
    jmp .__ret_2436
    jmp .L2459
.L2458:
.L2459:
    lea rax, [rel __g_parser_ng_ab]
    push rax
    mov rax, r15
    push rax
    mov rax, [rel __g_parser_ng_nargs]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    add r14, 1
    jmp .L2455
.L2454:
    cmp r12, 0
    je .L2460
.L2462:
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L2465
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2465
    mov rax, 1
    jmp .L2466
.L2465:
    mov rax, 0
.L2466:
    test rax, rax
    jz .L2463
    sub r12, 1
    mov rax, [rbp-48]
    cmp rax, 1
    jne .L2467
    mov rax, 1
    mov r13, rax
    jmp .L2468
.L2467:
    mov rax, [rbp-48]
    sub rax, 1
    mov [rbp-48], rax
    mov rax, [rel __g_parser_ng_nargs]
    push rax
    mov rax, [rel __g_parser_NG_ARGTOK]
    sub rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2469
    mov rax, [rbp-64]
    push rax
section .data
.str2471: db 116,111,111,32,109,97,110,121,32,103,101,110,101,114,105,99,32,99,111,112,105,101,115,32,111,114,32,116,111,107,101,110,115,32,40,109,111,114,101,32,116,104,97,110,32,116,104,101,32,99,111,109,112,105,108,101,114,39,115,32,116,97,98,108
    db 101,115,32,104,111,108,100,41,0
section .text
    lea rax, [rel .str2471]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_err
    add rsp, 32
    mov rax, 0
    jmp .__ret_2436
    jmp .L2470
.L2469:
.L2470:
    lea rax, [rel __g_parser_ng_args]
    push rax
    mov rax, [rel __g_parser_ng_nargs]
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-88], rax
    mov rax, [rel __g_parser_ng_nargs]
    add rax, 1
    mov [rel __g_parser_ng_nargs], rax
    mov rax, [rbp-88]
    push rax
    mov rax, 1
    push rax
    mov rcx, [rbp-64]
    mov rdx, 1
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, [rbp-88]
    push rax
    mov rax, 2
    push rax
    mov rcx, [rbp-64]
    mov rdx, 2
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, [rel __g_parser_TOK_GT]
    mov rdx, [rbp-88]
    mov [rdx], rax
section .data
.str2472: db 62,0
section .text
    lea rax, [rel .str2472]
    mov rdx, [rbp-88]
    add rdx, 8
    mov [rdx], rax
    mov rax, 1
    mov rdx, [rbp-88]
    add rdx, 16
    mov [rdx], eax
.L2468:
.L2464:
    jmp .L2462
.L2463:
    cmp r13, 1
    jne .L2473
    mov rax, r12
    mov [rbp-56], rax
    add r14, 1
    mov rax, r14
    mov [rel __g_parser_ng_use_next], rax
    add r15, 1
    lea rax, [rel __g_parser_ng_ab]
    push rax
    mov rax, r15
    push rax
    mov rax, [rel __g_parser_ng_nargs]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    jmp .L2474
.L2473:
    add r14, 1
.L2474:
    jmp .L2461
.L2460:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_LT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2475
    mov rax, [rbp-48]
    add rax, 1
    mov [rbp-48], rax
    jmp .L2476
.L2475:
.L2476:
    mov rcx, [rbp-64]
    sub rsp, 32
    call ng_arg_push
    add rsp, 32
    cmp rax, 0
    jne .L2477
    mov rax, [rbp-64]
    push rax
section .data
.str2479: db 116,111,111,32,109,97,110,121,32,103,101,110,101,114,105,99,32,99,111,112,105,101,115,32,111,114,32,116,111,107,101,110,115,32,40,109,111,114,101,32,116,104,97,110,32,116,104,101,32,99,111,109,112,105,108,101,114,39,115,32,116,97,98,108
    db 101,115,32,104,111,108,100,41,0
section .text
    lea rax, [rel .str2479]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_err
    add rsp, 32
    mov rax, 0
    jmp .__ret_2436
    jmp .L2478
.L2477:
.L2478:
    add r14, 1
.L2461:
.L2455:
.L2439:
    jmp .L2437
.L2438:
    lea rax, [rel __g_parser_ng_t_np]
    push rax
    pop rcx
    mov rdx, [rbp-16]
    sub rsp, 32
    call tget
    add rsp, 32
    cmp rax, r15
    je .L2480
    mov rax, [rel __g_parser_ng_use_next]
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ng_srct
    add rsp, 32
    push rax
section .data
.str2482: db 116,104,105,115,32,103,101,110,101,114,105,99,32,105,115,32,117,115,101,100,32,119,105,116,104,32,97,32,100,105,102,102,101,114,101,110,116,32,110,117,109,98,101,114,32,111,102,32,116,121,112,101,115,32,116,104,97,110,32,105,116,32,100,101
    db 99,108,97,114,101,115,0
section .text
    lea rax, [rel .str2482]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_err
    add rsp, 32
    mov rax, 0
    jmp .__ret_2436
    jmp .L2481
.L2480:
.L2481:
    lea rax, [rel __g_parser_ng_t_name]
    push rax
    pop rcx
    mov rdx, [rbp-16]
    sub rsp, 32
    call tget
    add rsp, 32
    mov [rbp-152], rax
    lea rax, [rel __g_parser_ng_mbuf]
    push rax
    mov rdx, [rbp-152]
    add rdx, 8
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-152]
    add rdx, 16
    mov eax, dword [rdx]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_put
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L2483:
    cmp r12, r15
    jge .L2484
    mov rcx, r13
    mov rdx, 95
    sub rsp, 32
    call bset
    add rsp, 32
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call bset
    add rsp, 32
    add r13, 2
    lea rax, [rel __g_parser_ng_ab]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    mov [rbp-112], rax
.L2486:
    mov rax, [rbp-112]
    push rax
    lea rax, [rel __g_parser_ng_ab]
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2487
    lea rax, [rel __g_parser_ng_args]
    push rax
    mov rax, [rbp-112]
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-120], rax
    mov rdx, [rbp-120]
    mov rax, [rdx]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2493
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_INTEGER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2493
    mov rax, 0
    jmp .L2494
.L2493:
    mov rax, 1
.L2494:
    test rax, rax
    jnz .L2491
    mov rax, rbx
    mov rcx, 100
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L2491
    mov rax, 0
    jmp .L2492
.L2491:
    mov rax, 1
.L2492:
    test rax, rax
    jz .L2489
    mov rax, r13
    push rax
    mov rdx, [rbp-120]
    add rdx, 8
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-120]
    add rdx, 16
    mov eax, dword [rdx]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_put
    add rsp, 32
    mov r13, rax
    jmp .L2490
.L2489:
    mov rcx, r13
    mov rdx, 95
    sub rsp, 32
    call bset
    add rsp, 32
    add r13, 1
.L2490:
    mov rax, [rbp-112]
    add rax, 1
    mov [rbp-112], rax
.L2488:
    jmp .L2486
.L2487:
    add r12, 1
.L2485:
    jmp .L2483
.L2484:
    mov rax, r13
    push rax
    lea rax, [rel __g_parser_ng_mbuf]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L2495:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_ni]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2496
    lea rax, [rel __g_parser_ng_i_nlen]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, r12
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2500
    lea rax, [rel __g_parser_ng_i_name]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    lea rax, [rel __g_parser_ng_mbuf]
    push rax
    pop rdx
    pop rcx
    mov r8, r12
    sub rsp, 32
    call prs_memeq
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2500
    mov rax, 1
    jmp .L2501
.L2500:
    mov rax, 0
.L2501:
    test rax, rax
    jz .L2498
    mov rax, [rbp-24]
    mov [rel __g_parser_ng_nargs], rax
    lea rax, [rel __g_parser_ng_i_name]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    mov r13, rax
    mov rcx, r13
    mov rdx, r12
    mov r8, [rbp-56]
    sub rsp, 32
    call ng_use_write
    add rsp, 32
    jmp .__ret_2436
    jmp .L2499
.L2498:
.L2499:
    add rbx, 1
.L2497:
    jmp .L2495
.L2496:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_NG_MAXI]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2502
    mov rax, 0
    push rax
section .data
.str2504: db 116,111,111,32,109,97,110,121,32,103,101,110,101,114,105,99,32,99,111,112,105,101,115,32,111,114,32,116,111,107,101,110,115,32,40,109,111,114,101,32,116,104,97,110,32,116,104,101,32,99,111,109,112,105,108,101,114,39,115,32,116,97,98,108
    db 101,115,32,104,111,108,100,41,0
section .text
    lea rax, [rel .str2504]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_err
    add rsp, 32
    mov rax, 0
    jmp .__ret_2436
    jmp .L2503
.L2502:
.L2503:
    mov rcx, r13
    sub rsp, 32
    call ng_keep
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_parser_ng_keep_len]
    cmp rax, 0
    jne .L2505
    mov rax, 0
    push rax
section .data
.str2507: db 116,111,111,32,109,97,110,121,32,103,101,110,101,114,105,99,32,99,111,112,105,101,115,32,111,114,32,116,111,107,101,110,115,32,40,109,111,114,101,32,116,104,97,110,32,116,104,101,32,99,111,109,112,105,108,101,114,39,115,32,116,97,98,108
    db 101,115,32,104,111,108,100,41,0
section .text
    lea rax, [rel .str2507]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_err
    add rsp, 32
    mov rax, 0
    jmp .__ret_2436
    jmp .L2506
.L2505:
.L2506:
    lea rax, [rel __g_parser_ng_i_name]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r13
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_i_nlen]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_keep_len]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_i_t]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, [rbp-16]
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_i_bodyn]
    push rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L2508:
    cmp r12, r15
    jge .L2509
    lea rax, [rel __g_parser_ng_i_argb]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    add rax, r12
    push rax
    lea rax, [rel __g_parser_ng_ab]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_ng_i_argn]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    add rax, r12
    push rax
    lea rax, [rel __g_parser_ng_ab]
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    lea rax, [rel __g_parser_ng_ab]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    add r12, 1
.L2510:
    jmp .L2508
.L2509:
    mov rax, [rel __g_parser_ng_ni]
    add rax, 1
    mov [rel __g_parser_ng_ni], rax
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_ng_keep_len]
    push rax
    pop rdx
    pop rcx
    mov r8, [rbp-56]
    sub rsp, 32
    call ng_use_write
    add rsp, 32
    jmp .__ret_2436
.__ret_2436:
    mov rbx, [rbp-208]
    mov r12, [rbp-200]
    mov r13, [rbp-192]
    mov r14, [rbp-184]
    mov r15, [rbp-176]
    mov rsp, rbp
    pop rbp
    ret
ng_use_write:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, [rel __g_parser_ng_use_at]
    push rax
    pop rcx
    sub rsp, 32
    call ng_srct
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ng_emit_named
    add rsp, 32
.L2512:
    cmp rbx, 0
    jle .L2513
    mov rax, [rel __g_parser_ng_use_at]
    push rax
    pop rcx
    sub rsp, 32
    call ng_srct
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ng_emit_gt
    add rsp, 32
    sub rbx, 1
.L2514:
    jmp .L2512
.L2513:
    mov rax, 1
    jmp .__ret_2511
.__ret_2511:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ng_rw:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
.L2516:
    mov rax, r15
    push rax
    mov rax, [rel __g_parser_ng_srcn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2517
    mov rax, [rel __g_parser_ng_err_msg]
    cmp rax, 0
    je .L2519
    mov rax, 0
    jmp .__ret_2515
    jmp .L2520
.L2519:
.L2520:
    mov rcx, r15
    sub rsp, 32
    call ng_srct
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rel __g_parser_ng_ctxmod]
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_parser_ng_main]
    cmp rax, 0
    je .L2521
    lea rax, [rel __g_parser_ng_tokmod]
    add rax, r15
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    mov [rbp-24], rax
    lea rax, [rel __g_parser_ng_tokflag]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call tget
    add rsp, 32
    mov rbx, rax
    jmp .L2522
.L2521:
.L2522:
    cmp rbx, 0
    je .L2523
    mov rax, [rel __g_parser_ng_round]
    cmp rax, 2
    jne .L2525
    mov rax, rbx
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ng_put_copies
    add rsp, 32
    jmp .L2526
.L2525:
.L2526:
    lea rax, [rel __g_parser_ng_t_end]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call tget
    add rsp, 32
    mov r15, rax
    jmp .L2524
.L2523:
    mov rdx, [rbp-16]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2527
    mov rcx, [rbp-16]
    sub rsp, 32
    call ng_emit
    add rsp, 32
    add r15, 1
    jmp .L2528
.L2527:
    mov rax, 0
    mov r14, rax
    cmp r15, 0
    je .L2529
    mov rax, r15
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ng_stype
    add rsp, 32
    mov r14, rax
    jmp .L2530
.L2529:
.L2530:
    mov rax, 1
    neg rax
    mov rbx, rax
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_TOK_DOT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2535
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ng_stype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_DOT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2535
    mov rax, 1
    jmp .L2536
.L2535:
    mov rax, 0
.L2536:
    test rax, rax
    jz .L2533
    mov rax, r15
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call ng_stype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2533
    mov rax, 1
    jmp .L2534
.L2533:
    mov rax, 0
.L2534:
    test rax, rax
    jz .L2531
    mov rcx, [rbp-16]
    sub rsp, 32
    call ng_find_mod
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2537
    mov rax, r15
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call ng_srct
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    mov rdx, [rbp-48]
    mov r8, 0
    sub rsp, 32
    call ng_find_decl
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2539
    lea rax, [rel __g_parser_ng_d_kind]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call tget
    add rsp, 32
    cmp rax, 3
    jne .L2541
    mov rax, r15
    add rax, 2
    mov rbx, rax
    jmp .L2542
.L2541:
    lea rax, [rel __g_parser_ng_d_dup]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call tget
    add rsp, 32
    cmp rax, 0
    je .L2543
    mov rcx, [rbp-48]
    mov rdx, r12
    sub rsp, 32
    call ng_dupname
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_dn_len]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_emit_named
    add rsp, 32
    mov rax, r15
    add rax, 3
    mov rbx, rax
    jmp .L2544
.L2543:
    mov rcx, r12
    sub rsp, 32
    call ng_emit
    add rsp, 32
    mov rax, r15
    add rax, 3
    mov rbx, rax
.L2544:
.L2542:
    jmp .L2540
.L2539:
.L2540:
    jmp .L2538
.L2537:
.L2538:
    jmp .L2532
.L2531:
.L2532:
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_TOK_DOT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2545
    mov rcx, [rbp-16]
    sub rsp, 32
    call ng_emit
    add rsp, 32
    mov rax, r15
    add rax, 1
    mov rbx, rax
    jmp .L2546
.L2545:
.L2546:
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2547
    mov rcx, [rbp-16]
    sub rsp, 32
    call ng_find_t
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2549
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ng_stype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2551
    mov rax, r15
    mov [rel __g_parser_ng_use_at], rax
    mov rcx, r15
    mov rdx, r12
    sub rsp, 32
    call ng_use
    add rsp, 32
    cmp rax, 1
    jne .L2553
    mov rax, [rel __g_parser_ng_use_next]
    mov rbx, rax
    jmp .L2554
.L2553:
.L2554:
    jmp .L2552
.L2551:
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ng_stype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2557
    lea rax, [rel __g_parser_ng_t_isfn]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2557
    mov rax, 1
    jmp .L2558
.L2557:
    mov rax, 0
.L2558:
    test rax, rax
    jz .L2555
    mov rax, [rbp-16]
    push rax
section .data
.str2559: db 97,32,103,101,110,101,114,105,99,32,102,117,110,99,116,105,111,110,32,105,115,32,99,97,108,108,101,100,32,119,105,116,104,32,105,116,115,32,116,121,112,101,115,58,32,110,97,109,101,60,84,62,40,46,46,46,41,0
section .text
    lea rax, [rel .str2559]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_err
    add rsp, 32
    mov rax, 0
    jmp .__ret_2515
    jmp .L2556
.L2555:
.L2556:
.L2552:
    jmp .L2550
.L2549:
    mov rax, [rel __g_parser_ng_anydup]
    cmp rax, 0
    je .L2560
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    neg rax
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
    call ng_find_decl
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2564
    lea rax, [rel __g_parser_ng_d_dup]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2564
    mov rax, 1
    jmp .L2565
.L2564:
    mov rax, 0
.L2565:
    test rax, rax
    jz .L2562
    mov rax, 0
    mov r12, rax
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ng_stype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_LPAREN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2570
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_TOK_AMPERSAND]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2570
    mov rax, 0
    jmp .L2571
.L2570:
    mov rax, 1
.L2571:
    test rax, rax
    jnz .L2568
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_KW_FN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2568
    mov rax, 0
    jmp .L2569
.L2568:
    mov rax, 1
.L2569:
    test rax, rax
    jz .L2566
    mov rax, 1
    mov r12, rax
    jmp .L2567
.L2566:
    mov rax, r15
    mov rcx, 2
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2576
    mov rax, r14
    mov rcx, 100
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2576
    mov rax, 1
    jmp .L2577
.L2576:
    mov rax, 0
.L2577:
    test rax, rax
    jz .L2574
    mov rax, r15
    sub rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call ng_stype
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_KW_FN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2574
    mov rax, 1
    jmp .L2575
.L2574:
    mov rax, 0
.L2575:
    test rax, rax
    jz .L2572
    mov rax, 1
    mov r12, rax
    jmp .L2573
.L2572:
.L2573:
.L2567:
    cmp r12, 1
    jne .L2578
    mov rcx, [rbp-16]
    mov rdx, [rbp-24]
    mov r8, 1
    sub rsp, 32
    call ng_find_decl
    add rsp, 32
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2580
    mov rax, [rbp-16]
    push rax
section .data
.str2582: db 116,119,111,32,109,111,100,117,108,101,115,32,100,101,102,105,110,101,32,97,32,102,117,110,99,116,105,111,110,32,111,102,32,116,104,105,115,32,110,97,109,101,58,32,119,114,105,116,101,32,119,104,105,99,104,44,32,109,111,100,117,108,101,46
    db 110,97,109,101,0
section .text
    lea rax, [rel .str2582]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_err
    add rsp, 32
    mov rax, 0
    jmp .__ret_2515
    jmp .L2581
.L2580:
.L2581:
    mov rcx, [rbp-24]
    mov rdx, [rbp-16]
    sub rsp, 32
    call ng_dupname
    add rsp, 32
    mov rbx, rax
    mov rax, [rbp-16]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_dn_len]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_emit_named
    add rsp, 32
    mov rax, r15
    add rax, 1
    mov rbx, rax
    jmp .L2579
.L2578:
.L2579:
    jmp .L2563
.L2562:
.L2563:
    jmp .L2561
.L2560:
.L2561:
.L2550:
    jmp .L2548
.L2547:
.L2548:
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2583
    mov rcx, [rbp-16]
    sub rsp, 32
    call ng_emit
    add rsp, 32
    mov rax, r15
    add rax, 1
    mov rbx, rax
    jmp .L2584
.L2583:
.L2584:
    mov rax, rbx
    mov r15, rax
.L2528:
.L2524:
.L2518:
    jmp .L2516
.L2517:
    mov rax, 0
    jmp .__ret_2515
.__ret_2515:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
ng_put_copies:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L2586:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_ng_ni]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2587
    lea rax, [rel __g_parser_ng_i_t]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, r14
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2591
    lea rax, [rel __g_parser_ng_i_bodyn]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2591
    mov rax, 1
    jmp .L2592
.L2591:
    mov rax, 0
.L2592:
    test rax, rax
    jz .L2589
    lea rax, [rel __g_parser_ng_i_bodyn]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call tget
    add rsp, 32
    mov r12, rax
    lea rax, [rel __g_parser_ng_i_bodyb]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call tget
    add rsp, 32
    mov rbx, rax
.L2593:
    cmp r12, 0
    jle .L2594
    lea rax, [rel __g_parser_ng_itok]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ng_emit
    add rsp, 32
    add rbx, 1
    sub r12, 1
.L2595:
    jmp .L2593
.L2594:
    jmp .L2590
.L2589:
.L2590:
    add r13, 1
.L2588:
    jmp .L2586
.L2587:
    mov rax, 0
    jmp .__ret_2585
.__ret_2585:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ng_make:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r15, rcx
    lea rax, [rel __g_parser_ng_i_t]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call tget
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_ng_nsub], rax
    lea rax, [rel __g_parser_ng_sub]
    mov [rel __g_parser_ng_dst], rax
    lea rax, [rel __g_parser_ng_nsub]
    mov [rel __g_parser_ng_dstn], rax
    lea rax, [rel __g_parser_ng_t_start]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call tget
    add rsp, 32
    mov r13, rax
    lea rax, [rel __g_parser_ng_t_lt]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call tget
    add rsp, 32
    sub rax, 1
    mov [rbp-32], rax
.L2597:
    mov rax, r13
    mov rcx, [rbp-32]
    cmp rax, rcx
    jge .L2598
    mov rax, [rel __g_parser_ng_tok]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ng_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ng_emit
    add rsp, 32
    add r13, 1
.L2599:
    jmp .L2597
.L2598:
    mov rax, [rel __g_parser_ng_tok]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ng_at
    add rsp, 32
    push rax
    lea rax, [rel __g_parser_ng_i_name]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    lea rax, [rel __g_parser_ng_i_nlen]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_emit_named
    add rsp, 32
    lea rax, [rel __g_parser_ng_t_body]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call tget
    add rsp, 32
    mov r13, rax
    lea rax, [rel __g_parser_ng_t_end]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call tget
    add rsp, 32
    mov [rbp-32], rax
    lea rax, [rel __g_parser_ng_t_np]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call tget
    add rsp, 32
    mov [rbp-56], rax
.L2600:
    mov rax, r13
    mov rcx, [rbp-32]
    cmp rax, rcx
    jge .L2601
    mov rax, [rel __g_parser_ng_tok]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ng_at
    add rsp, 32
    mov [rbp-40], rax
    mov rax, 1
    neg rax
    mov rbx, rax
    mov rdx, [rbp-40]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2603
    mov rax, 0
    mov r12, rax
.L2605:
    mov rax, r12
    mov rcx, [rbp-56]
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2608
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2608
    mov rax, 1
    jmp .L2609
.L2608:
    mov rax, 0
.L2609:
    test rax, rax
    jz .L2606
    lea rax, [rel __g_parser_ng_t_par]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    add rax, r12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rcx
    mov rdx, [rbp-40]
    sub rsp, 32
    call prs_tok_same
    add rsp, 32
    cmp rax, 1
    jne .L2610
    mov rax, r12
    mov rbx, rax
    jmp .L2611
.L2610:
.L2611:
    add r12, 1
.L2607:
    jmp .L2605
.L2606:
    jmp .L2604
.L2603:
.L2604:
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2612
    mov rcx, [rbp-40]
    sub rsp, 32
    call ng_emit
    add rsp, 32
    jmp .L2613
.L2612:
    lea rax, [rel __g_parser_ng_i_argb]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call tget
    add rsp, 32
    mov r12, rax
    lea rax, [rel __g_parser_ng_i_argn]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call tget
    add rsp, 32
    mov rbx, rax
.L2614:
    cmp rbx, 0
    jle .L2615
    lea rax, [rel __g_parser_ng_args]
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ng_emit
    add rsp, 32
    add r12, 1
    sub rbx, 1
.L2616:
    jmp .L2614
.L2615:
.L2613:
    add r13, 1
.L2602:
    jmp .L2600
.L2601:
    lea rax, [rel __g_parser_ng_itok]
    mov [rel __g_parser_ng_dst], rax
    lea rax, [rel __g_parser_ng_nitok]
    mov [rel __g_parser_ng_dstn], rax
    lea rax, [rel __g_parser_ng_sub]
    mov [rel __g_parser_ng_src], rax
    mov rax, [rel __g_parser_ng_nsub]
    mov [rel __g_parser_ng_srcn], rax
    mov rax, 0
    mov [rel __g_parser_ng_main], rax
    lea rax, [rel __g_parser_ng_t_mod]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call tget
    add rsp, 32
    mov [rel __g_parser_ng_ctxmod], rax
    lea rax, [rel __g_parser_ng_i_bodyb]
    push rax
    mov rax, r15
    push rax
    mov rax, [rel __g_parser_ng_nitok]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    sub rsp, 32
    call ng_rw
    add rsp, 32
    lea rax, [rel __g_parser_ng_i_bodyn]
    push rax
    mov rax, r15
    push rax
    mov rax, [rel __g_parser_ng_nitok]
    push rax
    lea rax, [rel __g_parser_ng_i_bodyb]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call tget
    add rsp, 32
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, 0
    jmp .__ret_2596
.__ret_2596:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
ng_main_pass:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    mov [rel __g_parser_ng_nout], rax
    lea rax, [rel __g_parser_ng_out]
    mov [rel __g_parser_ng_dst], rax
    lea rax, [rel __g_parser_ng_nout]
    mov [rel __g_parser_ng_dstn], rax
    mov rax, [rel __g_parser_ng_tok]
    mov [rel __g_parser_ng_src], rax
    mov rax, [rel __g_parser_ng_cnt]
    mov [rel __g_parser_ng_srcn], rax
    mov rax, 1
    mov [rel __g_parser_ng_main], rax
    sub rsp, 32
    call ng_rw
    add rsp, 32
    mov rax, 0
    jmp .__ret_2617
.__ret_2617:
    mov rsp, rbp
    pop rbp
    ret
ng_run:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    mov [rel __g_parser_ng_tok], rax
    mov rax, r13
    mov [rel __g_parser_ng_cnt], rax
    mov rax, 0
    mov [rel __g_parser_ng_err_msg], rax
    mov rax, 0
    mov [rel __g_parser_ng_err_tok], rax
    mov rax, 0
    mov [rel __g_parser_ng_ni], rax
    mov rax, 0
    mov [rel __g_parser_ng_nargs], rax
    mov rax, 0
    mov [rel __g_parser_ng_nitok], rax
    mov rax, 0
    mov [rel __g_parser_ng_ntext], rax
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_NG_MAXTOK]
    sub rax, 2
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2619
    mov rax, r13
    jmp .__ret_2618
    jmp .L2620
.L2619:
.L2620:
    sub rsp, 32
    call ng_modules
    add rsp, 32
    sub rsp, 32
    call ng_decls
    add rsp, 32
    mov rax, 1
    mov [rel __g_parser_ng_round], rax
    sub rsp, 32
    call ng_main_pass
    add rsp, 32
    mov rax, [rel __g_parser_ng_err_msg]
    cmp rax, 0
    je .L2621
    mov rax, 0
    jmp .__ret_2618
    jmp .L2622
.L2621:
.L2622:
.L2623:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_ng_ni]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2624
    mov rcx, r12
    sub rsp, 32
    call ng_make
    add rsp, 32
    mov rax, [rel __g_parser_ng_err_msg]
    cmp rax, 0
    je .L2626
    mov rax, 0
    jmp .__ret_2618
    jmp .L2627
.L2626:
.L2627:
    add r12, 1
.L2625:
    jmp .L2623
.L2624:
    mov rax, 2
    mov [rel __g_parser_ng_round], rax
    sub rsp, 32
    call ng_main_pass
    add rsp, 32
    mov rax, [rel __g_parser_ng_err_msg]
    cmp rax, 0
    je .L2628
    mov rax, 0
    jmp .__ret_2618
    jmp .L2629
.L2628:
.L2629:
.L2630:
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_ng_nout]
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2631
    mov rax, [rel __g_parser_ng_tok]
    push rax
    mov rax, rbx
    push rax
    lea rax, [rel __g_parser_ng_out]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    add rbx, 1
.L2632:
    jmp .L2630
.L2631:
    mov rax, [rel __g_parser_ng_nout]
    jmp .__ret_2618
.__ret_2618:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
tget:
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
    jmp .__ret_2633
.__ret_2633:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
tset:
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
    jmp .__ret_2634
.__ret_2634:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
bget:
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
    jmp .__ret_2635
.__ret_2635:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
bset:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 0
    jmp .__ret_2636
.__ret_2636:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
prs_memeq:
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
.L2638:
    cmp rbx, r12
    jge .L2639
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2641
    mov rax, 0
    jmp .__ret_2637
    jmp .L2642
.L2641:
.L2642:
    add rbx, 1
.L2640:
    jmp .L2638
.L2639:
    mov rax, 1
    jmp .__ret_2637
.__ret_2637:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_tok_same:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    push rax
    mov rdx, [rbp-16]
    add rdx, 16
    mov eax, dword [rdx]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2644
    mov rax, 0
    jmp .__ret_2643
    jmp .L2645
.L2644:
.L2645:
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-16]
    add rdx, 8
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_memeq
    add rsp, 32
    jmp .__ret_2643
.__ret_2643:
    mov rsp, rbp
    pop rbp
    ret
prs_tok_is:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov [rbp-8], rcx
    mov r12, rdx
    mov rbx, r8
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, rbx
    je .L2647
    mov rax, 0
    jmp .__ret_2646
    jmp .L2648
.L2647:
.L2648:
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call prs_memeq
    add rsp, 32
    jmp .__ret_2646
.__ret_2646:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_put_name:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    lea rax, [rel __g_parser_prs_names]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
.L2650:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    cmp rax, 0
    je .L2651
    add rbx, 1
.L2652:
    jmp .L2650
.L2651:
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rdx, [rbp-24]
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-24]
    add rdx, 8
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-24]
    add rdx, 16
    mov [rdx], eax
    mov rax, 0
    mov rdx, [rbp-24]
    add rdx, 20
    mov [rdx], ax
    mov rax, 0
    mov rdx, [rbp-24]
    add rdx, 22
    mov [rdx], ax
    mov rax, 0
    jmp .__ret_2649
.__ret_2649:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_names_init:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, 0
    mov [rbp-8], rax
    mov rax, [rel __g_parser_PT_SLICE_GET]
    push rax
section .data
.str2654: db 115,108,105,99,101,95,103,101,116,0
section .text
    lea rax, [rel .str2654]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_SLICE_SET]
    push rax
section .data
.str2655: db 115,108,105,99,101,95,115,101,116,0
section .text
    lea rax, [rel .str2655]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_SLICER_GET]
    push rax
section .data
.str2656: db 115,108,105,99,101,95,103,101,116,95,114,101,97,108,0
section .text
    lea rax, [rel .str2656]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_SLICER_SET]
    push rax
section .data
.str2657: db 115,108,105,99,101,95,115,101,116,95,114,101,97,108,0
section .text
    lea rax, [rel .str2657]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_LIST_GET]
    push rax
section .data
.str2658: db 108,105,115,116,95,103,101,116,0
section .text
    lea rax, [rel .str2658]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_LIST_SET]
    push rax
section .data
.str2659: db 108,105,115,116,95,115,101,116,0
section .text
    lea rax, [rel .str2659]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_LISTR_GET]
    push rax
section .data
.str2660: db 108,105,115,116,95,103,101,116,95,114,101,97,108,0
section .text
    lea rax, [rel .str2660]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_LISTR_SET]
    push rax
section .data
.str2661: db 108,105,115,116,95,115,101,116,95,114,101,97,108,0
section .text
    lea rax, [rel .str2661]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_MAP_GET]
    push rax
section .data
.str2662: db 109,97,112,95,103,101,116,0
section .text
    lea rax, [rel .str2662]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_MAP_SET]
    push rax
section .data
.str2663: db 109,97,112,95,115,101,116,0
section .text
    lea rax, [rel .str2663]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_MAPR_GET]
    push rax
section .data
.str2664: db 109,97,112,95,103,101,116,95,114,101,97,108,0
section .text
    lea rax, [rel .str2664]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_MAPR_SET]
    push rax
section .data
.str2665: db 109,97,112,95,115,101,116,95,114,101,97,108,0
section .text
    lea rax, [rel .str2665]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_LISTS_GET]
    push rax
section .data
.str2666: db 108,105,115,116,95,115,103,101,116,0
section .text
    lea rax, [rel .str2666]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_LISTS_SET]
    push rax
section .data
.str2667: db 108,105,115,116,95,115,115,101,116,0
section .text
    lea rax, [rel .str2667]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_LIST_LEN]
    push rax
section .data
.str2668: db 108,105,115,116,95,108,101,110,0
section .text
    lea rax, [rel .str2668]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_ONE]
    push rax
section .data
.str2669: db 49,0
section .text
    lea rax, [rel .str2669]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    mov rax, [rel __g_parser_PT_ZERO]
    push rax
section .data
.str2670: db 48,0
section .text
    lea rax, [rel .str2670]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_put_name
    add rsp, 32
    lea rax, [rel __g_parser_prs_names]
    push rax
    mov rax, [rel __g_parser_PT_ONE]
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-8], rax
    mov rax, [rel __g_parser_TOK_INTEGER]
    mov rdx, [rbp-8]
    mov [rdx], rax
    lea rax, [rel __g_parser_prs_names]
    push rax
    mov rax, [rel __g_parser_PT_ZERO]
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-8], rax
    mov rax, [rel __g_parser_TOK_INTEGER]
    mov rdx, [rbp-8]
    mov [rdx], rax
    mov rax, 0
    jmp .__ret_2653
.__ret_2653:
    mov rsp, rbp
    pop rbp
    ret
prs_made:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_parser_prs_names]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_2671
.__ret_2671:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_coll_get:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L2673
    mov rax, [rel __g_parser_PT_SLICE_GET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2672
    jmp .L2674
.L2673:
.L2674:
    cmp rbx, 1
    jne .L2675
    mov rax, [rel __g_parser_PT_LIST_GET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2672
    jmp .L2676
.L2675:
.L2676:
    cmp rbx, 2
    jne .L2677
    mov rax, [rel __g_parser_PT_LISTR_GET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2672
    jmp .L2678
.L2677:
.L2678:
    cmp rbx, 3
    jne .L2679
    mov rax, [rel __g_parser_PT_MAP_GET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2672
    jmp .L2680
.L2679:
.L2680:
    cmp rbx, 4
    jne .L2681
    mov rax, [rel __g_parser_PT_MAPR_GET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2672
    jmp .L2682
.L2681:
.L2682:
    cmp rbx, 5
    jne .L2683
    mov rax, [rel __g_parser_PT_SLICER_GET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2672
    jmp .L2684
.L2683:
.L2684:
    mov rax, [rel __g_parser_PT_LISTS_GET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2672
.__ret_2672:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_coll_set:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L2686
    mov rax, [rel __g_parser_PT_SLICE_SET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2685
    jmp .L2687
.L2686:
.L2687:
    cmp rbx, 1
    jne .L2688
    mov rax, [rel __g_parser_PT_LIST_SET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2685
    jmp .L2689
.L2688:
.L2689:
    cmp rbx, 2
    jne .L2690
    mov rax, [rel __g_parser_PT_LISTR_SET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2685
    jmp .L2691
.L2690:
.L2691:
    cmp rbx, 3
    jne .L2692
    mov rax, [rel __g_parser_PT_MAP_SET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2685
    jmp .L2693
.L2692:
.L2693:
    cmp rbx, 4
    jne .L2694
    mov rax, [rel __g_parser_PT_MAPR_SET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2685
    jmp .L2695
.L2694:
.L2695:
    cmp rbx, 5
    jne .L2696
    mov rax, [rel __g_parser_PT_SLICER_SET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2685
    jmp .L2697
.L2696:
.L2697:
    mov rax, [rel __g_parser_PT_LISTS_SET]
    push rax
    pop rcx
    sub rsp, 32
    call prs_made
    add rsp, 32
    jmp .__ret_2685
.__ret_2685:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_cur:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_parser_par_pos]
    push rax
    mov rax, [rel __g_parser_par_token_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2699
    mov rax, [rel __g_parser_par_pos]
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_parser_par_tokens]
    add rax, rcx
    jmp .__ret_2698
    jmp .L2700
.L2699:
.L2700:
    lea rax, [rel __g_parser_prs_eof]
    jmp .__ret_2698
.__ret_2698:
    mov rsp, rbp
    pop rbp
    ret
prs_ct:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-8], rax
    mov rdx, [rbp-8]
    mov rax, [rdx]
    jmp .__ret_2701
.__ret_2701:
    mov rsp, rbp
    pop rbp
    ret
prs_peek_next:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, 0
    mov [rbp-8], rax
    mov rax, [rel __g_parser_par_pos]
    add rax, 1
    push rax
    mov rax, [rel __g_parser_par_token_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2703
    mov rax, [rel __g_parser_par_pos]
    add rax, 1
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_parser_par_tokens]
    add rax, rcx
    mov [rbp-8], rax
    mov rdx, [rbp-8]
    mov rax, [rdx]
    jmp .__ret_2702
    jmp .L2704
.L2703:
.L2704:
    mov rax, [rel __g_parser_TOK_EOF]
    jmp .__ret_2702
.__ret_2702:
    mov rsp, rbp
    pop rbp
    ret
prs_adv:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_parser_par_pos]
    add rax, 1
    mov [rel __g_parser_par_pos], rax
    mov rax, 0
    jmp .__ret_2705
.__ret_2705:
    mov rsp, rbp
    pop rbp
    ret
prs_want:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_parser_par_expected], rax
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov rcx, rbx
    cmp rax, rcx
    sete al
    movzx rax, al
    jmp .__ret_2706
.__ret_2706:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_is_field_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2708
    mov rax, 1
    jmp .__ret_2707
    jmp .L2709
.L2708:
.L2709:
    cmp rbx, 100
    jl .L2710
    mov rax, 1
    jmp .__ret_2707
    jmp .L2711
.L2710:
.L2711:
    mov rax, 0
    jmp .__ret_2707
.__ret_2707:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
prs_new:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov rbx, rcx
    mov rax, [rel __g_parser_par_arena_ptr]
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, [rel __g_parser_par_arena_ptr]
    push rax
    mov rax, [rel __g_parser_AST_NODE_SIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_parser_par_arena_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L2713
    mov rax, 0
    jmp .__ret_2712
    jmp .L2714
.L2713:
.L2714:
    mov rax, [rel __g_parser_par_arena_ptr]
    push rax
    mov rax, [rel __g_parser_AST_NODE_SIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_parser_par_arena_ptr], rax
    mov rax, rbx
    mov rdx, [rbp-16]
    mov [rdx], rax
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 32
    mov [rdx], eax
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 36
    mov [rdx], ax
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 38
    mov [rdx], ax
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 40
    mov [rdx], rax
    mov rax, 0
    mov rdx, [rbp-16]
    add rdx, 48
    mov [rdx], rax
    mov rax, [rel __g_parser_par_pos]
    push rax
    mov rax, [rel __g_parser_par_token_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2715
    mov rax, [rel __g_parser_par_pos]
    push rax
    mov rax, [rel __g_parser_PRS_TOK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_parser_par_tokens]
    add rax, rcx
    mov [rbp-24], rax
    mov rdx, [rbp-24]
    add rdx, 20
    movzx eax, word [rdx]
    mov rdx, [rbp-16]
    add rdx, 36
    mov [rdx], ax
    jmp .L2716
.L2715:
.L2716:
    mov rax, [rbp-16]
    jmp .__ret_2712
.__ret_2712:
    mov rbx, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
par_slice_add:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_parser_par_coll_stok], rax
    mov rax, [rel __g_parser_par_last_is_slice]
    cmp rax, 2
    jne .L2718
    mov rax, 5
    mov rbx, rax
    jmp .L2719
.L2718:
.L2719:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call par_coll_add
    add rsp, 32
    mov rax, 0
    jmp .__ret_2717
.__ret_2717:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
par_coll_add:
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
    mov rax, [rel __g_parser_par_in_fn]
    cmp rax, 0
    jne .L2721
    mov rax, [rel __g_parser_par_gcoll_n]
    mov rbx, rax
    cmp rbx, 256
    jl .L2723
    mov rax, 0
    jmp .__ret_2720
    jmp .L2724
.L2723:
.L2724:
    lea rax, [rel __g_parser_par_gcoll_toks]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r13
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_par_gcoll_kind]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_par_gcoll_stok]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_par_coll_stok]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, rbx
    add rax, 1
    mov [rel __g_parser_par_gcoll_n], rax
    mov rax, 0
    jmp .__ret_2720
    jmp .L2722
.L2721:
.L2722:
    mov rax, [rel __g_parser_par_slice_n]
    mov rbx, rax
    cmp rbx, 64
    jl .L2725
    mov rax, 0
    jmp .__ret_2720
    jmp .L2726
.L2725:
.L2726:
    lea rax, [rel __g_parser_par_slice_toks]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r13
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_par_slice_kind]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_par_slice_stok]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_parser_par_coll_stok]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, rbx
    add rax, 1
    mov [rel __g_parser_par_slice_n], rax
    mov rax, 0
    jmp .__ret_2720
.__ret_2720:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
par_coll_of_vtag:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov rax, [rel __g_parser_par_last_vtag]
    mov r13, rax
    mov rax, r13
    and rax, 15
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 2
    jne .L2728
    mov rax, 1
    mov r12, rax
    jmp .L2729
.L2728:
    cmp r12, 3
    jne .L2730
    mov rax, 3
    mov r12, rax
    jmp .L2731
.L2730:
    mov rax, 0
    jmp .__ret_2727
.L2731:
.L2729:
    mov rax, 0
    mov [rel __g_parser_par_coll_stok], rax
    mov rax, r13
    mov rcx, 0xFFFFFFFF
    and rax, rcx
    sar rax, 4
    mov rbx, rax
    and rbx, 15
    cmp rbx, 2
    jne .L2732
    add r12, 1
    jmp .L2733
.L2732:
    cmp rbx, 3
    jne .L2734
    cmp r12, 1
    jne .L2736
    mov rax, 6
    mov r12, rax
    mov rax, [rel __g_parser_par_last_coll_stok]
    mov [rel __g_parser_par_coll_stok], rax
    mov rax, [rel __g_parser_par_ls_n]
    cmp rax, 8192
    jge .L2738
    lea rax, [rel __g_parser_par_ls_decl]
    push rax
    mov rax, [rel __g_parser_par_ls_n]
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
    call tset
    add rsp, 32
    lea rax, [rel __g_parser_par_ls_type]
    push rax
    mov rax, [rel __g_parser_par_ls_n]
    push rax
    mov rax, [rel __g_parser_par_last_coll_stok]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call tset
    add rsp, 32
    mov rax, [rel __g_parser_par_ls_n]
    add rax, 1
    mov [rel __g_parser_par_ls_n], rax
    jmp .L2739
.L2738:
.L2739:
    jmp .L2737
.L2736:
.L2737:
    jmp .L2735
.L2734:
    mov rax, rbx
    shl rax, 8
    mov rcx, rax
    mov rax, r12
    or rax, rcx
    mov r12, rax
.L2735:
.L2733:
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call par_coll_add
    add rsp, 32
    mov rax, 0
    jmp .__ret_2727
.__ret_2727:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
par_is_slice:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L2741:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_par_slice_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2742
    lea rax, [rel __g_parser_par_slice_toks]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call prs_tok_same
    add rsp, 32
    cmp rax, 1
    jne .L2744
    lea rax, [rel __g_parser_par_slice_stok]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    mov [rel __g_parser_par_coll_stok], rax
    lea rax, [rel __g_parser_par_slice_kind]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    and rax, 255
    add rax, 1
    push rax
    mov rax, rbx
    and rax, 0xFF00
    mov rcx, rax
    pop rax
    or rax, rcx
    jmp .__ret_2740
    jmp .L2745
.L2744:
.L2745:
    add r12, 1
.L2743:
    jmp .L2741
.L2742:
    mov rax, 0
    mov r12, rax
.L2746:
    mov rax, r12
    push rax
    mov rax, [rel __g_parser_par_gcoll_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2747
    lea rax, [rel __g_parser_par_gcoll_toks]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call prs_tok_same
    add rsp, 32
    cmp rax, 1
    jne .L2749
    lea rax, [rel __g_parser_par_gcoll_stok]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    mov [rel __g_parser_par_coll_stok], rax
    lea rax, [rel __g_parser_par_gcoll_kind]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call tget
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    and rax, 255
    add rax, 1
    push rax
    mov rax, rbx
    and rax, 0xFF00
    mov rcx, rax
    pop rax
    or rax, rcx
    jmp .__ret_2740
    jmp .L2750
.L2749:
.L2750:
    add r12, 1
.L2748:
    jmp .L2746
.L2747:
    mov rax, 0
    jmp .__ret_2740
.__ret_2740:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
par_slice_get_call:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-8], rcx
    mov r12, rdx
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L2752
    mov rax, 0
    jmp .__ret_2751
    jmp .L2753
.L2752:
.L2753:
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    mov rdx, [rbp-24]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L2754
    mov rax, 0
    jmp .__ret_2751
    jmp .L2755
.L2754:
.L2755:
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    mov rdx, [rbp-32]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L2756
    mov rax, 0
    jmp .__ret_2751
    jmp .L2757
.L2756:
.L2757:
    mov rax, [rbp-32]
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-24]
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_CALL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L2758
    mov rax, 0
    jmp .__ret_2751
    jmp .L2759
.L2758:
.L2759:
    mov rax, r12
    and rax, 255
    sub rax, 1
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call prs_coll_get
    add rsp, 32
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-40]
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_SLICE_GET_MARK]
    add rax, rbx
    mov rdx, [rbp-48]
    add rdx, 48
    mov [rdx], rax
    mov rax, r12
    and rax, 0xFF00
    mov rdx, [rbp-48]
    add rdx, 38
    mov [rdx], ax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2762
    mov rax, rbx
    mov rcx, 5
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2762
    mov rax, 0
    jmp .L2763
.L2762:
    mov rax, 1
.L2763:
    test rax, rax
    jz .L2760
    mov rax, 1
    mov [rel __g_parser_par_used_slice], rax
    jmp .L2761
.L2760:
.L2761:
    mov rax, [rbp-48]
    jmp .__ret_2751
.__ret_2751:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
par_make_assign:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-8], rcx
    mov r12, rdx
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
    mov rbx, rax
    mov rdx, [rbp-8]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_AST_CALL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2765
    mov rdx, [rbp-8]
    add rdx, 48
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_parser_SLICE_GET_MARK]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2769
    mov rax, rbx
    mov rcx, 6
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2769
    mov rax, 1
    jmp .L2770
.L2769:
    mov rax, 0
.L2770:
    test rax, rax
    jz .L2767
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L2771
    mov rax, 0
    jmp .__ret_2764
    jmp .L2772
.L2771:
.L2772:
    mov rax, r12
    mov rdx, [rbp-24]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L2773
    mov rax, 0
    jmp .__ret_2764
    jmp .L2774
.L2773:
.L2774:
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-56], rax
    mov rdx, [rbp-56]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-56], rax
    mov rdx, [rbp-56]
    add rdx, 8
    mov rax, [rdx]
    mov rdx, [rbp-32]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-24]
    mov rdx, [rbp-32]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_ARG]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L2775
    mov rax, 0
    jmp .__ret_2764
    jmp .L2776
.L2775:
.L2776:
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-56], rax
    mov rdx, [rbp-56]
    add rdx, 8
    mov rax, [rdx]
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-32]
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rel __g_parser_AST_CALL]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L2777
    mov rax, 0
    jmp .__ret_2764
    jmp .L2778
.L2777:
.L2778:
    mov rax, [rbp-40]
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rcx, rbx
    sub rsp, 32
    call prs_coll_set
    add rsp, 32
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rbp-48]
    jmp .__ret_2764
    jmp .L2768
.L2767:
.L2768:
    jmp .L2766
.L2765:
.L2766:
    mov rax, [rel __g_parser_AST_ASSIGN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L2779
    mov rax, 0
    jmp .__ret_2764
    jmp .L2780
.L2779:
.L2780:
    mov rax, [rbp-8]
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], rax
    mov rax, r12
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], rax
    mov rax, [rbp-48]
    jmp .__ret_2764
.__ret_2764:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
prs_init:
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
    mov rbx, r9
    mov rax, [rel __g_parser_prs_ready]
    cmp rax, 0
    jne .L2782
    sub rsp, 32
    call prs_names_init
    add rsp, 32
    mov rax, 1
    mov [rel __g_parser_prs_ready], rax
    jmp .L2783
.L2782:
.L2783:
    mov rax, r14
    mov [rel __g_parser_par_tokens], rax
    mov rax, r13
    mov [rel __g_parser_par_token_count], rax
    mov rax, r12
    mov [rel __g_parser_par_ast_buf], rax
    mov rax, r12
    mov [rel __g_parser_par_arena_ptr], rax
    mov rax, r12
    add rax, rbx
    mov [rel __g_parser_par_arena_end], rax
    mov rax, 0
    mov [rel __g_parser_par_pos], rax
    mov rax, 0
    mov [rel __g_parser_par_ast_root], rax
    mov rax, 1
    jmp .__ret_2781
.__ret_2781:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
prs_env:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov r14, rdx
    mov r13, r8
    mov r12, r9
    mov rbx, r10
    mov rax, r15
    mov [rel __g_parser_prs_arg_input], rax
    mov rax, r14
    mov [rel __g_parser_prs_src_buffer], rax
    mov rax, r13
    mov [rel __g_parser_prs_lmap_out], rax
    mov rax, r12
    mov [rel __g_parser_prs_lmap_file], rax
    mov rax, rbx
    mov [rel __g_parser_prs_lmap_count], rax
    mov rax, 0
    jmp .__ret_2784
.__ret_2784:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
prs_run:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov [rel __g_parser_par_pos], rax
    mov rax, [rel __g_parser_par_tokens]
    push rax
    mov rax, [rel __g_parser_par_token_count]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ng_run
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L2786
    mov rax, [rel __g_parser_ng_err_tok]
    cmp rax, 0
    je .L2788
    mov rax, [rel __g_parser_par_tokens]
    mov [rbp-40], rax
    mov rax, [rel __g_parser_ng_err_tok]
    mov [rbp-48], rax
    mov rdx, [rbp-48]
    mov rax, [rdx]
    mov rdx, [rbp-40]
    mov [rdx], rax
    mov rdx, [rbp-48]
    add rdx, 8
    mov rax, [rdx]
    mov rdx, [rbp-40]
    add rdx, 8
    mov [rdx], rax
    mov rdx, [rbp-48]
    add rdx, 16
    mov eax, dword [rdx]
    mov rdx, [rbp-40]
    add rdx, 16
    mov [rdx], eax
    mov rdx, [rbp-48]
    add rdx, 20
    movzx eax, word [rdx]
    mov rdx, [rbp-40]
    add rdx, 20
    mov [rdx], ax
    mov rdx, [rbp-48]
    add rdx, 22
    movzx eax, word [rdx]
    mov rdx, [rbp-40]
    add rdx, 22
    mov [rdx], ax
    jmp .L2789
.L2788:
.L2789:
    mov rax, [rel __g_parser_ng_err_msg]
    mov [rel __g_parser_par_custom_msg], rax
    mov rax, 0
    jmp .__ret_2785
    jmp .L2787
.L2786:
.L2787:
    mov rax, rbx
    mov [rel __g_parser_par_token_count], rax
    mov rax, [rel __g_parser_AST_PROGRAM]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L2790
    mov rax, 0
    jmp .__ret_2785
    jmp .L2791
.L2790:
.L2791:
    mov rax, [rbp-16]
    mov [rel __g_parser_par_ast_root], rax
    mov rax, [rel __g_parser_KW_KRON_PROGRAM]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2792
    mov rax, 0
    jmp .__ret_2785
    jmp .L2793
.L2792:
.L2793:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_KW_KRON_DOMAIN]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2794
    mov rax, 0
    jmp .__ret_2785
    jmp .L2795
.L2794:
.L2795:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2796
    mov rax, 0
    jmp .__ret_2785
    jmp .L2797
.L2796:
.L2797:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L2798:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_DOUBLE_COLON]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2799
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2801
    mov rax, 0
    jmp .__ret_2785
    jmp .L2802
.L2801:
.L2802:
    sub rsp, 32
    call prs_adv
    add rsp, 32
.L2800:
    jmp .L2798
.L2799:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_KW_EPOCH]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2803
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_TOK_INTEGER]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2805
    mov rax, 0
    jmp .__ret_2785
    jmp .L2806
.L2805:
.L2806:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L2804
.L2803:
.L2804:
    mov rax, [rel __g_parser_TOK_SEMICOLON]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2807
    mov rax, 0
    jmp .__ret_2785
    jmp .L2808
.L2807:
.L2808:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_KW_KRON_IMPORTS]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2809
    mov rax, 0
    jmp .__ret_2785
    jmp .L2810
.L2809:
.L2810:
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 1
    mov [rel __g_parser_par_hdr_phase], rax
.L2811:
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_EOF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2812
    mov rax, [rel __g_parser_par_hdr_phase]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2816
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_KW_KRON_DEFINITIONS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2816
    mov rax, 1
    jmp .L2817
.L2816:
    mov rax, 0
.L2817:
    test rax, rax
    jz .L2814
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, 0
    mov [rel __g_parser_par_hdr_phase], rax
    jmp .L2815
.L2814:
    sub rsp, 32
    call prs_top_level
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L2818
    mov rax, 0
    jmp .__ret_2785
    jmp .L2819
.L2818:
.L2819:
    mov rdx, [rbp-16]
    add rdx, 8
    mov rax, [rdx]
    cmp rax, 0
    jne .L2820
    mov rax, r12
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    jmp .L2821
.L2820:
    mov rax, [rel __g_parser_AST_PROGRAM]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L2822
    mov rax, 0
    jmp .__ret_2785
    jmp .L2823
.L2822:
.L2823:
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 16
    mov [rdx], rax
    mov rax, rbx
    mov [rbp-16], rax
    mov rax, r12
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
.L2821:
.L2815:
.L2813:
    jmp .L2811
.L2812:
    mov rax, [rel __g_parser_par_hdr_phase]
    cmp rax, 0
    je .L2824
    mov rax, 0
    jmp .__ret_2785
    jmp .L2825
.L2824:
.L2825:
    mov rax, 1
    jmp .__ret_2785
.__ret_2785:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
prs_top_level:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call prs_ct
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_FN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2827
    sub rsp, 32
    call prs_function
    add rsp, 32
    jmp .__ret_2826
    jmp .L2828
.L2827:
.L2828:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_VAR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2829
    sub rsp, 32
    call prs_statement
    add rsp, 32
    jmp .__ret_2826
    jmp .L2830
.L2829:
.L2830:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_CONST]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2831
    sub rsp, 32
    call prs_statement
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    je .L2833
    mov rdx, [rbp-16]
    add rdx, 38
    movzx eax, word [rdx]
    or rax, 4
    mov rdx, [rbp-16]
    add rdx, 38
    mov [rdx], ax
    jmp .L2834
.L2833:
.L2834:
    mov rax, [rbp-16]
    jmp .__ret_2826
    jmp .L2832
.L2831:
.L2832:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_SHARED]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2835
    sub rsp, 32
    call prs_adv
    add rsp, 32
    mov rax, [rel __g_parser_KW_VAR]
    push rax
    pop rcx
    sub rsp, 32
    call prs_want
    add rsp, 32
    cmp rax, 0
    jne .L2837
    mov rax, 0
    jmp .__ret_2826
    jmp .L2838
.L2837:
.L2838:
    sub rsp, 32
    call prs_statement
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    je .L2839
    mov rdx, [rbp-16]
    add rdx, 38
    movzx eax, word [rdx]
    or rax, 4
    mov rdx, [rbp-16]
    add rdx, 38
    mov [rdx], ax
    jmp .L2840
.L2839:
.L2840:
    mov rax, [rbp-16]
    jmp .__ret_2826
    jmp .L2836
.L2835:
.L2836:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_STRUCT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2841
    sub rsp, 32
    call prs_struct
    add rsp, 32
    jmp .__ret_2826
    jmp .L2842
.L2841:
.L2842:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_ENUM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2843
    sub rsp, 32
    call prs_enum
    add rsp, 32
    jmp .__ret_2826
    jmp .L2844
.L2843:
.L2844:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_KRON_ISA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2845
    sub rsp, 32
    call prs_isa
    add rsp, 32
    jmp .__ret_2826
    jmp .L2846
.L2845:
.L2846:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_BOOT_SEQUENCE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2847
    sub rsp, 32
    call prs_boot
    add rsp, 32
    jmp .__ret_2826
    jmp .L2848
.L2847:
.L2848:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_MMU_CONFIGURATION]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2849
    sub rsp, 32
    call prs_mmu
    add rsp, 32
    jmp .__ret_2826
    jmp .L2850
.L2849:
.L2850:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_INTERRUPT_SERVICE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2851
    sub rsp, 32
    call prs_isr
    add rsp, 32
    jmp .__ret_2826
    jmp .L2852
.L2851:
.L2852:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_DMA_CHANNEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2857
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_HARDWARE_DRIVER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2857
    mov rax, 0
    jmp .L2858
.L2857:
    mov rax, 1
.L2858:
    test rax, rax
    jnz .L2855
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_KERNEL_ARCHITECTURE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2855
    mov rax, 0
    jmp .L2856
.L2855:
    mov rax, 1
.L2856:
    test rax, rax
    jz .L2853
    sub rsp, 32
    call prs_config
    add rsp, 32
    jmp .__ret_2826
    jmp .L2854
.L2853:
.L2854:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_SECURITY_MODEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2863
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_FILESYSTEM_VOLUME]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2863
    mov rax, 0
    jmp .L2864
.L2863:
    mov rax, 1
.L2864:
    test rax, rax
    jnz .L2861
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_NETWORK_KERNEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2861
    mov rax, 0
    jmp .L2862
.L2861:
    mov rax, 1
.L2862:
    test rax, rax
    jz .L2859
    sub rsp, 32
    call prs_config
    add rsp, 32
    jmp .__ret_2826
    jmp .L2860
.L2859:
.L2860:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_POWER_MANAGER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2869
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_KRON_HYPERVISOR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2869
    mov rax, 0
    jmp .L2870
.L2869:
    mov rax, 1
.L2870:
    test rax, rax
    jnz .L2867
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_PACKAGE_MANAGER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2867
    mov rax, 0
    jmp .L2868
.L2867:
    mov rax, 1
.L2868:
    test rax, rax
    jz .L2865
    sub rsp, 32
    call prs_config
    add rsp, 32
    jmp .__ret_2826
    jmp .L2866
.L2865:
.L2866:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_EXECUTABLE_LOADER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2875
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_HUMAN_MACHINE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2875
    mov rax, 0
    jmp .L2876
.L2875:
    mov rax, 1
.L2876:
    test rax, rax
    jnz .L2873
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_KRON3D_CONTEXT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2873
    mov rax, 0
    jmp .L2874
.L2873:
    mov rax, 1
.L2874:
    test rax, rax
    jz .L2871
    sub rsp, 32
    call prs_config
    add rsp, 32
    jmp .__ret_2826
    jmp .L2872
.L2871:
.L2872:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_EXECUTION_MODEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2881
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_DEPLOYMENT_MODEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2881
    mov rax, 0
    jmp .L2882
.L2881:
    mov rax, 1
.L2882:
    test rax, rax
    jnz .L2879
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_SECURITY_RING]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2879
    mov rax, 0
    jmp .L2880
.L2879:
    mov rax, 1
.L2880:
    test rax, rax
    jz .L2877
    sub rsp, 32
    call prs_config
    add rsp, 32
    jmp .__ret_2826
    jmp .L2878
.L2877:
.L2878:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_SCHEDULER_DOMAIN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2883
    sub rsp, 32
    call prs_sched
    add rsp, 32
    jmp .__ret_2826
    jmp .L2884
.L2883:
.L2884:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_SYSCALL_DISPATCH]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2885
    sub rsp, 32
    call prs_sys
    add rsp, 32
    jmp .__ret_2826
    jmp .L2886
.L2885:
.L2886:
    mov rax, r13
    push rax
    mov rax, [rel __g_parser_KW_EXTERN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2887
    sub rsp, 32
    call prs_extern
    add rsp, 32
    jmp .__ret_2826
    jmp .L2888
.L2887:
.L2888:
    mov rax, r13
    mov rcx, 200
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L2891
    mov rax, r13
    mov rcx, 532
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L2891
    mov rax, 0
    jmp .L2892
.L2891:
    mov rax, 1
.L2892:
    test rax, rax
    jz .L2889
section .data
.str2893: db 97,32,100,101,99,108,97,114,97,116,105,111,110,32,103,111,101,115,32,104,101,114,101,32,45,45,32,102,110,44,32,118,97,114,44,32,99,111,110,115,116,44,32,115,104,97,114,101,100,32,118,97,114,44,32,115,116,114,117,99,116,44,32,101
    db 110,117,109,58,32,105,115,32,116,104,101,114,101,32,97,32,125,32,116,111,111,32,109,97,110,121,32,97,98,111,118,101,63,0
section .text
    lea rax, [rel .str2893]
    mov [rel __g_parser_par_custom_msg], rax
    mov rax, 0
    jmp .__ret_2826
    jmp .L2890
.L2889:
.L2890:
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    sub rsp, 32
    call prs_ct
    add rsp, 32
    push rax
    mov rax, [rel __g_parser_TOK_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2894
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call prs_adv
    add rsp, 32
    jmp .L2895
.L2894:
.L2895:
    sub rsp, 32
    call prs_generic_decl
    add rsp, 32
    cmp rax, 0
    jne .L2896
    mov rax, 0
    jmp .__ret_2826
    jmp .L2897
.L2896:
.L2897:
    mov rax, [rel __g_parser_AST_HARDWARE_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call prs_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L2898
    mov rax, 0
    jmp .__ret_2826
    jmp .L2899
.L2898:
.L2899:
    mov rax, r12
    mov rdx, [rbp-16]
    add rdx, 24
    mov [rdx], rax
    mov rax, rbx
    mov rdx, [rbp-16]
    add rdx, 8
    mov [rdx], rax
    mov rax, [rbp-16]
    jmp .__ret_2826
.__ret_2826:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
prs_ast_root:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_parser_par_ast_root]
    jmp .__ret_2900
.__ret_2900:
    mov rsp, rbp
    pop rbp
    ret
prs_error_token:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-8], rax
    mov rdx, [rbp-8]
    mov rax, [rdx]
    jmp .__ret_2901
.__ret_2901:
    mov rsp, rbp
    pop rbp
    ret
prs_position:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_parser_par_pos]
    jmp .__ret_2902
.__ret_2902:
    mov rsp, rbp
    pop rbp
    ret
prs_error_line:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-8], rax
    mov rdx, [rbp-8]
    add rdx, 20
    movzx eax, word [rdx]
    jmp .__ret_2903
.__ret_2903:
    mov rsp, rbp
    pop rbp
    ret
prs_error_col:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-8], rax
    mov rdx, [rbp-8]
    add rdx, 22
    movzx eax, word [rdx]
    jmp .__ret_2904
.__ret_2904:
    mov rsp, rbp
    pop rbp
    ret
prs_error_len:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    sub rsp, 32
    call prs_cur
    add rsp, 32
    mov [rbp-8], rax
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    jmp .__ret_2905
.__ret_2905:
    mov rsp, rbp
    pop rbp
    ret
prs_expected:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_parser_par_expected]
    jmp .__ret_2906
.__ret_2906:
    mov rsp, rbp
    pop rbp
    ret
prs_custom_msg:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_parser_par_custom_msg]
    jmp .__ret_2907
.__ret_2907:
    mov rsp, rbp
    pop rbp
    ret
prs_error_msg:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str2909: db 80,97,114,115,101,114,58,32,105,110,118,97,108,105,100,32,115,116,114,117,99,116,117,114,101,0
section .text
    lea rax, [rel .str2909]
    jmp .__ret_2908
.__ret_2908:
    mov rsp, rbp
    pop rbp
    ret
prs_token_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_parser_par_token_count]
    jmp .__ret_2910
.__ret_2910:
    mov rsp, rbp
    pop rbp
    ret
prs_ast_used:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_parser_par_arena_ptr]
    push rax
    mov rax, [rel __g_parser_par_ast_buf]
    mov rcx, rax
    pop rax
    sub rax, rcx
    jmp .__ret_2911
.__ret_2911:
    mov rsp, rbp
    pop rbp
    ret
prs_token_name:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r14, 0
    jne .L2913
section .data
.str2915: db 101,110,100,32,111,102,32,102,105,108,101,0
section .text
    lea rax, [rel .str2915]
    jmp .__ret_2912
    jmp .L2914
.L2913:
.L2914:
    cmp r14, 1
    jne .L2916
section .data
.str2918: db 97,110,32,105,100,101,110,116,105,102,105,101,114,0
section .text
    lea rax, [rel .str2918]
    jmp .__ret_2912
    jmp .L2917
.L2916:
.L2917:
    cmp r14, 2
    jne .L2919
section .data
.str2921: db 97,110,32,105,110,116,101,103,101,114,0
section .text
    lea rax, [rel .str2921]
    jmp .__ret_2912
    jmp .L2920
.L2919:
.L2920:
    cmp r14, 3
    jne .L2922
section .data
.str2924: db 97,32,100,101,99,105,109,97,108,32,110,117,109,98,101,114,0
section .text
    lea rax, [rel .str2924]
    jmp .__ret_2912
    jmp .L2923
.L2922:
.L2923:
    cmp r14, 4
    jne .L2925
section .data
.str2927: db 97,32,115,116,114,105,110,103,0
section .text
    lea rax, [rel .str2927]
    jmp .__ret_2912
    jmp .L2926
.L2925:
.L2926:
    cmp r14, 10
    jne .L2928
section .data
.str2930: db 39,123,39,0
section .text
    lea rax, [rel .str2930]
    jmp .__ret_2912
    jmp .L2929
.L2928:
.L2929:
    cmp r14, 11
    jne .L2931
section .data
.str2933: db 39,125,39,0
section .text
    lea rax, [rel .str2933]
    jmp .__ret_2912
    jmp .L2932
.L2931:
.L2932:
    cmp r14, 12
    jne .L2934
section .data
.str2936: db 39,40,39,0
section .text
    lea rax, [rel .str2936]
    jmp .__ret_2912
    jmp .L2935
.L2934:
.L2935:
    cmp r14, 13
    jne .L2937
section .data
.str2939: db 39,41,39,0
section .text
    lea rax, [rel .str2939]
    jmp .__ret_2912
    jmp .L2938
.L2937:
.L2938:
    cmp r14, 14
    jne .L2940
section .data
.str2942: db 39,91,39,0
section .text
    lea rax, [rel .str2942]
    jmp .__ret_2912
    jmp .L2941
.L2940:
.L2941:
    cmp r14, 15
    jne .L2943
section .data
.str2945: db 39,93,39,0
section .text
    lea rax, [rel .str2945]
    jmp .__ret_2912
    jmp .L2944
.L2943:
.L2944:
    cmp r14, 16
    jne .L2946
section .data
.str2948: db 39,59,39,0
section .text
    lea rax, [rel .str2948]
    jmp .__ret_2912
    jmp .L2947
.L2946:
.L2947:
    cmp r14, 17
    jne .L2949
section .data
.str2951: db 39,58,39,0
section .text
    lea rax, [rel .str2951]
    jmp .__ret_2912
    jmp .L2950
.L2949:
.L2950:
    cmp r14, 18
    jne .L2952
section .data
.str2954: db 39,44,39,0
section .text
    lea rax, [rel .str2954]
    jmp .__ret_2912
    jmp .L2953
.L2952:
.L2953:
    cmp r14, 20
    jne .L2955
section .data
.str2957: db 39,61,39,0
section .text
    lea rax, [rel .str2957]
    jmp .__ret_2912
    jmp .L2956
.L2955:
.L2956:
    cmp r14, 21
    jne .L2958
section .data
.str2960: db 39,45,62,39,0
section .text
    lea rax, [rel .str2960]
    jmp .__ret_2912
    jmp .L2959
.L2958:
.L2959:
    mov rax, r14
    push rax
    mov rax, [rel __g_parser_TOK_EXPECT_EXPR]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2961
section .data
.str2963: db 97,110,32,101,120,112,114,101,115,115,105,111,110,0
section .text
    lea rax, [rel .str2963]
    jmp .__ret_2912
    jmp .L2962
.L2961:
.L2962:
    cmp r14, 100
    jl .L2964
    mov rcx, r14
    sub rsp, 32
    call klx_keyword_name
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L2966
section .data
.str2968: db 97,32,107,101,121,119,111,114,100,0
section .text
    lea rax, [rel .str2968]
    jmp .__ret_2912
    jmp .L2967
.L2966:
.L2967:
    lea rax, [rel __g_parser_tn_kwbuf]
    push rax
    pop rcx
    mov rdx, 39
    sub rsp, 32
    call bset
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L2969:
    cmp r12, 60
    jge .L2970
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call bget
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L2972
    jmp .L2970
    jmp .L2973
.L2972:
.L2973:
    lea rax, [rel __g_parser_tn_kwbuf]
    add rax, 1
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call bset
    add rsp, 32
    add r12, 1
.L2971:
    jmp .L2969
.L2970:
    lea rax, [rel __g_parser_tn_kwbuf]
    add rax, 1
    add rax, r12
    push rax
    pop rcx
    mov rdx, 39
    sub rsp, 32
    call bset
    add rsp, 32
    lea rax, [rel __g_parser_tn_kwbuf]
    add rax, 2
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call bset
    add rsp, 32
    lea rax, [rel __g_parser_tn_kwbuf]
    jmp .__ret_2912
    jmp .L2965
.L2964:
.L2965:
    cmp r14, 30
    jl .L2974
section .data
.str2976: db 97,110,32,111,112,101,114,97,116,111,114,0
section .text
    lea rax, [rel .str2976]
    jmp .__ret_2912
    jmp .L2975
.L2974:
.L2975:
section .data
.str2977: db 97,32,116,111,107,101,110,0
section .text
    lea rax, [rel .str2977]
    jmp .__ret_2912
.__ret_2912:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
