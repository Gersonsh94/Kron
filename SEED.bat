@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM   KRON - PROMOTE THE BOOTSTRAP SEED
REM
REM   The seed is the one binary in this repository that nothing
REM   else can vouch for.  Every later compiler descends from it.
REM   Promote a new one ONLY when all of these were green on the
REM   binary you are about to promote:
REM
REM       BUILD.bat        (or BUILD_NASM.bat)
REM       RUNTESTS.bat /slow
REM       PETESTS.bat
REM       BOOTSTRAP.bat
REM
REM   Usage:
REM     SEED.bat              promote boot3.exe   (the fixpoint binary)
REM     SEED.bat kronc     promote kronc.exe
REM ============================================================

set "SRC=boot3.exe"
if not "%~1"=="" set "SRC=%~1.exe"

if not exist "%SRC%" (
    echo [ERROR] %SRC% not found.
    echo         Run BOOTSTRAP.bat first, or pass another name:
    echo             SEED.bat kronc
    exit /b 1
)

if not exist seed mkdir seed

if exist seed\kronc.exe (
    echo Current seed:
    type seed\SEED.txt 2>nul
    echo.
    fc /b seed\kronc.exe "%SRC%" >nul
    if not errorlevel 1 (
        echo [skip] %SRC% is byte-identical to the current seed.
        exit /b 0
    )
    echo About to REPLACE the seed with %SRC%.
    echo.
    set /p "OK=Type YES to confirm: "
    if /I not "!OK!"=="YES" (
        echo Aborted. Seed unchanged.
        exit /b 1
    )
    if exist seed\kronc.prev.exe del /q seed\kronc.prev.exe
    ren seed\kronc.exe kronc.prev.exe
)

copy /y "%SRC%" seed\kronc.exe >nul
if not exist seed\kronc.exe (
    echo [ERROR] could not write seed\kronc.exe
    exit /b 1
)

REM ---- provenance record ----
for %%S in (seed\kronc.exe) do set "BYTES=%%~zS"
set "HASH="
for /f "skip=1 tokens=*" %%H in ('certutil -hashfile seed\kronc.exe SHA256 2^>nul') do (
    if not defined HASH set "HASH=%%H"
)

> seed\SEED.txt echo Kron bootstrap seed
>>seed\SEED.txt echo   promoted from : %SRC%
>>seed\SEED.txt echo   date          : %DATE% %TIME%
>>seed\SEED.txt echo   size          : !BYTES! bytes
>>seed\SEED.txt echo   sha256        : !HASH!

echo.
echo ============================================================
echo   Seed promoted.
echo ============================================================
type seed\SEED.txt
echo.
echo   Commit seed\kronc.exe and seed\SEED.txt together.
echo   From now on BUILD.bat needs neither NASM nor GoLink.
echo ============================================================
echo.
exit /b 0
