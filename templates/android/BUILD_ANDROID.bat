@echo off
REM ===========================================================================
REM   KRON - an Android app from templates\app.kr
REM
REM   1. kronc builds app.kr into libkronapp.so, the library NativeActivity
REM      loads (ARM64, Android's C library)
REM   2. Gradle packs it into an APK, if Gradle is here: open this folder in
REM      Android Studio once (File > Open), which sets Gradle up, then run
REM      this again -- or press Run in Android Studio, with a phone plugged in
REM      (USB debugging on) or an ARM64 emulator.
REM
REM     BUILD_ANDROID.bat              kronc from the Kron folder, two up
REM     BUILD_ANDROID.bat /c:PATH      another kronc
REM ===========================================================================
setlocal EnableDelayedExpansion
cd /d "%~dp0"
set "JC=..\..\kronc.exe"
for %%A in (%*) do (
    set "ARG=%%~A"
    if /I "!ARG:~0,3!"=="/c:" set "JC=!ARG:~3!"
)
if not exist "%JC%" (
    echo [ERROR] kronc not found: %JC%
    exit /b 1
)
for %%F in ("%JC%") do set "JC=%%~fF"
pushd ..\..
"%JC%" templates\app.kr --target=android --lib -o templates\android\app\src\main\jniLibs\arm64-v8a\libkronapp.so
set RC=%errorlevel%
popd
if not "%RC%"=="0" (
    echo [ERROR] kronc could not build the app
    exit /b 1
)
echo [OK] app\src\main\jniLibs\arm64-v8a\libkronapp.so
if exist gradlew.bat (
    call gradlew.bat assembleDebug
    if errorlevel 1 exit /b 1
    echo [OK] app\build\outputs\apk\debug\app-debug.apk
    echo      install it with:  adb install -r app\build\outputs\apk\debug\app-debug.apk
) else (
    echo Open this folder in Android Studio and press Run: it packs the APK.
)
exit /b 0
