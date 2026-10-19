# Templates: Kron on phones

| Folder          | What it is                                                      |
|-----------------|-----------------------------------------------------------------|
| `app.kr`        | A whole app in Kron (std_ui, touch, keyboard), for both phones |
| `android/`      | The Android project around it: NativeActivity, no Java         |
| `ios/`          | The iOS project around it: a 90-line Swift shell, XcodeGen     |
| `react-native/` | Kron functions called from a React Native app (both phones)    |

`app.kr` runs on a computer too (`kronc templates\app.kr`), which is the
quickest way to work on it.
