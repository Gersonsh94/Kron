# ===========================================================================
#  MIGRATE.ps1 -- Jupiter to Kron
#
#  Rewrites every .jup source in a folder and renames it to .kr:
#
#    jupiter_program        -> kron_program
#    jupiter_domain         -> kron_domain
#    jupiter_imports        -> kron_imports
#    jupiter_definitions    -> kron_definitions
#    jupiter_isa_dynamic    -> kron_isa_dynamic
#    jupiter3d_context      -> kron3d_context
#    jupiter_hypervisor     -> kron_hypervisor
#
#  and shortens the keywords that were renamed at the same time:
#
#    boot_sequence -> boot, mmu_configuration -> mmu, and 30 more.
#
#  There are NO aliases. The compiler no longer knows the long names, so a
#  file that is not migrated will not compile.
#
#  Usage, from the folder holding the sources:
#
#    powershell -ExecutionPolicy Bypass -File MIGRATE.ps1
#    powershell -ExecutionPolicy Bypass -File MIGRATE.ps1 -DryRun
#    powershell -ExecutionPolicy Bypass -File MIGRATE.ps1 -Path "D:\somewhere"
#
#  -DryRun lists what would change without touching anything. Worth running
#  first: this rewrites every source file in the folder.
# ===========================================================================

param(
    [string]$Path = ".",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# Longest first: 'jupiter_definitions' has to be replaced before
# 'jupiter_domain' would match part of something else, and
# 'interrupt_service_routine' before any shorter prefix of it.
$map = [ordered]@{
    'jupiter_definitions'       = 'kron_definitions'
    'jupiter_hypervisor'        = 'kron_hypervisor'
    'jupiter_isa_dynamic'       = 'kron_isa_dynamic'
    'jupiter3d_context'         = 'kron3d_context'
    'jupiter_imports'           = 'kron_imports'
    'jupiter_program'           = 'kron_program'
    'jupiter_domain'            = 'kron_domain'

    'interrupt_service_routine' = 'isr'
    'human_machine_interface'   = 'hmi'
    'dma_channel_controller'    = 'dma'
    'invalidate_cache_line'     = 'invcache'
    'inter_cluster_export'      = 'export'
    'rotate_right_native'       = 'rotr'
    'rotate_left_native'        = 'rotl'
    'kernel_architecture'       = 'kernel'
    'mmu_configuration'         = 'mmu'
    'scheduler_domain'          = 'scheduler'
    'filesystem_volume'         = 'filesystem'
    'executable_loader'         = 'loader'
    'prefetch_t0_cache'         = 'prefetch'
    'deployment_model'          = 'deployment'
    'execution_model'           = 'execution'
    'package_manager'           = 'packages'
    'hardware_driver'           = 'driver'
    'domain_isolated'           = 'private'
    'enclave_hidden'            = 'private'
    'global_visible'            = 'public'
    'network_kernel'            = 'netkernel'
    'security_model'            = 'security'
    'syscall_table'             = 'syscalls'
    'boot_sequence'             = 'boot'
    'power_manager'             = 'power'
    'security_ring'             = 'ring'
    'hardware_void'             = 'void'
}

# Words that no longer exist at all. A file using one of these will not
# compile after migrating, and that is the point: they never did anything
# beyond emitting a table of name/value pairs.
$gone = @(
    'quantum_circuit','photonic_tensor_core','plasma_confinement_reactor',
    'nano_swarm_mesh','synthetic_wetware_mesh','dna_storage_volume',
    'neuromorphic_mesh','orbital_mesh_topology','relativistic_time_anchor',
    'zero_trust_quantum_fabric','living_compiler','ai_inference_accelerator',
    'tensor_accelerator','gpu_shader_pipeline','neural_network',
    'physics_world_simulation'
)

$files = Get-ChildItem -Path $Path -Filter *.jup -File
if ($files.Count -eq 0) {
    Write-Host "No .jup files in $Path"
    exit 0
}

Write-Host "Migrating $($files.Count) files in $Path"
if ($DryRun) { Write-Host "DRY RUN -- nothing will be written" }
Write-Host ""

$totalChanged = 0
$totalWarn = 0

foreach ($f in $files) {
    $text = Get-Content -Raw -Encoding UTF8 $f.FullName
    $orig = $text
    $hits = @()

    foreach ($k in $map.Keys) {
        # \b would not match around underscores, so the boundary is checked
        # by hand: the word must not be flanked by a letter, digit or _
        $pattern = "(?<![A-Za-z0-9_])" + [regex]::Escape($k) + "(?![A-Za-z0-9_])"
        $n = ([regex]::Matches($text, $pattern)).Count
        if ($n -gt 0) {
            $text = [regex]::Replace($text, $pattern, $map[$k])
            $hits += "$k x$n"
        }
    }

    $warn = @()
    foreach ($g in $gone) {
        $pattern = "(?<![A-Za-z0-9_])" + [regex]::Escape($g) + "(?![A-Za-z0-9_])"
        if ([regex]::IsMatch($text, $pattern)) { $warn += $g }
    }

    $newName = [IO.Path]::ChangeExtension($f.FullName, ".kr")

    if ($text -ne $orig -or $f.Extension -eq ".jup") {
        Write-Host ("  {0} -> {1}" -f $f.Name, [IO.Path]::GetFileName($newName))
        if ($hits.Count -gt 0) {
            Write-Host ("      " + ($hits -join ", "))
        }
        if ($warn.Count -gt 0) {
            Write-Host ("      REMOVED WORDS, will not compile: " + ($warn -join ", ")) -ForegroundColor Yellow
            $totalWarn++
        }
        if (-not $DryRun) {
            Set-Content -Path $newName -Value $text -Encoding UTF8 -NoNewline
            if ($newName -ne $f.FullName) { Remove-Item $f.FullName }
        }
        $totalChanged++
    }
}

Write-Host ""
Write-Host "$totalChanged files migrated"
if ($totalWarn -gt 0) {
    Write-Host "$totalWarn files use words that no longer exist -- fix them by hand" -ForegroundColor Yellow
}
if ($DryRun) { Write-Host "Nothing was written. Run without -DryRun to apply." }
