# Kron

Kron is a systems programming language designed for programs that must not crash on bad memory or race between threads, all while running natively without a runtime or garbage collector underneath.

It compiles to native code for Windows x86-64, Linux x86-64, Linux ARM64, macOS on Apple silicon, and to WebAssembly for the web—from a single source, with a single command.

## Key Features

* **Predictable Memory Safety:** Memory errors (like out-of-bounds arrays or invalid arena slices) become safe, catchable failures instead of crashes. No borrow checker, no garbage collector.
* **Concurrency Safe by Construction:** Data races are compile errors. Threads talk through channels (`std\\\_chan`), and the compiler rejects any thread that touches unshared global variables.
* **Fenced Raw Access:** Dangerous operations, raw memory addresses, and system calls only compile inside explicit `raw { }` blocks.
* **Zero Dependencies:** No C library (libc) and no heavy runtime to install. The executable talks to the system directly.
* **Built-in UI \& Graphics:** The standard library includes `std\\\_window` and `std\\\_ui` to draw hardware-accelerated interfaces and windows across all supported OSs and the web.

## Kron Tools

The Kron ecosystem is unified under a single command-line interface toolchain.

### Usage

```bash
krontools <command> \\\[options]
```

* `krontools build <file.kr>` - Compiles Kron source code into a native executable or WebAssembly.
* `krontools check <file.kr>` - Performs fast syntax and semantic analysis (used by editors).
* `krontools fmt <file.kr>` - Formats the source code according to Kron's style rules.
* `krontools lsp` - Starts the Language Server Protocol daemon for IDE integration (IntelliSense, go-to definition).
* `krontools run <file.kr>` - Compiles and immediately executes a program.

### Example

```kron
kron\\\_program
kron\\\_domain hello;
kron\\\_imports
kron\\\_definitions

fn main() {
    print("Hello from Kron!");
    return 0;
}
```

Compile and run:

```bash
krontools build main.kr --target=linux
./main
```

## Platform Support

* **Windows:** Native x86-64 executable.
* **Linux:** Native x86-64 and ARM64.
* **macOS:** Native Apple Silicon (M-series).
* **Web:** WebAssembly (`.wasm`), seamlessly integrated with an auto-generated HTML canvas and JS host.

## License

Kron is distributed under the terms of both the MIT license and the Apache License (Version 2.0).

See [LICENSE-APACHE](LICENSE-APACHE) and [LICENSE-MIT](LICENSE-MIT) for details.

