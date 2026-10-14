@echo off
setlocal

echo ============================================================
echo   KRON OS IMAGE BUILD
echo   MBR bootloader + kernel, no GRUB, no Multiboot
echo ============================================================
echo.

if "%~1"=="" (
    echo Usage: BUILDOS.bat program.jup
    exit /b 1
)

echo [1/4] Compiling %~1 in freestanding mode...
kronc.exe "%~1" --bare
if %errorlevel% neq 0 ( echo FAILED: Kron compilation & exit /b 1 )
copy /y "%~n1.asm" kernel_program.asm >nul
echo       OK

echo [2/4] Assembling the bootloader...
nasm.exe -f bin mbr.asm -o mbr.bin
if %errorlevel% neq 0 ( echo FAILED: mbr.asm & exit /b 1 )
echo       OK

echo [3/4] Assembling the kernel...
nasm.exe -f bin kernel.asm -o kernel.bin
if %errorlevel% neq 0 ( echo FAILED: kernel.asm & exit /b 1 )
echo       OK

echo [4/4] Building the disk image...
copy /b mbr.bin + kernel.bin kron_os.img >nul
if %errorlevel% neq 0 ( echo FAILED: image assembly & exit /b 1 )
echo       OK

echo.
echo ============================================================
echo   kron_os.img is ready
echo   Run with:  qemu-system-x86_64 -drive format=raw,file=kron_os.img
echo ============================================================
