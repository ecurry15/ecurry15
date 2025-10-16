 <#
.SYNOPSIS
    This PowerShell script ensures that Microsoft consumer experiences is turned off.

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-15
    Last Modified   : 2025-10-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000197

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN11-CC-000197_Fix.ps1 
#>

# Ensure running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n=== Configuring 'Turn off Microsoft consumer experiences' policy ===`n" -ForegroundColor Cyan

# Registry path
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"

# Create path if it doesn't exist
if (-not (Test-Path $regPath)) {
    Write-Host "Registry path not found. Creating: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Set DisableWindowsConsumerFeatures to 1 (Enabled)
try {
    Set-ItemProperty -Path $regPath -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1 -Force
    Write-Host "Set 'DisableWindowsConsumerFeatures' to 1 (Enabled)" -ForegroundColor Green
}
catch {
    Write-Host "Error setting registry value: $_" -ForegroundColor Red
    exit
}

# Verification
$val = (Get-ItemProperty -Path $regPath -Name "DisableWindowsConsumerFeatures" -ErrorAction SilentlyContinue).DisableWindowsConsumerFeatures
if ($val -eq 1) {
    Write-Host "Verification successful: Consumer experiences are turned OFF." -ForegroundColor Green
} else {
    Write-Host "Verification failed: Registry value not set correctly." -ForegroundColor Red
}

Write-Host "`n=== Microsoft consumer experiences has been disabled ===`n" -ForegroundColor Cyan
