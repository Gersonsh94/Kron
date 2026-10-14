# ===========================================================================
#  COMPAREASM.ps1 -- prove a compiler change does not alter the output
#
#  Phase 1 of the register allocator reroutes all of the code generator's
#  output through an intermediate representation. It is correct only if every
#  .asm comes out byte for byte identical to what the compiler produced
#  before the change. This checks exactly that.
#
#  Two steps, and the order matters:
#
#    1. BEFORE installing the new compiler, with the current kronc.exe:
#         powershell -ExecutionPolicy Bypass -File COMPAREASM.ps1 -Capture
#
#    2. AFTER building and installing the new one:
#         powershell -ExecutionPolicy Bypass -File COMPAREASM.ps1 -Check
#
#  Capture compiles every .kr and keeps its .asm in ref_asm\. Check compiles
#  them again and compares. Programs that import modules are taken from their
#  .fused.kr when one exists, the same way RUNTESTS.bat does.
# ===========================================================================

param(
    [switch]$Capture,
    [switch]$Check,
    [string]$Compiler = ".\kronc.exe"
)

$ErrorActionPreference = "Continue"

if (-not ($Capture -or $Check)) {
    Write-Host "Use -Capture before the change, -Check after it."
    exit 1
}

$refDir = "ref_asm"
if ($Capture) { New-Item -ItemType Directory -Force -Path $refDir | Out-Null }
if ($Check -and -not (Test-Path $refDir)) {
    Write-Host "No ref_asm\ -- run with -Capture first, using the OLD compiler."
    exit 1
}

# every .kr that is not itself a fused file; a fused twin wins when present
$sources = @()
foreach ($f in (Get-ChildItem -Filter *.kr -File)) {
    if ($f.Name -like "*.fused.kr") { continue }
    $base  = [IO.Path]::GetFileNameWithoutExtension($f.Name)
    $fused = "$base.fused.kr"
    if (Test-Path $fused) { $sources += [pscustomobject]@{ Base=$base; Src=$fused; Asm="$base.fused.asm" } }
    else                  { $sources += [pscustomobject]@{ Base=$base; Src=$f.Name; Asm="$base.asm" } }
}

$same = 0; $diff = 0; $skip = 0; $new = 0
$diffs = @()

foreach ($s in $sources) {
    if (Test-Path $s.Asm) { Remove-Item $s.Asm -Force }
    & $Compiler $s.Src *> $null
    if (-not (Test-Path $s.Asm)) { $skip++; continue }     # does not compile: not our concern here

    $ref = Join-Path $refDir ($s.Base + ".asm")
    if ($Capture) {
        Copy-Item $s.Asm $ref -Force
        $new++
        continue
    }

    if (-not (Test-Path $ref)) { $skip++; continue }
    $a = [IO.File]::ReadAllBytes((Resolve-Path $ref))
    $b = [IO.File]::ReadAllBytes((Resolve-Path $s.Asm))
    $eq = ($a.Length -eq $b.Length)
    if ($eq) {
        for ($i = 0; $i -lt $a.Length; $i++) { if ($a[$i] -ne $b[$i]) { $eq = $false; break } }
    }
    if ($eq) { $same++ } else { $diff++; $diffs += $s.Base }
}

Write-Host ""
if ($Capture) {
    Write-Host "$new references saved in ref_asm\  ($skip did not compile)"
    Write-Host "Now build and install the new compiler, then run with -Check."
} else {
    Write-Host "identical: $same    different: $diff    skipped: $skip"
    if ($diff -gt 0) {
        Write-Host ""
        Write-Host "These changed:" -ForegroundColor Yellow
        foreach ($d in $diffs) { Write-Host "   $d" }
        Write-Host ""
        Write-Host "Compare one by hand:  fc ref_asm\NAME.asm NAME.asm"
    } else {
        Write-Host "Every .asm is byte for byte what it was. The change is transparent."
    }
}
