@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM   KRON - KASM PATH (kasm + pe_writer, no NASM/GoLink)
REM
REM   For each program:
REM     1) builds it by the kasm path
REM     2) runs it
REM     3) compares its output with tests\expected\  (the reference
REM        RUNTESTS.bat captured by the NASM+GoLink path)
REM
REM   That checks not only that it assembles, but that it produces
REM   exactly the same as the external path.
REM ============================================================

set EXPDIR=tests\expected
set TMPDIR=tests\pe
if not exist "tests"    mkdir "tests"
if not exist "%TMPDIR%" mkdir "%TMPDIR%"
if exist "%TMPDIR%\_failures.txt" del "%TMPDIR%\_failures.txt" >nul 2>&1

set /a SAME=0
set /a DIFF=0
set /a NOASM=0
set /a NOREF=0

echo ============================================================
echo   KASM PATH - build, run and compare
echo ============================================================
echo.

for %%F in (*.kr) do call :one_test "%%~nF"

echo.
echo ============================================================
echo   SAME AS NASM:    !SAME!
echo   DIFFERENT OUTPUT: !DIFF!
echo   DOES NOT ASSEMBLE: !NOASM!
echo   NO REFERENCE:    !NOREF!
echo ============================================================
if !DIFF! GTR 0 (
    echo.
    echo   Programs whose output differs between the two paths:
    echo.
    type "%TMPDIR%\_failures.txt"
    echo.
    echo   That means kasm encodes some instruction wrong.
)
if !NOASM! GTR 0 (
    echo.
    echo   Assembly failures: see %TMPDIR%\_failures.txt
)
echo.
pause
goto :end

:one_test
set "N=%~1"

if /I "%N%"=="test_io"          goto :eof
if /I "%N%"=="test_mouse"       goto :eof
if /I "%N%"=="solidcube_anim"   goto :eof
if /I "%N%"=="solidcube_debug"  goto :eof
if /I "%N%"=="test_bad_syntax"              goto :eof

REM  One step, as a user builds: the .kr straight to the .exe, kept in the
REM  temporary folder. A file that does not compile is skipped, as before.
if exist "%TMPDIR%\%N%.exe" del "%TMPDIR%\%N%.exe" >nul 2>&1
.\kronc.exe "%N%.kr" -o "%TMPDIR%\%N%.exe" >"%TMPDIR%\%N%.log" 2>&1
if not exist "%TMPDIR%\%N%.exe" (
    findstr /c:"kasm failed" "%TMPDIR%\%N%.log" >nul 2>&1
    if errorlevel 1 goto :eof
)

if not exist "%TMPDIR%\%N%.exe" (
    REM  only to show the line kasm refused: the generated assembly
    .\kronc.exe "%N%.kr" -S -o "%TMPDIR%\%N%.asm" >nul 2>&1
    set "LINE="
    REM kasm reports "  at line N": the number is the third word
    for /f "tokens=3" %%L in ('findstr /c:"at line" "%TMPDIR%\%N%.log"') do set "LINE=%%L"
    if defined LINE (
        set "TEXT="
        for /f "usebackq tokens=* delims=" %%T in (`powershell -NoProfile -Command "$c=Get-Content '%TMPDIR%\%N%.asm'; if($c.Count -ge !LINE!){$c[!LINE!-1].Trim()}"`) do set "TEXT=%%T"
        echo   NO-ASM  %N%  line !LINE!:  !TEXT!
        >>"%TMPDIR%\_failures.txt" echo NO-ASM  %N%.asm:!LINE!:  !TEXT!
    ) else (
        echo   NO-ASM  %N%  ^(no line number^)
        >>"%TMPDIR%\_failures.txt" echo NO-ASM  %N%  no line
    )
    set /a NOASM+=1
    goto :eof
)

if not exist "%EXPDIR%\%N%.txt" (
    echo   NO-REF  %N%  ^(assembles, but there is no reference^)
    set /a NOREF+=1
    goto :eof
)

"%TMPDIR%\%N%.exe" >"%TMPDIR%\%N%.out" 2>&1
fc "%TMPDIR%\%N%.out" "%EXPDIR%\%N%.txt" >nul 2>&1
if errorlevel 1 (
    echo   DIFFERS %N%
    >>"%TMPDIR%\_failures.txt" echo DIFFERENT OUTPUT  %N%
    set /a DIFF+=1
) else (
    echo   OK      %N%
    set /a SAME+=1
)
goto :eof

:end
endlocal
