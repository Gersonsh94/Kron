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

REM  --- encodings: assemble the same file with NASM and with kasm and compare
REM  the opcode bytes. These exist because a multi-character literal was being
REM  truncated for months without anything noticing: the compiler simply did
REM  not use that path, so no test exercised it. The day it did, imports
REM  stopped expanding and the fixpoint still reported success.
set ENCLIST=kasmchar kasmsimd kasmnew kasmrex kasmalu kasmxmm kasmxmm16 kasmdb
REM
REM  Hand-written assembler programs, built by kasm alone and run. They test
REM  the assembler, not the language, which is why they have no .kr: test_scope
REM  checks that local labels (.loop, .done) belong to their own routine.
REM  It sat in RUNLIST for a long time, where it could only ever be OMITTED.
REM  test_kasmfix: byte compares and tests on [base + index +- N], and stores
REM  to [rel label + N], which kasm got wrong without saying so.
set ASMLIST=test_scope test_kasmfix
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
echo --- encodings ^(kasm against NASM, byte by byte^) ---
for %%T in (%ENCLIST%) do call :enctest %%T

echo.
echo --- assembler programs ^(kasm, run^) ---
for %%T in (%ASMLIST%) do call :asmtest %%T



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
REM  :runtest NAME   compiles, assembles, links, runs, compares
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

REM Delete earlier outputs so no stale result is read
if exist "%TMPDIR%\!B!.asm" del "%TMPDIR%\!B!.asm" >nul 2>&1
if exist "%N%_t.obj" del "%N%_t.obj" >nul 2>&1
if exist "%N%_t.exe" del "%N%_t.exe" >nul 2>&1

REM  The audit path needs the generated assembly: -S writes it, -o keeps it
REM  in the suite's temporary folder.
"%JC%" "%SRC%" -S -o "%TMPDIR%\!B!.asm" >"%TMPDIR%\%N%.build" 2>&1
if not exist "%TMPDIR%\!B!.asm" (
    echo   FAIL  %N%  ^(kronc wrote no .asm^)
    set /a FAIL+=1
    goto :eof
)

.\nasm.exe -f win64 -o "%N%_t.obj" "%TMPDIR%\!B!.asm" >>"%TMPDIR%\%N%.build" 2>&1
if not exist "%N%_t.obj" (
    echo   FAIL  %N%  ^(nasm failed - see %TMPDIR%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)

.\GoLink.exe /fo "%N%_t.exe" /entry main /console "%N%_t.obj" kernel32.dll >>"%TMPDIR%\%N%.build" 2>&1
if not exist "%N%_t.exe" (
    echo   FAIL  %N%  ^(GoLink failed - see %TMPDIR%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)

.\%N%_t.exe >"%TMPDIR%\%N%.out" 2>&1

if "%MODE%"=="baseline" (
    copy /y "%TMPDIR%\%N%.out" "%EXPDIR%\%N%.txt" >nul
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

fc "%TMPDIR%\%N%.out" "%EXPDIR%\%N%.txt" >nul 2>&1
if errorlevel 1 (
    echo   FAIL  %N%
    echo         --- expected vs got ---
    fc /N "%EXPDIR%\%N%.txt" "%TMPDIR%\%N%.out"
    set /a FAIL+=1
    goto :cleanup
)

REM  Second path: the one 'kronc prog.kr' really takes -- kasm and pe_writer,
REM  no NASM. Until this check existed the suite only ever built through NASM,
REM  so a store kasm could not encode and a .bss that pe_writer left full of
REM  leftover bytes both passed every test while the plain compiler failed.
REM  A test passes only when BOTH builds print the reference.
if exist "%TMPDIR%\%N%_k.exe" del "%TMPDIR%\%N%_k.exe" >nul 2>&1
"%JC%" "%SRC%" -o "%TMPDIR%\%N%_k.exe" >"%TMPDIR%\%N%.kbuild" 2>&1
if not exist "%TMPDIR%\%N%_k.exe" (
    echo   FAIL  %N%  ^(direct build failed - see %TMPDIR%\%N%.kbuild^)
    set /a FAIL+=1
    goto :cleanup
)
"%TMPDIR%\%N%_k.exe" >"%TMPDIR%\%N%.kout" 2>&1
fc "%TMPDIR%\%N%.kout" "%EXPDIR%\%N%.txt" >nul 2>&1
if errorlevel 1 (
    echo   FAIL  %N%  ^(direct build: kasm + pe_writer^)
    echo         --- expected vs got ---
    fc /N "%EXPDIR%\%N%.txt" "%TMPDIR%\%N%.kout"
    set /a FAIL+=1
    goto :cleanup
)
echo   PASS  %N%
set /a PASS+=1

:cleanup
if exist "%N%_t.obj" del "%N%_t.obj" >nul 2>&1
if exist "%N%_t.exe" del "%N%_t.exe" >nul 2>&1
if exist "%TMPDIR%\%N%_k.exe" del "%TMPDIR%\%N%_k.exe" >nul 2>&1
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
if exist "%TMPDIR%\!B!.asm" del "%TMPDIR%\!B!.asm" >nul 2>&1
if exist "%N%_t.obj" del "%N%_t.obj" >nul 2>&1

"%JC%" "%SRC%" -S -o "%TMPDIR%\!B!.asm" >"%TMPDIR%\%N%.build" 2>&1
if not exist "%TMPDIR%\!B!.asm" (
    echo   FAIL  %N%  ^(does not compile - see %TMPDIR%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)

REM  Writing the .asm is not enough: it also has to assemble. Without this
REM  step test_boot2 emitted  mov cr4, 0x6A0  -- not an x86 instruction --
REM  and passed. These tests have no main, so they are not linked.
.\nasm.exe -f win64 -o "%N%_t.obj" "%TMPDIR%\!B!.asm" >>"%TMPDIR%\%N%.build" 2>&1
if not exist "%N%_t.obj" (
    echo   FAIL  %N%  ^(compiles but does not assemble - see %TMPDIR%\%N%.build^)
    set /a FAIL+=1
    goto :eof
)
del "%N%_t.obj" >nul 2>&1

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
REM  :enctest NAME   assemble NAME.asm both ways and compare the bytes
REM
REM  kasm and NASM do not produce identical files: kasm uses movabs where a
REM  shorter form exists, pads the data section to sixteen bytes, and picks a
REM  32-bit displacement where an 8-bit one would do. All of that is legal and
REM  only affects size. What must never differ is the OPCODE, so only the
REM  bytes the two files have in common are compared, and only up to the
REM  length of the shorter one.
REM ===========================================================================
:enctest
set "N=%~1"
REM  These take a hand-written .asm, not a .kr, so the fused-source logic
REM  above does not apply to them.
if not exist "%N%.asm" (
    echo   OMIT  %N%  ^(no .asm file^)
    set /a SKIP+=1
    goto :eof
)
if exist "%TMPDIR%\%N%.nbin" del "%TMPDIR%\%N%.nbin" >nul 2>&1
if exist "%N%.kbin" del "%N%.kbin" >nul 2>&1

nasm.exe -f bin -o "%TMPDIR%\%N%.nbin" "%N%.asm" >"%TMPDIR%\%N%.build" 2>&1
if not exist "%TMPDIR%\%N%.nbin" (
    echo   FAIL  %N%  ^(nasm could not assemble it^)
    set /a FAIL+=1
    goto :eof
)

"%JC%" "%N%.asm" --assemble >>"%TMPDIR%\%N%.build" 2>&1
if not exist "%N%.kbin" (
    echo   FAIL  %N%  ^(kasm could not assemble it^)
    set /a FAIL+=1
    goto :eof
)

REM  Compare only the bytes the two files share. fc /b on the whole pair
REM  always reports a length difference -- kasm pads the data section to
REM  sixteen bytes -- so the reference is truncated to kasm's length first,
REM  and any remaining difference is a real opcode mismatch.
for %%Z in ("%N%.kbin") do set "JLEN=%%~zZ"
powershell -NoProfile -Command ^
  "$a=[IO.File]::ReadAllBytes('%TMPDIR%\%N%.nbin');" ^
  "$b=[IO.File]::ReadAllBytes('%N%.kbin');" ^
  "$n=[Math]::Min($a.Length,$b.Length);" ^
  "$d=0; for($i=0;$i -lt $n;$i++){ if($a[$i] -ne $b[$i]){ $d=$i+1; break } };" ^
  "if($d -eq 0){ exit 0 } else { Write-Output ('first differing byte at '+($d-1)); exit 1 }" ^
  >"%TMPDIR%\%N%.cmp" 2>&1
if errorlevel 1 (
    echo   FAIL  %N%  ^(opcodes differ - see %TMPDIR%\%N%.cmp^)
    set /a FAIL+=1
) else (
    echo   PASS  %N%  ^(same opcodes^)
    set /a PASS+=1
)
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

