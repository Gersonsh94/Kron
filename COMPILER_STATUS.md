# KRON COMPILER — STATUS

Kron is a systems language for programs that must not crash on bad memory or
race between threads, and must run without a runtime underneath: native
code for Windows, Linux (x86-64 and ARM64) and macOS on Apple silicon, and
WebAssembly for the web, from one source.

The compiler is written in x86-64 assembly and, part by part, in Kron: the
lexer is Kron since 19-10-2026 (`lexer/lexer.kr`). It depends on no C
runtime, and kasm alone builds it.

---

## 0. STATE AT 19-10-2026

The compiler moves to Kron, one part per delivery (DECISIONS.md, "The
compiler moves to Kron, part by part"); from now on all development and
optimization is in Kron. Parts 1, 2 and 3:

| Area | What |
|---|---|
| The lexer | `lexer/lexer.kr` (632 lines) with `include/tokens.kr`; `lexer/lexer.asm` is now only the door to it (the old entry names, registers kept) |
| The parser | `parser/parser.kr` and `parser_state.kr`, `parser_stmt.kr`, `parser_expr.kr`, `parser_titan.kr`, `parser_ng.kr` (6,343 lines) with `include/ast.kr`; `parser/parser.asm` (10,079 lines of assembly before) is now only its door, 179 lines |
| The semantic pass | `semantic/semantic.kr` (971 lines); `semantic/semantic.asm` (1,676 lines of assembly before) is now only its door, 135 lines |
| `--module` | `kronc part.kr --module` writes `part_kr.asm`: the functions alone, no runtime, no entry; its globals carry its name; it refuses `main`, `export` and globals computed at start; `extern "kronc"` names a function of the compiler outside the part |
| The build | `KRONPARTS.bat` makes the parts in Kron again (lexer, parser); BUILD.bat and BOOTSTRAP.bat call it with stage1 and stage2, so the fixpoint covers them |
| kasm | a label defined twice is an error; `resb`/`resq` outside `.bss` are zeros; `1e5` in `dq` |
| Language | a global array given values keeps them (`var t: [i64; 4] = [1, 2, 3, 4];`), as data; a character Kron does not use, and a text with no closing quote, are errors with their line and column; a parameter after a `ptr<T>` one no longer takes its element width; a function of more than 250 statements no longer crashes the compiler |

Still in assembly, in the order they come: the code generator, kasm and
the writers (PE, ELF, Mach-O, wasm, ARM64), main.

Checked: the Kron lexer gives the same tokens as the assembly one, the
Kron parser the same tree, tables and errors, and the Kron semantic pass
the same errors, positions and hints, on every `.kr` file of the
repository and on thousands of generated files; `-S` of every test is the
same text. Tests: Windows 104 plus the debug test, Linux 103, ARM64 103,
web 99, macOS (emulated) 102, 38 refused programs.

## 0b. STATE AT 18-10-2026

Since the last count (section 1), one delivery added:

| Area | What |
|---|---|
| C interop | `extern` blocks, `--lib` (.dll .so .dylib), `fn export`, `c_fn`, `c_call` |
| Phones | `--target=android`, `--target=ios`, `std_app.kr`, `templates/` (Android, iOS, React Native) |
| Language | struct values, `ptr<S>` fields, `list<S>`, generics, module names and `as`, zero-initialised locals |
| Speed | web 2-4x faster (registers as wasm locals), fewer pushes, constant shifts |
| Hardware | `std_gpu` (Vulkan, Metal, WebGPU), `std_shader` (KSL to SPIR-V, MSL, WGSL), `std_math3d`, `std_audio`, `std_gamepad`, JPEG in `std_image`, `std_json`, mouse capture and held keys in `std_window` |
| Tools | `--debug` and `std_debug.kr`; VS Code extension 0.5.0 (debugger, builds for every target); `GETTING_STARTED.md`; `GPUTESTS.bat` |

Tests: Windows 101 plus the debug test, Linux 100,
ARM64 100, web 96, macOS (emulated) 99, 35 refused programs; the GPU tests
(`tests/gpu`) pass on an RTX 3060 (Windows), Mesa's software Vulkan and
WebGPU (Dawn).

---

## 1. CODEBASE (verified line counts, 12-10-2026)

| File | Lines | Role |
|---|---:|---|
| `codegen/codegen.asm` | 15,693 | x86-64 code emission, the runtimes, the register allocator |
| `kasm.asm` | 7,712 | Kron's own x86-64 assembler |
| `karm.asm` | 5,259 | Kron's own ARM64 assembler |
| `xarm.asm` | 4,762 | x86-64 text -> ARM64 text, with the Linux and the macOS shims |
| `main.asm` | 4,641 | Driver, CLI, pipeline, ELF writers, the web page |
| `xwasm.asm` | 3,679 | x86-64 text -> WebAssembly module |
| `lexer/lexer.kr` | 632 | Tokenizer, in Kron (since 19-10-2026; with `include/tokens.kr`, 198) |
| `lexer/lexer.asm` | 101 | The door to it, by hand; `lexer/lexer_kr.asm` is made by `kronc --module` |
| `parser/*.kr` | 6,343 | Recursive-descent parser, AST construction, in Kron (since 19-10-2026; with `include/ast.kr`, 160) |
| `parser/parser.asm` | 179 | The door to it, by hand; `parser/parser_kr.asm` is made by `kronc --module` |
| `semantic/semantic.kr` | 971 | Semantic analysis, in Kron (since 19-10-2026) |
| `semantic/semantic.asm` | 135 | The door to it, by hand; `semantic/semantic_kr.asm` is made by `kronc --module` |
| `macho.asm` | 1,235 | Mach-O executable for macOS, with its ad-hoc signature (SHA-256) |
| `runtime/runtime.asm` | 784 | Runtime support |
| `pe_writer.asm` | 765 | PE32+ writer |
| `linker/linker.asm` | 658 | Linker |
| `krn.asm` | 378 | KRN container writer |
| `include/kron_types.inc` | 664 | Token, AST and type constants |
| `include/win64_api.inc` | 122 | Win64 API declarations |
| `include/web_host.inc` | 1,661 | `web/kron_web.js`, carried by the compiler (generated by `web/make_host.kr`) |
| **Total (assembly)** | **~48,500** | twelve modules and their doors (the parser and the semantic pass left it 19-10-2026) |

Beside the compiler: `web/kron_web.js` (941 lines, the host of the web
target), `web/kron_serve.kr` (a web server in Kron) and 21 standard library
modules (`std_*.kr`, 11,849 lines).

## 1b. KASM — THE ASSEMBLER

Kron assembles its own output. `kasm.asm` is a two-pass x86-64 assembler that
consumes the text the code generator produces and emits machine code bytes,
removing the need for NASM.

Pass one records where every label lands; pass two emits bytes with all
references resolved.

### Verified against NASM

| Layer | Result |
|---|---|
| Integer core (26 instructions) | byte-identical, except jumps use the long form |
| SSE double precision (11 instructions) | byte-identical |
| RIP-relative data references | correct; differs only by a deliberate alignment choice |
| Flat image, code + padding + data | produced and verified |
| Data strings and qwords (`db "text",0`, `dq n`) | correct |
| `.bss` reservations (`resb`, `resq`) | tracked, not emitted |
| External symbols | recorded with their call sites for the linker |

The jump difference is a size choice, not a correctness one: `0F 84 rel32` and
`74 rel8` both branch to the same place. Implementing the short form requires
iterating the layout until addresses stabilise, since shortening one jump shifts
everything after it.

The RIP difference was measured precisely: every displacement was off by exactly
12 bytes, which is the gap between NASM's 4-byte data alignment and kasm's
16-byte alignment. The encoding itself is identical.

A worked example: for `lea rax, [rel greeting]` at offset 0x08, kasm emitted
`48 8D 05 21 00 00 00`. The instruction ends at 0x0F, the displacement is 0x21,
so the target is 0x30 — exactly where the string was placed. Calls to external
symbols emit `E8 00 00 00 00` with the site recorded, since only the linker
knows where an imported function lands.

### Not yet handled

- Short-form jumps: purely a size optimisation
- Emitting a finished executable: kasm produces the bytes and the external
  reference table, but building a PE import table from them is the linker's job

kasm covers every instruction form the code generator emits, and pe_writer
(Windows), the ELF writer (Linux) and macho (macOS) write the executables.
For hand-written flat binaries it also takes `org`, `align`, `times` with an
expression, and data whose values are expressions of labels (the boot
sector of BUILDOS.bat is assembled this way).

## 1b2. KARM — THE ARM64 ASSEMBLER

`karm.asm` reads ARM64 assembly text, as kasm does for x86-64: ARM's operand
syntax, kasm's directives (`section`, `db`/`dw`/`dd`/`dq`, `resb`..`resq`,
`times`, `align`, `equ`), local labels, comments with `;` or `//`. Two passes;
the image is code, then data, then bss, at a fixed base, so every address is
final in pass two and nothing is left for a linker.

```
kronc.exe prog.s --assemble --target=linux-arm64      # AArch64 ELF, no extension
```

- About 95 instruction forms: integer arithmetic and logic (bit-mask
  immediates included), shifts, conditional select, extensions, every load and
  store addressing mode, pairs, exclusives, branches, `adr`/`adrp`/`adrl`,
  `svc`, `dmb`, and the scalar real instructions (d and s registers).
- `mov Xd, #any 64-bit value` takes one to four words; pass one records how
  many per occurrence, so a constant defined later still fits.
- **Verified:** 1523 instructions byte for byte against the GNU ARM assembler
  and linker (`arm_corpus.s`, reference in `tests\expected\arm_corpus.bin`);
  `arm_check.s` runs on ARM64 and checks constants, labels and data itself.
  `ARMTESTS.bat` runs both under QEMU. kasm assembles karm in the bootstrap,
  and the karm it builds gives the same bytes as the one NASM builds.
- Also: q registers in loads and stores, `vN.16b` with mov/and/orr/eor,
  `vN.2d` with fadd/fsub/fmul/fdiv, `fcvtns`, `prfm`, `dc civac`, and reals
  in `dq` (`dq 1.5`). A data line takes any number of items; an instruction
  with more than six operands is refused instead of losing the rest.

## 1b3. XARM — KRON PROGRAMS ON ARM64

```
kronc.exe program.kr --target=linux-arm64            # AArch64 ELF
kronc.exe program.kr --target=linux-arm64 -S         # the ARM64 assembly
```

`xarm.asm` lowers the x86-64 text codegen writes for Linux to ARM64 text,
instruction by instruction, keeping the x86-64 machine (register map, an
8-byte stack in x28, the flags) so the code generator and the runtime need
nothing of their own. karm assembles the result. The whole design and why
it was chosen are in DECISIONS.md, Platforms, step 2.

- Errors name the line of the generated text, what was wrong and the
  instruction: an x86-64 form with no ARM64 lowering is refused, never
  guessed.
- Verified: LINUXTESTS' 74 programs and the four slow graphics tests, same
  output on ARM64 under QEMU as on x86-64 (`ARMTESTS.bat`).

## 1b4. XWASM — KRON PROGRAMS ON THE WEB

```
kronc.exe program.kr --target=web          # program.wasm, program.html, kron_web.js
kronc.exe program.kr --target=web -S       # the x86-64 text xwasm reads
```

`xwasm.asm` lowers the same Linux x86-64 text to a WebAssembly module, as
xarm does for ARM64. The x86-64 machine is kept: its sixteen registers are
wasm globals (i64), the xmm registers v128 globals, the stack is in linear
memory, a code address is the index of its instruction and a slot of the
function table. Each non-local label starts a wasm function; the local
labels something jumps to are blocks of a loop with a `br_table`. The flags
are tracked at compile time by what set them. Three passes: which labels are
jumped to, where everything goes, the module.

The module imports `env.syscall` (Linux x86-64 numbering) and `env.memory`,
shared, so threads -- one instance of the module per web worker, over the
same memory -- see one memory. `.data` is a passive segment `kron_start`
copies in. `kron_thread(stack)` is the entry a thread starts at.

`web/kron_web.js` answers the calls: files (the real disk under Node.js,
folders in memory in a browser), time, memory, threads (`clone` starts a
worker, `futex` is `Atomics.wait`/`notify`), and from 1000 up the page's
canvas for `std_window`. Call 1100 answers 2: the program can tell it runs on
the web.

Verified: WEBTESTS' 90 programs give the same output under Node.js as on
Linux, threads included; in Chromium (Playwright), `std_window` and `std_ui`
programs draw, take keys, clicks and the clipboard, with and without the
COOP/COEP headers from the server.

## 1b5. MACHO — KRON PROGRAMS ON macOS

```
kronc.exe program.kr --target=macos        # an arm64 Mach-O, signed ad hoc
```

The ARM64 program xarm makes for Linux, with another shim: `__sysx` answers
each Linux call from XNU (`svc #0x80`, the macOS numbers, the flags, the
structures and the errors converted), `__mac_main` builds the stack `_start`
expects from what dyld passes, and threads are pthreads (the one import,
bound by dyld) with `__ulock_wait`/`__ulock_wake` for the futex. karm puts
the code and the data on separate 16 KB pages and records every `dq` that
holds an address; `macho.asm` writes the file: the load commands, the
rebase and bind opcodes, the symbols, and the code signature (SHA-256 of
every 4 KB page), laid out as LLVM's linker lays out its own.

Verified here: the structure with `llvm-objdump`, the signature's hashes
recomputed, and the 92 programs of the suite run, on Claude's side, under an
emulator of arm64 and of the XNU calls the shim makes, which loads the file
at a slide (rebasing tested), binds the imports and runs threads in turns.
On a Mac: `MACTESTS.bat` builds the suite, `MACTESTS.sh` runs it there.

## 1c. KRN — THE NATIVE CONTAINER

`jpx.asm` wraps the bytes kasm produced in Kron's own executable format,
specified in `KRN_FORMAT.md`. Verified end to end:

```
kronc.exe program.asm --assemble --krn   ->  program.krn
```

A produced file was checked field by field against its own header:

| Field | Value |
|---|---|
| Magic | `4A 50 58 21` = `KRN!` |
| Architecture / kind / ring | x86-64 / application / ring 3 |
| Entry, image base, stack | 0x1000, 0x400000, 0x100000 |
| Code section | declared at offset 256, 50 bytes, read+execute |
| Data section | declared at offset 320, 16 bytes, read+write |
| BSS section | reserved in memory, absent from the file |
| Signature | declared at 336, and `JSIG` found there |

Reading the bytes at the declared offsets returned exactly what kasm generated:
the function prologue at 256 and the two data values at 320.

What KRN carries that PE and ELF cannot express: the privilege ring in the
header, a capability mask, a requirement table for TITAN modules, and a
signature block that is part of the structure rather than bolted on afterwards.

The signature currently uses algorithm 1 from the specification: an FNV-1a
digest over everything preceding the block. That gives integrity — tampering is
detectable — but not authenticity, which needs a real signing key. The block
already reserves the fields for `ed25519` and post-quantum algorithms.

## 2. PIPELINE

```
source.kr -> expand -> lexer (Kron) -> parser -> AST -> semantic -> codegen -> x86-64 text
   x86-64 text -> kasm -> PE (Windows) or ELF (Linux x86-64)
   x86-64 text -> xarm -> ARM64 text -> karm -> ELF (Linux ARM64) or Mach-O (macOS)
   x86-64 text -> xwasm -> WebAssembly module (the web)
```

No external tool in any path, the compiler's own build and its tests
included: since 18-10-2026 neither NASM nor GoLink is used anywhere (see
DECISIONS.md, "Without NASM and GoLink").

```
kronc.exe app.kr                          # Windows .exe (default)
kronc.exe app.kr --target=linux           # Linux x86-64, no extension
kronc.exe app.kr --target=linux-arm64     # Linux ARM64
kronc.exe app.kr --target=macos           # macOS on Apple silicon
kronc.exe app.kr --target=web             # app.wasm + app.html + kron_web.js
kronc.exe app.kr --target=krn             # KRN, a Kron system
kronc.exe app.kr --target=bare            # flat binary, kernel
```

| Target | Code | Talks to the system through | Tested with |
|---|---|---|---|
| Windows | kasm | kernel32 (imports in the PE) | RUNTESTS |
| Linux x86-64 | kasm | `syscall`, no libc | LINUXTESTS (WSL) |
| Linux ARM64 | xarm + karm | `svc #0` through `__sysx` | ARMTESTS (QEMU) |
| macOS | xarm + karm + macho | `svc #0x80` through the macOS `__sysx`; pthread_create | MACTESTS (a Mac); an emulator on Claude's side |
| web | xwasm | `env.syscall`, answered by `kron_web.js` | WEBTESTS (Node.js); Chromium |
| krn / bare | kasm | VGA, ports | by hand |

Linux, Linux ARM64, macOS and the web run the same program, the Linux one:
`target_os()` is 2 on all four, and `syscall(n, ...)` takes the Linux x86-64
numbers on all four. Call 1100, which Linux does not have, tells them apart
(1 macOS, 2 the web): `os_name()` uses it.

**Calling convention:** parameters are passed in `rcx, rdx, r8, r9` (the
Windows x64 convention) on every target. Kron-to-Kron calls are
self-consistent everywhere; the shims are the only place that talks to
another convention (pthread_create on macOS).

---

## 3. LANGUAGE FEATURES

### Working

**Added 12-10-2026**

- `text`, `list<T>`, `map<T>` as types: `==` compares texts, `+` joins texts
  and numbers, `l[i]` and `m[key]` read and write, `for x in l`, `[a, b]`
  literals, `print` of whole collections; `var x = f()` takes f's type.
- Up to four results: `-> (T1, T2)`, `var a, b = f();`, `a, b = f();`, `_`.
- Functions as values: `fn(T) -> R` types, function names as values,
  `fn(x: T) -> R { ... }` expressions that keep copies of the variables
  they use (a record of the code and the copies, the record passed as a
  hidden last argument). Calling a function that does not exist is an error.
- Failure traces: `print_fail` names the function and line of the failure
  and every call that led there, from tables the program carries; nothing
  runs while nothing fails.
- xmm8-xmm15 in kasm and the register allocator (ten registers for reals),
  `vec4_*` four `f32` per instruction, `vec2_div`, `slice<f64>`.


**Core**
- `fn` functions with up to 4 parameters and a return value
- Nested calls in argument position: `add(triple(5), 5)`
- `var` / `const` declarations
- `if` / `else`, `while`, `loop`, `break`, `continue`, `return`
- Arithmetic (`+ - * / %`), comparison, logical operators
- `print(expr)` — decimal integer output
- Single-line (`//`) and block (`/* */`) comments
- Decimal and hexadecimal (`0x…`) literals

**Types**

| Name | Notes |
|---|---|
| `int8` `int16` `int32` `int64` | signed |
| `uint8` `uint16` `uint32` `uint64` | unsigned |
| `real32` `real64` | double precision, SSE codegen |
| `hardware_bit` | boolean |
| `utf8_stream` | string |
| `hardware_void` | no return value |

Struct fields occupy their declared width and are laid out **packed**, so a struct
mirrors the byte layout the hardware expects. Local scalar variables still occupy a
full 8-byte stack slot.

**Arrays**
```kron
var buffer: [int32; 64];
buffer[0] = 100;
var x: int32 = buffer[i];
```
Packed: each element takes its type's width (1, 2, 4 or 8 bytes; `[f32; N]`
four), in locals, globals and parameters. Every index is bounds-checked
against the declared size; an array passed to a parameter must have its
element type (semantic error kind 9).

**File-scope variables**
```kron
var counter: int32 = 100;   // outside any function

fn bump(n: int32) {
    counter = counter + n;  // persists across calls
    return counter;
}
```
Emitted as a labelled cell in `.data` and reached with `[rel __g_name]`. Arrays
and structs at file scope reserve their whole extent. No new syntax: the same
`var` declaration becomes a global purely by being outside a function.

**Floating point**
```kron
var a: real64 = 3.5;
var c: real64 = 0.0;
c = a / 1.25;
print(c);            // 2.800000
c = a * 2;           // integers are converted with cvtsi2sd
```
Whether an expression is floating point is decided statically before emitting,
so a whole subtree uses one register set: doubles live in `xmm0`, integers in
`rax`. Literals are emitted as `dq` constants and assembled by NASM. Printing
scales by 1e6 and rounds, so values print like `printf("%f")`.

**Structs**
```kron
struct Point {
    x: int32;
    y: int32;
}

var p: Point;
p.x = 10;
print(p.y);
```
Field offsets are resolved at compile time and accessed at the declared width:
a `uint8` field emits `movzx rax, byte [rbp-N]`, a `uint16` emits `mov [rbp-N], ax`.
Layout is packed, which is what hardware structures require:

```kron
struct IdtEntry {
    offset_low: uint16;    // +0
    selector: uint16;      // +2
    ist: uint8;            // +4
    type_attr: uint8;      // +5
    offset_mid: uint16;    // +6
    offset_high: uint32;   // +8
    reserved: uint32;      // +12
}                          // 16 bytes, exactly as the processor expects
```

**Pointers**
```kron
var p: int32 = &x;        // address-of
print(*p);                // dereference
*p = 99;                  // write through pointer

var base: ptr<uint32>;    // typed pointer
base = &buf;
poke32(base + 1, 200);    // + 1 advances 4 bytes, not 1
```
A `ptr<T>` variable carries the width of `T`, so `+` and `-` on it count
ELEMENTS: the compiler emits `imul rax, rax, sizeof(T)` on the offset.
Plain integer variables are never scaled.

**Hardware primitives**

| Primitive | Emits | Purpose |
|---|---|---|
| `outb(port, value)` | `out dx, al` | Write to an I/O port |
| `inb(port)` | `in al, dx` | Read from an I/O port |
| `poke(addr, value)` | `mov [rdx], rcx` | Raw 64-bit memory write |
| `peek(addr)` | `mov rax, [rax]` | Raw 64-bit memory read |
| `poke8/16/32(addr, v)` | `mov [rdx], cl/cx/ecx` | Exact-width write |
| `peek8/16/32(addr)` | `movzx` / `mov eax` | Exact-width read |
| `asm { "…"; }` | verbatim | Escape hatch for any instruction |

These are what make Kron a systems language: an IDT, a keyboard driver or a
page allocator can be written *in Kron*, without extending the compiler.

**Symbol export (interoperability)**
```kron
fn global_visible compute(x: int32) { … }
```
Emits `global compute`, making the symbol callable from any language. Also
accepted: `inter_cluster_export`. `domain_isolated` and `enclave_hidden` parse
but are not yet enforced.

### Not implemented

- Per-target calling conventions (System V vs Windows x64): only inside the
  shims.
- A function kept in a struct field cannot be called as `s.field(...)`:
  the compiler refuses it and says to call it through a variable.
- `failed();` alone as a statement: write `if failed() { }` or keep the
  value.
- Windows on macOS (`std_window`): `window_open` fails and says so.
- On the web: running other programs and the network; files are in memory
  and each thread has its own descriptors.

---

## 4. TITAN MODULES — 31 of 31 recognized

All 31 modules parse and emit real output. They fall into two tiers.

### Tier A — semantic codegen (4 modules)

The compiler understands what the module describes and emits matching machine code.

| Module | Keyword | Emits |
|---|---|---|
| M02 Kernel Boot | `boot_sequence` | `__boot_<name>` — executable routine applying initial CPU register state |
| M04 Hardware Interrupts | `interrupt_service_routine` | `__isr_<name>` — real ISR ending in `iretq`, plus `__isrvec_<name>` |
| M08 Process Scheduler | `scheduler_domain` | config tables + `__sched_<name>_switch` context-switch routine |
| M09 Syscall Table | `syscall_table` | `__sys_<name>_table` dispatch table + `__svc_*` handlers, ending in `iretq` or `sysret` depending on the declared `mechanism` |

### Tier B — declarative capture (27 modules)

Configuration becomes exported data; code blocks become exported routines.

Emitted per module:
```
__cfg_<name>_count   : dq n
__cfg_<name>_keys    : dq ptr…   property names
__cfg_<name>_texts   : dq ptr…   values as strings
__cfg_<name>_nums    : dq n…     numeric values (0 when non-numeric)
__cfg_<name>_<block> : executable routine per code block
```

Two additional modules emit purpose-built tables instead:
- **M01 ISA Definition** (`kron_isa_dynamic`) → `__isa_<name>_opcodes` / `_names` / `_count`
- **M03 Memory Management** (`mmu_configuration`) → `__mmu_<name>_levels` (level/entry pairs)

### Block classification rule

Inside a declarative module, a nested block is **code** when either:

1. its name starts with `on_` — event handler, or
2. it carries a parameter list: `name(args) { … }` — routine

Any other block is **data**: its `key = value` pairs are captured into the tables.
This rule is uniform across all modules; there are no per-module exceptions.

### Module inventory

**Level 1 — Silicon (7)**
`kron_isa_dynamic`, `boot_sequence`, `mmu_configuration`,
`interrupt_service_routine`, `dma_channel_controller`, `hardware_driver`,
`kernel_architecture`

**Level 2 — OS ecosystem (11)**
`scheduler_domain`, `syscall_table`, `security_model`, `filesystem_volume`,
`network_kernel`, `power_manager`, `kron_hypervisor`, `package_manager`,
`executable_loader`, `living_compiler`, `human_machine_interface`

**Level 3 — Compute and simulation (6)**
`tensor_accelerator`, `neural_network`, `ai_inference_accelerator`,
`gpu_shader_pipeline`, `kron3d_context`, `physics_world_simulation`

**Level 4 — Exotic (10)**
`quantum_circuit`, `dna_storage_volume`, `photonic_tensor_core`,
`orbital_mesh_topology`, `plasma_confinement_reactor`, `nano_swarm_mesh`,
`relativistic_time_anchor`, `zero_trust_quantum_fabric`, `neuromorphic_mesh`,
`synthetic_wetware_mesh`

Plus three structural models: `execution_model`, `deployment_model`, `security_ring`.

---

## 5. DEPENDENCIES AND INTEROPERABILITY

The distinction that governs design decisions:

- **Dependency** — the compiler cannot work without something external. Avoided.
- **Interoperability** — Kron code *can* talk to others when asked. Pursued.

### Current state

| Aspect | Status |
|---|---|
| C runtime | None. No `malloc`, `printf`, `memcpy`. Only `kernel32.dll` in hosted mode |
| Freestanding output | Working — `--bare` emits code with zero externs |
| Binary formats | `linker.asm` can emit PE32+ and ELF64 |
| ABI | Follows Win64 / System V, so any language can call Kron functions |
| Symbol export | `global_visible` marks functions as externally callable |

### Remaining external dependencies

None to build: kronc assembles and links everything itself, the compiler
included. `krun.bat` boots a kernel through Multiboot1 (GRUB, or `qemu
-kernel`); `BUILDOS.bat` makes a disk image with its own 512-byte MBR, which
needs neither.

QEMU is a test machine, not a dependency.

---

## 6. WHAT UNBLOCKS THE MOST NEXT

Ordered by how much each one enables:

1. **Done 18-10-2026**: kasm and the executable writers replaced NASM and
   GoLink everywhere, tests included; the own MBR boots (BUILDOS.bat).
2. **Under way since 19-10-2026**: the compiler in Kron, part by part. The
   lexer is done.
3. **UEFI** — the MBR covers BIOS machines; new PCs boot through UEFI.
4. **Parameters beyond the fourth** — the ABI requires passing them on the stack.
5. **Register allocation** — everything currently goes to the stack; this is
   where the most performance is left unclaimed.

---

## 7. DEFECTS FIXED (previously latent)

| Defect | Effect |
|---|---|
| Hex literal detection unreachable | `0x10` tokenized as `0` + `x10`; `.check_hex` was dead code |
| `outb` operand inversion | An extra `xchg` swapped port and value |
| Variable table corruption after arrays | `cg_add_var` advanced the count by N but wrote one entry, leaving garbage pointers |
| Return label ids clobbered | `emit_cstr` destroyed `rax` between `pop` and use, producing labels like `.__ret_44083450` |
| Four keywords never registered | `tensor_accelerator`, `neural_network`, `ai_inference_accelerator`, `security_ring` declared but absent from `keyword_table` |
| Call arguments discarded | Parser ran `consume_balanced_parens` on both parameter and argument lists; codegen emitted a bare `call` with no argument setup, so parameters silently received nothing |
| Float literal label id clobbered | `new_label`'s result was destroyed by an intervening `emit_cstr`, so the constant was defined under a garbage name while the load referenced the right one |
| Wrong shadow space in the expansion pass | 40 bytes instead of 32 left `rsp` misaligned at the nested `read_file` call, faulting inside `CreateFileA` |
| Generated control-flow labels reset NASM scope | `L11:` was emitted as a non-local label, so a function's `.__ret_N` was reassigned to it and every `return` after an `if`/`while` jumped to an undefined symbol. Latent until a function combined control flow with a later `return` |
| Global label placed inside a local scope | `par_type_width` was defined between `parse_type` and its own `.arr_type`, silently reassigning every following local label to a different owner and breaking ~100 jumps |
| Six integer types rejected by `parse_type` | `uint8`, `uint16`, `uint32`, `uint64`, `int8` and `int16` existed in the lexer with their own constants but were never accepted in a type position |
| Type token walked as an AST node | `cg_count_vars` recursed blindly into `AST.left`, which for struct-typed declarations holds a TOKEN pointer; it read source text as a tree and faulted. Latent because that field was always zero before |
| Fields of a global struct at offset 0 of the frame | `gq.x = 5` wrote `[rbp-0]`, the saved frame pointer: global structs now go through `lea rdx, [rel __g_NAME+OFF]` |
| f32 struct field written as eight bytes | it overwrote the next field: `movss` with `cvtsd2ss` / `cvtss2sd` now |
| Signed narrow fields zero-extended | an `i8` field holding -1 read 255 |
| `&g[i]` of a global array | the index was dropped |
| Globals known only once declared | a function using a global declared further down read it with the wrong width: globals are recorded in the pre-pass |
| `test dword [rel x], imm` in kasm | encoded as an add that wrote to `x` |
| String literals past ~1000 bytes | cut by the assemblers' line buffers: literals are written 64 bytes a line |
| `WriteFile` fifth argument in the wrong slot | `__print_int` wrote `lpOverlapped` at `[rsp+32]` *before* `sub rsp, 8`, leaving the real slot with stack garbage, and misaligned the stack at the call. Latent until argument passing dirtied that region |

---

## 8. VERIFIED EXAMPLES

**Arrays and pointers** — compiled, linked and executed:
```kron
fn main() {
    var buffer: [int32; 8];
    buffer[0] = 100;
    buffer[1] = 200;
    print(buffer[0]);   // 100
    var x: int32 = 42;
    var p: int32 = &x;
    *p = 99;
    print(x);           // 99
    return 0;
}
```

**IDT entry built in pure Kron** — a 16-byte hardware structure with 1, 2 and
4-byte fields at exact offsets:
```kron
poke16(base,      handler);   // offset low
poke16(base + 2,  0x0008);    // kernel code selector
poke8 (base + 4,  0);         // IST
poke8 (base + 5,  0x8E);      // present, ring0, interrupt gate
poke32(base + 8,  0);         // offset high
```

**Functions with parameters** — compiled, linked and executed, printing 42, 21, 123, 20:
```kron
fn add(a: int32, b: int32) {
    var result: int32 = 0;
    result = a + b;
    return result;
}

fn main() {
    print(add(10, 32));        // 42
    print(add(triple(5), 5));  // 20 — nested call in argument position
    return 0;
}
```

Calling convention: arguments arrive in `rcx`, `rdx`, `r8`, `r9`; the callee spills
them into stack slots on entry; callers reserve 32 bytes of shadow space.

**Structs** — compiled, linked and executed, printing 10, 25, 35, 300, 400, 25, 1.
The final two values confirm field independence: writing `p.x` leaves `p.y` and
`r.left` untouched.

**Packed struct layout** — compiled, linked and executed, printing
4660, 8, 142, 1, 305419896, 200, 100, 40000, 4000000, 100, 40000. The final two
confirm that writing a single-byte field leaves its byte-adjacent neighbours intact.

**Scaled pointer arithmetic** — compiled, linked and executed, printing
100, 200, 400, 100, 200, 11. A `ptr<uint32>` and a `ptr<uint8>` walk the same
buffer in 4-byte and 1-byte steps respectively, and a plain integer is unaffected.

**Floating point** — compiled, linked and executed, printing 4.750000, 2.250000,
4.375000, 2.800000, 7.000000, 8. The fourth confirms correct rounding (3.5/1.25 is
not exactly representable), the fifth mixed int/float arithmetic, and the last that
integer arithmetic is untouched.

**Dynamic memory, written in Kron** — `kron_alloc.kr` implements a bump
allocator over a static pool with a free list threaded through released blocks,
using only globals, typed pointers and sized memory access. Compiled, linked and
executed, printing 4096, 4032, 1234, 5678, 0. The last value confirms free-list
reuse: after releasing a block, the next request of the same size gets the same
address back. This is library code, not compiler code.

**Module inclusion** — `acquire_domain "file.kr";` splices another file's text
in before lexing, so a library can be written once and reused:

```kron
acquire_domain "std_mem.kr";

fn main() {
    print(str_length(a));
    return 0;
}
```
One level deep: directives inside an included file are not expanded, which keeps
the pass finite without cycle detection. An unreadable file is skipped silently.

**Standard library, written in Kron** — the `std_*.kr` modules provide memory
(`mem_copy`, `mem_set`, `mem_compare`, `mem_move`), strings (`str_length`,
`str_copy`, `str_compare`, `str_concat`, `str_find_byte`) and arithmetic
(`abs_value`, `min_value`, `max_value`, `clamp_value`, `power_of`). Verified
executing, printing 3, 0, -3, 5, 42, 19, 1024. No compiler changes were needed.

**Multiple output targets** — one source, verified producing three different
binaries: `global main` + `ExitProcess` for Windows, `global _start` + `syscall`
for Linux with no libc, and `global kmain` + `hlt` for bare metal.

**Freestanding kernel** — `--bare` output has no externs, entry point `kmain`,
VGA output, `cli`/`hlt` on exit.
