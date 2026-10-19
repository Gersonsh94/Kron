@echo off
REM ============================================================================
REM  KRON KERNEL - Compiles a .kr program into a bare-metal kernel and boots
REM  it in QEMU. Native all the way down: no Windows or Linux underneath.
REM
REM  Usage:  krun.bat my_kernel.kr
REM
REM  Needs: qemu-system-x86_64 on the PATH (to run it; kronc builds it all).
REM ============================================================================
setlocal
if "%~1"=="" (
    echo Usage: krun.bat ^<file.kr^>
    exit /b 1
)

set SRC=%~1
set BASE=%~n1

echo === [1/4] Compiling %SRC% for bare metal ===
if exist "%BASE%.asm" del "%BASE%.asm"
kronc.exe "%SRC%" --bare
if not exist "%BASE%.asm" (
    echo ERROR: the Kron compilation failed.
    exit /b 1
)

echo === [2/4] Preparing kernel_program.asm ===
copy /Y "%BASE%.asm" kernel_program.asm >nul

echo === [3/4] Assembling boot.asm -^> kernel.bin (Multiboot, flat binary) ===
if exist boot.kbin del boot.kbin
kronc.exe boot.asm --assemble >nul
if not exist boot.kbin (
    echo ERROR: kasm could not assemble the boot stub.
    exit /b 1
)
copy /Y boot.kbin kernel.bin >nul

echo === [4/4] Booting in QEMU (bare metal) ===
echo   Close the QEMU window to come back.
qemu-system-x86_64 -kernel kernel.bin

endlocal
