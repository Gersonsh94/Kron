# DECISIONS — required reading at the start of every session

> **RULE (29-09-2026, decided by Gerson): nothing in Spanish.** Everything is
> in English -- messages, variable and function names, comments, scripts and
> documentation, in the compiler, the library, the tests and Ganimedes. Only
> the conversation with Gerson is in Spanish.

**For Claude:** everything in this file has been DECIDED by Gerson. It is not
reopened, no alternatives are proposed, and nobody asks "are you sure...?". If
a decision looks wrong, say so once, in one sentence, and carry on with what
was decided. Only Gerson changes this file.

If something is not here, then it is asked.

---

## How Kron is presented (decided by Gerson, 07-10-2026)

By the problems it solves, never as "sovereign" or by how it is built:
memory-safe and thread-safe native code, no borrow checker to learn, one
`.exe` with nothing to install, errors that say how to fix them. The
compiler's banner says so: "Memory-safe, thread-safe native code". Inside the
project, the build Kron makes of itself is "the kasm build" or "the kasm
path" -- the precise name, not a slogan.

## Language

- It is called **Kron**. Compiler `kronc.exe`, sources `.kr`.
- Header: `kron_program`, `kron_domain`, `kron_imports`, `kron_definitions`.
- Own executable format: **KRN**, magic `KRN!` (`4B 52 4E 21`), module `krn.asm`.
- All code, comments and symbol names **in English**.
- No aliases for old names.

## Performance

- Goal: **the second fastest**, behind hand-written assembly.
- Measured starting point: **3.89×** slower than assembly (`bench.kr`).
- After the register allocator and the instruction reductions: **3.00×**.
- Working directly on the allocated registers: **~0.9×** (median of five
  runs: 73, 102, 77, 129, 88; noise of ±30 %). In this loop Kron is level with
  hand-written assembly.
- That is the best case: local integers only. Floats, arrays, struct fields
  and call arguments still take the slow path. Integer parameters already go
  to registers.
- Register allocator: **graph colouring over an intermediate
  representation.** Not local allocation. Not a later pass over the `.asm`.

## Direction of Kron (decided by Gerson, 28-09-2026)

Kron aims to cover the five problems today's languages leave open, in this
order:

1. **Memory safety without Rust's learning curve.** Arrays with bounds checked
   by default; `peek`, `poke` and dereferencing only inside an explicit block;
   dynamic memory through arenas. No borrowing, no lifetimes.
2. **Concurrency safe by construction.** Threads share nothing: they talk
   through channels, and the compiler rejects a thread that touches a global.
3. **Friendly to AI-generated code.** Follows from 1 and 2: no memory or
   thread traps, a small grammar, diagnostics with hints.
4. **Performance with ease of use.** A comfortable library (strings, lists,
   dictionaries) and, later, type inference. This is the longest one.
5. **Simple deployment.** Already done: one binary, no runtime, no libc.

**Revised speed goal:** close to optimised C, not equal or above. Safety
checks cost little and the compiler removes them when it can prove them
unnecessary. Close to C is already faster than Go, Java, C#, Python and
JavaScript.

Point 1 goes first because it shapes everything else: changing later how
memory is accessed would break all the code already written, Ganimedes too.

Decisions of point 1:
- **Stepping outside an array goes through the existing `fail` system**, with
  a cause and a hint, and the caller checks it with `failed()`. It does not
  stop the program: that is Kron's way.
- **The block for dangerous code is called `raw { ... }`.** `peek`, `poke`
  and `*p` are only allowed inside it.

**POINT 1 DONE (29-09-2026):**
- **Array bounds.** Local, global and parameter arrays check their bounds in
  `cg_emit_index_value`, which every read and write goes through. An index
  out of range is an implicit `fail`; `main` prints an unchecked failure on
  exit (`__main_exit`). Array parameters declare their size (`v: [i64; 4]`)
  and are checked against it; the semantic pass rejects passing a smaller
  array (error kind 6, at compile time, no runtime cost). Tests:
  `test_bounds`, `test_bounds2`, `test_bounds3`, `test_arrsz_bad`.
- **`raw`.** `peek`, `poke` and `*p` outside `raw { ... }` are a compile error
  (kind 7), at the exact position of the access. `raw` is an ordinary block
  marked `BLOCK_RAW`; only the semantic pass looks at the mark. `raw` is a
  reserved word. Pointer arithmetic does not need `raw`: `p + 1` only computes
  a number, what touches memory is dereferencing. Tests: `test_raw`;
  negatives `test_raw_bad` .. `test_raw_bad4`.
- **Dynamic memory: `std_arena.kr` and `slice<i64>`.** `arena_new`,
  `arena_slice`, `arena_free`, `slice_len`, `slice_get`, `slice_set`. A slice
  fits in one `i64` (position, arena and generation). `arena_free` does not
  give the memory back: it bumps the generation, and every earlier slice
  fails when used. Stepping outside a slice fails too. 64 MB pool in `.bss`,
  256 arenas at once. The parser turns `v[i]` on a `slice<i64>` into
  `slice_get(v, i)` and `v[i] = x` into `slice_set(v, i, x)`. Integers only.
  Using `slice` without importing `std_arena.kr` is an error. Tests:
  `test_arena_lib`, `test_slice`, `test_slice_bad`.
- Fixed on the way: forwarding an array parameter passed the address of the
  slot holding the pointer; the semantic pass never analysed call arguments,
  nor `as`, `trunc`, `inb`, `*p` or indirect calls; `break` and `continue`
  were never generated (they went to `.skip`).
- The `arenas` of the `mmu` block are something else: the bare-metal memory
  map (fixed address, size, growth). They stay as they are.

**POINT 2 (safe concurrency), in progress:**
- **Step 1 done: `std_chan.kr`.** Channels as a library: `chan_new`,
  `chan_send`, `chan_recv`, `chan_close`, `chan_len`. A bounded FIFO of
  `i64` per channel, a pool of one million slots (8 MB) in `.bss`, 64
  channels at once. `chan_recv(c, out)` returns 1 with the value in `out[0]`,
  or 0 when the channel is closed and empty. Test: `test_chan`.
- **Locks 8 to 15 belong to the channels**; programs use locks 0 to 7.
- **Step 2 done: the fail state is per thread.** It used to be one global
  shared by every thread, so two threads failing at once read each other's
  failure. Now each thread gets its own block (flag, cause, hint) the first
  time it fails, found through a TLS slot (`TlsAlloc`/`TlsGetValue`); a
  thread that never failed costs nothing. `main` reserves the slot at start
  (`__rt_init`). The runtime helpers align the stack themselves, because an
  index out of range fails in the middle of an expression. Test:
  `test_tfail`. `chan_recv` still reports the end of a channel through its
  return value, which is the cleaner design anyway.
- **Step 2 done: `thread_yield()`** gives the time slice away
  (`SwitchToThread`). `std_chan` calls it while waiting, so a thread on a
  full or empty channel no longer keeps a core busy.
- **Step 3 done: `shared var`.** Code that can run in a thread may only
  touch globals declared `shared var`. The compiler works out which functions
  can run in a thread -- the ones passed to `thread_start` and everything they
  call -- and rejects any of them that touches a plain global (error kind 8,
  at the exact access, with a hint). An indirect call from such code counts
  every address-taken function as reachable. The check lives in codegen, which
  already resolves every call, `&fn` and global access. `std_chan` declares
  its globals `shared`. Tests: `test_thread`, `test_chan`; negatives
  `test_shared_bad` (direct) and `test_shared_bad2` (through a call).
  Chosen by Claude at Gerson's request, over `raw` for globals and over
  per-module permission: it lists all shared memory where it is declared.
- Still to do: the short syntax.

## Networking (added 06-10-2026, at Gerson's request)

- **`dll_load("x.dll")` and `dll_proc(lib, "name")`**: load a system library
  at run time and get a function's address, called with `call ptr(args)` (the
  Windows convention: four integer arguments in rcx, rdx, r8, r9). Only inside
  `raw { }`: calling into a system library is as delicate as memory by
  address. They use `LoadLibraryA` and `GetProcAddress` from kernel32, so
  `pe_writer` still imports from kernel32 only.
- **`std_net.kr`**: TCP over Windows sockets, written in Kron on top of those
  two: `net_listen`, `net_listen_on`, `net_accept`, `net_connect`,
  `net_send`, `net_recv`, `net_close`. ws2_32.dll is loaded on the first call;
  its function pointers are `shared` globals, written once. Windows returns
  32-bit ints in a 64-bit register, so every result is sign-extended from its
  low half. Indirect calls go in statements of their own, never inside
  another call's arguments, so the stack is aligned. Test: `test_net`
  (loopback only, no firewall prompt).
- Next: UDP if needed, and a server in Ganimedes on top of `std_net`.

## Ganimedes

- Hybrid NoSQL+SQL engine written in Kron.
- **Kron and Ganimedes are separate projects.** Nothing in Kron refers to
  Ganimedes, so moving either folder breaks nothing. The Kron suite does not
  test Ganimedes. Ganimedes has its own `run_tests.bat`, with its references
  in `Schema\expected\`; the only thing it needs from Kron is the compiler
  path (`KRONC` at the top, or `/c:PATH`).
- Files for Ganimedes are delivered for the Ganimedes folder, never for the
  compiler's.
- **32-byte fixed keys.** **Columnar** store (parallel arrays).
- Hash index with **linear probing**, 8-byte slots, tombstones on delete.
- Multi-tenant: **shared and dedicated**. No collection per tenant.
  Mandatory session, tenant in the first word of the key, a stamp on every
  record, a rejection counter.
- **Immutable storage with a Merkle tree**: SHA-256, 128 children per node,
  32 records per leaf. The tree is updated at the checkpoint, not on every
  write, and leaves are hashed in parallel with threads.
- Frontend: the dashboard data is mock; the engine is what is being built.
- **Missing**: `UserRecord.kr` and `Sha256.kr` were not in the folder.
  `Sha256` has to be rewritten for the Merkle tree, and saved in `Schema\`.

## AI goal (stated by Gerson, 30-09-2026)

Gerson wants Kron to be able to build AI: a language model like ChatGPT, and
a brain-inspired AI with regions (hypothalamus and others) working together at
low energy.

Where the limits are:
- **Writing the code of a GPT, small or large**: a language question. The
  code of a small model and a huge one is the same; only the numbers change.
  Kron is at C's level for this (llm.c trains GPT-2 and llama2.c runs a model
  in plain C). Backpropagation is written by hand, as llm.c does.
- **Running a large open model on a PC**: a language and compiler question.
- **Training a large model**: a hardware question (a GPU cluster, data,
  money). No language closes that gap.

What Kron is missing for it, by what blocks most:

| missing | why | status |
|---|---|---|
| `slice<f64>` | weights and activations are reals whose size is only known at run time (read from the model file). **The only real blocker at language level.** | pending; extends `slice<i64>` |
| large memory | weights take from 60 MB to several GB; the `std_arena` pool is 64 MB | pending |
| positioned read | read a large weight file in parts; `loadfile` reads it whole. Ganimedes needs it too | pending |
| wide SIMD (AVX) | matrix products with 4-8 numbers per instruction instead of 2; also needs `RA_FREGS` raised (kasm REX on SSE) | pending |
| fast `exp` and `sqrt` | used millions of times per generated word | pending |
| low-precision numbers: `f16`, `bf16`, 8- and 4-bit integers | large models use them to fit in memory and run faster; Kron computes reals in `f64` | pending |
| hash map | the tokenizer's vocabulary; can be written by hand meanwhile, like Ganimedes' index | optional |
| GPU code generation | only for training large models; a whole new `codegen` | long term |

Channels (point 2) are also what the brain-inspired AI needs: spike queues
between regions. The order of work does not change unless Gerson says so.

## Order of work

- Next (Gerson, 12-10-2026): block C, phones (Android and iPhone: asked,
  not answered yet); then Ganimedes. The language comes before Ganimedes.


1. ~~Memory safety (point 1)~~ — **done**.
2. Safe concurrency with channels (point 2).
3. Ganimedes: block format, append-only log, Merkle tree.

## How we work

- Every delivery says **which file, which folder, and which part of the
  system**.
- Complete files. Gerson does not edit by hand.
- Before delivering a rename, search for the symbol in **every** module, not
  only the one being changed. And search **without word boundaries**:
  `TARGET_JPX` does not show up when searching `\bjpx`, and survived two
  renames.
- **Never deliver a module that was not received in this session.** Claude
  works on copies; every fix Gerson makes on his machine leaves Claude's copy
  behind without notice. Delivering it later undoes that fix. If a module
  needs changing, ask for it first.
- Every new label goes after a `jmp` or a `ret`.
- No `push` with an immediate: kasm does not encode it.
- Never load a 32-bit register from `[rsp + displacement]` or
  `[r12 + displacement]`: both bases need a SIB byte and kasm does not encode
  it with a 32-bit destination. `[rsp]` with no displacement works, and so do
  64-bit registers.
- Never keep values in registers across a call to `cg_emit`: it only
  preserves `r12`. Whatever has to survive goes on the stack.
- **kasm does not know `xmm8`–`xmm15`**: it reads them as label names. A load
  fails with an error, but a store assembles into garbage silently. Hence
  `RA_FREGS = 2` (only `xmm6` and `xmm7`) until kasm emits REX on every SSE
  instruction. Do not use `xmm8`+ in emitted code.
- In the encoding corpora, only instructions with a single possible encoding:
  `cmp eax, imm` and `add rax, imm` have two valid ones and NASM and kasm pick
  differently.
- When something cannot be seen, ask for the tool to see it. Do not guess.
- Every phase ends with `BOOTSTRAP.bat` at the fixpoint.
- **The suite tests both build paths** (07-10-2026). `kronc prog.kr` builds
  through kasm and pe_writer; RUNTESTS used to build every test through
  `-S` and NASM only, so the path everyone uses was never tested. Two bugs
  lived there unseen: kasm could not encode `mov qword [rbp-N], imm` (every
  `stream` initialised from a literal), and pe_writer left the file padding
  of `.data` full of leftover bytes, so `.bss` variables did not start at
  zero and the first `fail` of a program crashed. Now `:runtest` builds
  each test both ways and it only passes when both print the reference.
- **How Claude verifies before delivering** (when the session allows it):
  NASM + MinGW `ld` build `kronc.exe` from the modules (stand-ins for `krn`
  and `karm`, which Claude does not have), Wine runs it, and Linux runs the
  ELF output natively. `kasm.asm` also assembles as a Linux object for a
  small harness that lists every line kasm rejects at once. The three-step
  bootstrap runs the same way. This replaces checking with an invented
  `win64_api.inc`: the stand-in must declare only real Windows functions,
  never every missing name (that hid nine missing externs in `main.asm`).
- **`savefile(buffer, length, name)`** -- that order, on every target. The
  first Linux runtime read the name from rcx; `test_load` called
  `savefile(name, buffer, n)`. The two mistakes cancelled out on Linux, and
  on Windows the test wrote nothing and printed nothing -- and that empty
  output had been captured as its reference, so it "passed". A reference is
  only captured after reading it: an empty one is a red flag. `bmp` now
  writes the same image byte for byte on Windows and Linux.
- kasm registers **every** name of an `extern A, B, C` line (only the first
  one or two used to count, silently) and keeps up to 512 names.

## Register allocator

Done and verified, at the fixpoint:

- IR under `emit_bytes`: loads, stores, labels, jumps and the frame are
  structured records.
- Liveness by blocks, interference graph, Chaitin colouring with `rbx`,
  `r12`–`r15`, saved and restored in the frame.
- A simple right operand straight to `rcx`, no `push`/`pop`.
- Compare and jump fused in `if` and `while`.
- Operations on the allocated registers: `add r12, rbx` instead of four
  instructions, when the IR records are consecutive.
- Integer parameters to registers: the prologue stores them as
  `IR_STPARAM`, which becomes `mov rbx, rcx` when the parameter has a register.
- Simple call arguments straight to their register, skipping the stack, when
  every later argument is simple too.
- Floats to registers: a second colouring, for now over `xmm6` and `xmm7`.
- A simple float operand straight to `xmm1`, skipping the stack. Measured with
  `bench_f.kr`: from ~1,785,000 to ~889,000 ticks, **twice as fast**.

`RA_TRACE` and `RA_ENABLE` in `kron_types.inc`, with `RATRACE.ps1` and
`RAALLOC.ps1` to switch them.

Next speed steps, by what weighs most in real code:
1. kasm: REX on every SSE instruction, to raise `RA_FREGS` to 10.
2. Float operations on the allocated registers, like `add r12, rbx` for
   integers.
3. Measure against `gcc -O2` with programs that cannot be reduced to a
   formula.

## Using the compiler (decided by Gerson, 07-10-2026)

- **`kronc program.kr` writes `program.exe` and nothing else**, as a C compiler
  does. The generated assembly goes through the preprocessor, kasm and
  pe_writer in memory; no `.asm` is left on disk.
- **`-S`** writes the generated assembly instead, like `gcc -S`: for reading
  it, or for the NASM audit path. ELF and bare-metal targets have no
  kasm path yet and always write the `.asm`.
- **`--check`** runs every check, the thread rule included, and writes
  nothing. The VS Code extension uses it on every save.
- **`-o path`** names whatever is written: the `.exe`, or the `.asm` with
  `-S`.
- `preproc.asm` (the expanded source of `--assemble`) is written only with
  `-S`.
- The scripts that need the assembly (the NASM path of `RUNTESTS`, `kc.bat
  /nasm`) ask for it with `-S -o` into a temporary folder: no `.asm` ever
  appears in the project folders.
- **Nothing in Spanish anywhere in a build**, labels and variable names of the
  scripts included.

## Platforms (decided by Gerson, 07-10-2026: before Ganimedes goes on)

Four milestones, each with a test that says it is done. Order decided by
Gerson on 07-10-2026: Linux x86-64 complete, then ARM64, then reals and
vectors, then the library.

1. **Linux x86-64.** `kronc program.kr --target=linux` writes a Linux
   executable, no extension, nothing else.
   - **1a done, to confirm with `LINUXTESTS.bat`:** an ELF writer in
     `main.asm` (`elf_write`) and a Linux runtime in codegen's Linux
     preamble -- the same routines as the Windows one, same conventions
     (rcx, rdx, r8; rbx, rsi, rdi, r12-r15 kept), over system calls, no libc.
     Printing, `fail`, bounds, files, time. `_start` calls `main`, so main
     runs with the stack aligned as on Windows. The ELF has one loadable
     segment at 0x400000 with kasm's flat image at file offset 0x80; only
     `dq label` slots (fixup kind 6) need filling.
     `main` ends through `__main_exit` on Linux too: an unchecked `fail` is
     printed there before `exit_group` (a bare exit syscall skipped it).
     Verified 07-10-2026 on Claude's side with the real compiler built from
     these sources and run under Wine, the binaries run natively on Linux;
     on Gerson's machine LINUXTESTS gave 68 of 69, and the one left was
     `test_load`, fixed the same day (below); then 69 of 69 and the seed was
     promoted. The first attempt had only been run through NASM, and kasm
     refused `mov [rsp+8], rdx` in the float printer: **the Linux runtime
     has to be tested through kasm, which is what the compiler uses.**
   - **1b done: command-line arguments, on both systems.** `arg_count()`
     counts them, the program included; `arg_get(i)` gives the address of
     argument i as a NUL-terminated string (std_str's form), an empty string
     when i is out of range. Windows splits `GetCommandLineA` once, double
     quotes grouping; Linux reads argc and argv where `_start` finds them.
     Not `arg(i)`: `arg` is a common parameter name (test_thread uses it).
     Test: `test_args`.
   - **1c done: threads, locks, channels and per-thread `fail` on Linux.**
     `clone` with a 1 MB stack aligned to 1 MB; the bottom of that stack
     holds the thread's fail block, its id (cleared and woken by the kernel
     when it ends) and the mapping, which `thread_wait` releases -- **a
     thread is waited for once**. `__fail_block` finds the block from rsp
     alone; the main thread is the one whose rsp is within its stack limit
     (getrlimit at `_start`, capped at 1 GB) of where `_start` found it. It
     was a fixed 64 MB until 10-10-2026: under QEMU in WSL the thread stacks
     were mapped within 64 MB below the main stack, the threads took main's
     block and `test_tfail` failed on ARM64. No other mapping can sit inside
     the stack limit. Locks are futex words (0 free, 1 taken, 2 with
     waiters) on `xchg`, which kasm now encodes. Checked: 4 threads adding
     a million each under one lock, 40 000 messages through a channel from
     4 producers, 4 000 threads started and waited in a row.
   - **1d done: networking on Linux.** One `std_net.kr` for both systems:
     the `net_sys_*` layer picks its path with `target_os()`, ws2_32 on
     Windows, the kernel's socket calls through `syscall(...)` on Linux,
     with `SO_REUSEADDR` (a server restarts on its port at once) and
     `MSG_NOSIGNAL` (a closed peer is an error, not a signal that kills).
   - Ganimedes' four tests give the same output on Linux as on Windows.
   - **Done when** LINUXTESTS passes with the thread and network tests in
     it (`test_thread`, `test_chan`, `test_tfail`, `test_net`, `test_args`).
2. **ARM64** (added 07-10-2026 at Gerson's request: phones, Apple Silicon,
   Raspberry Pi). Same shape as x86: codegen writes ARM64 text, `karm`
   assembles it, `elf_write` wraps it (machine field AArch64). First target:
   ARM64 Linux (the base of Android and the Raspberry Pi), tested with QEMU
   on both sides (`qemu-user` in WSL). macOS/iOS later: their own executable
   format and signing.
   - State of `karm.asm` on 07-10-2026: an encoder of about twenty
     instructions, every encoding checked against the ARM tools. **Bug in its
     frame layout:** after `stp x29, x30, [sp, #-16]!` and `mov x29, sp`,
     `[x29+8]` is the saved return address, and `karm_str_frame` only takes
     positive offsets -- the first local overwrites the return address (its
     own selftest crashes under QEMU). Locals go below x29 with
     `stur`/`ldur` and negative offsets: checked, it returns 42.
   - **Step 1 done (07-10-2026): karm is a text assembler.** The old
     encoder (twenty functions and a broken selftest, the `--arm` option) is
     replaced. `kronc prog.s --assemble --target=linux-arm64` writes an
     AArch64 ELF (machine 183, 64 KB segment alignment for kernels with 64 KB
     pages). Encodings checked against the GNU ARM assembler on 1523
     instructions; `ARMTESTS.bat` runs the ARM64 tests under QEMU. A `.kr`
     program with that target is refused with a hint until the codegen
     exists.
   - **Steps 2 and 3 done (10-10-2026): `.kr` programs run on ARM64.**
     `kronc program.kr --target=linux-arm64` writes an AArch64 ELF. Not a
     second code generator: codegen generates the Linux program, and
     `xarm.asm` lowers each x86-64 instruction of that text to ARM64, which
     karm assembles. The runtime is the Linux one, lowered the same way.
     Why: one code generator to keep right instead of two, and every
     feature that works on x86-64 works on ARM64 the same day. What it
     keeps of the x86-64 machine, so nothing above it changes:
     - registers map one to one (rax x0, rcx x1, rdx x2, rbx x19, rsp x28,
       rbp x29, rsi x4, rdi x5, r8-r11 x6-x9, r12-r15 x20-x23; xmmN vN);
       x16 x17 are scratch inside one instruction, x10-x15 in the syscall;
     - x28 is the stack, 8 bytes per push as on x86-64, so every frame
       offset holds; the ARM sp is left alone;
     - `call f` is `str x30, [x28, #-8]!` `bl f` `ldr x30, [x28], #8`: the
       caller keeps its return address in the slot the x86 call would use,
       so `[rbp+16]` is still the first stack argument;
     - flags: cmp, test, add, sub and ucomisd set the ARM flags and each
       jcc/setcc condition is mapped by what set them; a condition the
       flags cannot answer is an error, never a guess;
     - `syscall` goes to `__sysx`, which maps the x86-64 call numbers to
       ARM64's and the calls ARM64 only has as *at (open, mkdir, unlink,
       rmdir, rename, dup2). **Kron's `syscall(n, ...)` takes the Linux
       x86-64 numbers on every Linux**, so std_net is one source for all.
     Verified: the 74 programs of LINUXTESTS and the four slow graphics
     tests give the same output on ARM64 (QEMU) as on x86-64, threads,
     channels and sockets included. `ARMTESTS.bat` runs them.
     The cost: about two ARM64 instructions per x86-64 one, a call is three.
     A direct ARM64 generator stays possible later, for speed; nothing
     above xarm would change.
   - Found on the way and fixed: the .bss of a Linux executable started
     wherever .data ended, so the futex words of the locks could be
     misaligned and every futex call failed (EINVAL); locks then spun,
     which on two processors never ended (`test_chan`). .bss is now
     16-byte aligned, as the PE writer already did. Three kasm encodings
     were silently wrong (see Known limits, fixed) and karm dropped data
     items past the sixth on a line.
   - **Done** when the LINUXTESTS list passes on ARM64: it does.
3. **Reals and vectors**: `f32`, the sixteen xmm registers in kasm,
   `slice<f64>`, fast `sqrt`/`exp`, a `print` of reals that does not
   overflow, 4-wide `f32` SIMD. Done when a reals benchmark is close to the
   integer one.
   - **Done 12-10-2026**: arrays packed by element width (`[f32; N]` four
     bytes, `[u8; N]` one), `f32` struct fields stored in four bytes, `print`
     of any real, exponents in literals, `fsqrt` from a bit guess (six Newton
     steps instead of forty) and `fexp` scaling by building 2^k.
   - **Done 12-10-2026 (the rest)**: kasm encodes xmm8-xmm15 (the REX
     bits), the register allocator has ten registers for reals, real moves
     between registers are `movaps` (a `movsd` kept a false dependency on
     the old value: `bench_xmm` went from 114 to 64 ms), `vec4_*` work on
     four `f32` at once (`addps`... on x86-64, `.4s` on ARM64), `vec2_div`,
     and `slice<f64>`. Test: `test_simd4`.
4. **Library**: list, map, string builder, positioned read, time (arguments
   came with 1b).
   Done when a normal program needs no `raw`.
   - **Done 12-10-2026**: std_text, std_list, std_map, std_file, std_time,
     std_os, std_image (see "The library without raw").

5. **macOS on Apple silicon** (Gerson, 12-10-2026: "a y b al mismo tiempo",
   he has an M4). See "macOS" below.
6. **The web** (same request, block B). See "The web" below.

- **Targets by full name**: `--target=windows | linux | linux-arm64 | macos |
  web | krn | bare`. An
  unknown name is an error, never a silent Windows build (it used to look at
  the first letter only).
- `beep` goes through the runtime (`__beep`) like everything else: generated
  code never calls the system directly.
- **`target_os()`**: 1 Windows, 2 Linux, 3 krn, 4 bare -- a constant the
  compiler writes, so one library source can choose its system path.
- **`syscall(num, a1..a6)` is an expression** (its result is rax), only
  inside `raw`, like `dll_load`. It used to be a statement whose result was
  thrown away. On Windows it becomes a `fail` ("syscall exists only on
  Linux"), never the instruction: the kernel's numbers are private there.
  Its keyword token lives in `AST.type_info`, because the generic walks
  follow `left` and `right`. Negative test: `test_syscall_bad`.
- **A global `const` is readable from threads**: it carries the `shared`
  mark for the thread check. Before, a function running in a thread could
  not even use a named constant (found by std_net's `NET_SYS_ACCEPT`).
- The raw error now names every raw-only operation: memory by address and
  the system (dll_load, dll_proc, syscall), not only peek and poke.

## Imports

`acquire_domain` chains. Before pasting anything, `imp_resolve` walks the
imports depth-first (the program's, each module's...) and builds one list in
dependency order, without repeats and cutting cycles. It is pasted whole at
the program's first `acquire_domain`. Limits: 64 modules in total, 8 levels
of nesting, 16 imports per file. An import that does not exist stops the
compilation with its name.

- Each module declares in its header what it uses. Whoever imports it does not
  need to know what it depends on.
- **A module is looked for next to the program first** (the folder of the
  `.kr` given to kronc), then as written, relative to the folder kronc runs
  from -- the same order `%include` already used. Before, only the second
  was tried, so compiling `Schema\test_hash.kr` from another folder could not
  find `HashIndexM.kr`. Found on 07-10-2026: Ganimedes' tests had been
  passing on stale `.asm` files left in `Schema\` -- the compile failed
  quietly and the old assembly was assembled instead. One-step compiling
  leaves no `.asm` to fall back on, which is how it surfaced.
- Tests: `test_chain` (a chain of two, a repeated import) and `test_nofile`
  (negative).

## Library

- `std_str`: 31 functions, NUL-terminated strings, the caller provides the
  memory. Test: `test_strlib`.
- `std_arena`: arenas and slices (see point 1).
- `from` is a reserved word in the lexer even though it is not in the
  grammar: check names against the lexer's table, not against the grammar.
- To save an expected output, use `cmd /c "prog.exe > file"`, never
  PowerShell's `>`: it writes UTF-16 and `fc` sees one character per line.

## The library without raw (12-10-2026, Gerson: everything in one delivery)

Delivered as one block, as Gerson asked: no more pieces with a question
between each.

- **Arrays are packed** (the known limit of 07-10-2026 is gone): every
  element takes its type's width in locals, globals, parameters, array
  literals, `&a[i]` and `sizeof`. Signed elements are widened with a shift
  pair (`shl`/`sar`), not `movsx`, which every assembler and translator here
  already knows. `[f32; N]` is stored in four bytes (`movss` +
  `cvtss2sd`/`cvtsd2ss`). Passing an array to a parameter of another element
  type is a compile error (kind 9). Test `test_packed`, negative
  `test_aw_bad`.
- Found on the way: **fields of a global struct** were reached at offset 0
  of the frame (`gq.x = 5` overwrote the saved rbp); an **f32 field** was
  written as eight bytes over the next one; **signed narrow fields** read
  -1 as 255; `&g[i]` of a global dropped the index; `&v[i]` of an array
  parameter pointed into the frame; a function using a global declared
  further down saw none of its type (globals are now recorded in the
  pre-pass). Test `test_fields`.
- **print of reals**: from 9e12 the whole part and the fraction are
  converted apart; from 2^63 it prints `d.dddddde+N`; inf and nan by name.
  Test `test_bigreal`. **Exponents in literals** (`1.5e3`, `2e-6`):
  lexer, kasm's `parse_float`, and a `.0` added for NASM when the literal
  has no point. Test `test_exp_lit`.
- **Thirty-two locks**: 16 to 31 belong to the library, prepared by the
  Windows runtime at start (programs 0 to 7, channels 8 to 15, as before).
- **std_heap.kr** under everything: blocks of 16 B to 1 MB by powers of two
  from 1 MB pieces of system memory (VirtualAlloc / mmap), free lists per
  size, big blocks as their own mapping; and **handles**: slot, generation
  and bit 62, checked on every use, so a freed text fails instead of being
  read. Bit 62 is never set in an address: a function that takes a text
  tells a handle from a string literal by it.
- Every public call of the library takes lock 16, works, gives it back,
  and only then fails: internal functions never `fail` with the lock held,
  they leave a code in `hp_err` that `heap_fail` turns into the cause and
  hint. Test `test_libthreads` (four threads, one list, one map).
- **std_text, std_list, std_map**: texts that grow, lists that grow, maps
  with text keys kept in insertion order (open addressing over an ordered
  entry array). Tests `test_text`, `test_list`, `test_map`.
- **std_file**: whole files, files kept open with a position, raw bytes at a
  position (pread/pwrite, SetFilePointerEx + ReadFile), folders. Linux
  avoids `stat` (its layout differs on ARM64) and `O_DIRECTORY` (its value
  differs): sizes come from `lseek`, folders from `getdents64`. Test
  `test_files`.
- **std_time**: UTC from the system, the calendar by Howard Hinnant's
  algorithms, the time zone from GetTimeZoneInformation or /etc/localtime
  (TZif, the 64-bit block when there is one).
- **std_os**: environment (GetEnvironmentVariableA, /proc/self/environ),
  running commands through cmd or sh, with their output (CreatePipe /
  pipe + fork + execve). Test `test_os`.
- **std_image**: PNG (every colour type and depth, palette, tRNS, Adam7)
  with its own inflate, and BMP; checked pixel by pixel against Pillow.
- **ARM64 system calls**: stat, lstat, access, pipe, fork, vfork, execve,
  readlink, chmod and the *at forms added to xarm's table and shim.
- **std_window**: the wheel, the right button, Ctrl and Shift, a clip
  rectangle, the system clipboard (CF_UNICODETEXT on Windows; CLIPBOARD
  with ConvertSelection / SelectionRequest on X11), and on X11 the
  keyboard's own layout (GetKeyboardMapping; AltGr; dead accents composed).
- **std_ui**: texts accepted wherever text is shown; `ui_edit` with a caret,
  `ui_area` (several lines), `ui_list`, `ui_select`, `ui_tabs`, `ui_radio`,
  menus (`ui_menubar` / `ui_menu` / `ui_menu_item`), `ui_image`, clipboard.
  An open menu or dropdown is an overlay: drawn last, in `ui_end`, and the
  controls under it ignore the mouse (its rectangle from the frame before).
  `notes_demo.kr` is a complete program built only from these.
- kasm learned `movss`, `cvtss2sd`, `cvtsd2ss`, `mov [rbp-N], r8/r16/r32`,
  `mov r32, [rbp-N]`, `movzx r, [rbp-N]`; karm `ldurb/sturb/ldurh/sturh`;
  xarm `movss` and the conversions.

## Programs with controls: std_ui.kr (11-10-2026, Gerson: real programs)

- **Kron draws its own controls** on a std_window window: text, buttons,
  boxes to type in, checkboxes, switches, sliders, progress bars, cards.
  Decided over the system's native controls because Linux has none without
  a C library (GTK, Qt), and Kron uses none: drawn by Kron, a program is the
  same on Windows, Linux and ARM64.
- **The look is current, not 1995** (Gerson rejected the first, flat
  version on sight): Inter for the letters, anti-aliased with 16 levels;
  corners rounded and smoothed (4 x 4 samples a pixel); soft shadows made of
  faint outlines; a light and a dark theme (`ui_dark`) with an accent color
  (`ui_accent`); hover and press eased over a few frames.
- **Immediate mode**: each frame the program states its controls and each
  answers what happened to it in that frame (`if ui_button(...)`). No
  objects to create or free. A control is known by its x and y.
- **The letters**: Inter (SIL Open Font License) regular and semibold at
  15 px and display semibold at 30 px, for the 191 printable characters of
  Latin-1 (accents, ñ, ¿ ¡, ×, ÷), a hex digit of coverage a pixel, kept in
  std_ui.kr and decoded at the first ui_begin (185 KB of pixels). Text is
  UTF-8 like the source; typed Latin-1 goes into the boxes as UTF-8.
- **std_window gained**: typed characters with shift and caps lock
  (`window_char`: WM_CHAR through TranslateMessage on Windows, a US-layout
  table on X11), presses and releases counted per frame (a click shorter
  than a frame used to be lost), `window_pixel_at`, `window_width/height`.
- **Found on the way and fixed**: a string literal past about a thousand
  characters was cut short without a word (one `db` line, longer than the
  assemblers' line buffers): codegen now writes 64 bytes a line, and xarm
  refuses a line it cannot hold instead of cutting it (`test_longstr`).
  kasm encoded `test dword [rel x], imm` as an add that wrote to x
  (`test_kasmfix` checks it).
- Verified under a virtual display: ui_demo on Linux, ARM64 (QEMU) and
  Windows (Wine) -- typing with shift, backspace, checkbox, slider, button;
  the calculator: 75*13 = 975, /3 = 325, 1/8 = 0.125.

## Windows to draw in (11-10-2026, Gerson's choice over a console-only flag)

- **`std_window.kr`**, in Kron: one window per program with its own picture
  (32 bits a pixel, at most 2 097 152), drawn with window_pixel / rect /
  clear and put on screen by `window_show`, which also reads the keyboard
  and the mouse. Same key codes everywhere (Windows' virtual keys).
- Windows: user32 and gdi32 through `dll_load`. The window class's
  procedure is `DefWindowProcA` itself, so there is no callback into Kron:
  `window_show` reads the input as it passes through PeekMessage, and a
  closed window is seen with `IsWindow`. StretchDIBits draws the picture.
- Linux, x86-64 and ARM64: the X11 protocol spoken over
  `/tmp/.X11-unix/X0` (then X1) with system calls -- no library. No
  authorization is sent: WSLg and local desktops accept that; a server that
  insists is a clear fail. WM_DELETE_WINDOW for the close button, fixed
  size hints, PutImage in bands under the request limit, events read
  without blocking.
- **`call ptr(args)` follows the Windows convention fully**: any number of
  arguments, the fifth on at [rsp+32]. Past the fourth they used to be
  dropped without a word. And every such call aligns rsp to 16 (saving the
  old one): inside an expression with temporaries pushed it was off by 8,
  and LoadCursorA crashed. `test_dllcall` (nine and twelve arguments, a
  call inside an expression).
- **`--window`**: the PE says GUI instead of console, and Windows opens no
  console for the program.
- Verified under a virtual X display: the Linux, ARM64 (QEMU) and Windows
  (Wine) builds of `window_demo.kr` draw the same picture and get the same
  keys and clicks.
- kasm learned `mov [rsp+N], reg64`; xarm turns `pop rsp` into a plain
  load (writeback into the base register is undefined on ARM64).

## Language, block A (12-10-2026, Gerson: blocks A and B in one delivery)

- **Failure traces.** `print_fail` (and the failure printed at the end)
  names the function and line where it happened and each call that led
  there: `  at NAME (FILE:LINE)`, `  called from NAME (FILE:LINE)`. How: the
  fail block has room for eight addresses; `__fail_raise` walks the frames
  (`rbp` chain) and keeps the return addresses; each function has a record
  (its start, its end, its name, its file and its line table) chained from
  `__kron_trace`, and the lines are labels emitted only at call and fail
  sites, so nothing runs while nothing fails. The library's lines come
  first, then the program's. Test: `test_trace` (threads included).
- **`text` is a type.** It prints as its words, `==`/`!=` compare bytes, `+`
  joins texts, literals, integers and reals (reals with the digits they need).
  A `text` declared from a literal is a text of its own (`text_add` grows
  it). The type travels in the AST (`col` bits 8-15) so `print`, `==` and
  `+` know a text from a number; `var x = f()` takes f's result type.
  Test: `test_texttype`.
- **`list<T>` and `map<T>`** (`T` = `i64`, `f64`, `text`): created empty when
  declared, `[a, b]` literals, `l[i]`/`m[k]` rewritten by the parser into
  the library calls, `for x in l`, `print` of the whole collection. A
  global initializer that is not a constant runs when `main` begins.
  Tests: `test_collections`, `test_list_bad`, `test_listshow_bad`.
- **Up to four results**, `-> (T1, ..., T4)`, returned in rax, rdx, r8, r9
  (reals as their bits, the first one also in xmm0); `var a, b = f();`,
  `a, b = f();`, `_` skips one; a call used as a value gives its first
  result. Test: `test_multi`.
- **Functions as values and closures.** A value of type `fn(T) -> R` is the
  address of a record: the code, then copies of the variables it uses, made
  when the `fn (...) { }` expression runs (captured by value: a function
  value never shares a variable with the code around it, so it can go to
  another thread without a race). The record goes along
  as a hidden last argument. A named function is a record with no copies
  (`__fnrec_NAME`). Records come from `__clo_alloc`, 1 MB chunks under a
  spin lock. Calling something that is not a function is a compile error
  (it used to jump to address 0). Tests: `test_fnvalues`, `test_nofn_bad`.
- `s.field(...)` is refused with "call it through a variable": the call
  would go through `s`. A struct field of type `fn` works through
  `var f = s.field; f(x)`. Test: `test_fieldcall_bad`.

## The web (block B, 12-10-2026)

- **`--target=web`**: `xwasm.asm` lowers the Linux x86-64 text to a
  WebAssembly module -- one more lowering beside xarm, so every feature is on
  the web the day it works on Linux. The module imports `env.syscall` (the
  Linux x86-64 numbers) and its memory; `web/kron_web.js` answers the calls
  as Linux would (the real disk under Node.js, folders in memory in a
  browser). Why this way and not a second code generator: the same reason as
  xarm. Why not WASI: a page has no WASI, and Kron already speaks Linux.
- Registers are wasm globals; a code address is an instruction index and a
  slot of the function table; non-local labels are functions, jumped-to
  local labels are blocks under a `br_table` loop; the flags are known at
  compile time by what set them; `xchg` with memory is an atomic exchange.
- **Threads on the web**: shared memory, one instance of the module per
  worker, `clone` starts one, `futex` is `Atomics.wait`/`notify`, the end of
  a thread clears and wakes its id word as Linux does. The page needs the
  COOP/COEP headers: `web/kron_serve.kr` (a server in Kron) sends them, and
  when a server does not, `kron_web.js` installs itself as a service worker
  that adds them. Without shared memory the program still runs, without
  threads (`thread_start` fails with its cause).
- **Windows on the web**: the page draws: each `window_show` sends the
  picture to the page, and the page sends the keyboard and the mouse
  through a ring in shared memory. A worker never shows a canvas of its own
  while its loop runs, so OffscreenCanvas was dropped.
- Files `NAME.wasm`, `NAME.html`, `kron_web.js`; the compiler carries
  `kron_web.js` (`include/web_host.inc`, made by `web/make_host.kr`) and
  writes it beside every program, so host and program always match.
- Call 1100 (not a Linux call) tells the layer under the Linux program:
  ENOSYS on Linux, 1 macOS, 2 the web. `os_name()` and `std_window` use it.
- **Done** when WEBTESTS (Node.js) passes: 90 of 90 (test_os and test_net
  are not in it: a page has no processes and no sockets).

## macOS (12-10-2026)

- **`--target=macos`**: the Linux ARM64 program with a macOS shim in place
  of the Linux one (`xarm_set_os(1)`), assembled by karm at 0x100004000 with
  each section on a 16 KB page, in a Mach-O written by `macho.asm`. The shim
  converts numbers, flags (`open`, `mmap`, sockets), structures (`stat`,
  `getdents`, `sockaddr`), errors (carry flag, errno numbers) and the calls
  macOS does not have (`clock_gettime` from the counter and
  `gettimeofday`, `nanosleep` as `select`, `getcwd` with `F_GETPATH`,
  `/proc/self/environ` from dyld's `envp`, `futex` as `__ulock_wait/wake`).
- Threads are pthreads: `pthread_create` and `pthread_detach` are the only
  imports (dyld binds them); a raw `bsdthread_create` would need
  libpthread's own entry. The thread runs Kron's function on Kron's stack
  (x28) as `__thread_start`'s child does on Linux.
- The file is laid out as LLVM's linker lays out its own: `__PAGEZERO`,
  `__TEXT` (header page, code), `__DATA` (data, bss), `__LINKEDIT` (rebase,
  bind, exports, symbols, signature). PIE: karm records every `dq` of an
  address in .data and the rebase opcodes list them. The code signature is
  ad hoc and linker-signed (SHA-256 of each 4 KB page), what Apple silicon
  requires and what a linker writes.
- Windows on macOS come later (Cocoa through the Objective-C runtime);
  until then `window_open` fails and suggests `--target=web`.
- Verified without a Mac: llvm-objdump reads every field; the signature's
  hashes are recomputed; the 92 programs of the suite pass under
  an emulator on Claude's side (arm64 with unicorn, plus the XNU calls the shim
  makes, loading at a slide, threads in turns, sockets, fork and exec).
  **Done** when `MACTESTS.sh` passes on Gerson's Mac.

## Fixed 12-10-2026

- kasm: `db 0x51, 0x52` gave one byte -- the number skipper stopped at the
  `x` and ended the list, and every label after it moved. Test: `kasmdb`
  (ENCLIST). The compiler's own tables are written in decimal, so a seed
  built before the fix assembles them right.
- The modules are spliced into one unit (`kron_all.asm`), so a label
  defined in two modules silently resolves to the first: xwasm's `i_add`...
  took xarm's. Every module's labels must be unique; the NASM audit build
  reports only the global ones, so check with a scan of the labels before
  adding a module.
- karm: `neg qword [rel x]` and `cmp dword [reg + reg*4], imm` are not in
  kasm's set; karm uses a register for both.
- Code outside any function (a `}` too many) was taken as a TITAN module
  declaration, which swallowed every function after it; the error came
  later as "unknown function". Only a module keyword starts a module now;
  anything else there is a syntax error that asks about the `}`. Test:
  `test_stray_bad`.
- `std_window`: a key keeps the modifiers held when it went down; a quick
  Ctrl+C pressed and released within one frame read as a plain C, because
  Ctrl was already up when the program read the key (found testing the
  clipboard in a browser; the same on X11 and Windows).

## Fixed 11-10-2026 (codegen)

- Unary minus on a real took the integer path: the bits of the double were
  negated as an integer and converted, and a literal was never loaded, so
  `print(-1.5)` printed `-1.000000` and `var y: f64 = -2.25` held -1. Found
  while checking the manual's examples. Now `-x` of a real is `0.0 - x`,
  computed as a real. `test_fneg` is in all three suites.

## Fixed 10-10-2026 (kasm)

- `cmp`/`test byte [base + index +- N], imm`: the N and the scale were
  dropped, and `test` was encoded as `add` -- it wrote to memory.
- `mov [rel label + N], reg`: the +N was dropped, the store went to label.
- `[rel label + N]` took only `+` and a plain number right after the name:
  `[rel x + 32]` lost its 32 and `[rel x + 2*8]` meant x + 2.
  `test_kasmfix.asm` (in RUNTESTS' assembler list) checks all three.

## Known limits, still to fix

- A Kron function named like a NASM directive or macro (`at`, `struc`,
  `times`...) breaks the NASM audit build; the kasm build is unaffected.
- Text arguments are checked as handles, or as addresses between 64 KB and
  2^47: any other integer passed where a text is expected could still be
  read as one.
- The extern table still drops names past 512 without an error.
- Linux threads: a 1 MB stack each, with the fail block at its bottom --
  deep recursion inside a thread would overwrite it before the system
  notices. Waiting for the same thread twice crashes on Linux (its stack is
  released by the first wait); on Windows it is harmless.

- `failed();` alone is not a statement: `if failed() { }`.
- The web target runs about three to six times slower than native code:
  the x86-64 registers are wasm globals. Keeping them in locals inside a
  function would close most of it.
- macOS: tested in emulation only until MACTESTS.sh runs on a Mac.

- The `--dump` option writes nothing.
- kasm does not check undefined symbols.
- `jup_` prefixes on internal symbols.
