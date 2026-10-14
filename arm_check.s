; ARM64 TEST: karm checks itself on a real ARM64 machine (or QEMU).
; The program compares what karm assembled against values it already knows:
; 80 constants that need one to four instructions (mov), w registers, an
; equ defined after its use (its size is unknown on pass one), local labels
; in two functions, dq of a label against adrl of the same label, .bss that
; starts at zero, times. It prints one line and exits with the number of
; checks that failed.
; Expected: "arm_check: every check ran" and exit code 0.
section .text
global _start
_start:
    mov x20, #0          // failures
    mov x0, #0
    adrl x1, table
    ldr x2, [x1, #0]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #1
    adrl x1, table
    ldr x2, [x1, #8]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-1
    adrl x1, table
    ldr x2, [x1, #16]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #65535
    adrl x1, table
    ldr x2, [x1, #24]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #65536
    adrl x1, table
    ldr x2, [x1, #32]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #305419896
    adrl x1, table
    ldr x2, [x1, #40]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-305419896
    adrl x1, table
    ldr x2, [x1, #48]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #1311768467463790320
    adrl x1, table
    ldr x2, [x1, #56]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-81985529216486896
    adrl x1, table
    ldr x2, [x1, #64]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-9223372036854775808
    adrl x1, table
    ldr x2, [x1, #72]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #9223372036854775807
    adrl x1, table
    ldr x2, [x1, #80]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-281470681808896
    adrl x1, table
    ldr x2, [x1, #88]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #281470681743360
    adrl x1, table
    ldr x2, [x1, #96]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-65536
    adrl x1, table
    ldr x2, [x1, #104]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #4294967295
    adrl x1, table
    ldr x2, [x1, #112]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #4294967296
    adrl x1, table
    ldr x2, [x1, #120]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-4294967296
    adrl x1, table
    ldr x2, [x1, #128]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #915533473134040693
    adrl x1, table
    ldr x2, [x1, #136]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #1680490732736907042
    adrl x1, table
    ldr x2, [x1, #144]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #5166499419593367711
    adrl x1, table
    ldr x2, [x1, #152]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #6742787359027594307
    adrl x1, table
    ldr x2, [x1, #160]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #6987862831916868175
    adrl x1, table
    ldr x2, [x1, #168]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #1418732859287952241
    adrl x1, table
    ldr x2, [x1, #176]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #8035156797252622602
    adrl x1, table
    ldr x2, [x1, #184]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-2480724440120465443
    adrl x1, table
    ldr x2, [x1, #192]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-6715189222637052449
    adrl x1, table
    ldr x2, [x1, #200]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #6552755443543573921
    adrl x1, table
    ldr x2, [x1, #208]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #1365478522915135877
    adrl x1, table
    ldr x2, [x1, #216]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #1569340318782520025
    adrl x1, table
    ldr x2, [x1, #224]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #3607544962680919340
    adrl x1, table
    ldr x2, [x1, #232]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #6652588277861219678
    adrl x1, table
    ldr x2, [x1, #240]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #1274808478445842095
    adrl x1, table
    ldr x2, [x1, #248]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #2868675141862995535
    adrl x1, table
    ldr x2, [x1, #256]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-4296525121124629446
    adrl x1, table
    ldr x2, [x1, #264]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-8052731068608219611
    adrl x1, table
    ldr x2, [x1, #272]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-7590501365206009213
    adrl x1, table
    ldr x2, [x1, #280]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-7994597261718597453
    adrl x1, table
    ldr x2, [x1, #288]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-6442241693635307493
    adrl x1, table
    ldr x2, [x1, #296]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #6876337892168982231
    adrl x1, table
    ldr x2, [x1, #304]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-8394370807752918241
    adrl x1, table
    ldr x2, [x1, #312]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #1593339394233448204
    adrl x1, table
    ldr x2, [x1, #320]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #9195866929865642559
    adrl x1, table
    ldr x2, [x1, #328]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-9089951569419007625
    adrl x1, table
    ldr x2, [x1, #336]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #8280660284981927784
    adrl x1, table
    ldr x2, [x1, #344]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-1698278541962015623
    adrl x1, table
    ldr x2, [x1, #352]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-4364993909050862886
    adrl x1, table
    ldr x2, [x1, #360]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-2954913345319812005
    adrl x1, table
    ldr x2, [x1, #368]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #8460773098616379373
    adrl x1, table
    ldr x2, [x1, #376]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #6672323138040855658
    adrl x1, table
    ldr x2, [x1, #384]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-4218758764216679835
    adrl x1, table
    ldr x2, [x1, #392]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #8050821411739381761
    adrl x1, table
    ldr x2, [x1, #400]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #8813804880804999652
    adrl x1, table
    ldr x2, [x1, #408]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-8853461474553905843
    adrl x1, table
    ldr x2, [x1, #416]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-3090736404278710958
    adrl x1, table
    ldr x2, [x1, #424]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #4390957578585610004
    adrl x1, table
    ldr x2, [x1, #432]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #1648713923554033681
    adrl x1, table
    ldr x2, [x1, #440]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #3247001713738020434
    adrl x1, table
    ldr x2, [x1, #448]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-9264748858431242240
    adrl x1, table
    ldr x2, [x1, #456]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-2748973056
    adrl x1, table
    ldr x2, [x1, #464]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-104281805946880
    adrl x1, table
    ldr x2, [x1, #472]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-148691767787520
    adrl x1, table
    ldr x2, [x1, #480]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-13745
    adrl x1, table
    ldr x2, [x1, #488]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #2662989824
    adrl x1, table
    ldr x2, [x1, #496]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-134372346822656
    adrl x1, table
    ldr x2, [x1, #504]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #57047
    adrl x1, table
    ldr x2, [x1, #512]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #181247619891200
    adrl x1, table
    ldr x2, [x1, #520]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #3766026240
    adrl x1, table
    ldr x2, [x1, #528]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #2892300288
    adrl x1, table
    ldr x2, [x1, #536]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-2324430848
    adrl x1, table
    ldr x2, [x1, #544]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #291241984
    adrl x1, table
    ldr x2, [x1, #552]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-103349798043648
    adrl x1, table
    ldr x2, [x1, #560]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-48150878355456
    adrl x1, table
    ldr x2, [x1, #568]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #237155209183232
    adrl x1, table
    ldr x2, [x1, #576]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-261610752966656
    adrl x1, table
    ldr x2, [x1, #584]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-10713782038537699328
    adrl x1, table
    ldr x2, [x1, #592]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #-1311110441518235648
    adrl x1, table
    ldr x2, [x1, #600]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #26158
    adrl x1, table
    ldr x2, [x1, #608]
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov w0, #0
    mov x2, #0
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov w0, #1
    mov x2, #1
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov w0, #4294967295
    mov x2, #4294967295
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov w0, #305419896
    mov x2, #305419896
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov w0, #2147483648
    mov x2, #2147483648
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov w0, #4294901760
    mov x2, #4294901760
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #LATE
    mov x2, #0x1122334455667788
    cmp x0, x2
    cset x3, ne
    add x20, x20, x3
    mov x0, #SMALL
    cmp x0, #5
    cset x3, ne
    add x20, x20, x3
    bl f1
    cmp x0, #11
    cset x3, ne
    add x20, x20, x3
    bl f2
    cmp x0, #22
    cset x3, ne
    add x20, x20, x3
    adrl x1, ptr
    ldr x1, [x1]
    adrl x2, msg
    cmp x1, x2
    cset x3, ne
    add x20, x20, x3
    adrl x1, buf
    ldr x2, [x1, #4088]
    cmp x2, #0
    cset x3, ne
    add x20, x20, x3
    mov x2, #77
    str x2, [x1, #4088]
    ldr x4, [x1, #4088]
    cmp x4, #77
    cset x3, ne
    add x20, x20, x3
    adrl x1, rep
    ldrb w2, [x1, #15]
    cmp w2, #0x41
    cset x3, ne
    add x20, x20, x3
    ldrb w2, [x1, #16]
    cmp w2, #0
    cset x3, ne
    add x20, x20, x3
    mov x0, #1
    adrl x1, msg
    mov x2, #MSGLEN
    mov x8, #64
    svc #0
    mov x0, x20
    mov x8, #93
    svc #0
f1:
    mov x0, #1
    b .done
.done:
    add x0, x0, #10
    ret
f2:
    mov x0, #2
    b .done
.done:
    add x0, x0, #20
    ret
SMALL equ 5
section .data
msg: db "arm_check: every check ran", 10
MSGLEN equ 27
align 8
ptr: dq msg
align 8
table:
    dq 0
    dq 1
    dq -1
    dq 65535
    dq 65536
    dq 305419896
    dq -305419896
    dq 1311768467463790320
    dq -81985529216486896
    dq -9223372036854775808
    dq 9223372036854775807
    dq -281470681808896
    dq 281470681743360
    dq -65536
    dq 4294967295
    dq 4294967296
    dq -4294967296
    dq 915533473134040693
    dq 1680490732736907042
    dq 5166499419593367711
    dq 6742787359027594307
    dq 6987862831916868175
    dq 1418732859287952241
    dq 8035156797252622602
    dq -2480724440120465443
    dq -6715189222637052449
    dq 6552755443543573921
    dq 1365478522915135877
    dq 1569340318782520025
    dq 3607544962680919340
    dq 6652588277861219678
    dq 1274808478445842095
    dq 2868675141862995535
    dq -4296525121124629446
    dq -8052731068608219611
    dq -7590501365206009213
    dq -7994597261718597453
    dq -6442241693635307493
    dq 6876337892168982231
    dq -8394370807752918241
    dq 1593339394233448204
    dq 9195866929865642559
    dq -9089951569419007625
    dq 8280660284981927784
    dq -1698278541962015623
    dq -4364993909050862886
    dq -2954913345319812005
    dq 8460773098616379373
    dq 6672323138040855658
    dq -4218758764216679835
    dq 8050821411739381761
    dq 8813804880804999652
    dq -8853461474553905843
    dq -3090736404278710958
    dq 4390957578585610004
    dq 1648713923554033681
    dq 3247001713738020434
    dq -9264748858431242240
    dq -2748973056
    dq -104281805946880
    dq -148691767787520
    dq -13745
    dq 2662989824
    dq -134372346822656
    dq 57047
    dq 181247619891200
    dq 3766026240
    dq 2892300288
    dq -2324430848
    dq 291241984
    dq -103349798043648
    dq -48150878355456
    dq 237155209183232
    dq -261610752966656
    dq -10713782038537699328
    dq -1311110441518235648
    dq 26158
rep: times 16 db 0x41
    db 0
LATE equ 0x1122334455667788
section .bss
buf: resb 8192
