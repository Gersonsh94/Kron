# Kron for VS Code

Language support for Kron while its own IDE is being built.

## What it does

- **A debugger**: F5 builds the current file with `--debug` and runs it under the
  debugger. Click left of a line number to set a breakpoint; when the program
  stops there, the Variables panel shows the locals of every function on the
  stack and the globals of your files -- numbers, reals, texts, lists, maps,
  arrays and structs, opened field by field -- and F10 (next statement), F11
  (step into a call) and Shift+F11 (step out) move on. Hovering a name while
  stopped shows its value. The program's output goes to the Debug Console.
  How it works: a debug build calls the debugger before every statement of
  your own files (the std_*.kr modules run at full speed, without stops) and
  keeps every variable in memory where it can be read; std_debug.kr, which
  the compiler adds to a debug build, answers through the program's standard
  input and output. Limits, for now: the main thread is the one followed;
  the program cannot be paused from outside (use a breakpoint); breakpoints
  added while it runs take effect at its next stop; debug builds are for
  Windows and Linux x86-64.
- **Build and run with one key**: Ctrl+F5 builds and runs the current file
  without the debugger; Ctrl+Alt+B only builds. The same actions are buttons in
  the editor's title bar. The program runs in a terminal called "Kron".
- **Build for another system**: "Kron: Build for Another System..." (Ctrl+Shift+P)
  builds the file for Windows, Linux (x86-64 or ARM64), macOS, the web, or as
  an Android or iOS library, next to the source.
- **Errors as you save**: every save runs `kronc --check` in the background, which
  writes nothing, and underlines the error, with its hint, in the right file --
  also when it is in an imported module. Turn it off with the setting
  `kron.checkOnSave`.
- **Completion** of keywords, built-in functions, and your own functions,
  structs, enums, globals and constants, including those of imported modules.
- **Go to definition** (F12, or Ctrl+click), across imported modules.
- **Hover help** on fail, raw, shared, slice, extern, export, c_fn, c_call, the
  thread and lock functions, and the header words; on your own functions it
  shows their signature.
- **Outline**: functions, structs, enums and globals in the side bar and with
  Ctrl+Shift+O.
- **The Kron logo** as the extension icon, and the `{K}` mark as the icon of
  `.kr` files in the explorer, for light and dark themes.
- Highlighting, `//` comments, bracket matching, indentation, snippets (`extern`,
  `export`, `fngen` for a generic function, and the basic ones).

## Debugging with launch.json

F5 needs no configuration. To pass arguments, or to debug another file than
the open one, add `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "kron",
      "request": "launch",
      "name": "Debug my program",
      "program": "${workspaceFolder}/main.kr",
      "args": ["input.txt"],
      "stopOnEntry": false
    }
  ]
}
```

The debug build is written as `NAME_debug.exe`, next to the program.

## Where the compiler is

A `kronc.exe` in the open folder is used first. Otherwise, the setting
`kron.compilerPath`, which defaults to `C:\Users\Gerson\Kron-compiler\kronc.exe`.

## Install

Ctrl+Shift+P, "Developer: Install Extension from Location...", choose this
`kron-lang` folder, then "Developer: Reload Window". An older version
installed the same way is replaced.
