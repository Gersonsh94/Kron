@echo off
setlocal enabledelayedexpansion

:: ============================================================
::  kc.bat - Kron -> native .exe, in one command
::
::    kc.bat program.kr          sovereign path: kronc only
::    kc.bat program.kr /nasm    with NASM and GoLink, to audit
::
::  Writes program.asm and program.exe next to the source.
::
::  The default path uses neither NASM nor GoLink: kronc assembles
::  and writes the PE itself. /nasm is there to compare, which is
::  how kasm bugs get caught -- NASM complains about an undefined
::  symbol and kasm does not.
::
::  acquire_domain resolves nested imports on its own: a program
::  imports only the modules it uses directly.
:: ============================================================

if "%~1"=="" (
    echo Usage: kc.bat file.kr [/nasm]
    exit /b 1
)

set "SRC=%~1"
set "BASE=%~dpn1"
set "ASM=%BASE%.asm"
set "OBJ=%BASE%.obj"
set "EXE=%BASE%.exe"

set "USENASM="
if /i "%~2"=="/nasm" set "USENASM=1"

if not exist "%SRC%" (
    echo Not found: %SRC%
    exit /b 1
)

echo.
echo === [1] Kron: %SRC% -^> %ASM% ===
"%~dp0kronc.exe" "%SRC%"
if %errorlevel% neq 0 (
    echo Compilation failed.
    exit /b 1
)
if not exist "%ASM%" (
    echo No .asm was written
    exit /b 1
)

if defined USENASM goto :via_nasm

echo.
echo === [2] kasm + pe_writer: %ASM% -^> %EXE% ===
"%~dp0kronc.exe" "%ASM%" --assemble --pe
if %errorlevel% neq 0 (
    echo kasm failed to assemble.
    exit /b 1
)
goto :done

:via_nasm
echo.
echo === [2] NASM: %ASM% -^> %OBJ% ===
nasm.exe -f win64 -o "%OBJ%" "%ASM%"
if %errorlevel% neq 0 (
    echo NASM failed. An undefined symbol usually means a function
    echo that is missing: check the acquire_domain lines.
    exit /b 1
)

echo.
echo === [3] GoLink: %OBJ% -^> %EXE% ===
GoLink.exe /fo "%EXE%" /entry main /console "%OBJ%" kernel32.dll
if %errorlevel% neq 0 (
    echo GoLink failed to link.
    exit /b 1
)

:done
if not exist "%EXE%" (
    echo No .exe was written
    exit /b 1
)
echo.
echo ============================================================
echo   DONE: %EXE%
echo ============================================================
