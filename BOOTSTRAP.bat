@echo off
setlocal enabledelayedexpansion
echo ============================================================
echo   KRON - BOOTSTRAP FIXPOINT
echo   Three self-compiled generations, compared byte for byte
echo ============================================================
echo.

if not exist kronc.exe (
    echo [ERROR] kronc.exe missing -- run BUILD.bat first
    exit /b 1
)
if not exist kron_all.asm (
    echo [ERROR] kron_all.asm missing
    exit /b 1
)

del /q kron_all.exe boot1.exe boot2.exe boot3.exe 2>nul

echo [gen 1] kronc.exe (NASM) --^> boot1.exe
kronc.exe kron_all.asm --assemble --pe >nul
if not exist kron_all.exe goto :nogen1
copy /y kron_all.exe boot1.exe >nul
del /q kron_all.exe

echo [gen 2] boot1.exe --^> boot2.exe
boot1.exe kron_all.asm --assemble --pe >nul
if not exist kron_all.exe goto :nogen2
copy /y kron_all.exe boot2.exe >nul
del /q kron_all.exe

echo [gen 3] boot2.exe --^> boot3.exe
boot2.exe kron_all.asm --assemble --pe >nul
if not exist kron_all.exe goto :nogen3
copy /y kron_all.exe boot3.exe >nul
del /q kron_all.exe

echo.
echo --- comparing ---
fc /b boot2.exe boot3.exe >nul
if errorlevel 1 goto :nofix

fc /b boot1.exe boot2.exe >nul
if errorlevel 1 goto :fixnonasm

echo.
echo ============================================================
echo   FIXPOINT REACHED
echo   gen1 == gen2 == gen3
echo.
echo   All three generations are emitted by kasm, so this does NOT say
echo   kasm and NASM agree byte for byte -- they do not, kasm uses movabs
echo   and its .text comes out larger. What it does say is stronger:
echo   the compiler reproduces itself exactly, and the NASM-built and
echo   kasm-built compilers behave identically.
echo ============================================================
goto :verify

:fixnonasm
echo.
echo ============================================================
echo   FIXPOINT REACHED
echo   gen2 == gen3
echo.
echo   gen1 differs, which means the NASM-built compiler and the
echo   kasm-built one do not emit identical output. The fixpoint still
echo   holds from gen2 on, but that gap is worth looking into.
echo ============================================================
goto :verify

:verify
echo.
echo --- does the fixpoint binary compile? ---
if not exist test_fp1.kr (
    echo   [skipped] test_fp1.kr missing
    goto :ok
)
del /q test_fp1.asm test_fp1.exe 2>nul
REM  one step, .kr to .exe, the way a user builds
boot3.exe test_fp1.kr >nul
if not exist test_fp1.exe goto :badcompile
test_fp1.exe >nul
echo   OK -- compiles, assembles, and the executable runs
:ok
echo.
exit /b 0

:nogen1
echo   [FAIL] gen 1 produced no executable
exit /b 1
:nogen2
echo   [FAIL] gen 2 produced no executable -- boot1 cannot assemble
exit /b 1
:nogen3
echo   [FAIL] gen 3 produced no executable -- boot2 cannot assemble
exit /b 1

:nofix
echo.
echo ============================================================
echo   NO FIXPOINT -- gen2 and gen3 differ
echo   The compiler introduces error when reproducing itself.
echo   Diff:  fc /b boot2.exe boot3.exe
echo ============================================================
exit /b 1

:badcompile
echo   [FAIL] boot3 produced no test_fp1.exe
exit /b 1
