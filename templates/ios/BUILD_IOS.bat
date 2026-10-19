@echo off
REM ===========================================================================
REM   KRON - the Kron part of an iOS app, from templates\app.kr
REM
REM   kronc builds app.kr into KronApp.framework (ARM64, iOS 14 on), which
REM   the Swift app in App\ shows on the screen. The app itself is put
REM   together on a Mac: copy this folder there, then
REM       xcodegen generate        (or make the project by hand: README.md)
REM       open KronDemo.xcodeproj  and Run on an iPhone
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
if not exist KronApp.framework mkdir KronApp.framework
copy /y KronApp.framework.Info.plist KronApp.framework\Info.plist >nul
pushd ..\..
"%JC%" templates\app.kr --target=ios --lib -o templates\ios\KronApp.framework\KronApp
set RC=%errorlevel%
popd
if not "%RC%"=="0" (
    echo [ERROR] kronc could not build the app
    exit /b 1
)
echo [OK] KronApp.framework -- now on a Mac: xcodegen generate, then Run in Xcode
exit /b 0
