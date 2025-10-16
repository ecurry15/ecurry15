 <#
.SYNOPSIS
    This PowerShell script ensures that the "Always install with elevated privileges" feature is disabled.

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-15
    Last Modified   : 2025-10-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000315

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN11-CC-000315_Fix.ps1 
#>

# Ensure running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n=== Configuring 'Always install with elevated privileges' policy ===`n" -ForegroundColor Cyan

# Define registry paths
$regPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer",
    "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer"
)

foreach ($path in $regPaths) {
    # Ensure registry path exists
    if (-not (Test-Path $path)) {
        Write-Host "Creating registry path: $path" -ForegroundColor Yellow
        New-Item -Path $path -Force | Out-Null
    }

    # Set AlwaysInstallElevated to 0 (Disabled)
    Set-ItemProperty -Path $path -Name "AlwaysInstallElevated" -Type DWord -Value 0 -Force
    Write-Host "Set 'AlwaysInstallElevated' to 0 under $path" -ForegroundColor Green
}

# Verification
foreach ($path in $regPaths) {
    try {
        $val = (Get-ItemProperty -Path $path -Name "AlwaysInstallElevated" -ErrorAction Stop).AlwaysInstallElevated
        if ($val -eq 0) {
            Write-Host "Verified: $path → AlwaysInstallElevated = 0 (Disabled)" -ForegroundColor Green
        } else {
            Write-Host "Warning: $path → AlwaysInstallElevated = $val (Should be 0)" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Value missing under $path — should be created." -ForegroundColor Yellow
    }
}

Write-Host "`n=== Always install with elevated privileges has been disabled ===`n" -ForegroundColor Cyan
