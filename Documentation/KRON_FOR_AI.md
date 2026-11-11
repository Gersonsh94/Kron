# Kron for an AI that writes it

One file to read before writing Kron. It is short on purpose: the syntax
that works, the rules a newcomer breaks, and where to look for the rest.
Everything here was checked against the compiler. For the whole language,
see `Documentation/MANUAL_EN.md`; for the exact grammar, `kron_grammar.txt`.

## 1. A file

Every file has the same four lines first. `main` is where a program starts.

```
kron_program
kron_domain hello;              // the module's name: the file's, without .kr
kron_imports
acquire_domain "std_text.kr";   // one line a module; none is fine too
kron_definitions

fn main() {
    print("Hello from Kron\n");   // a string: no line end added
    print(42);                    // a number: the line ends after it
    say("a text and a line end"); // say: std_text.kr
    return 0;
}
```

Build: `kronc.exe file.kr` (Windows), with `--target=linux`, `linux-arm64`,
`macos` or `web` for the others; `--check` only checks it.

## 2. The syntax in one place

```
// values
var n: i64 = 0;                 // i8 i16 i32 i64, u8 .. u64, f32 f64, bool
var x = 2.5;                    // the type taken from the value: f64
const LIMIT: i64 = 64;
var grid: [i64; 100];           // an array; [u8; N] is a byte buffer
var v: [i64; 4] = [10, 20, 30, 40];
d = n as f64;                   // conversions with as; real to int truncates

// structs and enums
struct Vec3 { x: f64; y: f64; z: f64; }
enum Color { Red, Green, Blue = 10 }
var p: Vec3;                    // every field 0
p.x = 1.0;
var q: Vec3 = Vec3 { x: 1.0, y: 2.0, z: 3.0 };
var pp: ptr<Vec3> = &p;
pp.x = 2.0;                     // through a pointer: the same dot

// control flow: no parentheses around conditions, braces always
if a < b { ... } else if a == b { ... } else { ... }
while i < 10 { i = i + 1; }
for var i: i64 = 0; i < 10; i = i + 1 { ... }
for w in words { ... }          // a list
switch k { case 1: { ... } case Color.Red: { ... } default: { ... } }
break; continue;

// operators
+ - * / %   == != < > <= >=   && || !   & | ^ ~ << >>   += -= *= /= ^=
// no ++ or --, no ?: (write an if)

// functions
fn area(w: f64, h: f64) -> f64 { return w * h; }
fn divide(a: i64, b: i64) -> (i64, i64) { return a / b, a % b; }
var quot, rest = divide(17, 5);
fn apply(f: fn(i64) -> i64, x: i64) -> i64 { return f(x); }
var sq = fn(x: i64) -> i64 { return x * x; };
fn biggest<T>(a: T, b: T) -> T { if a > b { return a; } return b; }
print(biggest<i64>(3, 9));
```

## 3. Failures instead of crashes

A function that cannot do its job fails. It returns at once with 0 (0.0 for
a real); its caller asks `failed()`, which reads the failure and clears it.

```
fn ratio(a: f64, b: f64) -> f64 {
    if b == 0.0 {
        fail "division by zero" hint "a divisor above 0";
    }
    return a / b;
}

var r: f64 = ratio(1.0, 0.0);
if failed() {
    print_fail();               // the cause, the hint, the calls that led there
}
```

The checks the compiler adds fail the same way: an index outside an array
**returns from the function it happens in** at once, before the lines
after it. So check `failed()` in the caller, not on the next line.

## 4. Texts, lists and maps

Import `std_map.kr` (it brings `std_text.kr` and `std_list.kr`).

```
var name: text = "Ana";
var greeting: text = "Hello, " + name + "! " + 31;   // + joins texts and numbers
if name == "Ana" { text_add(name, " Ruiz"); }        // == on a text compares bytes
var words = text_split("pear apple fig", " ");       // a list of texts
text_sort(words);                                    // list_sort orders numbers only
var nums: list<i64> = [3, 1, 2];
nums[0] = 7;
list_add(nums, 9);
var ages: map<i64>;
ages["ana"] = 31;
print(map_get_or(ages, "eva", -1));
```

- A `"..."` is a string literal: the address of its bytes. Two literals
  compared with `==` compare addresses. Compare **texts** (a `text`
  variable on one side), or use `str_equals`.
- `list_sort` orders numbers; a list of texts is ordered by `text_sort`.
- A struct field that is a list or a map starts at 0: give it `list_new()`
  or `map_new()` first. Then `s.items[i]` reads and writes it.

## 5. Threads

Code that runs in a thread may only touch globals declared `shared`; the
compiler refuses anything else.

```
shared var total: i64;

fn worker(arg: i64) -> i64 {
    lock_take(0);
    total = total + arg;
    lock_give(0);
    return 0;
}

fn main() {
    lock_init(0);
    var h: i64 = thread_start(worker, 5);
    thread_wait(h);
    print(total);
    return 0;
}
```

Locks 0 to 7 are the program's. `std_task.kr` (`task_for`) and
`std_chan.kr` (channels) are the easier ways.

## 6. Raw access

Memory by address, system calls and C calls compile only inside
`raw { }`:

```
var buf: [u8; 16];
raw {
    var p: i64 = &buf;
    poke8(p, 75);
    print(peek8(p));
}
```

`peek8/16/32`, `peek`, `poke8/16/32`, `poke`, `syscall`, `dll_load`,
`dll_proc`, `call f(...)` and `c_call(address, ...)` are all raw-only.
`extern "lib" { fn name(...) -> T; }` declares C functions of a library.

## 7. The rules a newcomer breaks

Each of these is an error (or worse) in Kron, though other languages allow
it:

1. **A global is declared before any line that uses it**, in the file's
   order. Put the `var` lines of globals at the top.
2. **A function used as a value** (passed, stored, given as a hook) is
   defined above the line that uses it as a value. Calling it is fine
   anywhere.
3. **Two modules must not have globals of the same name**: it is an error
   at the second declaration, naming both modules. Give each module's
   globals a prefix (`vid_count`, `snd_count`). Functions of the same name
   in two modules are allowed (`module.name` picks one).
4. **`text` needs `std_text.kr` imported** (or `std_map.kr`, which brings
   it). `list<T>` and `map<T>` need `std_list.kr` and `std_map.kr`.
5. **Reserved words.** These cannot name anything: `fn var const if else
   while for switch case default break continue return struct enum true
   false raw fail as ptr extern sizeof failed print_fail print printc`
   and the types (`i64 f64 bool text`...), the threads' and memory
   built-ins (`thread_start lock_take peek poke dll_load`...) and the
   header words (`kron_program`...).

   Many other words are kept only where their construct stands and are
   names everywhere else: `shared` (before `var`), `in` (in `for x in`),
   `hint` (in `fail "..." hint "..."`), `slice` (before `<`), `stream`
   and `void` (where a type goes), `loop` and `asm` (before `{`), `call`,
   the built-ins written as calls (`outb inb trunc ticks beep readkey
   savefile loadfile cpu_count target_os mousex`...), the system-model
   module words (`ring kernel power driver security boot mmu`...) and
   `from new delete null import module range epoch`. A program that
   defines a function with such a name (`fn trunc(x: f64)`) calls its own.
6. **No `++`, `--` or `?:`.** Write `i += 1` and an `if`.
7. **Integer division truncates toward zero** (`-7 / 2` is `-3`). Write
   reals as reals when a real is wanted: `7.0 / 2.0`.
8. **Big arrays go in globals**: a local array of tens of thousands of
   elements does not fit on the stack.
9. **A struct is a value**: assigning or passing it copies it. Use
   `ptr<S>` (`&s`) to change it in place.
10. **Up to 16 parameters and 6 results** a function, and a call gives
    exactly as many arguments as the function declares. An array of the
    function's own cannot be returned (it ends with the function): return
    a struct that holds it, or fill an array the caller passes.
11. **Everything in the code is in English**: names, comments, messages.

## 8. The standard library

Each module starts with a comment that lists its functions and how they are
used. Read that comment for the module the task needs, not the whole file.

| Need | Module |
|---|---|
| maths | `std_math.kr` (`fsqrt fsin fcos fabs fmin fmax fclamp ffloor fround m_pi`), `std_exp.kr` (`fexp fln fpow`), `std_math3d.kr` (`Vec2 Vec3 Vec4 Quat Mat4`) |
| texts, lists, maps | `std_text.kr` `std_list.kr` `std_map.kr` |
| files, time, the system | `std_file.kr` `std_time.kr` `std_os.kr` |
| threads | `std_task.kr` `std_chan.kr` |
| memory | `std_arena.kr` (checked slices) |
| network | `std_net.kr` (TCP, UDP) |
| pictures | `std_image.kr` (PNG, JPEG, BMP) |
| a window, keys, mouse, touches | `std_window.kr`; controls: `std_ui.kr` |
| 3D, shaders, compute | `std_gpu.kr` `std_shader.kr` (KSL); G-buffers, hdr, indirect draws: MANUAL_EN.md, "What a renderer is built from" |
| sound | `std_audio.kr`; `std_vorbis.kr` (Ogg), `std_mp3.kr` (MP3) |
| video | `std_video.kr` (MPEG-1 `.mpg`) |
| controllers | `std_gamepad.kr` |
| JSON | `std_json.kr` |
| phone apps | `std_app.kr` |

## 9. A whole program

```
kron_program
kron_domain example;
kron_imports
acquire_domain "std_map.kr";
kron_definitions

const MIN_COUNT: i64 = 2;
var ex_calls: i64;                  // a global: declared before any use

struct Stat {
    word: text;
    count: i64;
}

fn checked_ratio(a: i64, b: i64) -> f64 {
    if b == 0 {
        fail "division by zero" hint "pass a total above 0";
    }
    return (a as f64) / (b as f64);
}

fn keep_if(l: list<i64>, test: fn(i64) -> i64) -> list<i64> {
    var out: list<i64> = [];
    for x in l {
        if test(x) == 1 { list_add(out, x); }
    }
    return out;
}

fn is_even(x: i64) -> i64 {         // above main, which uses it as a value
    if x % 2 == 0 { return 1; }
    return 0;
}

fn main() {
    var words = text_split("the cat and the dog and the bird", " ");
    var counts: map<i64>;
    for w in words {
        counts[w] = map_get_or(counts, w, 0) + 1;
        ex_calls += 1;
    }
    var stats: list<Stat>;
    var keys = map_keys(counts);
    for k in keys {
        if counts[k] >= MIN_COUNT {
            var s: Stat;
            s.word = k;
            s.count = counts[k];
            list_add(stats, s);
        }
    }
    for s in stats {
        say(s.word + ": " + s.count);
    }
    print(checked_ratio(3, 4));
    print(checked_ratio(1, 0));
    if failed() {
        print_fail();
    }
    var evens = keep_if([1, 2, 3, 4, 6], is_even);
    print(evens);
    say("words read: " + ex_calls);
    return 0;
}
```

It prints:

```
the: 3
and: 2
0.750000
0.000000
fail: division by zero
hint: pass a total above 0
  at checked_ratio (example.kr:20)
  called from main (example.kr:59)
[2, 4, 6]
words read: 8
```

## 10. Before handing code over

Build it with `--check` (or build and run it). The compiler's errors give
the file, line and column, and usually a hint; fix them in order, from the
first.
