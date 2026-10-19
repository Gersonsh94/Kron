@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM   KRON - TEST SUITE
REM
REM   Usage:
REM     RUNTESTS.bat /baseline   Captures the current output as the
REM                              reference (only when you know the
REM                              compiler is right).
REM     RUNTESTS.bat             Compares against the reference.
REM     RUNTESTS.bat /slow       Includes the slow tests (3D).
REM
REM     RUNTESTS.bat /c:PATH     Tests ANOTHER compiler binary instead
REM                              of .\kronc.exe.  Used to run the
REM                              suite on a kasm-built compiler BEFORE
REM                              seeding it:
REM                                  RUNTESTS.bat /slow /c:boot3.exe
REM                                  RUNTESTS.bat /slow /c:seed\kronc.exe
REM                              /baseline refuses to run with /c:
REM                              the reference is only captured with
REM                              the installed compiler.
REM
REM   Interactive tests (keyboard/mouse) are left out on purpose:
REM   they block waiting for input.
REM ============================================================

set EXPDIR=tests\expected
set TMPDIR=tests\tmp
if not exist "tests"    mkdir "tests"
if not exist "%EXPDIR%" mkdir "%EXPDIR%"
if not exist "%TMPDIR%" mkdir "%TMPDIR%"

set MODE=check
set SLOW=0
set "JC=.\kronc.exe"
set "JCSET=0"
for %%A in (%*) do (
    if /I "%%A"=="/baseline" set MODE=baseline
    if /I "%%A"=="/slow"     set SLOW=1
    set "ARG=%%A"
    if /I "!ARG:~0,3!"=="/c:" (
        set "JC=!ARG:~3!"
        set "JCSET=1"
    )
)

if not exist "%JC%" (
    echo [ERROR] compiler not found: %JC%
    exit /b 1
)
if "%JCSET%"=="1" if "%MODE%"=="baseline" (
    echo [ERROR] /baseline and /c: cannot be combined.
    echo         The reference is only captured with the installed compiler.
    exit /b 1
)

set /a PASS=0
set /a FAIL=0
set /a NEWB=0
set /a SKIP=0

REM ---- Tests that compile, run and compare output ----
set RUNLIST=test_float test_logic test_array test_struct test_trunc test_fcmp
set RUNLIST=%RUNLIST% test_fparam test_6params test_gfloat
set RUNLIST=%RUNLIST% test_global test_global2 test_str test_savename
set RUNLIST=%RUNLIST% test_fb cube cube_reuse test_features
set RUNLIST=%RUNLIST% test_fp1 test_fp2 test_fp3 test_ptrarith hello_multi
REM  --- standard library ---
set RUNLIST=%RUNLIST% test_math test_stdlib test_vec3 test_stats
REM  --- floating-point and transcendental function regressions ---
set RUNLIST=%RUNLIST% test_gfloat2 test_fmix test_exp test_ml test_random

REM  --- operators from section 03 of the grammar ---
set RUNLIST=%RUNLIST% test_unary test_ushr test_rot test_arenatok
set RUNLIST=%RUNLIST% test_cache test_rawtypes
set RUNLIST=%RUNLIST% test_compound test_switch
REM  --- language fundamentals ---
set RUNLIST=%RUNLIST% test_sparam test_unsigned test_rec test_bits test_cast
set RUNLIST=%RUNLIST% test_aparam test_bool test_stream test_slit test_mat test_nest test_slitr test_manyp test_kwfield test_enum test_fail test_size test_ufield test_pcond test_simd test_load test_chain test_strlib test_bounds test_bounds2 test_break test_bounds3 test_raw test_arena_lib test_slice test_thread test_chan test_tfail test_net test_args test_fneg test_dllcall test_longstr
set RUNLIST=%RUNLIST% test_packed
set RUNLIST=%RUNLIST% test_bigreal test_fields
set RUNLIST=%RUNLIST% test_text test_list test_map test_files test_os
set RUNLIST=%RUNLIST% test_libthreads
set RUNLIST=%RUNLIST% test_exp_lit
set RUNLIST=%RUNLIST% test_trace test_texttype test_collections test_multi test_fnvalues test_simd4
set RUNLIST=%RUNLIST% test_extern test_callback test_structval test_liststruct test_generic test_modnames test_math3d test_json test_garray test_ptrparam

REM ---- Slow tests (3D rendering): only with /slow ----
set SLOWLIST=tri bmp solidcube cube3d

REM ---- Tests that must only COMPILE (declarations, no main) ----
set COMPILELIST=test_arena test_mmu2 test_mmu3 test_pool test_boot2
set COMPILELIST=%COMPILELIST% kron_alloc

REM ---- Negative tests: the compiler MUST reject them ----
set BADLIST=test_bad_syntax test_arena_bad test_arena_dup test_arena_zero test_arenatok_bad test_mmu_bad test_pgf_bad test_pool_bad test_boot_bad test_arena_ovl
REM  --- diagnostics: each one exercises a different message ---
REM    test_diag   parser, 'expected X, found Y'
REM    test_diag2  semantic, 'undeclared name'
REM    test_diag3  semantic, 'undeclared array'
REM    test_diag4  semantic, 'cannot assign to this'
REM    use_mod     the error lives in mod_bad.kr: tests the line map
set BADLIST=%BADLIST% test_diag test_diag2 test_diag3 test_diag4 use_mod test_17par test_nofile test_arrsz_bad
set BADLIST=%BADLIST% test_raw_bad test_raw_bad2 test_raw_bad3 test_raw_bad4 test_slice_bad
set BADLIST=%BADLIST% test_shared_bad test_shared_bad2 test_syscall_bad
set BADLIST=%BADLIST% test_aw_bad test_list_bad test_listshow_bad test_nofn_bad test_fieldcall_bad test_stray_bad
set BADLIST=%BADLIST% test_extern_bad test_generic_bad test_modnames_bad test_garray_bad test_char_bad test_text_bad

REM  --- encodings: kasm assembles each file and its bytes must be the ones in
REM  tests\enc\NAME.bin, which were checked opcode by opcode against another
REM  assembler when they were made. These exist because a multi-character
REM  literal was being truncated for months without anything noticing: the
REM  compiler simply did not use that path, so no test exercised it. The day
REM  it did, imports stopped expanding and the fixpoint still reported
REM  success. mbr is the boot sector of BUILDOS.bat (16-bit code written as
REM  bytes, 'org', expressions of labels), checked by booting it.
set ENCLIST=kasmchar kasmsimd kasmnew kasmrex kasmalu kasmxmm kasmxmm16 kasmdb mbr
REM
REM  Hand-written assembler programs, built by kasm alone and run. They test
REM  the assembler, not the language, which is why they have no .kr: test_scope
REM  checks that local labels (.loop, .done) belong to their own routine.
REM  It sat in RUNLIST for a long time, where it could only ever be OMITTED.
REM  test_kasmfix: byte compares and tests on [base + index +- N], and stores
REM  to [rel label + N], which kasm got wrong without saying so.
set ASMLIST=test_scope test_kasmfix
REM
REM  Debug builds (--debug): built as the editor builds them and driven as it
REM  drives them, with the commands of tests\debug\NAME.in on the standard
REM  input (breakpoints, steps); the reference holds what the debugger is told.
set DEBUGLIST=test_debug
REM
REM  peek and poke outside raw { } are a compile error: test_raw_bad, _bad2
REM  and _bad3, in BADLIST, hide one in a statement, a call argument and a
REM  conversion.

echo ============================================================
if "%MODE%"=="baseline" (
    echo   KRON - CAPTURING REFERENCE
) else (
    echo   KRON - TEST SUITE
)
echo   Compiler: %JC%
echo ============================================================
echo.

for %%T in (%RUNLIST%) do call :runtest %%T
if "%SLOW%"=="1" (
    echo.
    echo --- slow tests ---
    for %%T in (%SLOWLIST%) do call :runtest %%T
)

echo.
echo --- compile and assemble only ^(no main^) ---
for %%T in (%COMPILELIST%) do call :comptest %%T

echo.
echo --- negative tests ^(must be rejected^) ---
for %%T in (%BADLIST%) do call :badtest %%T

echo.
echo --- encodings ^(kasm against tests\enc, byte by byte^) ---
for %%T in (%ENCLIST%) do call :enctest %%T

echo.
echo --- assembler programs ^(kasm, run^) ---
for %%T in (%ASMLIST%) do call :asmtest %%T

echo.
echo --- debug builds ^(--debug, driven by tests\debug\NAME.in^) ---
for %%T in (%DEBUGLIST%) do call :debugtest %%T



echo.
echo ============================================================
if "%MODE%"=="baseline" (
    echo   Reference saved in %EXPDIR%\
    echo   New: !NEWB!   Skipped: !SKIP!   Errors: !FAIL!
    echo.
    echo   CHECK the .txt files in %EXPDIR% before trusting them.
) else (
    echo   PASS: !PASS!    FAIL: !FAIL!    SKIPPED: !SKIP!
    if !FAIL! GTR 0 (
        echo.
        echo   There are regressions. Check the differences above.
    ) else (
        echo.
        echo   All good.
    )
)
echo ============================================================
echo.
pause
goto :end

REM ============================================================
REM  :runtest NAME   builds with kronc, runs, compares
REM ============================================================
:runtest
set "N=%~1"
REM  A .fused.kr, if one is present, is still preferred -- but the compiler's
REM  own expander now chains imports, and the suite passes without any.
REM  FUSE.ps1 is no longer needed.
set "SRC=%N%.kr"
set "B=%N%"
if exist "%N%.fused.kr" (
    set "SRC=%N%.fused.kr"
    set "B=%N%.fused"
)
if not exist "%SRC%" (
    echo   OMIT  %N%  ^(no .kr file^)
    set /a SKIP+=1
    goto :eof
)

REM  One build, the one 'kronc prog.kr' really takes: kasm and pe_writer,
REM  nothing else on the machine.
if exist "%TMPDIR%\%N%_k.exe" del "%TMPDIR%\%N%_k.exe" >nul 2>&1
"%JC%" "%SRC%" -o "%TMPDIR%\%N%_k.exe" >"%TMPDIR%\%N%.kbuild" 2>&1
if not exist "%TMPDIR%\%N%_k.exe" (
    echo   FAIL  %N%  ^(does not build - see %TMPDIR%\%N%.kbuild^)
    set /a FAIL+=1
    goto :cleanup
)
"%TMPDIR%\%N%_k.exe" >"%TMPDIR%\%N%.kout" 2>&1

if "%MODE%"=="baseline" (
    copy /y "%TMPDIR%\%N%.kout" "%EXPDIR%\%N%.txt" >nul
    for %%S in ("%EXPDIR%\%N%.txt") do set BYTES=%%~zS
    echo   REF   %N%  ^(!BYTES! bytes^)
    set /a NEWB+=1
    goto :cleanup
)

if not exist "%EXPDIR%\%N%.txt" (
    echo   OMIT  %N%  ^(no reference - run /baseline^)
    set /a SKIP+=1
    goto :cleanup
)

fc "%TMPDIR%\%N%.kout" "%EXPDIR%\%N%.txt" >nul 2>&1
if errorlevel 1 (
    echo   FAIL  %N%
    echo         --- expected vs got ---
    fc /N "%EXPDIR%\%N%.txt" "%TMPDIR%\%N%.kout"
    set /a FAIL+=1
    goto :cleanup
)
echo   PASS  %N%
set /a PASS+=1

:cleanup
if exist "%TMPDIR%\%N%_k.exe" del "%TMPDIR%\%N%_k.exe" >nul 2>&1
goto :eof

REM ============================================================
REM  :debugtest NAME   --debug build, commands from tests\debug\NAME.in
REM ============================================================
:debugtest
set "N=%~1"
if not exist "%N%.kr" (
    echo   OMIT  %N%  ^(no .kr file^)
    set /a SKIP+=1
    goto :eof
)
if exist "%TMPDIR%\%N%_d.exe" del "%TMPDIR%\%N%_d.exe" >nul 2>&1
"%JC%" "%N%.kr" --debug -o "%TMPDIR%\%N%_d.exe" >"%TMPDIR%\%N%.dbuild" 2>&1
if not exist "%TMPDIR%\%N%_d.exe" (
    echo   FAIL  %N%  ^(the debug build failed - see %TMPDIR%\%N%.dbuild^)
    set /a FAIL+=1
    goto :eof
)
"%TMPDIR%\%N%_d.exe" < "tests\debug\%N%.in" >"%TMPDIR%\%N%.dout" 2>&1
if "%MODE%"=="baseline" (
    copy /y "%TMPDIR%\%N%.dout" "%EXPDIR%\%N%.txt" >nul
    echo   REF   %N%
    set /a NEWB+=1
    goto :eof
)
fc "%TMPDIR%\%N%.dout" "%EXPDIR%\%N%.txt" >nul 2>&1
if errorlevel 1 (
    echo   FAIL  %N%  ^(debug build^)
    echo         --- expected vs got ---
    fc /N "%EXPDIR%\%N%.txt" "%TMPDIR%\%N%.dout"
    set /a FAIL+=1
) else (
    echo   PASS  %N%  ^(debug build^)
    set /a PASS+=1
)
if exist "%TMPDIR%\%N%_d.exe" del "%TMPDIR%\%N%_d.exe" >nul 2>&1
goto :eof

REM ============================================================
REM  :comptest NAME  must produce an .asm; it is not run
REM ============================================================
:comptest
set "N=%~1"
REM  A .fused.kr, if one is present, is still preferred -- but the compiler's
REM  own expander now chains imports, and the suite passes without any.
REM  FUSE.ps1 is no longer needed.
set "SRC=%N%.kr"
set "B=%N%"
if exist "%N%.fused.kr" (
    set "SRC=%N%.fused.kr"
    set "B=%N%.fused"
)
if not exist "%SRC%" (
    echo   OMIT  %N%  ^(no .kr file^)
    set /a SKIP+=1
    goto :eof
)
if exist "%TMPDIR%\%N%_c.exe" del "%TMPDIR%\%N%_c.exe" >nul 2>&1
"%JC%" "%SRC%" -o "%TMPDIR%\%N%_c.exe" >"%TMPDIR%\%N%.build" 2>&1
if not exist "%TMPDIR%\%N%_c.exe" (
    echo   FAIL  %N%  ^(does not compile and assemble - see %TMPDIR%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)
del "%TMPDIR%\%N%_c.exe" >nul 2>&1

echo   PASS  %N%  ^(compiles and assembles^)
set /a PASS+=1
goto :eof

REM ============================================================
REM  :badtest NAME   the compiler MUST reject it
REM ============================================================
:badtest
set "N=%~1"
REM  A .fused.kr, if one is present, is still preferred -- but the compiler's
REM  own expander now chains imports, and the suite passes without any.
REM  FUSE.ps1 is no longer needed.
set "SRC=%N%.kr"
set "B=%N%"
if exist "%N%.fused.kr" (
    set "SRC=%N%.fused.kr"
    set "B=%N%.fused"
)
if not exist "%SRC%" (
    echo   OMIT  %N%  ^(no .kr file^)
    set /a SKIP+=1
    goto :eof
)
REM  --check runs every check and writes nothing
"%JC%" "%SRC%" --check >"%TMPDIR%\%N%.build" 2>&1
findstr /c:"Check passed" "%TMPDIR%\%N%.build" >nul 2>&1
if not errorlevel 1 (
    echo   FAIL  %N%  ^(should have been rejected and compiled^)
    set /a FAIL+=1
) else (
    echo   PASS  %N%  ^(rejected, as it must be^)
    set /a PASS+=1
)
goto :eof

REM ===========================================================================
REM  :enctest NAME   kasm assembles NAME.asm; the bytes must be tests\enc\NAME.bin
REM ===========================================================================
:enctest
set "N=%~1"
if not exist "%N%.asm" (
    echo   OMIT  %N%  ^(no .asm file^)
    set /a SKIP+=1
    goto :eof
)
if not exist "tests\enc\%N%.bin" (
    echo   OMIT  %N%  ^(no reference in tests\enc^)
    set /a SKIP+=1
    goto :eof
)
if exist "%N%.kbin" del "%N%.kbin" >nul 2>&1
"%JC%" "%N%.asm" --assemble >"%TMPDIR%\%N%.build" 2>&1
if not exist "%N%.kbin" (
    echo   FAIL  %N%  ^(kasm could not assemble it - see %TMPDIR%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)
fc /b "%N%.kbin" "tests\enc\%N%.bin" >"%TMPDIR%\%N%.cmp" 2>&1
if errorlevel 1 (
    echo   FAIL  %N%  ^(bytes differ - see %TMPDIR%\%N%.cmp^)
    set /a FAIL+=1
) else (
    echo   PASS  %N%  ^(same bytes^)
    set /a PASS+=1
)
del "%N%.kbin" >nul 2>&1
goto :eof

REM ===========================================================================
REM  :asmtest NAME   NAME.asm built by kasm alone, run, output compared
REM ===========================================================================
:asmtest
set "N=%~1"
if not exist "%N%.asm" (
    echo   OMIT  %N%  ^(no .asm file^)
    set /a SKIP+=1
    goto :eof
)
if exist "%N%.exe" del "%N%.exe" >nul 2>&1
"%JC%" "%N%.asm" --assemble --pe >"%TMPDIR%\%N%.build" 2>&1
if not exist "%N%.exe" (
    echo   FAIL  %N%  ^(kasm could not assemble it - see %TMPDIR%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)
.\%N%.exe >"%TMPDIR%\%N%.out" 2>&1
if "%MODE%"=="baseline" (
    copy /y "%TMPDIR%\%N%.out" "%EXPDIR%\%N%.txt" >nul
    echo   REF   %N%
    set /a NEWB+=1
    goto :eof
)
if not exist "%EXPDIR%\%N%.txt" (
    echo   OMIT  %N%  ^(no reference^)
    set /a SKIP+=1
    goto :eof
)
fc "%TMPDIR%\%N%.out" "%EXPDIR%\%N%.txt" >nul 2>&1
if errorlevel 1 (
    echo   FAIL  %N%
    echo         --- expected vs got ---
    fc /N "%EXPDIR%\%N%.txt" "%TMPDIR%\%N%.out"
    set /a FAIL+=1
) else (
    echo   PASS  %N%  ^(kasm, run^)
    set /a PASS+=1
)
goto :eof

:end
endlocal

