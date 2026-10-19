@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM   KRON - SELF-BUILD
REM
REM   Builds kronc.exe from seed\kronc.exe using nothing
REM   but kasm and pe_writer.  No NASM.  No GoLink.
REM
REM   Three generations, because the seed may be an older
REM   compiler: stage1 is assembled by the seed's kasm, stage2
REM   by the kasm just built.  The parts of the compiler written
REM   in Kron (KRONPARTS.bat) go in as they are for stage1, and
REM   are made again by stage1 for stage2 and by stage2 for
REM   stage3.  Those two may legitimately
REM   differ.  stage2 and stage3 may not -- that is the fixpoint,
REM   and stage3 is what gets installed.
REM
REM   If you have no seed yet, SEED.bat kronc promotes the kronc.exe
REM   you have.
REM ============================================================

if not exist seed\kronc.exe (
    echo [ERROR] seed\kronc.exe missing -- run SEED.bat first
    exit /b 1
)
if not exist kron_all.asm (
    echo [ERROR] kron_all.asm missing
    exit /b 1
)

echo ============================================================
echo   KRON - SELF-BUILD
echo ============================================================
echo.
type seed\SEED.txt 2>nul
echo.

del /q stage1.exe stage2.exe stage3.exe kron_all.exe 2>nul

echo [stage 1] seed --^> stage1.exe
seed\kronc.exe kron_all.asm --assemble --pe >nul
if not exist kron_all.exe goto :nostage1
copy /y kron_all.exe stage1.exe >nul
del /q kron_all.exe

echo [stage 2] stage1.exe makes the parts in Kron again, then --^> stage2.exe
call KRONPARTS.bat stage1.exe
if errorlevel 1 goto :noparts
stage1.exe kron_all.asm --assemble --pe >nul
if not exist kron_all.exe goto :nostage2
copy /y kron_all.exe stage2.exe >nul
del /q kron_all.exe

echo [stage 3] stage2.exe makes the parts in Kron again, then --^> stage3.exe
call KRONPARTS.bat stage2.exe
if errorlevel 1 goto :noparts
stage2.exe kron_all.asm --assemble --pe >nul
if not exist kron_all.exe goto :nostage3
copy /y kron_all.exe stage3.exe >nul
del /q kron_all.exe

echo.
echo --- checking the fixpoint ---
fc /b stage2.exe stage3.exe >nul
if errorlevel 1 goto :nofix

fc /b stage1.exe stage2.exe >nul
if errorlevel 1 (
    echo   stage2 == stage3   ^(stage1 differs: older seed, expected^)
) else (
    echo   stage1 == stage2 == stage3
)

echo.
echo --- smoke test ---
if not exist test_fp1.kr (
    echo   [skipped] test_fp1.kr missing
    goto :install
)
del /q test_fp1.asm test_fp1.exe 2>nul
REM  one step, .kr to .exe, the way a user builds
stage3.exe test_fp1.kr >nul
if not exist test_fp1.exe goto :badcompile
test_fp1.exe >nul
echo   OK -- compiles, assembles, and the executable runs

:install
del /q kronc.exe 2>nul
copy /y stage3.exe kronc.exe >nul
if not exist kronc.exe goto :noinstall
del /q stage1.exe stage2.exe stage3.exe 2>nul

echo.
echo ============================================================
echo   kronc.exe installed, built by Kron's own tools
echo   Built by:  seed\kronc.exe  (no NASM, no GoLink)
echo.
echo   Next:  RUNTESTS.bat /slow
echo   Re-seed with SEED.bat only when both are green.
echo ============================================================
echo.
exit /b 0

:noparts
echo   [FAIL] a part of the compiler written in Kron does not compile
echo          -- kronc.exe was NOT replaced
exit /b 1
:nostage1
echo   [FAIL] stage 1 produced no executable -- the seed cannot
echo          assemble the current kron_all.asm
exit /b 1
:nostage2
echo   [FAIL] stage 2 produced no executable -- stage1 cannot assemble
exit /b 1
:nostage3
echo   [FAIL] stage 3 produced no executable -- stage2 cannot assemble
exit /b 1

:nofix
echo.
echo ============================================================
echo   NO FIXPOINT -- stage2 and stage3 differ
echo   The compiler introduces error when reproducing itself.
echo   kronc.exe was NOT replaced.
echo   Diff:  fc /b stage2.exe stage3.exe
echo ============================================================
exit /b 1

:badcompile
echo   [FAIL] stage3 produced no test_fp1.exe -- NOT installed
exit /b 1
:noinstall
echo   [FAIL] could not write kronc.exe ^(file in use?^)
exit /b 1
