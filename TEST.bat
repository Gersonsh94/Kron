@echo off
REM ============================================================
REM  KRON - QUICK SMOKE TEST
REM  Run: TEST.bat   (in the compiler folder)
REM  Three tiny programs; the full suite is RUNTESTS.bat.
REM ============================================================
setlocal

echo ============================================================
echo   KRON - QUICK SMOKE TEST
echo ============================================================
echo.

if not exist kronc.exe (
    echo [!] kronc.exe is missing. Building it first...
    call BUILD.bat
    if not exist kronc.exe (
        echo ERROR: kronc.exe could not be built
        pause
        exit /b 1
    )
)

REM ------------------------------------------------------------
REM TEST 1: the smallest program
REM ------------------------------------------------------------
echo [TEST 1] Smallest program: fn main() {}
(
echo kron_program
echo kron_domain smoke1;
echo kron_imports
echo kron_definitions
echo fn main^(^) {}
) > smoke1.kr
kronc.exe smoke1.kr -o smoke1.exe
echo   Exit code: %errorlevel%
echo.

REM ------------------------------------------------------------
REM TEST 2: a variable
REM ------------------------------------------------------------
echo [TEST 2] A variable
(
echo kron_program
echo kron_domain smoke2;
echo kron_imports
echo kron_definitions
echo fn main^(^) {
echo   var x: i64 = 42;
echo }
) > smoke2.kr
kronc.exe smoke2.kr -o smoke2.exe
echo   Exit code: %errorlevel%
echo.

REM ------------------------------------------------------------
REM TEST 3: arithmetic and print
REM ------------------------------------------------------------
echo [TEST 3] Arithmetic and print
(
echo kron_program
echo kron_domain smoke3;
echo kron_imports
echo kron_definitions
echo fn main^(^) {
echo   var x: i64 = 42;
echo   var y: i64 = 10;
echo   var z: i64 = x + y;
echo   print^(z^);
echo }
) > smoke3.kr
kronc.exe smoke3.kr -o smoke3.exe
echo   Exit code: %errorlevel%
smoke3.exe
echo.

echo ============================================================
echo   DONE
echo ============================================================
pause
