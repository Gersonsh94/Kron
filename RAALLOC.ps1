# ===========================================================================
#  RAALLOC.ps1 -- switch register allocation on or off
#
#    powershell -ExecutionPolicy Bypass -File RAALLOC.ps1 -On
#    powershell -ExecutionPolicy Bypass -File RAALLOC.ps1 -Off
#
#  Rewrites the RA_ENABLE line in include\kron_types.inc and nothing else.
#  Rebuild afterwards.
#
#  Off keeps every local in memory while the analysis still runs, so the
#  output is what it was before the allocator. That is the way back if a
#  program ever comes out wrong: switch it off, rebuild, and compare.
# ===========================================================================

param([switch]$On, [switch]$Off)

if (-not ($On -xor $Off)) { Write-Host "Use -On or -Off."; exit 1 }

$f = "include\kron_types.inc"
$bytes = [IO.File]::ReadAllBytes((Resolve-Path $f))
$text  = [Text.Encoding]::UTF8.GetString($bytes)
$val   = if ($On) { "1" } else { "0" }
$new   = [regex]::Replace($text, '(%define RA_ENABLE\s+)\d', "`${1}$val")

if (-not ($new -match "%define RA_ENABLE\s+$val")) {
    Write-Host "No RA_ENABLE line found in $f"; exit 1
}
[IO.File]::WriteAllBytes((Resolve-Path $f), [Text.Encoding]::UTF8.GetBytes($new))
Write-Host "RA_ENABLE = $val. Rebuild with BUILD_NASM.bat."
