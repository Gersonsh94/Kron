; ARM64 TEST: the encoding corpus. 1523 instructions covering every form
; karm encodes. ARMTESTS.bat assembles it with kronc and compares the code
; with tests\expected\arm_corpus.bin, made by the GNU ARM assembler and
; linker at the same address (0x400080): an outside check, as NASM is for
; kasm. No output: it is never run.
_start:
    add x15, x2, x16
lab0:
    add x15, x2, x16, lsl #3
    add x15, x2, x16, asr #63
    add x15, x2, #0
    add x15, x2, #4095
    add x15, x2, #4096
    add x15, x2, #0x7ff000
    add w19, w0, w0
    add w19, w0, #17
    add w19, w0, w0, lsr #31
    sub x15, x2, x16
    sub x15, x2, x16, lsl #3
    sub x15, x2, x16, asr #63
    sub x15, x2, #0
    sub x15, x2, #4095
    sub x15, x2, #4096
    sub x15, x2, #0x7ff000
    sub w30, w12, w0
    sub w30, w12, #17
    sub w30, w12, w0, lsr #31
    adds x15, x2, x16
    adds x15, x2, x16, lsl #3
    adds x15, x2, x16, asr #63
    adds x15, x2, #0
    adds x15, x2, #4095
    adds x15, x2, #4096
    adds x15, x2, #0x7ff000
    adds w3, w12, w0
    adds w3, w12, #17
    adds w3, w12, w0, lsr #31
    subs x15, x2, x16
    subs x15, x2, x16, lsl #3
    subs x15, x2, x16, asr #63
    subs x15, x2, #0
    subs x15, x2, #4095
    subs x15, x2, #4096
    subs x15, x2, #0x7ff000
    subs w12, w1, w0
    subs w12, w1, #17
    subs w12, w1, w0, lsr #31
    add sp, sp, #64
lab40:
    sub sp, sp, #4080
    add x15, sp, #16
    add sp, x15, #0
    add x15, sp, x2
    sub sp, sp, x2
    add x15, x2, #-8
    sub x15, x2, #-8
    cmp x15, x2
    cmp x15, #0
    cmp x15, #4095
    cmn x15, #1
    cmp w0, w7
    cmp sp, x15
    cmp x15, x2, lsl #2
    neg x15, x2
    neg w7, w0
    mul x15, x2, x16
    madd x15, x2, x16, x5
    msub x15, x2, x16, x1
    sdiv x15, x2, x16
    udiv x15, x2, x16
    mul w12, w7, w0
    sdiv w30, w12, w0
    and x15, x2, x16
    and x15, x2, x16, lsl #4
    and x15, x2, x16, ror #7
    and w1, w19, w19
    orr x15, x2, x16
    orr x15, x2, x16, lsl #4
    orr x15, x2, x16, ror #7
    orr w12, w0, w12
    eor x15, x2, x16
    eor x15, x2, x16, lsl #4
    eor x15, x2, x16, ror #7
    eor w12, w7, w0
    ands x15, x2, x16
    ands x15, x2, x16, lsl #4
    ands x15, x2, x16, ror #7
    ands w1, w0, w12
    bic x15, x2, x16
lab80:
    bic x15, x2, x16, lsl #4
    bic x15, x2, x16, ror #7
    bic w30, w1, w3
    orn x15, x2, x16
    orn x15, x2, x16, lsl #4
    orn x15, x2, x16, ror #7
    orn w7, w1, w12
    eon x15, x2, x16
    eon x15, x2, x16, lsl #4
    eon x15, x2, x16, ror #7
    eon w0, w12, w3
    and x15, x2, #0xff
    and x15, x2, #0xffff
    and x15, x2, #0x1
    and x15, x2, #0xfffffffffffffffe
    and x15, x2, #0x5555555555555555
    and x15, x2, #0x00ff00ff00ff00ff
    and x15, x2, #0xf0
    and x15, x2, #0x8000000000000000
    and x15, x2, #0x7fffffffffffffff
    and x15, x2, #0xffff0000ffff0000
    and w12, w30, #0xff
    and w19, w1, #0xfffffffe
    and w0, w12, #0x55555555
    and w12, w19, #0x80000000
    and w1, w3, #0x0f0f0f0f
    orr x15, x2, #0xff
    orr x15, x2, #0xffff
    orr x15, x2, #0x1
    orr x15, x2, #0xfffffffffffffffe
    orr x15, x2, #0x5555555555555555
    orr x15, x2, #0x00ff00ff00ff00ff
    orr x15, x2, #0xf0
    orr x15, x2, #0x8000000000000000
    orr x15, x2, #0x7fffffffffffffff
    orr x15, x2, #0xffff0000ffff0000
    orr w0, w12, #0xff
    orr w19, w0, #0xfffffffe
    orr w12, w0, #0x55555555
    orr w12, w1, #0x80000000
lab120:
    orr w7, w19, #0x0f0f0f0f
    eor x15, x2, #0xff
    eor x15, x2, #0xffff
    eor x15, x2, #0x1
    eor x15, x2, #0xfffffffffffffffe
    eor x15, x2, #0x5555555555555555
    eor x15, x2, #0x00ff00ff00ff00ff
    eor x15, x2, #0xf0
    eor x15, x2, #0x8000000000000000
    eor x15, x2, #0x7fffffffffffffff
    eor x15, x2, #0xffff0000ffff0000
    eor w12, w7, #0xff
    eor w30, w3, #0xfffffffe
    eor w7, w12, #0x55555555
    eor w7, w3, #0x80000000
    eor w3, w1, #0x0f0f0f0f
    ands x15, x2, #0xff
    ands x15, x2, #0xffff
    ands x15, x2, #0x1
    ands x15, x2, #0xfffffffffffffffe
    ands x15, x2, #0x5555555555555555
    ands x15, x2, #0x00ff00ff00ff00ff
    ands x15, x2, #0xf0
    ands x15, x2, #0x8000000000000000
    ands x15, x2, #0x7fffffffffffffff
    ands x15, x2, #0xffff0000ffff0000
    ands w30, w1, #0xff
    ands w19, w30, #0xfffffffe
    ands w1, w0, #0x55555555
    ands w12, w3, #0x80000000
    ands w12, w7, #0x0f0f0f0f
    tst x15, x2
    tst x15, #0xff
    tst w3, #1
    mvn x15, x2
    mvn w19, w7
    mvn x15, x2, lsl #3
    and sp, x1, #0xfff0
    lsl x15, x2, x16
    lsl x15, x2, #0
lab160:
    lsl x15, x2, #1
    lsl x15, x2, #63
    lsl w3, w12, #5
    lsl w0, w0, w12
    lsr x15, x2, x16
    lsr x15, x2, #0
    lsr x15, x2, #1
    lsr x15, x2, #63
    lsr w7, w1, #5
    lsr w30, w3, w1
    asr x15, x2, x16
    asr x15, x2, #0
    asr x15, x2, #1
    asr x15, x2, #63
    asr w7, w7, #5
    asr w0, w19, w0
    ror x15, x2, x16
    ror x15, x2, #0
    ror x15, x2, #1
    ror x15, x2, #63
    ror w30, w12, #5
    ror w12, w30, w30
    cset x15, eq
    csel x15, x2, x16, eq
    cset x15, ne
    csel x15, x2, x16, ne
    cset x15, cs
    csel x15, x2, x16, cs
    cset x15, hs
    csel x15, x2, x16, hs
    cset x15, cc
    csel x15, x2, x16, cc
    cset x15, lo
    csel x15, x2, x16, lo
    cset x15, mi
    csel x15, x2, x16, mi
    cset x15, pl
    csel x15, x2, x16, pl
    cset x15, vs
    csel x15, x2, x16, vs
lab200:
    cset x15, vc
    csel x15, x2, x16, vc
    cset x15, hi
    csel x15, x2, x16, hi
    cset x15, ls
    csel x15, x2, x16, ls
    cset x15, ge
    csel x15, x2, x16, ge
    cset x15, lt
    csel x15, x2, x16, lt
    cset x15, gt
    csel x15, x2, x16, gt
    cset x15, le
    csel x15, x2, x16, le
    cset w3, eq
    csinc x15, x2, x16, ne
    csneg x15, x2, x16, ge
    csel w3, w19, w3, lt
    sxtb x15, w12
    sxth x15, w7
    sxtw x15, w12
    uxtb w30, w7
    uxth w0, w30
    sxtb w0, w3
    mov x15, x2
    mov w7, w19
    mov sp, x15
    mov x15, sp
    mov x29, sp
    mov x15, #0
    mov x15, #65535
    mov x15, #-1
    mov x15, #0x10000
    mov x15, #-65536
    mov w19, #7
    mov w0, #-1
    movz x15, #0x1234, lsl #16
    movk x15, #0xbeef, lsl #48
    movn x15, #5
    movk w0, #1, lsl #16
lab240:
    movz x15, #77
    ldr x9, [x1]
    str x9, [x1]
    ldr x9, [x1, #8]
    str x9, [x1, #8]
    ldr x9, [x1, #32760]
    str x9, [x1, #32760]
    ldr x9, [x1, #-8]
    str x9, [x1, #-8]
    ldr x9, [x1, #255]
    str x9, [x1, #255]
    ldr x9, [x1, #-256]
    str x9, [x1, #-256]
    ldr x9, [x1, #12]
    str x9, [x1, #12]
    ldr x9, [x1, #8]!
    str x9, [x1, #8]!
    ldr x9, [x1, #-16]!
    str x9, [x1, #-16]!
    ldr x9, [sp, #16]
    str x9, [sp, #16]
    ldr x9, [sp]
    str x9, [sp]
    ldr x9, [x29, #-24]
    str x9, [x29, #-24]
    ldr x9, [x1, x2]
    str x9, [x1, x2]
    ldr x9, [x1, x2, lsl #3]
    str x9, [x1, x2, lsl #3]
    ldr x9, [x1, w2, sxtw]
    str x9, [x1, w2, sxtw]
    ldr x9, [x1, w2, uxtw #3]
    str x9, [x1, w2, uxtw #3]
    ldr x9, [x1, w2, sxtw #3]
    str x9, [x1, w2, sxtw #3]
    ldr x9, [x1], #8
    str x9, [sp], #-16
    ldur x9, [x29, #-8]
    stur x9, [x29, #-200]
    ldur x9, [x1, #16]
lab280:
    ldr x0, [x1]
    str x0, [x1]
    ldr x0, [x1, #8]
    str x0, [x1, #8]
    ldr x0, [x1, #32760]
    str x0, [x1, #32760]
    ldr x0, [x1, #-8]
    str x0, [x1, #-8]
    ldr x0, [x1, #255]
    str x0, [x1, #255]
    ldr x0, [x1, #-256]
    str x0, [x1, #-256]
    ldr x0, [x1, #12]
    str x0, [x1, #12]
    ldr x0, [x1, #8]!
    str x0, [x1, #8]!
    ldr x0, [x1, #-16]!
    str x0, [x1, #-16]!
    ldr x0, [sp, #16]
    str x0, [sp, #16]
    ldr x0, [sp]
    str x0, [sp]
    ldr x0, [x29, #-24]
    str x0, [x29, #-24]
    ldr x0, [x1, x2]
    str x0, [x1, x2]
    ldr x0, [x1, x2, lsl #3]
    str x0, [x1, x2, lsl #3]
    ldr x0, [x1, w2, sxtw]
    str x0, [x1, w2, sxtw]
    ldr x0, [x1, w2, uxtw #3]
    str x0, [x1, w2, uxtw #3]
    ldr x0, [x1, w2, sxtw #3]
    str x0, [x1, w2, sxtw #3]
    ldr x0, [x1], #8
    str x0, [sp], #-16
    ldur x0, [x29, #-8]
    stur x0, [x29, #-200]
    ldur x0, [x1, #16]
    ldr x30, [x1]
lab320:
    str x30, [x1]
    ldr x30, [x1, #8]
    str x30, [x1, #8]
    ldr x30, [x1, #32760]
    str x30, [x1, #32760]
    ldr x30, [x1, #-8]
    str x30, [x1, #-8]
    ldr x30, [x1, #255]
    str x30, [x1, #255]
    ldr x30, [x1, #-256]
    str x30, [x1, #-256]
    ldr x30, [x1, #12]
    str x30, [x1, #12]
    ldr x30, [x1, #8]!
    str x30, [x1, #8]!
    ldr x30, [x1, #-16]!
    str x30, [x1, #-16]!
    ldr x30, [sp, #16]
    str x30, [sp, #16]
    ldr x30, [sp]
    str x30, [sp]
    ldr x30, [x29, #-24]
    str x30, [x29, #-24]
    ldr x30, [x1, x2]
    str x30, [x1, x2]
    ldr x30, [x1, x2, lsl #3]
    str x30, [x1, x2, lsl #3]
    ldr x30, [x1, w2, sxtw]
    str x30, [x1, w2, sxtw]
    ldr x30, [x1, w2, uxtw #3]
    str x30, [x1, w2, uxtw #3]
    ldr x30, [x1, w2, sxtw #3]
    str x30, [x1, w2, sxtw #3]
    ldr x30, [x1], #8
    str x30, [sp], #-16
    ldur x30, [x29, #-8]
    stur x30, [x29, #-200]
    ldur x30, [x1, #16]
    ldr w19, [x1]
    str w12, [x1]
lab360:
    ldrsw x30, [x1]
    ldr w30, [x1, #4]
    str w7, [x1, #4]
    ldrsw x9, [x1, #4]
    ldr w19, [x1, #16380]
    str w7, [x1, #16380]
    ldrsw x30, [x1, #16380]
    ldr w3, [x1, #-4]
    str w0, [x1, #-4]
    ldrsw x17, [x1, #-4]
    ldr w3, [x1, x2, lsl #2]
    str w1, [x1, x2, lsl #2]
    ldrsw x29, [x1, x2, lsl #2]
    ldrb w0, [x1]
    strb w7, [x1]
    ldrsb x0, [x1]
    ldrsb w1, [x1]
    ldrb w30, [x1, #1]
    strb w3, [x1, #1]
    ldrsb x2, [x1, #1]
    ldrsb w19, [x1, #1]
    ldrb w1, [x1, #4095]
    strb w7, [x1, #4095]
    ldrsb x16, [x1, #4095]
    ldrsb w30, [x1, #4095]
    ldrb w7, [x1, #-1]
    strb w0, [x1, #-1]
    ldrsb x2, [x1, #-1]
    ldrsb w7, [x1, #-1]
    ldrb w7, [x1, x2]
    strb w12, [x1, x2]
    ldrsb x9, [x1, x2]
    ldrsb w1, [x1, x2]
    ldrh w30, [x1]
    strh w7, [x1]
    ldrsh x28, [x1]
    ldrh w3, [x1, #2]
    strh w19, [x1, #2]
    ldrsh x16, [x1, #2]
    ldrh w3, [x1, #8190]
lab400:
    strh w19, [x1, #8190]
    ldrsh x16, [x1, #8190]
    ldrh w1, [x1, #-2]
    strh w1, [x1, #-2]
    ldrsh x1, [x1, #-2]
    ldrh w1, [x1, x2, lsl #1]
    strh w1, [x1, x2, lsl #1]
    ldrsh x5, [x1, x2, lsl #1]
    ldr d31, [x1]
    str d1, [x1]
    ldr d0, [x1, #8]
    str d8, [x1, #8]
    ldr d15, [sp, #-16]
    str d1, [sp, #-16]
    ldr d2, [x29, #-8]
    str d2, [x29, #-8]
    ldr d0, [x1, x2, lsl #3]
    str d1, [x1, x2, lsl #3]
    ldr s9, [x1, #4]
    str s31, [x1]
    stp x29, x30, [sp, #-16]!
    ldp x29, x30, [sp], #16
    stp x19, x20, [sp, #16]
    ldp x19, x20, [sp, #504]
    stp x0, x1, [x2, #-512]
    stp w0, w1, [sp, #8]
    ldp w2, w3, [x1], #-8
    stp d8, d9, [sp, #-16]!
    ldp d8, d9, [sp], #16
    ldp x0, x1, [x2]
    ldxr x0, [x1]
    stxr w2, x0, [x1]
    ldaxr x3, [x4]
    stlxr w5, x3, [x4]
    ldxr w0, [x1]
    stlxr w2, w0, [sp]
    br x16
    blr x9
    ret
    ret x5
lab440:
    svc #0
    svc #0x80
    nop
    dmb ish
    fmov d2, d15
    fmov d15, x15
    fmov x2, d31
    fmov s31, s31
    fmov s0, w7
    fmov w30, s31
    fadd d8, d8, d8
    fadd s9, s0, s9
    fsub d31, d8, d0
    fsub s1, s0, s1
    fmul d8, d1, d0
    fmul s4, s31, s0
    fdiv d0, d0, d15
    fdiv s1, s31, s0
    fsqrt d2, d15
    fsqrt s0, s0
    fneg d1, d15
    fneg s9, s1
    fabs d31, d2
    fabs s4, s31
    fcmp d2, d8
    fcmp d0, #0.0
    fcmp s0, s9
    scvtf d8, x17
    scvtf d8, w3
    scvtf s0, x2
    ucvtf d0, x15
    fcvtzs x9, d8
    fcvtzs w30, d31
    fcvtzu x2, s31
    fcvt d0, s1
    fcvt s31, d2
    add x2, x28, x0
    add x2, x28, x0, lsl #3
    add x2, x28, x0, asr #63
    add x2, x28, #0
lab480:
    add x2, x28, #4095
    add x2, x28, #4096
    add x2, x28, #0x7ff000
    add w30, w12, w3
    add w30, w12, #17
    add w30, w12, w3, lsr #31
    sub x2, x28, x0
    sub x2, x28, x0, lsl #3
    sub x2, x28, x0, asr #63
    sub x2, x28, #0
    sub x2, x28, #4095
    sub x2, x28, #4096
    sub x2, x28, #0x7ff000
    sub w19, w30, w0
    sub w19, w30, #17
    sub w19, w30, w0, lsr #31
    adds x2, x28, x0
    adds x2, x28, x0, lsl #3
    adds x2, x28, x0, asr #63
    adds x2, x28, #0
    adds x2, x28, #4095
    adds x2, x28, #4096
    adds x2, x28, #0x7ff000
    adds w19, w30, w3
    adds w19, w30, #17
    adds w19, w30, w3, lsr #31
    subs x2, x28, x0
    subs x2, x28, x0, lsl #3
    subs x2, x28, x0, asr #63
    subs x2, x28, #0
    subs x2, x28, #4095
    subs x2, x28, #4096
    subs x2, x28, #0x7ff000
    subs w12, w3, w1
    subs w12, w3, #17
    subs w12, w3, w1, lsr #31
    add sp, sp, #64
    sub sp, sp, #4080
    add x2, sp, #16
    add sp, x2, #0
lab520:
    add x2, sp, x28
    sub sp, sp, x28
    add x2, x28, #-8
    sub x2, x28, #-8
    cmp x2, x28
    cmp x2, #0
    cmp x2, #4095
    cmn x2, #1
    cmp w3, w30
    cmp sp, x2
    cmp x2, x28, lsl #2
    neg x2, x28
    neg w1, w12
    mul x2, x28, x0
    madd x2, x28, x0, x28
    msub x2, x28, x0, x28
    sdiv x2, x28, x0
    udiv x2, x28, x0
    mul w3, w19, w1
    sdiv w12, w30, w30
    and x2, x28, x0
    and x2, x28, x0, lsl #4
    and x2, x28, x0, ror #7
    and w30, w30, w1
    orr x2, x28, x0
    orr x2, x28, x0, lsl #4
    orr x2, x28, x0, ror #7
    orr w30, w1, w30
    eor x2, x28, x0
    eor x2, x28, x0, lsl #4
    eor x2, x28, x0, ror #7
    eor w7, w19, w30
    ands x2, x28, x0
    ands x2, x28, x0, lsl #4
    ands x2, x28, x0, ror #7
    ands w1, w1, w12
    bic x2, x28, x0
    bic x2, x28, x0, lsl #4
    bic x2, x28, x0, ror #7
    bic w7, w3, w19
lab560:
    orn x2, x28, x0
    orn x2, x28, x0, lsl #4
    orn x2, x28, x0, ror #7
    orn w0, w0, w30
    eon x2, x28, x0
    eon x2, x28, x0, lsl #4
    eon x2, x28, x0, ror #7
    eon w3, w7, w3
    and x2, x28, #0xff
    and x2, x28, #0xffff
    and x2, x28, #0x1
    and x2, x28, #0xfffffffffffffffe
    and x2, x28, #0x5555555555555555
    and x2, x28, #0x00ff00ff00ff00ff
    and x2, x28, #0xf0
    and x2, x28, #0x8000000000000000
    and x2, x28, #0x7fffffffffffffff
    and x2, x28, #0xffff0000ffff0000
    and w1, w19, #0xff
    and w12, w3, #0xfffffffe
    and w7, w30, #0x55555555
    and w19, w3, #0x80000000
    and w3, w0, #0x0f0f0f0f
    orr x2, x28, #0xff
    orr x2, x28, #0xffff
    orr x2, x28, #0x1
    orr x2, x28, #0xfffffffffffffffe
    orr x2, x28, #0x5555555555555555
    orr x2, x28, #0x00ff00ff00ff00ff
    orr x2, x28, #0xf0
    orr x2, x28, #0x8000000000000000
    orr x2, x28, #0x7fffffffffffffff
    orr x2, x28, #0xffff0000ffff0000
    orr w1, w0, #0xff
    orr w1, w7, #0xfffffffe
    orr w1, w3, #0x55555555
    orr w1, w7, #0x80000000
    orr w12, w12, #0x0f0f0f0f
    eor x2, x28, #0xff
    eor x2, x28, #0xffff
lab600:
    eor x2, x28, #0x1
    eor x2, x28, #0xfffffffffffffffe
    eor x2, x28, #0x5555555555555555
    eor x2, x28, #0x00ff00ff00ff00ff
    eor x2, x28, #0xf0
    eor x2, x28, #0x8000000000000000
    eor x2, x28, #0x7fffffffffffffff
    eor x2, x28, #0xffff0000ffff0000
    eor w30, w0, #0xff
    eor w7, w19, #0xfffffffe
    eor w3, w30, #0x55555555
    eor w19, w0, #0x80000000
    eor w30, w19, #0x0f0f0f0f
    ands x2, x28, #0xff
    ands x2, x28, #0xffff
    ands x2, x28, #0x1
    ands x2, x28, #0xfffffffffffffffe
    ands x2, x28, #0x5555555555555555
    ands x2, x28, #0x00ff00ff00ff00ff
    ands x2, x28, #0xf0
    ands x2, x28, #0x8000000000000000
    ands x2, x28, #0x7fffffffffffffff
    ands x2, x28, #0xffff0000ffff0000
    ands w0, w7, #0xff
    ands w30, w19, #0xfffffffe
    ands w30, w1, #0x55555555
    ands w7, w1, #0x80000000
    ands w7, w30, #0x0f0f0f0f
    tst x2, x28
    tst x2, #0xff
    tst w19, #1
    mvn x2, x28
    mvn w3, w0
    mvn x2, x28, lsl #3
    and sp, x1, #0xfff0
    lsl x2, x28, x0
    lsl x2, x28, #0
    lsl x2, x28, #1
    lsl x2, x28, #63
    lsl w30, w19, #5
lab640:
    lsl w7, w7, w7
    lsr x2, x28, x0
    lsr x2, x28, #0
    lsr x2, x28, #1
    lsr x2, x28, #63
    lsr w19, w0, #5
    lsr w19, w1, w1
    asr x2, x28, x0
    asr x2, x28, #0
    asr x2, x28, #1
    asr x2, x28, #63
    asr w1, w0, #5
    asr w1, w12, w7
    ror x2, x28, x0
    ror x2, x28, #0
    ror x2, x28, #1
    ror x2, x28, #63
    ror w30, w19, #5
    ror w1, w12, w30
    cset x2, eq
    csel x2, x28, x0, eq
    cset x2, ne
    csel x2, x28, x0, ne
    cset x2, cs
    csel x2, x28, x0, cs
    cset x2, hs
    csel x2, x28, x0, hs
    cset x2, cc
    csel x2, x28, x0, cc
    cset x2, lo
    csel x2, x28, x0, lo
    cset x2, mi
    csel x2, x28, x0, mi
    cset x2, pl
    csel x2, x28, x0, pl
    cset x2, vs
    csel x2, x28, x0, vs
    cset x2, vc
    csel x2, x28, x0, vc
    cset x2, hi
lab680:
    csel x2, x28, x0, hi
    cset x2, ls
    csel x2, x28, x0, ls
    cset x2, ge
    csel x2, x28, x0, ge
    cset x2, lt
    csel x2, x28, x0, lt
    cset x2, gt
    csel x2, x28, x0, gt
    cset x2, le
    csel x2, x28, x0, le
    cset w12, eq
    csinc x2, x28, x0, ne
    csneg x2, x28, x0, ge
    csel w7, w19, w3, lt
    sxtb x2, w1
    sxth x2, w12
    sxtw x2, w12
    uxtb w1, w0
    uxth w0, w30
    sxtb w19, w19
    mov x2, x28
    mov w0, w12
    mov sp, x2
    mov x2, sp
    mov x29, sp
    mov x2, #0
    mov x2, #65535
    mov x2, #-1
    mov x2, #0x10000
    mov x2, #-65536
    mov w19, #7
    mov w1, #-1
    movz x2, #0x1234, lsl #16
    b lab0
    bl lab0
    b.eq lab0
    b.ne lab0
    b.lt lab0
    b.hs lab0
    cbz x3, lab0
    cbnz w4, lab0
    adr x5, lab0
    adrp x6, lab0
    ldr x7, lab0
    ldr w8, lab0
    ldr d9, lab0
    b lab40
    bl lab40
    b.eq lab40
    b.ne lab40
    b.lt lab40
    b.hs lab40
    cbz x3, lab40
    cbnz w4, lab40
    adr x5, lab40
    adrp x6, lab40
    ldr x7, lab40
    ldr w8, lab40
    ldr d9, lab40
    b lab80
    bl lab80
    b.eq lab80
    b.ne lab80
    b.lt lab80
    b.hs lab80
    cbz x3, lab80
    cbnz w4, lab80
    adr x5, lab80
    adrp x6, lab80
    ldr x7, lab80
    ldr w8, lab80
    ldr d9, lab80
    b lab120
    bl lab120
    b.eq lab120
    b.ne lab120
    b.lt lab120
    b.hs lab120
    cbz x3, lab120
    cbnz w4, lab120
    adr x5, lab120
    adrp x6, lab120
    ldr x7, lab120
    ldr w8, lab120
    ldr d9, lab120
    b lab160
    bl lab160
    b.eq lab160
    b.ne lab160
    b.lt lab160
    b.hs lab160
    cbz x3, lab160
    cbnz w4, lab160
    adr x5, lab160
    adrp x6, lab160
    ldr x7, lab160
    ldr w8, lab160
    ldr d9, lab160
    b lab200
    bl lab200
    b.eq lab200
    b.ne lab200
    b.lt lab200
    b.hs lab200
    cbz x3, lab200
    cbnz w4, lab200
    adr x5, lab200
    adrp x6, lab200
    ldr x7, lab200
    ldr w8, lab200
    ldr d9, lab200
    b fwd_end
    bl fwd_end
    b.eq fwd_end
    b.ne fwd_end
    b.lt fwd_end
    b.hs fwd_end
    cbz x3, fwd_end
    cbnz w4, fwd_end
    adr x5, fwd_end
    adrp x6, fwd_end
    ldr x7, fwd_end
    ldr w8, fwd_end
    ldr d9, fwd_end
    movk x2, #0xbeef, lsl #48
    movn x2, #5
    movk w7, #1, lsl #16
    movz x2, #77
    ldr x5, [x1]
    str x5, [x1]
lab720:
    ldr x5, [x1, #8]
    str x5, [x1, #8]
    ldr x5, [x1, #32760]
    str x5, [x1, #32760]
    ldr x5, [x1, #-8]
    str x5, [x1, #-8]
    ldr x5, [x1, #255]
    str x5, [x1, #255]
    ldr x5, [x1, #-256]
    str x5, [x1, #-256]
    ldr x5, [x1, #12]
    str x5, [x1, #12]
    ldr x5, [x1, #8]!
    str x5, [x1, #8]!
    ldr x5, [x1, #-16]!
    str x5, [x1, #-16]!
    ldr x5, [sp, #16]
    str x5, [sp, #16]
    ldr x5, [sp]
    str x5, [sp]
    ldr x5, [x29, #-24]
    str x5, [x29, #-24]
    ldr x5, [x1, x2]
    str x5, [x1, x2]
    ldr x5, [x1, x2, lsl #3]
    str x5, [x1, x2, lsl #3]
    ldr x5, [x1, w2, sxtw]
    str x5, [x1, w2, sxtw]
    ldr x5, [x1, w2, uxtw #3]
    str x5, [x1, w2, uxtw #3]
    ldr x5, [x1, w2, sxtw #3]
    str x5, [x1, w2, sxtw #3]
    ldr x5, [x1], #8
    str x5, [sp], #-16
    ldur x5, [x29, #-8]
    stur x5, [x29, #-200]
    ldur x5, [x1, #16]
    ldr x0, [x1]
    str x0, [x1]
    ldr x0, [x1, #8]
lab760:
    str x0, [x1, #8]
    ldr x0, [x1, #32760]
    str x0, [x1, #32760]
    ldr x0, [x1, #-8]
    str x0, [x1, #-8]
    ldr x0, [x1, #255]
    str x0, [x1, #255]
    ldr x0, [x1, #-256]
    str x0, [x1, #-256]
    ldr x0, [x1, #12]
    str x0, [x1, #12]
    ldr x0, [x1, #8]!
    str x0, [x1, #8]!
    ldr x0, [x1, #-16]!
    str x0, [x1, #-16]!
    ldr x0, [sp, #16]
    str x0, [sp, #16]
    ldr x0, [sp]
    str x0, [sp]
    ldr x0, [x29, #-24]
    str x0, [x29, #-24]
    ldr x0, [x1, x2]
    str x0, [x1, x2]
    ldr x0, [x1, x2, lsl #3]
    str x0, [x1, x2, lsl #3]
    ldr x0, [x1, w2, sxtw]
    str x0, [x1, w2, sxtw]
    ldr x0, [x1, w2, uxtw #3]
    str x0, [x1, w2, uxtw #3]
    ldr x0, [x1, w2, sxtw #3]
    str x0, [x1, w2, sxtw #3]
    ldr x0, [x1], #8
    str x0, [sp], #-16
    ldur x0, [x29, #-8]
    stur x0, [x29, #-200]
    ldur x0, [x1, #16]
    ldr x30, [x1]
    str x30, [x1]
    ldr x30, [x1, #8]
    str x30, [x1, #8]
lab800:
    ldr x30, [x1, #32760]
    str x30, [x1, #32760]
    ldr x30, [x1, #-8]
    str x30, [x1, #-8]
    ldr x30, [x1, #255]
    str x30, [x1, #255]
    ldr x30, [x1, #-256]
    str x30, [x1, #-256]
    ldr x30, [x1, #12]
    str x30, [x1, #12]
    ldr x30, [x1, #8]!
    str x30, [x1, #8]!
    ldr x30, [x1, #-16]!
    str x30, [x1, #-16]!
    ldr x30, [sp, #16]
    str x30, [sp, #16]
    ldr x30, [sp]
    str x30, [sp]
    ldr x30, [x29, #-24]
    str x30, [x29, #-24]
    ldr x30, [x1, x2]
    str x30, [x1, x2]
    ldr x30, [x1, x2, lsl #3]
    str x30, [x1, x2, lsl #3]
    ldr x30, [x1, w2, sxtw]
    str x30, [x1, w2, sxtw]
    ldr x30, [x1, w2, uxtw #3]
    str x30, [x1, w2, uxtw #3]
    ldr x30, [x1, w2, sxtw #3]
    str x30, [x1, w2, sxtw #3]
    ldr x30, [x1], #8
    str x30, [sp], #-16
    ldur x30, [x29, #-8]
    stur x30, [x29, #-200]
    ldur x30, [x1, #16]
    ldr w30, [x1]
    str w30, [x1]
    ldrsw x5, [x1]
    ldr w0, [x1, #4]
    str w3, [x1, #4]
lab840:
    ldrsw x5, [x1, #4]
    ldr w3, [x1, #16380]
    str w12, [x1, #16380]
    ldrsw x5, [x1, #16380]
    ldr w30, [x1, #-4]
    str w12, [x1, #-4]
    ldrsw x15, [x1, #-4]
    ldr w3, [x1, x2, lsl #2]
    str w12, [x1, x2, lsl #2]
    ldrsw x16, [x1, x2, lsl #2]
    ldrb w30, [x1]
    strb w1, [x1]
    ldrsb x0, [x1]
    ldrsb w19, [x1]
    ldrb w3, [x1, #1]
    strb w7, [x1, #1]
    ldrsb x30, [x1, #1]
    ldrsb w12, [x1, #1]
    ldrb w30, [x1, #4095]
    strb w12, [x1, #4095]
    ldrsb x16, [x1, #4095]
    ldrsb w30, [x1, #4095]
    ldrb w12, [x1, #-1]
    strb w1, [x1, #-1]
    ldrsb x28, [x1, #-1]
    ldrsb w1, [x1, #-1]
    ldrb w12, [x1, x2]
    strb w12, [x1, x2]
    ldrsb x0, [x1, x2]
    ldrsb w30, [x1, x2]
    ldrh w7, [x1]
    strh w30, [x1]
    ldrsh x2, [x1]
    ldrh w12, [x1, #2]
    strh w0, [x1, #2]
    ldrsh x2, [x1, #2]
    ldrh w1, [x1, #8190]
    strh w1, [x1, #8190]
    ldrsh x17, [x1, #8190]
    ldrh w12, [x1, #-2]
lab880:
    strh w19, [x1, #-2]
    ldrsh x1, [x1, #-2]
    ldrh w12, [x1, x2, lsl #1]
    strh w0, [x1, x2, lsl #1]
    ldrsh x15, [x1, x2, lsl #1]
    ldr d31, [x1]
    str d15, [x1]
    ldr d15, [x1, #8]
    str d15, [x1, #8]
    ldr d8, [sp, #-16]
    str d0, [sp, #-16]
    ldr d15, [x29, #-8]
    str d0, [x29, #-8]
    ldr d1, [x1, x2, lsl #3]
    str d1, [x1, x2, lsl #3]
    ldr s4, [x1, #4]
    str s0, [x1]
    stp x29, x30, [sp, #-16]!
    ldp x29, x30, [sp], #16
    stp x19, x20, [sp, #16]
    ldp x19, x20, [sp, #504]
    stp x0, x1, [x2, #-512]
    stp w0, w1, [sp, #8]
    ldp w2, w3, [x1], #-8
    stp d8, d9, [sp, #-16]!
    ldp d8, d9, [sp], #16
    ldp x0, x1, [x2]
    ldxr x0, [x1]
    stxr w2, x0, [x1]
    ldaxr x3, [x4]
    stlxr w5, x3, [x4]
    ldxr w0, [x1]
    stlxr w2, w0, [sp]
    br x16
    blr x9
    ret
    ret x5
    svc #0
    svc #0x80
    nop
lab920:
    dmb ish
    fmov d0, d15
    fmov d8, x28
    fmov x0, d0
    fmov s9, s4
    fmov s31, w12
    fmov w12, s31
    fadd d1, d31, d2
    fadd s9, s31, s31
    fsub d8, d15, d1
    fsub s31, s4, s31
    fmul d1, d8, d1
    fmul s9, s0, s9
    fdiv d8, d2, d0
    fdiv s1, s9, s0
    fsqrt d1, d31
    fsqrt s4, s0
    fneg d1, d31
    fneg s4, s1
    fabs d2, d1
    fabs s9, s1
    fcmp d31, d0
    fcmp d8, #0.0
    fcmp s9, s1
    scvtf d31, x5
    scvtf d1, w19
    scvtf s9, x28
    ucvtf d8, x15
    fcvtzs x16, d1
    fcvtzs w3, d2
    fcvtzu x1, s4
    fcvt d0, s4
    fcvt s31, d8
    add x17, x0, x16
    add x17, x0, x16, lsl #3
    add x17, x0, x16, asr #63
    add x17, x0, #0
    add x17, x0, #4095
    add x17, x0, #4096
    add x17, x0, #0x7ff000
lab960:
    add w3, w12, w12
    add w3, w12, #17
    add w3, w12, w12, lsr #31
    sub x17, x0, x16
    sub x17, x0, x16, lsl #3
    sub x17, x0, x16, asr #63
    sub x17, x0, #0
    sub x17, x0, #4095
    sub x17, x0, #4096
    sub x17, x0, #0x7ff000
    sub w3, w12, w0
    sub w3, w12, #17
    sub w3, w12, w0, lsr #31
    adds x17, x0, x16
    adds x17, x0, x16, lsl #3
    adds x17, x0, x16, asr #63
    adds x17, x0, #0
    adds x17, x0, #4095
    adds x17, x0, #4096
    adds x17, x0, #0x7ff000
    adds w0, w30, w1
    adds w0, w30, #17
    adds w0, w30, w1, lsr #31
    subs x17, x0, x16
    subs x17, x0, x16, lsl #3
    subs x17, x0, x16, asr #63
    subs x17, x0, #0
    subs x17, x0, #4095
    subs x17, x0, #4096
    subs x17, x0, #0x7ff000
    subs w0, w0, w3
    subs w0, w0, #17
    subs w0, w0, w3, lsr #31
    add sp, sp, #64
    sub sp, sp, #4080
    add x17, sp, #16
    add sp, x17, #0
    add x17, sp, x0
    sub sp, sp, x0
    add x17, x0, #-8
lab1000:
    sub x17, x0, #-8
    cmp x17, x0
    cmp x17, #0
    cmp x17, #4095
    cmn x17, #1
    cmp w3, w0
    cmp sp, x17
    cmp x17, x0, lsl #2
    neg x17, x0
    neg w30, w1
    mul x17, x0, x16
    madd x17, x0, x16, x9
    msub x17, x0, x16, x2
    sdiv x17, x0, x16
    udiv x17, x0, x16
    mul w30, w7, w30
    sdiv w19, w30, w3
    and x17, x0, x16
    and x17, x0, x16, lsl #4
    and x17, x0, x16, ror #7
    and w7, w1, w12
    orr x17, x0, x16
    orr x17, x0, x16, lsl #4
    orr x17, x0, x16, ror #7
    orr w12, w12, w7
    eor x17, x0, x16
    eor x17, x0, x16, lsl #4
    eor x17, x0, x16, ror #7
    eor w19, w3, w0
    ands x17, x0, x16
    ands x17, x0, x16, lsl #4
    ands x17, x0, x16, ror #7
    ands w3, w0, w30
    bic x17, x0, x16
    bic x17, x0, x16, lsl #4
    bic x17, x0, x16, ror #7
    bic w19, w1, w7
    orn x17, x0, x16
    orn x17, x0, x16, lsl #4
    orn x17, x0, x16, ror #7
lab1040:
    orn w0, w3, w0
    eon x17, x0, x16
    eon x17, x0, x16, lsl #4
    eon x17, x0, x16, ror #7
    eon w19, w0, w30
    and x17, x0, #0xff
    and x17, x0, #0xffff
    and x17, x0, #0x1
    and x17, x0, #0xfffffffffffffffe
    and x17, x0, #0x5555555555555555
    and x17, x0, #0x00ff00ff00ff00ff
    and x17, x0, #0xf0
    and x17, x0, #0x8000000000000000
    and x17, x0, #0x7fffffffffffffff
    and x17, x0, #0xffff0000ffff0000
    and w3, w0, #0xff
    and w12, w30, #0xfffffffe
    and w1, w0, #0x55555555
    and w3, w30, #0x80000000
    and w0, w7, #0x0f0f0f0f
    orr x17, x0, #0xff
    orr x17, x0, #0xffff
    orr x17, x0, #0x1
    orr x17, x0, #0xfffffffffffffffe
    orr x17, x0, #0x5555555555555555
    orr x17, x0, #0x00ff00ff00ff00ff
    orr x17, x0, #0xf0
    orr x17, x0, #0x8000000000000000
    orr x17, x0, #0x7fffffffffffffff
    orr x17, x0, #0xffff0000ffff0000
    orr w0, w3, #0xff
    orr w12, w7, #0xfffffffe
    orr w3, w12, #0x55555555
    orr w1, w0, #0x80000000
    orr w12, w19, #0x0f0f0f0f
    eor x17, x0, #0xff
    eor x17, x0, #0xffff
    eor x17, x0, #0x1
    eor x17, x0, #0xfffffffffffffffe
    eor x17, x0, #0x5555555555555555
lab1080:
    eor x17, x0, #0x00ff00ff00ff00ff
    eor x17, x0, #0xf0
    eor x17, x0, #0x8000000000000000
    eor x17, x0, #0x7fffffffffffffff
    eor x17, x0, #0xffff0000ffff0000
    eor w1, w0, #0xff
    eor w1, w3, #0xfffffffe
    eor w0, w1, #0x55555555
    eor w1, w3, #0x80000000
    eor w19, w3, #0x0f0f0f0f
    ands x17, x0, #0xff
    ands x17, x0, #0xffff
    ands x17, x0, #0x1
    ands x17, x0, #0xfffffffffffffffe
    ands x17, x0, #0x5555555555555555
    ands x17, x0, #0x00ff00ff00ff00ff
    ands x17, x0, #0xf0
    ands x17, x0, #0x8000000000000000
    ands x17, x0, #0x7fffffffffffffff
    ands x17, x0, #0xffff0000ffff0000
    ands w12, w30, #0xff
    ands w1, w3, #0xfffffffe
    ands w7, w12, #0x55555555
    ands w19, w1, #0x80000000
    ands w3, w3, #0x0f0f0f0f
    tst x17, x0
    tst x17, #0xff
    tst w30, #1
    mvn x17, x0
    mvn w0, w3
    mvn x17, x0, lsl #3
    and sp, x1, #0xfff0
    lsl x17, x0, x16
    lsl x17, x0, #0
    lsl x17, x0, #1
    lsl x17, x0, #63
    lsl w0, w0, #5
    lsl w0, w19, w12
    lsr x17, x0, x16
    lsr x17, x0, #0
lab1120:
    lsr x17, x0, #1
    lsr x17, x0, #63
    lsr w12, w1, #5
    lsr w12, w7, w1
    asr x17, x0, x16
    asr x17, x0, #0
    asr x17, x0, #1
    asr x17, x0, #63
    asr w7, w0, #5
    asr w19, w30, w19
    ror x17, x0, x16
    ror x17, x0, #0
    ror x17, x0, #1
    ror x17, x0, #63
    ror w7, w19, #5
    ror w7, w12, w30
    cset x17, eq
    csel x17, x0, x16, eq
    cset x17, ne
    csel x17, x0, x16, ne
    cset x17, cs
    csel x17, x0, x16, cs
    cset x17, hs
    csel x17, x0, x16, hs
    cset x17, cc
    csel x17, x0, x16, cc
    cset x17, lo
    csel x17, x0, x16, lo
    cset x17, mi
    csel x17, x0, x16, mi
    cset x17, pl
    csel x17, x0, x16, pl
    cset x17, vs
    csel x17, x0, x16, vs
    cset x17, vc
    csel x17, x0, x16, vc
    cset x17, hi
    csel x17, x0, x16, hi
    cset x17, ls
    csel x17, x0, x16, ls
lab1160:
    cset x17, ge
    csel x17, x0, x16, ge
    cset x17, lt
    csel x17, x0, x16, lt
    cset x17, gt
    csel x17, x0, x16, gt
    cset x17, le
    csel x17, x0, x16, le
    cset w7, eq
    csinc x17, x0, x16, ne
    csneg x17, x0, x16, ge
    csel w12, w3, w19, lt
    sxtb x17, w1
    sxth x17, w1
    sxtw x17, w3
    uxtb w1, w30
    uxth w19, w19
    sxtb w19, w1
    mov x17, x0
    mov w7, w3
    mov sp, x17
    mov x17, sp
    mov x29, sp
    mov x17, #0
    mov x17, #65535
    mov x17, #-1
    mov x17, #0x10000
    mov x17, #-65536
    mov w0, #7
    mov w30, #-1
    movz x17, #0x1234, lsl #16
    movk x17, #0xbeef, lsl #48
    movn x17, #5
    movk w1, #1, lsl #16
    movz x17, #77
    ldr x0, [x1]
    str x0, [x1]
    ldr x0, [x1, #8]
    str x0, [x1, #8]
    ldr x0, [x1, #32760]
lab1200:
    str x0, [x1, #32760]
    ldr x0, [x1, #-8]
    str x0, [x1, #-8]
    ldr x0, [x1, #255]
    str x0, [x1, #255]
    ldr x0, [x1, #-256]
    str x0, [x1, #-256]
    ldr x0, [x1, #12]
    str x0, [x1, #12]
    ldr x0, [x1, #8]!
    str x0, [x1, #8]!
    ldr x0, [x1, #-16]!
    str x0, [x1, #-16]!
    ldr x0, [sp, #16]
    str x0, [sp, #16]
    ldr x0, [sp]
    str x0, [sp]
    ldr x0, [x29, #-24]
    str x0, [x29, #-24]
    ldr x0, [x1, x2]
    str x0, [x1, x2]
    ldr x0, [x1, x2, lsl #3]
    str x0, [x1, x2, lsl #3]
    ldr x0, [x1, w2, sxtw]
    str x0, [x1, w2, sxtw]
    ldr x0, [x1, w2, uxtw #3]
    str x0, [x1, w2, uxtw #3]
    ldr x0, [x1, w2, sxtw #3]
    str x0, [x1, w2, sxtw #3]
    ldr x0, [x1], #8
    str x0, [sp], #-16
    ldur x0, [x29, #-8]
    stur x0, [x29, #-200]
    ldur x0, [x1, #16]
    ldr x0, [x1]
    str x0, [x1]
    ldr x0, [x1, #8]
    str x0, [x1, #8]
    ldr x0, [x1, #32760]
    str x0, [x1, #32760]
lab1240:
    ldr x0, [x1, #-8]
    str x0, [x1, #-8]
    ldr x0, [x1, #255]
    str x0, [x1, #255]
    ldr x0, [x1, #-256]
    str x0, [x1, #-256]
    ldr x0, [x1, #12]
    str x0, [x1, #12]
    ldr x0, [x1, #8]!
    str x0, [x1, #8]!
    ldr x0, [x1, #-16]!
    str x0, [x1, #-16]!
    ldr x0, [sp, #16]
    str x0, [sp, #16]
    ldr x0, [sp]
    str x0, [sp]
    ldr x0, [x29, #-24]
    str x0, [x29, #-24]
    ldr x0, [x1, x2]
    str x0, [x1, x2]
    ldr x0, [x1, x2, lsl #3]
    str x0, [x1, x2, lsl #3]
    ldr x0, [x1, w2, sxtw]
    str x0, [x1, w2, sxtw]
    ldr x0, [x1, w2, uxtw #3]
    str x0, [x1, w2, uxtw #3]
    ldr x0, [x1, w2, sxtw #3]
    str x0, [x1, w2, sxtw #3]
    ldr x0, [x1], #8
    str x0, [sp], #-16
    ldur x0, [x29, #-8]
    stur x0, [x29, #-200]
    ldur x0, [x1, #16]
    ldr x30, [x1]
    str x30, [x1]
    ldr x30, [x1, #8]
    str x30, [x1, #8]
    ldr x30, [x1, #32760]
    str x30, [x1, #32760]
    ldr x30, [x1, #-8]
lab1280:
    str x30, [x1, #-8]
    ldr x30, [x1, #255]
    str x30, [x1, #255]
    ldr x30, [x1, #-256]
    str x30, [x1, #-256]
    ldr x30, [x1, #12]
    str x30, [x1, #12]
    ldr x30, [x1, #8]!
    str x30, [x1, #8]!
    ldr x30, [x1, #-16]!
    str x30, [x1, #-16]!
    ldr x30, [sp, #16]
    str x30, [sp, #16]
    ldr x30, [sp]
    str x30, [sp]
    ldr x30, [x29, #-24]
    str x30, [x29, #-24]
    ldr x30, [x1, x2]
    str x30, [x1, x2]
    ldr x30, [x1, x2, lsl #3]
    str x30, [x1, x2, lsl #3]
    ldr x30, [x1, w2, sxtw]
    str x30, [x1, w2, sxtw]
    ldr x30, [x1, w2, uxtw #3]
    str x30, [x1, w2, uxtw #3]
    ldr x30, [x1, w2, sxtw #3]
    str x30, [x1, w2, sxtw #3]
    ldr x30, [x1], #8
    str x30, [sp], #-16
    ldur x30, [x29, #-8]
    stur x30, [x29, #-200]
    ldur x30, [x1, #16]
    ldr w0, [x1]
    str w19, [x1]
    ldrsw x9, [x1]
    ldr w7, [x1, #4]
    str w1, [x1, #4]
    ldrsw x0, [x1, #4]
    ldr w0, [x1, #16380]
    str w19, [x1, #16380]
lab1320:
    ldrsw x16, [x1, #16380]
    ldr w30, [x1, #-4]
    str w12, [x1, #-4]
    ldrsw x30, [x1, #-4]
    ldr w3, [x1, x2, lsl #2]
    str w12, [x1, x2, lsl #2]
    ldrsw x5, [x1, x2, lsl #2]
    ldrb w19, [x1]
    strb w3, [x1]
    ldrsb x0, [x1]
    ldrsb w7, [x1]
    ldrb w1, [x1, #1]
    strb w1, [x1, #1]
    ldrsb x9, [x1, #1]
    ldrsb w7, [x1, #1]
    ldrb w0, [x1, #4095]
    strb w3, [x1, #4095]
    ldrsb x15, [x1, #4095]
    ldrsb w3, [x1, #4095]
    ldrb w12, [x1, #-1]
    strb w3, [x1, #-1]
    ldrsb x5, [x1, #-1]
    ldrsb w0, [x1, #-1]
    ldrb w3, [x1, x2]
    strb w1, [x1, x2]
    ldrsb x15, [x1, x2]
    ldrsb w1, [x1, x2]
    ldrh w0, [x1]
    strh w3, [x1]
    ldrsh x16, [x1]
    ldrh w0, [x1, #2]
    strh w7, [x1, #2]
    ldrsh x9, [x1, #2]
    ldrh w12, [x1, #8190]
    strh w19, [x1, #8190]
    ldrsh x5, [x1, #8190]
    ldrh w1, [x1, #-2]
    strh w12, [x1, #-2]
    ldrsh x0, [x1, #-2]
    ldrh w0, [x1, x2, lsl #1]
lab1360:
    strh w3, [x1, x2, lsl #1]
    ldrsh x1, [x1, x2, lsl #1]
    ldr d1, [x1]
    str d8, [x1]
    ldr d15, [x1, #8]
    str d0, [x1, #8]
    ldr d8, [sp, #-16]
    str d0, [sp, #-16]
    ldr d2, [x29, #-8]
    str d2, [x29, #-8]
    ldr d31, [x1, x2, lsl #3]
    str d1, [x1, x2, lsl #3]
    ldr s0, [x1, #4]
    str s31, [x1]
    stp x29, x30, [sp, #-16]!
    ldp x29, x30, [sp], #16
    stp x19, x20, [sp, #16]
    ldp x19, x20, [sp, #504]
    stp x0, x1, [x2, #-512]
    stp w0, w1, [sp, #8]
    ldp w2, w3, [x1], #-8
    stp d8, d9, [sp, #-16]!
    ldp d8, d9, [sp], #16
    ldp x0, x1, [x2]
    ldxr x0, [x1]
    stxr w2, x0, [x1]
    ldaxr x3, [x4]
    stlxr w5, x3, [x4]
    ldxr w0, [x1]
    stlxr w2, w0, [sp]
    br x16
    blr x9
    ret
    ret x5
    svc #0
    svc #0x80
    nop
    dmb ish
    fmov d15, d1
    fmov d31, x29
lab1400:
    fmov x16, d2
    fmov s9, s1
    fmov s4, w19
    fmov w12, s1
    fadd d0, d31, d15
    fadd s9, s31, s1
    fsub d15, d15, d15
    fsub s0, s31, s1
    fmul d0, d0, d0
    fmul s1, s4, s0
    fdiv d8, d8, d15
    fdiv s0, s0, s31
    fsqrt d31, d1
    fsqrt s9, s4
    fneg d0, d8
    fneg s0, s31
    fabs d15, d0
    fabs s31, s0
    fcmp d31, d31
    fcmp d8, #0.0
    fcmp s4, s0
    scvtf d2, x5
    scvtf d31, w30
    scvtf s1, x5
    ucvtf d31, x30
    fcvtzs x17, d8
    fcvtzs w30, d8
    fcvtzu x1, s9
    fcvt d31, s4
    fcvt s0, d15
fwd_end:
    nop
