# Kron in a React Native app

`kron_rn.kr` is a Kron library: its functions are called from JavaScript
through a small native module on each system. Here they add, count
Fibonacci numbers and build a greeting; any Kron code goes the same way.

## Android

1. Build the library for phones (ARM64):

   ```
   kronc templates\react-native\kron_rn.kr --target=android --lib -o libkron.so
   ```

2. In the React Native app, put it in `android/app/src/main/jniLibs/arm64-v8a/libkron.so`.
3. Copy `android/src/main/java/dev/kron/rn/` (KronNative.kt, KronModule.kt)
   into `android/app/src/main/java/dev/kron/rn/`.
4. Register the package in `MainApplication.kt`, in `getPackages()`:

   ```kotlin
   add(dev.kron.rn.KronPackage())
   ```

5. In `android/app/build.gradle`, `defaultConfig { ndk { abiFilters "arm64-v8a" } }`
   keeps the APK to the phones the library is built for.

`KronNative`'s methods are `external`: Android finds them in libkron.so by
their Java names, `Java_dev_kron_rn_KronNative_add` and so on, which
kron_rn.kr exports.

## iOS

1. Build the framework (on any computer):

   ```
   kronc templates\react-native\kron_rn.kr --target=ios --lib -o KronRN.framework\KronRN
   copy templates\react-native\ios\KronRN.framework.Info.plist KronRN.framework\Info.plist
   ```

2. On the Mac, in `ios/YourApp.xcworkspace`: drag `KronRN.framework` into the
   app target's *Frameworks, Libraries, and Embedded Content* with
   **Embed & Sign**, and add `ios/KronModule.m` to the target.

`KronModule.m` declares the plain C names kron_rn.kr exports (`kron_add`,
`kron_fib`, `kron_greet`) and calls them.

## JavaScript

Copy `js/Kron.js` into the app:

```js
import Kron from './Kron';
const sum = await Kron.add(2, 3);        // 5
const text = await Kron.greet('Ada');    // "Hello, Ada, from Kron"
```

`js/App.example.js` is a screen that uses it.

## Your own functions

Write them in a `.kr` file with `fn export`, numbers and strings as
parameters (`str` arrives as a pointer to UTF-8 bytes), and add a line for
each in KronNative.kt / KronModule.kt and KronModule.m. A whole screen drawn
by Kron is a different thing: see `templates/android` and `templates/ios`.
