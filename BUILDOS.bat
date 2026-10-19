@echo off
setlocal

REM ============================================================================
REM  KRON OS IMAGE - a Kron program as the only thing on a disk
REM
REM  Usage:  BUILDOS.bat program.kr
REM  Makes:  kron_os.img  (the MBR in sector 1, the kernel from sector 2)
REM  Run:    qemu-system-x86_64 -drive format=raw,file=kron_os.img
REM
REM  Everything is built by kronc: the program with --bare, the MBR and the
REM  kernel entry with kasm (kronc file.asm --assemble). Nothing else.
REM ============================================================================

echo ============================================================
echo   KRON OS IMAGE BUILD
echo   MBR bootloader + kernel, no GRUB, no Multiboot
echo ============================================================
echo.

if "%~1"=="" (
    echo Usage: BUILDOS.bat program.kr
    exit /b 1
)

echo [1/4] Compiling %~1 for bare metal...
if exist "%~n1.asm" del "%~n1.asm"
kronc.exe "%~1" --bare
if not exist "%~n1.asm" ( echo FAILED: the Kron compilation & exit /b 1 )
copy /y "%~n1.asm" kernel_program.asm >nul
echo       OK

echo [2/4] Assembling the bootloader...
if exist mbr.kbin del mbr.kbin
kronc.exe mbr.asm --assemble >nul
if not exist mbr.kbin ( echo FAILED: mbr.asm & exit /b 1 )
echo       OK

echo [3/4] Assembling the kernel...
if exist kernel.kbin del kernel.kbin
kronc.exe kernel.asm --assemble >nul
if not exist kernel.kbin ( echo FAILED: kernel.asm & exit /b 1 )
for %%S in (kernel.kbin) do set KSIZE=%%~zS
if %KSIZE% gtr 32768 (
    echo FAILED: the kernel is %KSIZE% bytes; the MBR reads 32768
    echo         raise KERNEL_SECTORS and KERNEL_BYTES in mbr.asm
    exit /b 1
)
echo       OK ^(%KSIZE% bytes^)

echo [4/4] Building the disk image...
copy /b mbr.kbin + kernel.kbin kron_os.img >nul
if errorlevel 1 ( echo FAILED: image assembly & exit /b 1 )
REM  the MBR reads 64 sectors: the disk must have them
powershell -NoProfile -Command "$f=[IO.File]::ReadAllBytes('kron_os.img'); if($f.Length -lt 33280){ $g=New-Object byte[] 33280; [Array]::Copy($f,$g,$f.Length); [IO.File]::WriteAllBytes('kron_os.img',$g) }"
echo       OK

echo.
echo ============================================================
echo   kron_os.img is ready
echo   Run with:  qemu-system-x86_64 -drive format=raw,file=kron_os.img
echo ============================================================
