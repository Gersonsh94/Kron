@echo off
setlocal enabledelayedexpansion
echo ============================================================
echo   KRON - BOOTSTRAP FIXPOINT
echo   Three self-compiled generations, compared byte for byte
echo   (each generation compiles kron.kr, the compiler, with the
echo   one before it: gen 1 with the installed kronc.exe)
echo ============================================================
echo.

if not exist kronc.exe (
    echo [ERROR] kronc.exe missing -- run BUILD.bat first
    exit /b 1
)
if not exist kron.kr (
    echo [ERROR] kron.kr missing
    exit /b 1
)

del /q boot1.exe boot2.exe boot3.exe 2>nul

echo [gen 1] kronc.exe (the installed compiler) --^> boot1.exe
kronc.exe kron.kr -o boot1.exe >nul
if not exist boot1.exe goto :nogen1

echo [gen 2] boot1.exe --^> boot2.exe
boot1.exe kron.kr -o boot2.exe >nul
if not exist boot2.exe goto :nogen2

echo [gen 3] boot2.exe --^> boot3.exe
boot2.exe kron.kr -o boot3.exe >nul
if not exist boot3.exe goto :nogen3

echo.
echo --- comparing ---
fc /b boot2.exe boot3.exe >nul
if errorlevel 1 goto :nofix

fc /b boot1.exe boot2.exe >nul
if errorlevel 1 goto :fixgen1

echo.
echo ============================================================
echo   FIXPOINT REACHED
echo   gen1 == gen2 == gen3
echo.
echo   The compiler, a Kron program compiled by itself, assembled by
echo   its own kasm and written by its own pe_writer, reproduces
echo   itself exactly: nothing else took part.
echo ============================================================
goto :verify

:fixgen1
echo.
echo ============================================================
echo   FIXPOINT REACHED
echo   gen2 == gen3
echo.
echo   gen1 differs: the installed kronc.exe was built from older sources
echo   (normal right after an update -- BUILD.bat installs the new one).
echo   The fixpoint holds from gen2 on.
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
echo   [FAIL] gen 1 produced no executable:
kronc.exe kron.kr -o boot1.exe
exit /b 1
:nogen2
echo   [FAIL] gen 2 produced no executable:
boot1.exe kron.kr -o boot2.exe
exit /b 1
:nogen3
echo   [FAIL] gen 3 produced no executable:
boot2.exe kron.kr -o boot3.exe
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
