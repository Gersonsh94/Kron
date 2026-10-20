@echo off
REM ===========================================================================
REM   KRON - LINUX TESTS (through WSL)
REM
REM   Builds every single-threaded test of the suite for Linux, runs it in
REM   WSL and compares its output with the same references the Windows suite
REM   uses. The one difference allowed is the line ending: the references
REM   were written on Windows, so their carriage returns are dropped first.
REM
REM     LINUXTESTS.bat            build, run and compare
REM     LINUXTESTS.bat /c:PATH    test another compiler binary
REM
REM   Threads, locks, channels and networking run on Linux too (clone,
REM   futex, the kernel's sockets): test_thread, test_chan, test_tfail and
REM   test_net are in the list.
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
wsl -e true >nul 2>&1
if errorlevel 1 (
    echo [ERROR] WSL is not available: install it with  wsl --install
    exit /b 1
)

set "OUT=tests\linux"
if not exist "%OUT%" mkdir "%OUT%"
set "EXPDIR=tests\expected"

set LIST=test_float test_logic test_array test_struct test_trunc test_fcmp
set LIST=%LIST% test_fparam test_6params test_gfloat test_global test_global2
set LIST=%LIST% test_str test_savename test_fb cube cube_reuse test_features
set LIST=%LIST% test_fp1 test_fp2 test_fp3 test_ptrarith hello_multi test_math
set LIST=%LIST% test_stdlib test_vec3 test_stats test_gfloat2 test_fmix test_exp
set LIST=%LIST% test_ml test_random test_unary test_ushr test_rot test_arenatok
set LIST=%LIST% test_cache test_rawtypes test_compound test_switch test_sparam
set LIST=%LIST% test_unsigned test_rec test_bits test_cast test_aparam test_bool
set LIST=%LIST% test_stream test_slit test_mat test_nest test_slitr test_manyp
set LIST=%LIST% test_kwfield test_enum test_fail test_size test_ufield test_pcond
set LIST=%LIST% test_simd test_load test_chain test_strlib test_bounds
set LIST=%LIST% test_bounds2 test_break test_bounds3 test_raw test_arena_lib
set LIST=%LIST% test_slice test_args test_thread test_chan test_tfail test_net
set LIST=%LIST% test_fneg test_longstr
set LIST=%LIST% test_packed
set LIST=%LIST% test_bigreal test_fields
set LIST=%LIST% test_text test_list test_map test_files test_os
set LIST=%LIST% test_libthreads
set LIST=%LIST% test_exp_lit
set LIST=%LIST% test_trace test_texttype test_collections test_multi test_fnvalues test_simd4
set LIST=%LIST% test_extern test_callback test_structval test_liststruct test_generic test_modnames test_math3d test_json test_garray test_ptrparam test_longfn test_gconst test_fcmpval test_realint test_textlend test_random_alone test_textown

set /a PASS=0
set /a FAIL=0
set /a SKIP=0

echo ============================================================
echo   KRON - LINUX TESTS ^(through WSL^)
echo   Compiler: %JC%
echo ============================================================
echo.

for %%T in (%LIST%) do call :linuxtest %%T

echo.
echo ============================================================
echo   PASS: !PASS!    FAIL: !FAIL!    SKIPPED: !SKIP!
if !FAIL! gtr 0 (
    echo.
    echo   There are differences. Check them above.
) else (
    echo.
    echo   All good.
)
echo ============================================================
endlocal
goto :eof

REM ===========================================================================
REM  :linuxtest NAME   build for Linux, run in WSL, compare with the reference
REM ===========================================================================
:linuxtest
set "N=%~1"
if not exist "%N%.kr" (
    echo   OMIT  %N%  ^(no .kr file^)
    set /a SKIP+=1
    goto :eof
)
if not exist "%EXPDIR%\%N%.txt" (
    echo   OMIT  %N%  ^(no reference^)
    set /a SKIP+=1
    goto :eof
)
if exist "%OUT%\%N%" del "%OUT%\%N%" >nul 2>&1
"%JC%" "%N%.kr" --target=linux -o "%OUT%\%N%" >"%OUT%\%N%.build" 2>&1
if not exist "%OUT%\%N%" (
    echo   FAIL  %N%  ^(does not build - see %OUT%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)
wsl -e sh -c "chmod +x ./%OUT:\=/%/%N% 2>/dev/null; ./%OUT:\=/%/%N% > ./%OUT:\=/%/%N%.out 2>&1"
wsl -e sh -c "tr -d '\r' < ./%EXPDIR:\=/%/%N%.txt | cmp -s - ./%OUT:\=/%/%N%.out"
if errorlevel 1 (
    echo   FAIL  %N%
    echo         --- expected vs got ---
    wsl -e sh -c "tr -d '\r' < ./%EXPDIR:\=/%/%N%.txt | diff - ./%OUT:\=/%/%N%.out | head -20"
    set /a FAIL+=1
) else (
    echo   PASS  %N%  ^(Linux^)
    set /a PASS+=1
)
goto :eof
