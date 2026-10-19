# ===========================================================================
#  RATRACE.ps1 -- switch the register allocator's trace on or off
#
#    powershell -ExecutionPolicy Bypass -File RATRACE.ps1 -On
#    powershell -ExecutionPolicy Bypass -File RATRACE.ps1 -Off
#
#  Rewrites the RA_TRACE line in include\kron_types.inc and nothing else. The
#  compiler has to be rebuilt afterwards for the change to take effect.
#
#  With the trace on, every compiled function carries its liveness analysis
#  as comments, so the .asm is NOT what the normal compiler produces. Leave it
#  off for RUNTESTS, COMPAREASM and anything that gets seeded.
# ===========================================================================

param([switch]$On, [switch]$Off)

if (-not ($On -xor $Off)) { Write-Host "Use -On or -Off."; exit 1 }

$f = "include\kron_types.inc"
$bytes = [IO.File]::ReadAllBytes((Resolve-Path $f))
$text  = [Text.Encoding]::UTF8.GetString($bytes)
$val   = if ($On) { "1" } else { "0" }
$new   = [regex]::Replace($text, '(%define RA_TRACE\s+)\d', "`${1}$val")

if ($new -eq $text -and -not ($text -match "%define RA_TRACE\s+$val")) {
    Write-Host "No RA_TRACE line found in $f"; exit 1
}
[IO.File]::WriteAllBytes((Resolve-Path $f), [Text.Encoding]::UTF8.GetBytes($new))
Write-Host "RA_TRACE = $val. Rebuild with BOOTSTRAP.bat, then SEED.bat and BUILD.bat."
