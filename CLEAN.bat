@echo off
setlocal enabledelayedexpansion
REM ===========================================================================
REM   KRON - CLEANUP
REM
REM   CLEAN.bat            what is generated: test .asm, .obj, test .exe
REM   CLEAN.bat /fused     also any leftover .fused.kr (no longer needed)
REM   CLEAN.bat /backups   also old copies: .BAK, .VERDE, .PRE_, .prev
REM   CLEAN.bat /scratch   also loose debugging files
REM   CLEAN.bat /all       all of the above
REM   CLEAN.bat /list      deletes nothing, only says what it would delete
REM
REM   An .asm counts as GENERATED when a .kr of the same name exists. The
REM   compiler's modules have no .kr, so they survive; neither do the
REM   kasm*.asm corpora.
REM ===========================================================================

set "DOFUSED="
set "DOBAK="
set "DOSCRATCH="
set "LIST="
for %%A in (%*) do (
    if /i "%%A"=="/fused"   set "DOFUSED=1"
    if /i "%%A"=="/backups" set "DOBAK=1"
    if /i "%%A"=="/scratch" set "DOSCRATCH=1"
    if /i "%%A"=="/list"    set "LIST=1"
    if /i "%%A"=="/all"     ( set "DOFUSED=1" & set "DOBAK=1" & set "DOSCRATCH=1" )
)

set /a N=0

echo ============================================================
if defined LIST (
    echo   KRON - CLEANUP ^(list only, deletes nothing^)
) else (
    echo   KRON - CLEANUP
)
echo ============================================================
echo.

echo --- .asm generated from a .kr ---
for %%F in (*.asm) do (
    if exist "%%~nF.kr" call :kill "%%F"
)

echo.
echo --- test objects and binaries ---
for %%F in (*.obj) do call :kill "%%F"
for %%F in (*.exe) do (
    set "KEEP="
    if /i "%%F"=="kronc.exe"      set "KEEP=1"
    if /i "%%F"=="boot1.exe"      set "KEEP=1"
    if /i "%%F"=="boot2.exe"      set "KEEP=1"
    if /i "%%F"=="boot3.exe"      set "KEEP=1"
    if not defined KEEP call :kill "%%F"
)

echo.
echo --- loose outputs ---
for %%F in (*.kbin *.expanded *.bmp) do call :kill "%%F"
if exist preproc.asm call :kill preproc.asm

if defined DOFUSED (
    echo.
    echo --- .fused.kr  ^(no longer needed^) ---
    for %%F in (*.fused.kr *.fused.asm) do call :kill "%%F"
)

if defined DOBAK (
    echo.
    echo --- old copies ---
    for %%F in (*.BAK.asm *.BAK2.asm *.VERDE.asm *.PRE_*.asm *.pre.asm *.clean.asm) do call :kill "%%F"
    for %%F in (*_backup.asm *_backup.kr *.bak *.diff) do call :kill "%%F"
    for %%F in (lexer\*.BAK.asm lexer\*.VERDE.asm lexer\*.pre.asm lexer\*.clean.asm) do call :kill "%%F"
    for %%F in (parser\*.BAK.asm semantic\*.BAK.asm codegen\*.BAK*.asm codegen\*.PRE_*.asm) do call :kill "%%F"
    if exist seed\kronc.prev.exe call :kill seed\kronc.prev.exe
    if exist seed\jupiterc.prev.exe call :kill seed\jupiterc.prev.exe
)

if defined DOSCRATCH (
    echo.
    echo --- loose debugging files ---
    REM  kasm bisection cuts, one-afternoon experiments, one-letter files.
    for %%F in (cut_*.asm cut_*.exe) do call :kill "%%F"
    for %%F in (t.asm t1.asm t2.asm t3.asm t4.asm p1.asm q1.asm ref.asm a1.asm) do call :kill "%%F"
    for %%F in (a.txt b.txt c.txt v.txt a.bin k.bin hi.txt) do call :kill "%%F"
    for %%F in (test_float2.kr test_float2.asm manual.kr zz.kr) do call :kill "%%F"
    for %%F in (t_one.kr t_two.kr mod_a.kr mod_b.kr) do call :kill "%%F"
    for %%F in (test_math_kasm.asm test_math_nasm.asm) do call :kill "%%F"
    for %%F in (jupiter_std.asm jupiter_two.asm) do call :kill "%%F"
    for %%F in (flat_test.asm rip_imm.asm test_min.asm test_ops.asm) do call :kill "%%F"
    for %%F in (test_pp1.asm test_pp2.asm test_pp3.asm) do call :kill "%%F"
    REM  replaced by their Kron equivalents
    for %%F in (jc.bat jupiter_alloc.kr jpx.asm JPX_FORMAT.md) do call :kill "%%F"
    for %%F in (jupiter_gramatica.txt) do call :kill "%%F"
)

echo.
echo ============================================================
if defined LIST (
    echo   !N! files would be deleted. Run without /list to do it.
) else (
    echo   !N! files deleted.
)
echo ============================================================
echo.
echo   NOT touched, even though they look like it:
echo     krn.asm karm.asm kasm.asm       compiler modules
echo     kasmchar/new/rex/simd.asm       suite corpora
echo     kasmdiff.asm                    comparison tool
echo     KRN_FORMAT.md                   the own executable format
echo     kron_alloc.kr                   allocator written in Kron
echo     kc.bat                          builds a program in one go
echo     kron_all.asm seed\ tests\expected\ and the .bat and .ps1
echo     lexer\lexer_kr.asm              made from lexer.kr, part of the build
echo     parser\parser_kr.asm            made from parser.kr, part of the build
echo     semantic\semantic_kr.asm        made from semantic.kr, part of the build
echo     codegen\codegen_kr.asm          made from codegen.kr, part of the build
echo.
if not defined DOFUSED echo   .fused.kr files are kept unless /fused is given.
echo.
pause
goto :eof

:kill
if not exist "%~1" goto :eof
echo   %~1
set /a N+=1
if not defined LIST del /q "%~1" >nul 2>&1
goto :eof
