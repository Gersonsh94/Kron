@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM   KRON - SELF-HOSTING MEASURE
REM
REM   For each module of the compiler:
REM     1) nasm -E preprocesses it (expands %include / %define / %macro)
REM     2) kasm tries to assemble it
REM     3) counts how many lines it does not support
REM
REM   nasm acts only as a PREPROCESSOR, it assembles nothing. This is
REM   scaffolding to measure what kasm still lacks, not the goal.
REM
REM   Usage:  SELFHOST.bat
REM ============================================================

set TMPDIR=tests\self
if not exist "tests"    mkdir "tests"
if not exist "%TMPDIR%" mkdir "%TMPDIR%"

set /a READY=0
set /a MISSING=0

echo ============================================================
echo   SELF-HOSTING - which modules kasm can take
echo ============================================================
echo.

call :one_module main
call :one_module lexer
call :one_module parser
call :one_module semantic
call :one_module codegen
call :one_module runtime
call :one_module linker
call :one_module kasm
call :one_module jpx
call :one_module karm
call :one_module xarm
call :one_module xwasm
call :one_module macho
call :one_module pe_writer

echo.
echo ============================================================
echo   ASSEMBLE: !READY!     MISSING SOMETHING: !MISSING!
echo ============================================================
echo.
echo   Details for each one are in %TMPDIR%\
echo.
pause
goto :end

:one_module
set "M=%~1"
set "SRC="
if exist "%M%.asm"        set "SRC=%M%.asm"
if exist "%M%\%M%.asm"    set "SRC=%M%\%M%.asm"
if not defined SRC (
    echo   ?       %M%  ^(cannot find the .asm^)
    goto :eof
)

REM 1) preprocess with nasm
.\nasm.exe -E -i include\ "%SRC%" -o "%TMPDIR%\%M%.pre.asm" >"%TMPDIR%\%M%.nasm.log" 2>&1
if not exist "%TMPDIR%\%M%.pre.asm" (
    echo   ?       %M%  ^(nasm -E failed, see %TMPDIR%\%M%.nasm.log^)
    set /a MISSING+=1
    goto :eof
)

REM 2) try to assemble with kasm
if exist "%TMPDIR%\%M%.pre.exe" del "%TMPDIR%\%M%.pre.exe" >nul 2>&1
.\kronc.exe "%TMPDIR%\%M%.pre.asm" --assemble --pe >"%TMPDIR%\%M%.kasm.log" 2>&1

if exist "%TMPDIR%\%M%.pre.exe" (
    echo   OK      %M%
    set /a READY+=1
    goto :eof
)

REM 3) count the lines it does not support
set /a N=0
for /f %%L in ('findstr /c:"at line" "%TMPDIR%\%M%.kasm.log" 2^>nul ^| find /c /v ""') do set /a N=%%L
echo   MISSING %M%  ^(!N! lines^)
set /a MISSING+=1
goto :eof

:end
endlocal
