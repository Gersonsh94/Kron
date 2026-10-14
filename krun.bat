@echo off
REM ============================================================================
REM  KRON KERNEL - Compiles a .kr program into a bare-metal kernel and boots
REM  it in QEMU. Native all the way down: no Windows or Linux underneath.
REM
REM  Usage:  krun.bat my_kernel.kr
REM
REM  Needs: nasm and qemu-system-x86_64 on the PATH.
REM ============================================================================
setlocal
if "%~1"=="" (
    echo Usage: krun.bat ^<file.kr^>
    exit /b 1
)

set SRC=%~1
set BASE=%~n1

echo === [1/4] Compiling %SRC% for bare metal ===
kronc.exe "%SRC%" --bare
if errorlevel 1 (
    echo ERROR: the Kron compilation failed.
    exit /b 1
)

echo === [2/4] Preparing kernel_program.asm ===
copy /Y "%BASE%.asm" kernel_program.asm >nul
if errorlevel 1 (
    echo ERROR: %BASE%.asm was not found
    exit /b 1
)

echo === [3/4] Assembling boot.asm -^> kernel.bin (flat binary) ===
nasm -f bin boot.asm -o kernel.bin
if errorlevel 1 (
    echo ERROR: NASM failed to assemble the boot stub.
    exit /b 1
)

echo === [4/4] Booting in QEMU (bare metal) ===
echo   Close the QEMU window to come back.
qemu-system-x86_64 -kernel kernel.bin

endlocal
