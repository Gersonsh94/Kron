@echo off
:: ============================================================
::  kc.bat - Kron -> native .exe, in one command
::
::    kc.bat program.kr          kronc alone: the .kr straight to
::                               the .exe, nothing else written
::    kc.bat program.kr /nasm    through NASM and GoLink, to audit
::
::  kronc does the whole job itself: kc.bat stays for the /nasm
::  comparison, which is how kasm bugs get caught -- NASM
::  complains about an undefined symbol and kasm does not. The
::  .asm that path needs goes to the temporary folder.
:: ============================================================

if "%~1"=="" (
    echo Usage: kc.bat file.kr [/nasm]
    exit /b 1
)

set "SRC=%~1"
set "EXE=%~dpn1.exe"
set "ASM=%TEMP%\%~n1.asm"
set "OBJ=%TEMP%\%~n1.obj"

if not exist "%SRC%" (
    echo Not found: %SRC%
    exit /b 1
)

if /i "%~2"=="/nasm" goto :via_nasm

"%~dp0kronc.exe" "%SRC%"
if not exist "%EXE%" (
    echo Compilation failed.
    exit /b 1
)
goto :done

:via_nasm
"%~dp0kronc.exe" "%SRC%" -S -o "%ASM%"
if not exist "%ASM%" (
    echo Compilation failed.
    exit /b 1
)
nasm.exe -f win64 -o "%OBJ%" "%ASM%"
if %errorlevel% neq 0 (
    echo NASM failed. An undefined symbol usually means a function
    echo that is missing: check the acquire_domain lines.
    exit /b 1
)
GoLink.exe /fo "%EXE%" /entry main /console "%OBJ%" kernel32.dll >nul
if not exist "%EXE%" (
    echo GoLink failed to link.
    exit /b 1
)
del "%ASM%" "%OBJ%" >nul 2>&1
goto :done

:done
echo.
echo ============================================================
echo   DONE: %EXE%
echo ============================================================
exit /b 0
