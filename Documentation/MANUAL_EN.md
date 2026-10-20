# Kron — Manual

Kron is a systems language for programs that must not crash on bad memory or
race between threads, and must run without a runtime underneath. It compiles
to native code for Windows x86-64, Linux x86-64, Linux ARM64 and macOS on
Apple silicon, and to WebAssembly for a web page, from one source, with one
command.

What it solves:

- **Memory errors become failures you can handle.** An index out of range, a
  slice of a freed arena, an allocation that does not fit: the function stops
  and returns 0, and its caller asks `failed()`. Nothing reads or writes
  memory it should not.
- **Data races are compile errors.** Code that can run in a thread may only
  touch globals declared `shared`; anything else is refused at compile time.
- **Raw access is fenced.** Memory by address and calls into the system only
  compile inside `raw { }`, so the dangerous lines are the ones you can see.
- **No dependencies.** No C library, no runtime to install. The executable
  talks to the system directly.
- **A failure says where it came from.** It names the function and line
  where it happened and every call that led there.

---

## 1. Getting started

```
kronc.exe program.kr                           program.exe   (Windows)
kronc.exe program.kr --target=linux            program       (Linux x86-64)
kronc.exe program.kr --target=linux-arm64      program       (Linux ARM64)
kronc.exe program.kr --target=macos            program       (macOS, Apple silicon)
kronc.exe program.kr --target=web              program.wasm, program.html, kron_web.js
```

| Option | Effect |
|---|---|
| `-o path` | where to write the result |
| `-S` | write the assembly instead of the executable |
| `--check` | check the program, write nothing (what the editor uses on save) |
| `--window` | Windows: no console window behind the program (for `std_window`) |
| `--target=windows \| linux \| linux-arm64 \| macos \| web \| krn \| bare` | the platform |

### A first program

Every file has three parts: its name, what it imports, what it defines.

```
kron_program
kron_domain hello;
kron_imports
kron_definitions

fn main() {
    print("Hello from Kron");
    print(42);
    print(2.5);
    return 0;
}
```

Output:

```
Hello from Kron42
2.500000
```

`print` of a number ends the line; `print` of a string does not. Execution
starts at `main`.

---

## 2. Types

| Name | Alias | Meaning |
|---|---|---|
| `int8` `int16` `int32` `int64` | `i8` `i16` `i32` `i64` | signed integers |
| `uint8` `uint16` `uint32` `uint64` | `u8` `u16` `u32` `u64` | unsigned integers |
| `real32` `real64` | `f32` `f64` | reals (arithmetic is done in double precision; an `f32` in an array or a struct is stored in four bytes) |
| `bool` | | `true` / `false` |
| `text` | | a text that grows: prints as its words, `==` compares, `+` joins (section 10) |
| `list<T>` `map<T>` | | a list, a map from texts to values; `T` is `i64`, `f64` or `text` (section 10) |
| `fn(T1, T2) -> R` | | a function as a value (section 5) |
| `stream` | | an address and a length: `s.bytes`, `s.len` |
| `slice<i64>` `slice<f64>` | | a checked view into an arena (section 8) |
| `ptr<T>` | | a raw pointer |

Unsigned types compare, divide and shift as unsigned, in variables, fields and
return values.

### Declarations

```
var count: i64 = 0;
var ratio: f64 = 1.5;
var grid: [i64; 100];                 // an array of 100
var v: [i64; 4] = [10, 20, 30, 40];   // an array literal
const LIMIT: i64 = 64;
```

`var x = f();` takes its type from what it is given: a text, a list, a
function... A `var` outside any function is a global: it lives for the whole
program and starts at zero (a global can start from any expression; those
that are not constants are computed when `main` begins). Large arrays belong there; a local array of tens of thousands
of elements does not fit on the stack. A global array can start from
numbers written out, which are data in the program; the elements not given
are zero:

```
var primes: [i64; 100] = [2, 3, 5, 7, 11];
var mask: [u8; 4] = [0xFF, 0x0F, 0, -1];
```

Outside a `"..."` text and a `//` comment, a program is letters, digits,
`_`, blanks and Kron's operators; any other character (`@`, `#`, an `é`) is
an error at its line and column.

Every element of an array takes the width of its type: a `[u8; 4096]` is
4096 bytes, a `[i32; 100]` 400, a `[f32; 3]` 12. `&buf[0]` of a `[u8; N]`
is therefore a real byte buffer, which files, the network and the system
take as it is. An array passed to a function must have the element type
its parameter declares; the compiler checks it.

Reals can be written with an exponent: `1.5e3`, `2e-6`, `1e300`.

### Structs and enums

```
struct Vec3 {
    x: f64;
    y: f64;
    z: f64;
}

enum Color {
    Red,            // 0
    Green,          // 1
    Blue = 10,      // 10
    Violet          // 11
}

var p: Vec3;
p.x = 1.0;
print(Color.Blue);
```

Structs are passed by value. Enums and structs may be declared after they are
used.

### Conversions

```
d = n as f64;          // integer to real
i = d as i64;          // real to integer, towards zero
b = big as u8;         // narrowing keeps the low bits
```

Without `as` the same happens wherever a value goes: a real given to an
integer -- a variable, a field, an element, a parameter -- is truncated
towards zero, an integer given to a real is converted, and `var x = 2.5;`
is a real. A comparison is a bool whatever it compares.

`sizeof(T)` gives the size of a type at compile time: `sizeof(Vec3)` is 24.

---

## 3. Control flow

```
if a < b {
    ...
} else {
    ...
}

while count > 0 {
    count = count - 1;
}

for var i: i64 = 0; i < 10; i = i + 1 {
    print(i);
}

switch k {
    case 1: { print(11); }
    case 2: { print(22); }
    default: { print(0); }
}
```

`break` and `continue` work inside loops. `switch` takes a variable; the cases
are constants, enum members included.

---

## 4. Operators

| Group | Operators |
|---|---|
| Arithmetic | `+` `-` `*` `/` `%`, unary `-` (`%` of reals: the remainder, with the sign of the left side) |
| Comparison | `<` `>` `<=` `>=` `==` `!=` |
| Logical | `&&` `\|\|` (short-circuit), `!` |
| Bits | `&` `\|` `^` `~` `<<` `>>` (`>>` is logical on unsigned types), on integers only |
| Compound | `+=` `-=` `*=` `/=` `^=` |
| Address | `&x`, `&f` (a function) |

---

## 5. Functions

```
fn area(w: f64, h: f64) -> f64 {
    return w * h;
}
```

- Up to sixteen parameters, integers, reals, structs and arrays.
- Arrays are passed by address: a write through the parameter is seen by the
  caller.
- Calling a function that does not exist is a compile error.

### Several results

A function can give back up to four values:

```
fn divide(a: i64, b: i64) -> (i64, i64) {
    return a / b, a % b;
}

var q, r = divide(17, 5);       // 3 and 2
q, r = divide(100, 7);          // into variables that exist
var _, rest = divide(9, 4);     // _ skips one
print(divide(8, 2));            // used once, a call gives its first result
```

The results can be of different types: `-> (text, i64, f64)`.

### Functions as values

A function's name is a value, and so is a function written where a value
goes. It keeps the values of the variables around it that it uses, as they
were when it was made:

```
fn apply(f: fn(i64) -> i64, x: i64) -> i64 {
    return f(x);
}

fn make_adder(n: i64) -> fn(i64) -> i64 {
    return fn(x: i64) -> i64 { return x + n; };
}

fn main() {
    var add10 = make_adder(10);
    print(add10(1));                                        // 11
    print(apply(fn(x: i64) -> i64 { return x * x; }, 7));    // 49
    var k: i64 = 100;
    var plus_k = fn(x: i64) -> i64 { return x + k; };
    k = 1;
    print(plus_k(5));                                       // 105: it kept 100
    return 0;
}
```

A value of type `fn(...)` can be a parameter, a result, a variable, a global
or a struct field; a function kept in a field is called through a variable,
`var f = op.run; f(x)`. `thread_start` takes a function name as it is:
`thread_start(worker, 5)`.

---

## 6. Failures

A function that cannot do its job says so with `fail`:

```
fn reserve(available: i64, requested: i64) -> i64 {
    if available < requested {
        fail "arena out of space" hint "raise size_bytes";
    }
    return requested;
}
```

It returns at once with 0. The caller asks `failed()`, which reads the failure
and clears it; `print_fail()` prints the cause and the hint:

```
p = reserve(100, 4096);
if failed() {
    print_fail();
}
```

The checks the compiler adds — array bounds, slices — fail the same way. Each
thread has its own failure state. A failure nobody read is printed when the
program ends.

`print_fail()` also says where it happened and how the program got there:
the function and line of the failure, then each call that led to it.

```
fail: index out of range
hint: the index has to go from 0 to the array size minus one
  at leaf (shop.kr:19)
  called from middle (shop.kr:23)
  called from main (shop.kr:48)
```

A failure inside the standard library names the library's line first and
then the program's own calls, so it is clear which of them it was. The
record costs nothing while nothing fails: the lines are a table the program
carries, read only when a failure is printed.

---

## 7. Threads

```
shared var counter: i64;

fn adder(arg: i64) -> i64 {
    lock_take(0);
    counter = counter + arg;
    lock_give(0);
    return 0;
}

fn main() {
    lock_init(0);
    var h: i64 = thread_start(&adder, 5);
    thread_wait(h);
    print(counter);
    return 0;
}
```

| Built-in | Purpose |
|---|---|
| `thread_start(&fn, arg)` | start a thread, one argument; returns its handle |
| `thread_wait(h)` | wait for it to end (once per thread) |
| `thread_yield()` | let another thread run |
| `lock_init(n)` `lock_take(n)` `lock_give(n)` | numbered locks: programs use 0 to 7 (channels take 8 to 15, the library 16 to 31) |
| `cpu_count()` | processors available |

A function that runs in a thread, or anything it calls, may only touch
`shared` globals and constants. The compiler checks this.

Channels (`std_chan.kr`) pass values between threads without touching locks:

```
var got: [i64; 1];
var c: i64 = chan_new(16);
chan_send(c, 42);
chan_recv(c, got);       // got[0] is 42
```

---

## 8. Memory without addresses: arenas and slices

`std_arena.kr` hands out memory as slices. A slice checks every access: the
index must be inside it, and its arena must not have been freed since.

```
var a: i64 = arena_new(64);
var v: slice<i64> = arena_slice(a, 3);
v[0] = 5;
print(v[3]);             // 0, and failed() is 1: outside the slice
arena_free(a);
print(v[0]);             // 0, and failed() is 1: the arena is gone
```

---

## 9. Raw access

Memory by address and calls into the system compile only inside `raw { }`:

```
raw {
    var p: i64 = &buf;
    poke8(p, 75);
    print(peek8(p));
}
```

| Inside `raw` | Purpose |
|---|---|
| `peek8/16/32(addr)` `poke8/16/32(addr, v)` | memory by address |
| `syscall(n, ...)` | a Linux system call, Linux x86-64 numbering on every Linux |
| `dll_load("x.dll")` `dll_proc(lib, "name")` | a Windows library function, called with `call ptr(args)`: the Windows convention, any number of integer arguments |

---

## 10. Texts, lists and maps

Programs that handle text and collections need no `raw`: `std_text.kr`,
`std_list.kr` and `std_map.kr` give texts that grow, lists that grow and
maps from text keys to values, and the types `text`, `list<T>` and `map<T>`
let them be written as values.

```
kron_imports
acquire_domain "std_map.kr";         // brings std_text and std_list too
kron_definitions

fn greet(who: text) -> text {
    return "Hello, " + who + "!";
}

fn main() {
    var name: text = "Gerson";
    print(greet(name) + " " + 31);                // Hello, Gerson! 31
    if name == "Gerson" {
        text_add(name, " Sh");
    }

    var words = text_split("pear apple fig", " ");
    list_sort(words);
    print(words);                                 // ["apple", "fig", "pear"]

    var nums: list<i64> = [3, 1, 2];
    nums[0] = 7;
    for n in nums {
        print(n);
    }

    var ages: map<i64>;
    ages["ana"] = 31;
    print(ages["ana"]);                           // 31
    print(ages);                                  // {"ana": 31}
    print(map_get_or(ages, "eva", -1));           // -1
    return 0;
}
```

- A `text` prints as its words; `==` and `!=` compare the bytes; `+` joins
  texts, string literals, integers and reals into a new text. Declared from
  a literal, a `text` is a text of its own that `text_add` can grow.
- A text the compiler makes for a call -- `"$" + n`, or a `"..."` given to
  a `text` parameter -- is lent when the function only reads it: the
  literal goes as it is, the joined text is freed when the call returns.
  `draw("$" + n)` in a loop takes no memory. A function that keeps what it
  is given -- in a global, a field, a list, or by returning it -- gets a
  text of its own, as a variable does. The compiler works out which
  functions only read; reading the bytes through `text_cstr` counts.
- `list<T>` and `map<T>` hold `i64`, `f64` or `text`. Declared without a
  value they start empty; `[a, b, c]` makes a list. `l[i]` and `m[key]` read
  and write; `for x in l { }` walks a list (`break` and `continue` work);
  `print` shows the whole collection.
- Struct fields, parameters, results and globals can be of these types.

Texts, lists and maps are **handles**: one `i64` that names the object and
is checked on every use. An index out of range, a key that is not there, a
handle used after `text_free` / `list_free` / `map_free`, or a number where a
text belongs: the function fails with a cause and a hint and returns 0, as
everywhere in Kron. Wherever a text is read, a string literal works too.
Every call takes the library's lock, so threads can share them.

| Texts (`std_text.kr`) | |
|---|---|
| `text(x)` `text_new()` `text_free(t)` | make and free |
| `text_add(t, x)` `text_add_int(t, n)` `text_add_real(t, x, decimals)` `text_add_char(t, code)` | add to a text |
| `text_len(x)` `text_at(x, i)` `text_same(a, b)` `text_compare(a, b)` | read |
| `text_find(x, part)` `text_find_after(x, part, i)` `text_count(x, part)` `text_contains` `text_starts` `text_ends` | search |
| `text_part(x, i, n)` `text_upper` `text_lower` `text_trim` `text_replace(x, old, new)` `text_repeat(x, n)` | new texts |
| `text_split(x, sep)` `text_lines(x)` `text_join(list, sep)` `text_sort(list)` | with lists |
| `text_to_int(x)` `text_to_real(x)` `text_is_int` `text_is_real` `text_from_int(n)` `text_from_real(x, d)` | numbers |
| `say(x)` `text_print(x)` | output, with and without a line end |
| `text_cstr(x)` `text_view(x)` `text_from_bytes(address, n)` | to and from byte buffers (`text_view` never fails: "" for a freed text) |

| Lists (`std_list.kr`) | Maps (`std_map.kr`) |
|---|---|
| `list_new()` `list_free(l)` | `map_new()` `map_free(m)` |
| `list_add(l, v)` `list_get(l, i)` `list_set(l, i, v)` | `map_set(m, key, v)` `map_get(m, key)` `map_get_or(m, key, other)` |
| `list_len` `list_last` `list_pop` `list_insert(l, i, v)` `list_remove(l, i)` | `map_has` `map_remove` `map_len` `map_clear` |
| `list_find(l, v)` `list_sort(l)` `list_reverse` `list_clear` `list_copy` | `map_keys(m)` `map_values(m)`, in the order the keys came |
| `list_add_real` `list_get_real` `list_set_real` | `map_set_real` `map_get_real`, `map_iset` `map_iget` `map_ihas` `map_iremove` (integer keys) |

---

## 11. Files, time and the system

```
acquire_domain "std_file.kr";
acquire_domain "std_time.kr";
acquire_domain "std_os.kr";
...
file_write_all("notes.txt", "first line\n");
file_append("notes.txt", "second line\n");
var lines: i64 = file_lines("notes.txt");          // a list of texts
say(time_text(time_local(time_now())));            // 2026-10-12 09:41:07
var listing: i64 = os_run_output("dir");           // what a command printed
```

| Files (`std_file.kr`) | |
|---|---|
| `file_read_all(path)` `file_lines(path)` `file_write_all(path, x)` `file_append(path, x)` | whole files |
| `file_open(path, "r" / "w" / "a" / "rw")` `file_close(f)` | files kept open |
| `file_read(f, n)` `file_read_line(f)` `file_write(f, x)` `file_at_end(f)` | from where the last read or write stopped |
| `file_read_at(f, pos, address, n)` `file_write_at(f, pos, address, n)` | bytes at a position, into a `[u8; N]` |
| `file_seek` `file_pos` `file_size` | |
| `file_exists` `file_length` `file_delete` `file_rename(old, new)` | names |
| `dir_exists` `dir_make` `dir_remove` `dir_list(path)` | folders; `dir_list` gives a sorted list of names |

| Time (`std_time.kr`) | |
|---|---|
| `time_now()` `time_ms()` | seconds, milliseconds since 1970 (UTC) |
| `time_clock()` `time_sleep(ms)` | for measuring and waiting |
| `time_local(t)` `time_offset(t)` | the computer's time zone |
| `time_year` `time_month` `time_day` `time_hour` `time_minute` `time_second` `time_weekday` `time_yearday` | parts of a time |
| `time_make(y, mo, d, h, mi, s)` `time_text(t)` `time_date_text(t)` | to seconds and to text |

| The system (`std_os.kr`) | |
|---|---|
| `os_args()` `os_name()` `os_cwd()` `os_chdir(path)` `os_exit(code)` | `os_name()` is `"windows"`, `"linux"`, `"macos"` or `"web"` |
| `env_get(name)` `env_has(name)` | environment variables |
| `os_run(command)` `os_run_output(command)` | run a command (cmd on Windows, sh on Linux): its exit code, or what it printed |

Pictures (`std_image.kr`): `image_load(path)` reads PNG (every kind) and BMP;
`image_width` `image_height` `image_get(img, x, y)` `image_set` `image_new(w, h)`
`image_save_bmp(img, path)` `image_free`. `std_ui` draws them.

---

## 12. Windows to draw in

`std_window.kr` opens a window and lets the program draw in it, pixel by
pixel, on Windows, on Linux (a desktop, or WSL with WSLg), x86-64 and ARM64
alike, and on a web page, where the window is the page's canvas (section 15):

```
kron_imports
acquire_domain "std_window.kr";
kron_definitions

fn main() {
    window_open(320, 240, "demo");
    while window_show() {
        window_clear(rgb(0, 0, 40));
        window_rect(window_mouse_x(), window_mouse_y(), 8, 8, rgb(255, 200, 0));
        if window_key() == 27 {
            window_close();
        }
        window_sleep(16);
    }
    return 0;
}
```

| Function | Purpose |
|---|---|
| `window_open(w, h, "title")` | 1, or a fail with the reason |
| `window_clear(color)` `window_pixel(x, y, color)` `window_rect(x, y, w, h, color)` | draw; outside the window is ignored |
| `window_show()` | to the screen, input read; 1 while open, 0 once closed |
| `window_key()` | next key, 0 when none: letters and digits by their code, space 32, enter 13, escape 27, backspace 8, tab 9, arrows 37-40, delete 46, home 36, end 35, page up 33, page down 34, F1-F12 112-123 |
| `window_char()` | next character typed, in the keyboard's own layout (dead accents too) |
| `window_mouse_x()` `window_mouse_y()` `window_mouse_down()` | the pointer |
| `window_wheel()` `window_right_down()` `window_right_pressed()` | the wheel and the right button |
| `window_ctrl()` `window_shift()` | modifier keys held, or held when the key `window_key` just gave went down (a quick Ctrl+C fits in one frame) |
| `window_clip_set(address, n)` `window_clip_get()` | the system clipboard, shared with other programs |
| `window_clip(x, y, w, h)` `window_unclip()` | keep drawing inside a rectangle |
| `window_sleep(ms)` `window_close()` `rgb(r, g, b)` | |

Build it with `--window` on Windows so no console opens behind it
(`print` then goes nowhere). `window_demo.kr` is a complete example.

### Programs with text, buttons and boxes: `std_ui.kr`

`std_ui.kr` draws the controls of a modern program on that window: smooth
letters (Inter, with accents and ñ), rounded corners, soft shadows, a light
and a dark theme, and controls that ease into their hover state. Kron draws
them itself, so they look the same on Windows, Linux and ARM64. Every frame
the program says what is on the screen and each control answers what
happened to it:

```
kron_imports
acquire_domain "std_ui.kr";
kron_definitions

fn main() {
    var name: i64 = text_new();
    window_open(420, 240, "Hello");
    while window_show() {
        ui_begin();
        ui_card(20, 20, 380, 200, "Profile");
        ui_edit(40, 70, 340, name, "Your name");
        if ui_button(40, 140, 140, 40, "Save") {
            say(name);
        }
        ui_end();
    }
    return 0;
}
```

| Function | Purpose |
|---|---|
| `ui_begin()` `ui_end()` | around each frame's controls; `ui_begin` paints the background |
| `ui_dark(on)` `ui_accent(color)` | the dark or light theme; the color of buttons and focus |
| `ui_label` `ui_muted` `ui_bold` `ui_title` `(x, y, "text")` | text: normal, secondary, semibold, large |
| `ui_text(x, y, "text", color)` `ui_text_big(x, y, "text", color, 2)` | text in any color |
| `ui_button(x, y, w, h, "text")` | filled with the accent color; 1 in the frame it is clicked |
| `ui_button_alt(...)` `ui_button_color(x, y, w, h, "text", fill, text_color)` | outlined, or any colors |
| `ui_edit(x, y, w, t, "placeholder")` | a box that edits text `t`: caret, arrows, home, end, delete, Ctrl+C/X/V; 1 when enter is pressed in it |
| `ui_area(x, y, w, h, t)` | several lines of text `t`, scrolled with the wheel; 1 when it changed |
| `ui_input(x, y, w, buffer, capacity)` `ui_input_hint(..., "placeholder")` | the same on a byte buffer |
| `ui_list(x, y, w, h, items, selected)` | a list of texts that scrolls (wheel, bar, arrows): the selected index |
| `ui_select(x, y, w, items, selected)` | a dropdown: the chosen index |
| `ui_radio(x, y, "text", value, mine)` `ui_tabs(x, y, "One\|Two", selected)` | one of a group; tabs |
| `ui_menubar()` `ui_menu("File")` `ui_menu_item("Open")` `ui_menu_line()` | a menu bar: `ui_menu` is 1 while open, `ui_menu_item` 1 when chosen |
| `ui_image(x, y, img)` `ui_image_size(x, y, w, h, img)` | pictures from `std_image`, with their alpha |
| `ui_copy(x)` `ui_paste()` | the clipboard as texts |
| `ui_check(x, y, "text", value)` `ui_switch(x, y, "text", value)` | return the new value |
| `ui_slider(x, y, w, value, low, high)` `ui_progress(x, y, w, value, total)` | |
| `ui_card(x, y, w, h, "title")` | a raised panel to group controls |
| `ui_round(x, y, w, h, radius, color)` `ui_circle(cx, cy, radius, color)` | shapes |
| `ui_key(k)` `ui_typed(c)` | a key pressed, or a character typed, this frame |
| `ui_int_text(buffer, n)` `ui_real_text(buffer, v, decimals)` | numbers as text |

Text is UTF-8, as the source is; the letters cover ASCII and Latin-1. Every
control that shows text takes a text from `std_text` or a literal. A control
is known by its position, so two controls must not share x and y. Complete
programs: `notes_demo.kr` (a notes program: menus, a list of files, an
editor), `ui_gallery.kr` (every control), `ui_demo.kr` (a sign-up form) and
`calculator.kr`.

---

## 13. Built-ins

| Built-in | Purpose |
|---|---|
| `print(x)` | print an integer, a real or a string |
| `printc(n)` | print one character by its code |
| `savefile(addr, len, "name")` | write a file |
| `loadfile("name", addr, capacity)` | read a file; returns the bytes read, 0 if it cannot be opened |
| `ticks()` `ticks_per_sec()` | a clock for measuring |
| `arg_count()` `arg_get(i)` | command-line arguments (`arg_get` gives a NUL-terminated string) |
| `target_os()` | 1 Windows, 2 Linux (macOS and the web too: they run the Linux program), 3 krn, 4 bare |
| `readkey()` `beep(hz, ms)` | console |
| `vec2_load/add/sub/mul/div/store` | two `f64` per instruction |
| `vec4_load(&a[i])` `vec4_store(&a[i], v)` | four `f32` of an `[f32; N]` at once |
| `vec4_add/sub/mul/div` `vec4_fill(x)` `vec4_sum(v)` | four `f32` per instruction; one real into four; four into one |

The vector values live in registers and compose by nesting:
`vec4_sum(vec4_mul(vec4_load(&a[0]), vec4_load(&b[0])))` is a dot product of
four.

A string literal is the address of NUL-terminated bytes; `var s: stream =
"text"` also records its length. Escapes: `\n` `\t` `\r` `\0` `\\` `\"`.
Compare strings with `str_equals`, never by address.

---

## 14. Modules

```
kron_imports
acquire_domain "std_math.kr";
acquire_domain "my_module.kr";
```

A module is looked for next to the program first. Imports chain: a module
brings in what it imports itself, each one once.

### Standard library

| Module | What it has |
|---|---|
| `std_math.kr` | `fsqrt` `fsin` `fcos` `ftan` `fabs` `fmin` `fmax` `fclamp` `ffloor` `fceil` `fround` `fmod` `fpowi` `flerp` `m_pi` ... |
| `std_exp.kr` | `fexp` `fln` `flog2` `flog10` `fpow` `sigmoid` `ftanh` `relu` and their derivatives |
| `std_str.kr` | `str_length` `str_copy` `str_concat` `str_equals` `str_find` `str_split_get` `str_trim` `str_from_int` `str_to_int` ... (31) |
| `std_mem.kr` | `mem_copy` `mem_set` `mem_zero` `mem_compare` `mem_move` ... |
| `std_arena.kr` | arenas and slices |
| `std_chan.kr` | channels between threads |
| `std_net.kr` | TCP: `net_listen` `net_accept` `net_connect` `net_send` `net_recv` `net_close`, on Windows and Linux |
| `std_random.kr` | `rnd_seed` `rnd_int` `rnd_uniform` `rnd_normal` ... |
| `std_stats.kr` | mean, variance, median, percentiles, correlation, linear regression |
| `std_vec3.kr` | 3D vectors, rotations, projection |
| `std_ml.kr` | logistic regression with its metrics |
| `std_text.kr` `std_list.kr` `std_map.kr` | texts, lists and maps (section 10) |
| `std_file.kr` `std_time.kr` `std_os.kr` | files and folders, dates and time, the system (section 11) |
| `std_image.kr` | PNG, BMP and JPEG pictures |
| `std_window.kr` | a window to draw in, with keyboard, mouse, wheel and clipboard (on a web page, its canvas) |
| `std_ui.kr` | controls: buttons, text boxes, lists, menus, dropdowns, tabs, pictures |
| `std_app.kr` | a whole app on a phone (Android, iOS), section 18 |
| `std_gpu.kr` `std_shader.kr` `std_math3d.kr` `std_audio.kr` `std_gamepad.kr` | the graphics card, sound and controllers (section 19) |
| `std_json.kr` | reading JSON |
| `std_debug.kr` | the debugger's side, added by `--debug` (section 20) |

---

## 15. The web

`--target=web` turns the program into WebAssembly. Three files come out:

| File | |
|---|---|
| `program.wasm` | the program |
| `program.html` | the page that runs it: its output, and a canvas for `std_window` and `std_ui` |
| `kron_web.js` | what the page uses to run it: files, time, memory, threads, the window |

A browser opens them only from a web server, not from the disk.
`web/kron_serve.kr` is one, written in Kron:

```
kronc.exe web\kron_serve.kr -o kron_serve.exe
kronc.exe calculator.kr --target=web
kron_serve.exe                              then open http://localhost:8000/calculator.html
```

It serves the folder it runs in, to this computer only, and sends the two
headers that let a page share memory between threads
(`Cross-Origin-Opener-Policy` and `Cross-Origin-Embedder-Policy`). Any other
server works too: when it does not send them, `kron_web.js` adds them itself
with a service worker and reloads the page once.

What a program has on the web:

- **Everything that does not need the operating system**: texts, lists,
  maps, arenas, failures and their traces, reals, `vec4`.
- **Threads**: each one is a web worker running the same program over the
  same memory; locks, channels and `thread_wait` work as on Linux.
- **Windows**: `std_window` draws on the page's canvas, with the keyboard,
  the mouse, the wheel and the clipboard; `std_ui` programs look as they do
  on Windows and Linux.
- **Files**: folders and files in memory, empty when the page opens, gone
  when it closes; each thread has its own open files.
- **Time**: the clock, `time_sleep` and `window_sleep`.

Not there: running other programs (`os_run`), the network (`std_net`) and
command-line arguments (`arg_count()` is 1). A program runs about one and a
half to three times slower than as native code. 3D (`std_gpu`) draws with
WebGPU (Chrome, Edge; Firefox and Safari as they enable it), sound plays
after the first click or key (browsers ask for that), gamepads and the
captured mouse work as on a computer.

Programs that only print run in Node.js too, with files on the real disk:

```
node kron_web.js program.wasm
```

which is how `WEBTESTS.bat` tests the whole suite. After changing
`web/kron_web.js`, `web/make_host.kr` turns it into `include/web_host.inc`,
which the compiler carries inside itself; then build the compiler again.

---

## 16. macOS

`--target=macos` builds a program for macOS on Apple silicon (M1 and later),
signed the way a linker signs what it builds, so it runs on the Mac it is
copied to:

```
kronc.exe program.kr --target=macos -o program
```

On the Mac:

```
chmod +x program
./program
```

A file that arrived through a browser or AirDrop carries the quarantine
mark, and macOS asks before running it: `xattr -d com.apple.quarantine
program` removes it.

The program is the Linux ARM64 one with a different layer underneath: files,
folders, time, memory, threads, the network and running other programs all
work. Windows (`std_window`, `std_ui`) do not yet: `window_open` fails and
says so. `std_gpu` draws with Metal without a window (pictures, tests). The same program built with `--target=web` opens its window in a
browser on the Mac.

---

## 17. Values, generics and module names

### Struct values

A struct is a value: assigning it, passing it and returning it copies it
whole, nested structs included. A struct declared without a value starts
with every field at 0, and so does every local declared without one.

```
struct Vec3 { x: f32; y: f32; z: f32; }

fn mid(a: Vec3, b: Vec3) -> Vec3 {
    return Vec3 { x: (a.x + b.x) * 0.5, y: (a.y + b.y) * 0.5, z: (a.z + b.z) * 0.5 };
}

var p: Vec3 = mid(a, b);        // a copy: changing p leaves a and b alone
var q: ptr<Vec3> = &p;
q.x = 2.0;                       // through a pointer: p.x is 2
```

`list<S>` holds structs by value: `l[i]` is a copy, `l[i] = s` stores one,
`for s in l` gives each, and `list_add`, `list_insert`, `list_remove`,
`list_pop`, `list_last`, `list_reverse` work on them as on numbers.

### Generics

A function or a struct can take types as parameters. The types are written
where it is used, and the compiler makes a copy for each set of them:

```
struct Pair<A, B> { first: A; second: B; }

fn biggest<T>(a: T, b: T) -> T {
    if a > b { return a; }
    return b;
}

print(biggest<i64>(3, 9));                    // 9
print(biggest<f64>(2.5, 1.5));                // 2.500000
var p: Pair<i64, f64> = Pair<i64, f64> { first: 7, second: 0.5 };
```

### Module names

Two modules may define functions of the same name. Inside each module its
own one is meant; elsewhere the name is written with its module,
`module.name` (the file's name without `.kr`), or with a shorter name given
on import:

```
acquire_domain "mod_sq.kr" as sq;
acquire_domain "mod_tri.kr";

print(sq.area(4));
print(mod_tri.area(4));
```

A name defined in only one module needs nothing. Using a name two modules
define, without saying which, is a compile error that lists them.

---

## 18. Calling C, and being called from it

### extern: the system's libraries

```
extern "libm.so.6", "libm.dylib", "msvcrt.dll" {
    fn cos(x: f64) -> f64;
    fn printf(format: str, ...) -> i32;
}

raw {
    print(cos(0.0));
    printf("%d %s\n", 7, "seven");
}
```

The strings name the library on each system; the first that loads is used,
and each function is looked up the first time it is called. The calls go
inside `raw { }`: what they run is C, outside what Kron checks. Reals go as
reals, integers as integers, texts and pointers as addresses, and `...`
takes any number more. A function no library has makes the call fail with
a hint, instead of stopping the program.

### Libraries: `--lib`

```
kronc.exe engine.kr --lib                         engine.dll
kronc.exe engine.kr --lib --target=linux          libengine.so
kronc.exe engine.kr --lib --target=macos          libengine.dylib
```

Functions marked `export` are what C (or C#, Python, Swift, Kotlin...) can
call; they take and return numbers, reals and addresses in the system's C
convention:

```
fn export engine_step(dt: f64) -> i64 { ... }
```

The library's globals get their first values the first time any export is
called, and an optional `fn lib_init()` runs then.

### Callbacks

`c_fn(f)` is the address C calls to reach the export `f` (a comparison for
`qsort`, a window procedure); `c_call(address, args...)` calls a C function
by its address. Both only inside `raw { }`.

### Phones

`--target=android` (a `.so` for an app) and `--target=ios` (a `.dylib` for
an app) build libraries; `templates/` has the Android and iOS projects
around them, a whole app in Kron (`templates/app.kr`, with `std_app.kr`),
and a React Native module. `templates/README.md` says how to build each.

---

## 19. The graphics card, sound and controllers

```
window_open(1280, 720, "demo");
gpu_open(1280, 720);
var prog: i64 = gpu_shader(source);         // KSL, below
var cube: i64 = gpu_cube();
var tex: i64 = gpu_texture(image_load("crate.png"));
while window_show() {
    gpu_begin(color4(20, 24, 32, 255));
    gpu_set_mat4(prog, "mvp", mvp);
    gpu_draw(prog, cube, tex);
    gpu_end();                               // the frame is in the window
}
```

The same program draws with Vulkan on Windows, Linux and Android, Metal on
macOS and iOS, and WebGPU in a browser. Without a window it draws all the
same, for `gpu_pixel(x, y)` and `gpu_save_bmp(path)`. Blending (alpha) is
on unless `gpu_blend(0)` turns it off for the shaders made after;
`gpu_depth` and `gpu_cull` work the same way.

| Module | What it has |
|---|---|
| `std_gpu.kr` | `gpu_open` `gpu_shader` `gpu_mesh` `gpu_mesh_lists` `gpu_cube` `gpu_plane` `gpu_sphere` `gpu_texture` `gpu_begin` `gpu_set_mat4/vec4/vec3/vec2/float` `gpu_draw` `gpu_draw_textures` `gpu_end` `gpu_pixel` `gpu_save_bmp` `gpu_close` |
| `std_shader.kr` | KSL, the shader language, translated to SPIR-V, MSL and WGSL |
| `std_math3d.kr` | `Vec2` `Vec3` `Vec4` `Quat` `Mat4` and their functions: `m4_perspective` `m4_look_at` `m4_trs` `q_slerp` ... |
| `std_image.kr` | PNG, BMP and baseline JPEG; `image_from_bytes` |
| `std_audio.kr` | `audio_open` `audio_load_wav` `audio_tone` `audio_play` `audio_stop` `audio_set_volume` `audio_set_pan` `audio_update` |
| `std_gamepad.kr` | `gamepad_poll` `gamepad_connected` `gamepad_button` `gamepad_pressed` `gamepad_axis`, Xbox layout |
| `std_json.kr` | `json_parse` and the functions that read what it gives |
| `std_window.kr` | also: `window_key_down(k)` (a key held now), `window_mouse_capture(1)` with `window_mouse_dx/dy` |

### KSL: shaders in Kron's style

```
uniform { mvp: mat4; model: mat4; light: vec3; }
texture albedo;
in pos: vec3;
in normal: vec3;
in uv: vec2;
var vn: vec3;
var vuv: vec2;
vertex {
    vn = (model * vec4(normal, 0.0)).xyz;
    vuv = uv;
    position = mvp * vec4(pos, 1.0);
}
fragment {
    let d = max(dot(normalize(vn), light), 0.0);
    color = vec4(sample(albedo, vuv).rgb * (0.25 + 0.75 * d), 1.0);
}
```

Types `float vec2 vec3 vec4 mat4 bool`; `let`, `var`, `if`, `for i in 0..4`,
`discard`; the usual functions (`normalize dot cross mix clamp pow sin`...).
A mesh's corners are floats in the order of the `in` lines: position, normal
and uv make eight a corner, which is what `gpu_cube` and `gpu_sphere` give;
`gpu_mesh_lists(vertices, 8, indices)` makes one from a `list<f64>` and a
`list<i64>`. `shader_error()` says what is wrong in a shader and on
which line.

### What is not here

Kron gives the program the graphics card, the sound and the controllers.
What a game builds on them -- a game loop, collisions, scene graphs, model
formats -- belongs to libraries written in Kron, outside the language and
its standard library.

---

## 20. The debugger

```
kronc.exe program.kr --debug -o program_debug.exe
```

A debug build stops where it is told and shows every variable. The Kron
extension for VS Code does all of it from the editor: F5 builds the open
file this way and runs it under the debugger; breakpoints are set by
clicking left of the line numbers; F10, F11 and Shift+F11 step over, into
and out of calls; the Variables panel shows the locals of each function on
the stack and the globals of the program's files -- texts, lists, maps,
arrays and structs, field by field.

What a debug build changes: before each statement of the program's own
files there is a call to the debugger (`std_debug.kr`, added by the
compiler; the std_*.kr modules run at full speed, without stops), and
every local stays in memory, where it can be read. It talks to the editor
through its standard input and output; the protocol is described at the top
of `std_debug.kr`. Debug builds are for Windows and Linux x86-64. The main
thread is the one followed; the others run without stops.

---

## 21. Getting started on a new machine

See `GETTING_STARTED.md` next to the compiler: what to install (nothing for
programs nor for the compiler), the first program, the
editor, the tests, building for other systems.

---

## 22. Building the compiler

The compiler is written in x86-64 assembly and, part by part, in Kron
itself: its lexer is `lexer/lexer.kr`, its parser `parser/parser.kr` and
the files it imports, its semantic pass `semantic/semantic.kr`, its code
generator `codegen/codegen.kr` and its assembler `kasm.kr`, with the
files they import. `BUILD.bat`
builds `kronc.exe` from the seed with nothing but Kron's own tools, and
`BOOTSTRAP.bat` checks that it reproduces itself byte for byte.

A part in Kron is compiled as a module:

```
kronc.exe lexer\lexer.kr --module        lexer\lexer_kr.asm
kronc.exe parser\parser.kr --module      parser\parser_kr.asm
kronc.exe semantic\semantic.kr --module  semantic\semantic_kr.asm
kronc.exe codegen\codegen.kr --module    codegen\codegen_kr.asm
kronc.exe kasm.kr --module               kasm_kr.asm
```

which is its functions as assembly text, with no runtime and no entry, for
`kron_all.asm` to include. A module has no `main` and exports nothing; its
globals start from numbers written out. A function of the compiler outside
the part is named in `extern "kronc" { fn name(...); }` and called as any
other. `KRONPARTS.bat` makes every part
again, and BUILD.bat and BOOTSTRAP.bat call it with each compiler they
build.

---

## 23. Limits

| Limit | Value |
|---|---|
| Parameters per function | 16 |
| Results per function | 4 |
| Locks | 16 |
| Thread stack (Linux, macOS, web) | 1 MB |

- Reals print with six decimals; from 2⁶³ up they print as `d.dddddde+N`.
  A real inside `+` with a text, or inside a printed list or map, prints
  with the digits it needs: `2.5`, `1.62`.
- A function value keeps copies of the variables it uses; a later change to
  them is not seen by it.
- On Linux, macOS and the web, wait for each thread once.

---

## 24. Testing

```
RUNTESTS.bat            the suite on Windows: compile, run, compare
RUNTESTS.bat /slow      with the 3D rendering programs
LINUXTESTS.bat          the same programs on Linux, through WSL
ARMTESTS.bat            the same programs on ARM64, through WSL and QEMU
WEBTESTS.bat            the same programs as WebAssembly, through Node.js
MACTESTS.bat            builds them for macOS into tests\mac; then, on a Mac
                        with Apple silicon, in the same folder:  bash MACTESTS.sh
GPUTESTS.bat            the graphics card, a window, the sound, the controllers
BOOTSTRAP.bat           the compiler compiles itself; three generations must match
```

`RUNTESTS.bat` also builds `test_debug.kr` with `--debug` and drives it with
`tests\debug\test_debug.in`, as the editor would.

---

## 25. A complete example

```
kron_program
kron_domain shapes;
kron_imports
acquire_domain "std_math.kr";
kron_definitions

enum Kind {
    Circle,
    Square
}

struct Shape {
    kind: i64;
    size: f64;
}

fn area(s: Shape) -> f64 {
    var k: i64 = s.kind;
    switch k {
        case Kind.Circle: { return m_pi() * s.size * s.size; }
        case Kind.Square: { return s.size * s.size; }
    }
    fail "unknown shape" hint "use Kind.Circle or Kind.Square";
}

fn main() {
    var c: Shape;
    c.kind = Kind.Circle;
    c.size = 1.0;
    print(area(c));             // 3.141593

    var q: Shape;
    q.kind = 7;
    print(area(q));             // 0.000000
    if failed() {
        print_fail();           // fail: unknown shape / hint: ...
    }
    return 0;
}
```
