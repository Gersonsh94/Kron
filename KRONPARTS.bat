@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM   KRON - THE PARTS OF THE COMPILER WRITTEN IN KRON
REM
REM   KRONPARTS.bat COMPILER
REM
REM   Makes the assembly text of each part again, with COMPILER
REM   (kronc.exe when none is named):
REM
REM       lexer\lexer.kr    makes  lexer\lexer_kr.asm
REM       parser\parser.kr  makes  parser\parser_kr.asm
REM       semantic\semantic.kr  makes  semantic\semantic_kr.asm
REM
REM   kron_all.asm includes those files, so kasm still builds the
REM   whole compiler alone. BUILD.bat and BOOTSTRAP.bat call this
REM   with each compiler they build: the fixpoint then covers the
REM   parts in Kron too.
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
