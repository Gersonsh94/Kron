@echo off
REM ===========================================================================
REM   KRON - WEB TESTS (WebAssembly, run by Node.js)
REM
REM   Builds the tests of the suite with --target=web, runs each NAME.wasm
REM   with the host the compiler writes beside it (node kron_web.js NAME.wasm)
REM   and compares the output with the same references the other suites use.
REM   Needs Node.js 18 or later in the PATH.
REM
REM     WEBTESTS.bat            build, run and compare
REM     WEBTESTS.bat /c:PATH    test another compiler binary
REM
REM   Threads run: each is a worker with its own instance of the module over
REM   the one shared memory. A page has no processes to start and no sockets
REM   of its own, so test_os (os_run) and test_net are not in the list.
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
where node >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is not in the PATH: install it from nodejs.org
    exit /b 1
)

set "OUT=tests\web"
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
set LIST=%LIST% test_slice test_args test_thread test_chan test_tfail
set LIST=%LIST% test_fneg test_longstr
set LIST=%LIST% test_packed
set LIST=%LIST% test_bigreal test_fields
set LIST=%LIST% test_text test_list test_map test_files
set LIST=%LIST% test_libthreads
set LIST=%LIST% test_exp_lit
set LIST=%LIST% test_trace test_texttype test_collections test_multi test_fnvalues test_simd4
set LIST=%LIST% test_structval test_liststruct test_generic test_modnames test_math3d test_json test_garray test_ptrparam test_longfn test_gconst test_fcmpval test_realint test_textlend test_random_alone test_textown

set /a PASS=0
set /a FAIL=0
set /a SKIP=0

echo ============================================================
echo   KRON - WEB TESTS ^(WebAssembly, through Node.js^)
echo   Compiler: %JC%
echo ============================================================
echo.

for %%T in (%LIST%) do call :webtest %%T

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
REM  :webtest NAME   build for the web, run with Node.js, compare
REM ===========================================================================
:webtest
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
if exist "%OUT%\%N%.wasm" del "%OUT%\%N%.wasm" >nul 2>&1
"%JC%" "%N%.kr" --target=web -o "%OUT%\%N%.wasm" >"%OUT%\%N%.build" 2>&1
if not exist "%OUT%\%N%.wasm" (
    echo   FAIL  %N%  ^(does not build - see %OUT%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)
node "%OUT%\kron_web.js" "%OUT%\%N%.wasm" > "%OUT%\%N%.out" 2>&1
node -e "const f=require('fs');const a=f.readFileSync(process.argv[1],'latin1').replace(/\r/g,'').trim();const b=f.readFileSync(process.argv[2],'latin1').replace(/\r/g,'').trim();process.exit(a===b?0:1)" "%EXPDIR%\%N%.txt" "%OUT%\%N%.out"
if errorlevel 1 (
    echo   FAIL  %N%
    echo         --- expected ---
    type "%EXPDIR%\%N%.txt"
    echo         --- got ---
    type "%OUT%\%N%.out"
    set /a FAIL+=1
) else (
    echo   PASS  %N%  ^(web^)
    set /a PASS+=1
)
goto :eof
