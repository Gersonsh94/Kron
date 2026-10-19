# A Kron app on iOS

`templates/app.kr` is the whole app: Kron draws every pixel with std_ui and
reads the touches. The Swift in `App/` is the shell iOS requires around it:
it puts the program's pictures on the screen (about 90 lines, nothing to
change).

## 1. The Kron part, on any computer

```
templates\ios\BUILD_IOS.bat
```

or, from the Kron folder:

```
kronc templates\app.kr --target=ios --lib -o templates\ios\KronApp.framework\KronApp
copy templates\ios\KronApp.framework.Info.plist templates\ios\KronApp.framework\Info.plist
```

`KronApp.framework` holds the program for iPhones (ARM64, iOS 14 and later).

## 2. The app, on a Mac with Xcode

With [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`):

```
cd templates/ios
xcodegen generate
open KronDemo.xcodeproj
```

Without it: in Xcode, File > New > Project > iOS App (Swift, UIKit
"Storyboard" removed or kept), delete the generated Swift files, add
`App/KronApp.swift`, set *Objective-C Bridging Header* to `App/Bridging.h`,
and drag `KronApp.framework` into *Frameworks, Libraries, and Embedded
Content* with **Embed & Sign**.

Choose your team under Signing & Capabilities and press Run with an iPhone
plugged in. The simulator is not supported yet: the framework is built for
iPhones themselves.

## How it fits together

| Swift (App/KronApp.swift)        | Kron (std_app.kr, std_window.kr)         |
|----------------------------------|------------------------------------------|
| `kron_app_start(w, h)`           | starts `main` in a thread of its own     |
| `kron_app_frame(buffer, bytes)`  | the last picture `window_show` gave      |
| `kron_app_touch(phase, x, y)`    | the mouse's left button                  |
| `kron_app_key(key, ch)`          | `window_key`, `window_char`              |
| `kron_app_wants_keyboard()`      | a box to type in has the focus           |

The same calls embed a Kron program in any other app that can call C.

Note: the Kron runtime reaches the system with its calls directly, as it
does on macOS; Apple documents only its C library for that. It works on
current iOS versions; should a future one change it, the runtime will move
to the C library's functions, without changes to programs.
