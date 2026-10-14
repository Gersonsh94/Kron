@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM   JUPITER - DIFFERENTIAL CODEGEN DIFF
REM
REM   Two compilers built from the SAME source, one assembled by
REM   NASM (good) and one by jasm (bad).  Feed both the same .jup
REM   and diff what they emit.  Wherever the output differs, jasm
REM   mis-encoded the routine that produced it.
REM
REM   Usage:
REM     DIFFGEN.bat                       good=jupiterc_splice.exe
REM                                       bad =boot3.exe
REM     DIFFGEN.bat GOOD.exe BAD.exe      pick your own pair
REM
REM   Results land in tests\diffgen\ :
REM     NAME.good.asm / NAME.bad.asm      generated assembly
REM     NAME.good.log / NAME.bad.log      compiler stdout
REM     NAME.diff.txt                     the differences
REM ============================================================

set "GOOD=jupiterc_splice.exe"
set "BAD=boot3.exe"
if not "%~1"=="" set "GOOD=%~1"
if not "%~2"=="" set "BAD=%~2"

if not exist "%GOOD%" ( echo [ERROR] good compiler not found: %GOOD% & exit /b 1 )
if not exist "%BAD%"  ( echo [ERROR] bad compiler not found: %BAD%  & exit /b 1 )

set OUT=tests\diffgen
if not exist tests mkdir tests
if not exist "%OUT%" mkdir "%OUT%"
del /q "%OUT%\*" >nul 2>&1

REM  the eight programs that fail, plus the negative tests that
REM  are wrongly accepted -- those exercise semantic validation
set LIST=test_math test_stdlib test_vec3 test_stats test_exp test_ml test_random cube3d
set LIST=%LIST% test_arena_bad test_arena_dup test_arena_zero test_mmu_bad
set LIST=%LIST% test_pgf_bad test_pool_bad test_boot_bad test_arena_ovl
REM  two that PASS on both -- if these differ too, the damage is wider
set LIST=%LIST% test_float test_fmix

echo ============================================================
echo   DIFFERENTIAL CODEGEN DIFF
echo   good: %GOOD%
echo   bad : %BAD%
echo ============================================================
echo.

set /a SAME=0
set /a DIFFER=0
set /a ONLYGOOD=0
set /a ONLYBAD=0
set /a NEITHER=0

for %%T in (%LIST%) do call :compare %%T

echo.
echo ============================================================
echo   SAME OUTPUT:        !SAME!
echo   DIFFERENT OUTPUT:   !DIFFER!
echo   ONLY GOOD EMITS:    !ONLYGOOD!
echo   ONLY BAD EMITS:     !ONLYBAD!
echo   NEITHER EMITS:      !NEITHER!
echo.
echo   Diffs are in %OUT%\NAME.diff.txt
echo   Start with the SHORTEST diff -- it is the cleanest signal.
echo ============================================================
echo.
exit /b 0

:compare
set "N=%~1"
if not exist "%N%.jup" (
    echo   skip    %N%  ^(no .jup^)
    goto :eof
)

if exist "%N%.asm" del /q "%N%.asm" >nul 2>&1
"%GOOD%" "%N%.jup" >"%OUT%\%N%.good.log" 2>&1
if exist "%N%.asm" (
    move /y "%N%.asm" "%OUT%\%N%.good.asm" >nul
    set "G=1"
) else (
    set "G=0"
)

if exist "%N%.asm" del /q "%N%.asm" >nul 2>&1
"%BAD%" "%N%.jup" >"%OUT%\%N%.bad.log" 2>&1
if exist "%N%.asm" (
    move /y "%N%.asm" "%OUT%\%N%.bad.asm" >nul
    set "B=1"
) else (
    set "B=0"
)

if "!G!!B!"=="00" (
    echo   none    %N%  ^(neither emits .asm^)
    set /a NEITHER+=1
    goto :eof
)
if "!G!!B!"=="10" (
    echo   GOOD^>   %N%  ^(only the good compiler emits^)
    set /a ONLYGOOD+=1
    goto :eof
)
if "!G!!B!"=="01" (
    echo   BAD^>    %N%  ^(only the bad compiler emits -- accepted what it should reject^)
    set /a ONLYBAD+=1
    goto :eof
)

fc "%OUT%\%N%.good.asm" "%OUT%\%N%.bad.asm" >"%OUT%\%N%.diff.txt" 2>&1
if errorlevel 1 (
    set "LINES="
    for /f %%C in ('find /c /v "" ^< "%OUT%\%N%.diff.txt"') do set "LINES=%%C"
    echo   DIFFER  %N%  ^(!LINES! lines of diff^)
    set /a DIFFER+=1
) else (
    del /q "%OUT%\%N%.diff.txt" >nul 2>&1
    echo   same    %N%
    set /a SAME+=1
)
goto :eof
