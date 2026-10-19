@echo off
:: ============================================================
::  kc.bat - Kron -> native .exe, in one command
::
::    kc.bat program.kr          the .kr straight to the .exe,
::                               next to it; nothing else written
:: ============================================================

if "%~1"=="" (
    echo Usage: kc.bat file.kr
    exit /b 1
)

set "SRC=%~1"
set "EXE=%~dpn1.exe"

if not exist "%SRC%" (
    echo Not found: %SRC%
    exit /b 1
)

"%~dp0kronc.exe" "%SRC%"
if not exist "%EXE%" (
    echo Compilation failed.
    exit /b 1
)

echo.
echo ============================================================
echo   DONE: %EXE%
echo ============================================================
exit /b 0
