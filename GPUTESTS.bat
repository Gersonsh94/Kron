@echo off
REM ===========================================================================
REM   KRON - GPU, WINDOW, SOUND AND CONTROLLER TESTS
REM
REM   For a machine with a graphics card (Vulkan driver: NVIDIA, AMD or
REM   Intel; any card from the last ten years has one), speakers and,
REM   if there is one, a game controller. Builds and runs:
REM
REM     tests\gpu\gpu_basic.kr     draws without a window and checks the
REM                                pixels it reads back: clear color, depth,
REM                                textures, blending, a lit cube, a mesh
REM                                made from lists, and the time of 30
REM                                frames of 2000 cubes each. The cube is
REM                                saved in tests\tmp\gpu_cube.bmp.
REM     tests\gpu\gpu_target.kr    render targets: a picture drawn into,
REM                                then read as colour and as depth (shadow
REM                                maps). Vulkan only, for now.
REM     tests\gpu\gpu_mip.kr       mipmaps: a fine checkerboard drawn small
REM                                comes out grey, not black and white
REM     tests\gpu\gpu_bc.kr        BC1 (compressed) textures: four colours on
REM                                a 64 x 64 picture come out right
REM     tests\gpu\gpu_window.kr    three seconds of a sphere and a cube in a
REM                                window: frames a second, and that they
REM                                reach the window
REM     tests\gpu\gpu_devices.kr   three notes (you should hear them) and
REM                                the controllers found (press A on one)
REM
REM   Usage:
REM     GPUTESTS.bat               the three tests
REM     GPUTESTS.bat /c:PATH       tests another compiler binary
REM
REM   Each test prints its checks, "ok" or "FAIL", and ends with the number
REM   that failed as its exit code. When the GPU does not open, the line
REM   after says why (most often: the driver is missing or too old).
REM ===========================================================================

setlocal EnableDelayedExpansion
set "JC=.\kronc.exe"
for %%A in (%*) do (
    set "ARG=%%~A"
    if /I "!ARG:~0,3!"=="/c:" set "JC=!ARG:~3!"
)
if not exist "%JC%" (
    echo [ERROR] compiler not found: %JC%
    exit /b 1
)
if not exist "tests\tmp" mkdir "tests\tmp"

set /a PASS=0
set /a FAIL=0

echo ============================================================
echo   KRON - GPU TESTS
echo   Compiler: %JC%
echo ============================================================
echo.

call :gputest gpu_basic
call :gputest gpu_target
call :gputest gpu_mip
call :gputest gpu_bc
call :gputest gpu_window
call :gputest gpu_devices

echo.
echo ============================================================
echo   PASS: %PASS%   FAIL: %FAIL%
echo ============================================================

if %FAIL% gtr 0 exit /b 1
exit /b 0

REM ---------------------------------------------------------------------------
:gputest
set "N=%~1"
echo --- %N% ---
if exist "tests\tmp\%N%.exe" del "tests\tmp\%N%.exe"
"%JC%" tests\gpu\%N%.kr -o tests\tmp\%N%.exe > tests\tmp\%N%.build.log 2>&1
if not exist "tests\tmp\%N%.exe" (
    echo   [FAIL] %N% does not build: see tests\tmp\%N%.build.log
    set /a FAIL+=1
    goto :eof
)
tests\tmp\%N%.exe
set "RC=!errorlevel!"
REM  a crash ends with a negative code, which "if errorlevel 1" lets through
if not "!RC!"=="0" (
    echo   [FAIL] %N%  ^(exit code !RC!^)
    set /a FAIL+=1
) else (
    echo   [PASS] %N%
    set /a PASS+=1
)
echo.
goto :eof
