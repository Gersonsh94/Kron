# Getting started with Kron

## 1. What you need

To write and run programs, and to build the compiler itself: **`kronc.exe`
and the `std_*.kr` files next to it**. Nothing else -- no C compiler, no
assembler, no linker, no runtime, no SDK. The programs Kron builds need
nothing installed either.

Optional, for the editor and the tests:

| For | Install |
|---|---|
| The editor | VS Code, then the extension in `kron-vscode\kron-lang` (section 3) |
| `LINUXTESTS.bat`, `ARMTESTS.bat` | WSL (`wsl --install`); for ARM64 also `wsl sudo apt install -y qemu-user` |
| `WEBTESTS.bat` | Node.js 18 or later |
| `GPUTESTS.bat` | a graphics card driver with Vulkan (any NVIDIA, AMD or Intel from the last ten years) |

## 2. A first program

`hello.kr`:

```
kron_program
kron_domain hello;
kron_imports
acquire_domain "std_text.kr";
kron_definitions

fn main() -> i64 {
    var name: text = "world";
    say("hello, " + name);
    return 0;
}
```

```
kronc.exe hello.kr          hello.exe, next to it
hello.exe
```

A program goes next to the compiler, or in a folder of its own with the
`std_*.kr` files it imports copied beside it: a module is looked for next to
the program first, then where the compiler runs.

## 3. The editor

In VS Code: Ctrl+Shift+P, "Developer: Install Extension from Location...",
choose `kron-vscode\kron-lang`, then "Developer: Reload Window".

| Key | |
|---|---|
| F5 | debug: build with `--debug` and run; breakpoints, steps, variables |
| Ctrl+F5 | build and run |
| Ctrl+Alt+B | build |
| Ctrl+Shift+P, "Kron: Build for Another System..." | Linux, ARM64, macOS, web, Android, iOS |

Errors are underlined on every save, with their hint.

## 4. Other systems

```
kronc.exe prog.kr --target=linux -o prog            Linux x86-64
kronc.exe prog.kr --target=linux-arm64 -o prog      Linux ARM64 (Raspberry Pi, servers)
kronc.exe prog.kr --target=macos -o prog            macOS, Apple silicon
kronc.exe prog.kr --target=web                      prog.wasm, prog.html, kron_web.js
kronc.exe prog.kr --lib                             prog.dll (and --target=... for .so, .dylib)
kronc.exe prog.kr --lib --target=android            libprog.so for an Android app
kronc.exe prog.kr --lib --target=ios                prog.dylib for an iOS app
```

Bare metal, with no operating system underneath (QEMU or a real PC):

```
BUILDOS.bat prog.kr     kron_os.img: Kron's own MBR and the program as kernel
krun.bat prog.kr        the program as a Multiboot kernel, started in QEMU
```

Web pages are opened from a server: build `web\kron_serve.kr` once
(`kronc.exe web\kron_serve.kr -o kron_serve.exe`), run it in the folder of
the page and open `http://localhost:8000/prog.html`.

## 5. Where to go next

| | |
|---|---|
| `Documentation\MANUAL_EN.md` | the language and the library |
| `templates\app.kr` and `templates\README.md` | an app for phones |
| `calculator.kr` | a program with windows and controls |
| `RUNTESTS.bat` | the test suite (`/slow` adds the 3D rendering programs) |
| `GPUTESTS.bat` | the graphics card, the window, the sound, the controllers |

## 6. When the compiler changes

After an update of the compiler's sources (the `*.asm` files, and the
parts written in Kron, `lexer\lexer.kr`, `parser\parser.kr` with the
files it imports, `semantic\semantic.kr`, and `codegen\codegen.kr` with
the files it imports), `BOOTSTRAP.bat` builds it
three times with itself and checks that the last two are identical;
`SEED.bat` then keeps the result as the seed, and `BUILD.bat` installs it
as `kronc.exe`. The parts in Kron become assembly text (`lexer_kr.asm`,
`parser_kr.asm`, `semantic_kr.asm`, `codegen_kr.asm`)
with `kronc --module`; `KRONPARTS.bat` does that for all of them, and the
two scripts call it on their own.
