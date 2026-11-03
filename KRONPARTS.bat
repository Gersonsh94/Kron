@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM   KRON - THE PARTS OF THE COMPILER WRITTEN IN KRON
REM
REM   KRONPARTS.bat COMPILER
REM
REM   Makes the assembly text of each part again, with COMPILER
REM   (kronc.exe when none is named): each NAME.kr below makes
REM   NAME_kr.asm next to it (kronc --module).
REM
REM   Those files are not sources: they are made, as an object
REM   file is, and they are not kept in the repository. kron_all.asm
REM   includes them, so kasm still builds the whole compiler alone.
REM   BUILD.bat and BOOTSTRAP.bat call this first with the compiler
REM   they start from, then with each compiler they build: the
REM   fixpoint covers the parts in Kron too.
REM ============================================================

set "JC=%~1"
if "%JC%"=="" set "JC=kronc.exe"
if not exist "%JC%" (
    echo [ERROR] compiler not found: %JC%
    exit /b 1
)

call :part lexer\lexer.kr
if errorlevel 1 exit /b 1
call :part parser\parser.kr
if errorlevel 1 exit /b 1
call :part semantic\semantic.kr
if errorlevel 1 exit /b 1
call :part codegen\codegen.kr
if errorlevel 1 exit /b 1
call :part kasm.kr
if errorlevel 1 exit /b 1
call :part imports.kr
if errorlevel 1 exit /b 1
call :part pe_writer.kr
if errorlevel 1 exit /b 1
call :part elf_writer.kr
if errorlevel 1 exit /b 1
call :part macho_writer.kr
if errorlevel 1 exit /b 1
call :part krn_writer.kr
if errorlevel 1 exit /b 1
call :part web_writer.kr
if errorlevel 1 exit /b 1
call :part xarm.kr
if errorlevel 1 exit /b 1
call :part xarm_tails.kr
if errorlevel 1 exit /b 1
call :part xwasm.kr
if errorlevel 1 exit /b 1
call :part karm_core.kr
if errorlevel 1 exit /b 1
call :part karm_alu.kr
if errorlevel 1 exit /b 1
call :part karm_mem.kr
if errorlevel 1 exit /b 1
call :part main_pp.kr
if errorlevel 1 exit /b 1
call :part main_io.kr
if errorlevel 1 exit /b 1
call :part main_cli.kr
if errorlevel 1 exit /b 1
call :part main_drv.kr
if errorlevel 1 exit /b 1
call :part main_out.kr
if errorlevel 1 exit /b 1
exit /b 0

:part
"%JC%" %1 --module >nul 2>&1
if errorlevel 1 (
    echo   [FAIL] %1 does not compile:
    "%JC%" %1 --module
    exit /b 1
)
echo   %1
exit /b 0
