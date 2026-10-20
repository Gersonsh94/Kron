@echo off
REM ===========================================================================
REM   KRON - macOS TESTS, part 1 of 2: build them (on Windows)
REM
REM   Builds every test of the suite with --target=macos into tests\mac,
REM   with the list of names in tests\mac\LIST.txt. Then, on the Mac (Apple
REM   silicon), from the folder of the compiler copied there:
REM
REM       bash MACTESTS.sh
REM
REM   runs each one and compares its output with the same references the
REM   other suites use.
REM
REM     MACTESTS.bat            build
REM     MACTESTS.bat /c:PATH    with another compiler binary
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

set "OUT=tests\mac"
if not exist "%OUT%" mkdir "%OUT%"

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
set LIST=%LIST% test_extern test_structval test_liststruct test_generic test_modnames test_math3d test_json test_garray test_ptrparam test_longfn test_gconst test_fcmpval test_realint test_textlend test_random_alone

set /a BUILT=0
set /a FAIL=0
if exist "%OUT%\LIST.txt" del "%OUT%\LIST.txt" >nul 2>&1

echo ============================================================
echo   KRON - macOS TESTS: building ^(Apple silicon, Mach-O^)
echo   Compiler: %JC%
echo ============================================================
echo.

for %%T in (%LIST%) do call :macbuild %%T

echo.
echo ============================================================
echo   BUILT: !BUILT!    FAILED TO BUILD: !FAIL!
echo.
echo   Now on the Mac, in this folder:  bash MACTESTS.sh
echo ============================================================
endlocal
goto :eof

:macbuild
set "N=%~1"
if not exist "%N%.kr" goto :eof
if exist "%OUT%\%N%" del "%OUT%\%N%" >nul 2>&1
"%JC%" "%N%.kr" --target=macos -o "%OUT%\%N%" >"%OUT%\%N%.build" 2>&1
if not exist "%OUT%\%N%" (
    echo   FAIL  %N%  ^(does not build - see %OUT%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)
echo %N%>>"%OUT%\LIST.txt"
echo   built %N%
set /a BUILT+=1
goto :eof
