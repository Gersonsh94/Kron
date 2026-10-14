@echo off
REM ===========================================================================
REM   KRON - ARM64 TESTS (through WSL and QEMU)
REM
REM   Two parts, both run on an emulated ARM64 machine:
REM
REM   The assembler, with kronc --target=linux-arm64 --assemble:
REM     arm_hello    prints its line
REM     arm_check    karm checks itself: constants, labels, data; exit 0
REM     arm_corpus   1523 instructions, byte for byte against the code the
REM                  GNU ARM assembler made (tests\expected\arm_corpus.bin)
REM     arm_bad      must be refused
REM
REM   The language, with kronc --target=linux-arm64: every program of the
REM   Linux suite, compared with the same references. Threads, channels and
REM   sockets included.
REM
REM   Needs, once, in Ubuntu:   wsl sudo apt update
REM                             wsl sudo apt install -y qemu-user
REM   (or qemu-user-static: either qemu-aarch64 or qemu-aarch64-static works)
REM
REM     ARMTESTS.bat              build, run and compare
REM     ARMTESTS.bat /c:PATH      test another compiler binary
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
set "QEMU="
for /f "delims=" %%Q in ('wsl -e sh -c "command -v qemu-aarch64 || command -v qemu-aarch64-static"') do set "QEMU=%%Q"
if "%QEMU%"=="" (
    echo [ERROR] QEMU for ARM64 is missing: install it with
    echo         wsl sudo apt update
    echo         wsl sudo apt install -y qemu-user
    echo         ^(or qemu-user-static if Ubuntu does not offer qemu-user^)
    exit /b 1
)

set "OUT=tests\arm"
if not exist "%OUT%" mkdir "%OUT%"
set "EXPDIR=tests\expected"
set /a PASS=0
set /a FAIL=0

echo ============================================================
echo   KRON - ARM64 TESTS ^(through WSL and QEMU^)
echo   Compiler: %JC%
echo   QEMU:     %QEMU%
echo ============================================================
echo.

REM ---- arm_hello: its output against the reference
call :build arm_hello
if exist "%OUT%\arm_hello" (
    wsl -e sh -c "chmod +x ./tests/arm/arm_hello; %QEMU% ./tests/arm/arm_hello > ./tests/arm/arm_hello.out 2>&1"
    wsl -e sh -c "tr -d '\r' < ./tests/expected/arm_hello.txt | cmp -s - ./tests/arm/arm_hello.out"
    if errorlevel 1 (
        echo   FAIL  arm_hello  ^(output differs^)
        set /a FAIL+=1
    ) else (
        echo   PASS  arm_hello  ^(ARM64^)
        set /a PASS+=1
    )
)

REM ---- arm_check: exit code 0 means every check held
call :build arm_check
if exist "%OUT%\arm_check" (
    wsl -e sh -c "chmod +x ./tests/arm/arm_check; %QEMU% ./tests/arm/arm_check > ./tests/arm/arm_check.out 2>&1"
    if errorlevel 1 (
        echo   FAIL  arm_check  ^(exit code = number of failed checks: !errorlevel!^)
        set /a FAIL+=1
    ) else (
        echo   PASS  arm_check  ^(ARM64^)
        set /a PASS+=1
    )
)

REM ---- arm_corpus: the code after the 128-byte header against the GNU build
call :build arm_corpus
if exist "%OUT%\arm_corpus" (
    for %%S in ("%EXPDIR%\arm_corpus.bin") do set CSIZE=%%~zS
    wsl -e sh -c "cmp -i 128:0 -n !CSIZE! ./tests/arm/arm_corpus ./tests/expected/arm_corpus.bin"
    if errorlevel 1 (
        echo   FAIL  arm_corpus  ^(encodings differ from the GNU assembler^)
        set /a FAIL+=1
    ) else (
        echo   PASS  arm_corpus  ^(1523 instructions, same bytes as GNU as^)
        set /a PASS+=1
    )
)

REM ---- arm_bad: must be refused
if exist "%OUT%\arm_bad" del "%OUT%\arm_bad" >nul 2>&1
"%JC%" arm_bad.s --assemble --target=linux-arm64 -o "%OUT%\arm_bad" >"%OUT%\arm_bad.build" 2>&1
if exist "%OUT%\arm_bad" (
    echo   FAIL  arm_bad  ^(accepted; it must be refused^)
    set /a FAIL+=1
) else (
    echo   PASS  arm_bad  ^(refused, as it must be^)
    set /a PASS+=1
)

echo.
echo --- Kron programs on ARM64 ---
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
for %%T in (%LIST%) do call :armtest %%T

echo.
echo ============================================================
echo   PASS: !PASS!    FAIL: !FAIL!
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
REM  :build NAME   kronc NAME.s --assemble --target=linux-arm64
REM ===========================================================================
:build
set "N=%~1"
if exist "%OUT%\%N%" del "%OUT%\%N%" >nul 2>&1
"%JC%" "%N%.s" --assemble --target=linux-arm64 -o "%OUT%\%N%" >"%OUT%\%N%.build" 2>&1
if not exist "%OUT%\%N%" (
    echo   FAIL  %N%  ^(does not build - see %OUT%\%N%.build^)
    set /a FAIL+=1
)
goto :eof

REM ===========================================================================
REM  :armtest NAME   build NAME.kr for ARM64, run it in QEMU, compare
REM ===========================================================================
:armtest
set "N=%~1"
if not exist "%N%.kr" (
    echo   OMIT  %N%  ^(no .kr file^)
    goto :eof
)
if not exist "%EXPDIR%\%N%.txt" (
    echo   OMIT  %N%  ^(no reference^)
    goto :eof
)
if exist "%OUT%\%N%" del "%OUT%\%N%" >nul 2>&1
"%JC%" "%N%.kr" --target=linux-arm64 -o "%OUT%\%N%" >"%OUT%\%N%.build" 2>&1
if not exist "%OUT%\%N%" (
    echo   FAIL  %N%  ^(does not build - see %OUT%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)
wsl -e sh -c "chmod +x ./tests/arm/%N%; %QEMU% ./tests/arm/%N% > ./tests/arm/%N%.out 2>&1"
wsl -e sh -c "tr -d '\r' < ./tests/expected/%N%.txt | cmp -s - ./tests/arm/%N%.out"
if errorlevel 1 (
    echo   FAIL  %N%
    echo         --- expected vs got ---
    wsl -e sh -c "tr -d '\r' < ./tests/expected/%N%.txt | diff - ./tests/arm/%N%.out | head -20"
    set /a FAIL+=1
) else (
    echo   PASS  %N%  ^(ARM64^)
    set /a PASS+=1
)
goto :eof
