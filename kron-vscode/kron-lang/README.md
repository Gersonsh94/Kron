# Kron for VS Code

Language support for Kron while its own IDE is being built.

## What it does

- **Build and run with one key**: F5 builds and runs the current file; Ctrl+Alt+B
  only builds. The same two actions are buttons in the editor's title bar. The
  program runs in a terminal called "Kron".
- **Errors as you save**: every save compiles in the background and underlines
  the error, with its hint, in the right file -- also when it is in an imported
  module. Turn it off with the setting `kron.checkOnSave`.
- **Completion** of keywords, built-in functions, and your own functions,
  structs, enums, globals and constants, including those of imported modules.
- **Go to definition** (F12, or Ctrl+click), across imported modules.
- **Hover help** on fail, raw, shared, slice, the thread and lock functions, and
  the header words; on your own functions it shows their signature.
- **Outline**: functions, structs, enums and globals in the side bar and with
  Ctrl+Shift+O.
- **The Kron logo** as the extension icon, and the `{K}` mark as the icon of
  `.kr` files in the explorer, for light and dark themes.
- Highlighting, `//` comments, bracket matching, indentation, snippets