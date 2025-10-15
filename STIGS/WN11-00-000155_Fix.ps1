<#
.SYNOPSIS
    This PowerShell script disables PowerShell 2.0.

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-15
    Last Modified   : 2025-10-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000155

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN11-00-000155_Fix.ps1 
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n=== Disabling Windows PowerShell 2.0 feature ===`n" -ForegroundColor Cyan

# Feature name for PowerShell 2.0
$featureName = "MicrosoftWindowsPowerShellV2Root"

try {
    # Check current state
    $feature = Get-WindowsOptionalFeature -Online -FeatureName $featureName -ErrorAction Stop

    if ($feature.State -eq "Disabled") {
        Write-Host "PowerShell 2.0 is already disabled." -ForegroundColor Green
    } else {
        Write-Host "Disabling PowerShell 2.0..." -ForegroundColor Yellow
        Disable-WindowsOptionalFeature -Online -FeatureName $featureName -NoRestart -ErrorAction Stop | Out-Null
        Write-Host "PowerShell 2.0 has been successfully disabled." -ForegroundColor Green
    }

    # Verify configuration
    $verify = (Get-WindowsOptionalFeature -Online -FeatureName $featureName).State
    if ($verify -eq "Disabled") {
        Write-Host "Verification successful: PowerShell 2.0 is disabled." -ForegroundColor Green
    } else {
        Write-Host "Verification failed: PowerShell 2.0 is still enabled." -ForegroundColor Red
    }
}
catch {
    Write-Host "Error while disabling PowerShell 2.0: $_" -ForegroundColor Red
}

Write-Host "`n=== PowerShell 2.0 is disabled ===`n" -ForegroundColor Cyan
