@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM   KRON - SPLICE BISECT
REM
REM   The kasm-built binary fails 16 tests that the NASM+GoLink
REM   binary passes.  Two suspects:
REM
REM     (a) the splice   -- kron_all.asm merges eleven modules
REM                         into one translation unit, which can
REM                         collide symbols or reorder sections
REM                         in ways separate assembly never sees
REM     (b) kasm         -- mis-encodes something in the compiler
REM                         source, in paths only exercised when
REM                         compiling .kr (not when assembling)
REM
REM   This builds the SAME spliced source with NASM+GoLink.
REM   That isolates (a) from (b): same input, different assembler.
REM
REM   Then run:   RUNTESTS.bat /slow /c:kronc_splice.exe
REM ============================================================

if not exist kron_all.asm (
    echo [ERROR] kron_all.asm missing
    exit /b 1
)
if not exist obj mkdir obj
if not exist tests mkdir tests

del /q obj\all.obj kronc_splice.exe 2>nul

echo ============================================================
echo   SPLICE BISECT - assembling kron_all.asm with NASM
echo ============================================================
echo.

nasm -f win64 -i include\ -o obj\all.obj kron_all.asm >tests\splice_nasm.log 2>&1
set NASMRC=%errorlevel%

type tests\splice_nasm.log

if not exist obj\all.obj (
    echo.
    echo ============================================================
    echo   VERDICT: THE SPLICE IS BROKEN
    echo.
    echo   NASM rejects kron_all.asm ^(exit %NASMRC%^).  The errors
    echo   above are real defects that separate assembly never
    echo   showed, because each module got its own object file.
    echo   kasm accepts them silently -- that is the second bug.
    echo.
    echo   Full log: tests\splice_nasm.log
    echo ============================================================
    exit /b 1
)

echo   [OK] NASM assembled the splice
echo.
echo --- linking with GoLink ---
GoLink /fo kronc_splice.exe /entry main /console obj\all.obj kernel32.dll >tests\splice_link.log 2>&1
type tests\splice_link.log

if not exist kronc_splice.exe (
    echo.
    echo ============================================================
    echo   VERDICT: THE SPLICE IS BROKEN AT LINK TIME
    echo   GoLink could not produce an executable from the merged
    echo   object.  Log: tests\splice_link.log
    echo ============================================================
    exit /b 1
)

echo.
echo ============================================================
echo   kronc_splice.exe built -- same source, NASM instead of kasm
echo.
echo   Now run:
echo       RUNTESTS.bat /slow /c:kronc_splice.exe
echo.
echo   58 PASS  -^> the splice is fine.  kasm miscompiles the
echo               compiler.  Bisect kasm next.
echo   42 PASS  -^> the splice itself changes behaviour, with no
echo               kasm involved.  Suspect section merging and
echo               ordering across the eleven modules.
echo   anything else -^> tell me the exact list.
echo ============================================================
echo.
exit /b 0
