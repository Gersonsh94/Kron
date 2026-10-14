@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM   KRON - AUDIT BUILD  (NASM + GoLink)
REM
REM   This is no longer the canonical build.  BUILD.bat now
REM   builds from seed\kronc.exe with no external tools.
REM
REM   Kept for two things the kasm path cannot do:
REM
REM     1. Rebuild the compiler from source with a third-party
REM        assembler, so the seed binary can be audited by
REM        anyone who does not trust it.
REM     2. Assemble the fourteen modules SEPARATELY.  The splice
REM        in kron_all.asm keeps only the first copy of each
REM        %include, which hides duplicate symbols and missing
REM        externs that separate assembly would catch.
REM
REM   Output goes to kronc_nasm.exe so it cannot clobber the
REM   binary that BUILD.bat installed.
REM ============================================================

echo.
echo ============================================================
echo   KRON COMPILER v1.0 - AUDIT BUILD, WINDOWS
echo   Tools: NASM + GoLink
echo ============================================================
echo.

where nasm >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: NASM not found. Install NASM and add it to PATH.
    pause
    exit /b 1
)

where GoLink >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: GoLink not found. Install GoLink and add it to PATH.
    pause
    exit /b 1
)

echo [OK] NASM found
echo [OK] GoLink found
echo.

if not exist obj mkdir obj

echo [1/14] Assembling main.asm...
nasm -f win64 -i include\ -o obj\main.obj main.asm
if %errorlevel% neq 0 ( echo ERROR in main.asm & pause & exit /b 1 )
echo       OK

echo [2/14] Assembling lexer...
nasm -f win64 -i include\ -o obj\lexer.obj lexer\lexer.asm
if %errorlevel% neq 0 ( echo ERROR in lexer.asm & pause & exit /b 1 )
echo       OK

echo [3/14] Assembling parser...
nasm -f win64 -i include\ -o obj\parser.obj parser\parser.asm
if %errorlevel% neq 0 ( echo ERROR in parser.asm & pause & exit /b 1 )
echo       OK

echo [4/14] Assembling semantic...
nasm -f win64 -i include\ -o obj\semantic.obj semantic\semantic.asm
if %errorlevel% neq 0 ( echo ERROR in semantic.asm & pause & exit /b 1 )
echo       OK

echo [5/14] Assembling codegen...
nasm -f win64 -i include\ -o obj\codegen.obj codegen\codegen.asm
if %errorlevel% neq 0 ( echo ERROR in codegen.asm & pause & exit /b 1 )
echo       OK

echo [6/14] Assembling runtime...
nasm -f win64 -i include\ -o obj\runtime.obj runtime\runtime.asm
if %errorlevel% neq 0 ( echo ERROR in runtime.asm & pause & exit /b 1 )
echo       OK

echo [7/14] Assembling linker...
nasm -f win64 -i include\ -o obj\linker_mod.obj linker\linker.asm
if %errorlevel% neq 0 ( echo ERROR in linker.asm & pause & exit /b 1 )
echo       OK

echo [8/14] Assembling kasm (own assembler)...
nasm -f win64 -i include\ -o obj\kasm.obj kasm.asm
if %errorlevel% neq 0 ( echo ERROR in kasm.asm & pause & exit /b 1 )
echo       OK

echo [9/14] Assembling krn (own format)...
nasm -f win64 -i include\ -o obj\krn.obj krn.asm
if %errorlevel% neq 0 ( echo ERROR in krn.asm & pause & exit /b 1 )
echo       OK

echo [10/14] Assembling karm (ARM64 assembler)...
nasm -f win64 -i include\ -o obj\karm.obj karm.asm
if %errorlevel% neq 0 ( echo ERROR in karm.asm & pause & exit /b 1 )
echo       OK

echo [11/14] Assembling xarm (lowering to ARM64)...
nasm -f win64 -i include\ -o obj\xarm.obj xarm.asm
if %errorlevel% neq 0 ( echo ERROR in xarm.asm & pause & exit /b 1 )
echo       OK

echo [12/14] Assembling xwasm (lowering to WebAssembly)...
nasm -f win64 -i include\ -o obj\xwasm.obj xwasm.asm
if %errorlevel% neq 0 ( echo ERROR in xwasm.asm & pause & exit /b 1 )
echo       OK

echo [13/14] Assembling macho (the macOS executable)...
nasm -f win64 -i include\ -o obj\macho.obj macho.asm
if %errorlevel% neq 0 ( echo ERROR in macho.asm & pause & exit /b 1 )
echo       OK

echo [14/14] Assembling pe_writer...
nasm -f win64 -i include\ -o obj\pe_writer.obj pe_writer.asm
if %errorlevel% neq 0 ( echo ERROR in pe_writer.asm & pause & exit /b 1 )
echo       OK

echo.
echo Linking with GoLink...
GoLink /fo kronc_nasm.exe /entry main /console ^
    obj\main.obj ^
    obj\lexer.obj ^
    obj\parser.obj ^
    obj\semantic.obj ^
    obj\codegen.obj ^
    obj\runtime.obj ^
    obj\linker_mod.obj ^
    obj\kasm.obj ^
    obj\krn.obj ^
    obj\karm.obj ^
    obj\xarm.obj ^
    obj\xwasm.obj ^
    obj\macho.obj ^
    obj\pe_writer.obj ^
    kernel32.dll

if %errorlevel% neq 0 (
    echo ERROR: GoLink failed to link.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   kronc_nasm.exe written (audit build)
echo   Compare it with the compiler Kron builds itself:
echo     fc /b kronc.exe kronc_nasm.exe
echo ============================================================
echo.
pause
