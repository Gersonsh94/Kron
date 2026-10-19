# A Kron app on Android

`templates/app.kr` is the whole app: Kron draws every pixel with std_ui and
reads the touches and the keyboard. Android runs it through NativeActivity,
with no Java or Kotlin: the project here only packs the library into an APK.

## Build

1. The library, on any computer:

   ```
   templates\android\BUILD_ANDROID.bat
   ```

   or, from the Kron folder:

   ```
   kronc templates\app.kr --target=android --lib -o templates\android\app\src\main\jniLibs\arm64-v8a\libkronapp.so
   ```

2. The APK: open `templates\android` in Android Studio (File > Open) and press
   Run with a phone plugged in (USB debugging on) or an ARM64 emulator. Once
   Android Studio has set up Gradle, `BUILD_ANDROID.bat` builds the APK too:
   `app\build\outputs\apk\debug\app-debug.apk`, installed with
   `adb install -r app\build\outputs\apk\debug\app-debug.apk`.

## How it fits together

* `AndroidManifest.xml` names `android.app.NativeActivity` and the library,
  `libkronapp.so` (`android.app.lib_name` = `kronapp`).
* Android calls `ANativeActivity_onCreate` in the library: std_app.kr takes
  the window and the input queue from it and starts the program's `main` in
  a thread of its own.
* `window_open(0, 0, "")` takes the whole screen; `window_show` draws the
  picture into the window and reads the touches (the left button) and the
  keys (back is escape, 27). A box to type in brings up the keyboard.

Your own app: copy `templates\app.kr`, change it, and build it the same way.
Phones with ARM64 (every phone since about 2017) and Android 8 or later.
