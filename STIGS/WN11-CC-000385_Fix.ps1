<#
.SYNOPSIS
    This PowerShell script sets "Allow Windows Ink Workspace" to "Enabled and set Options "On, but disallow access above lock".

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-16
    Last Modified   : 2025-10-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000385

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN11-CC-000385_Fix.ps1 
#>

# Ensure running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n=== Configuring 'Allow Windows Ink Workspace' policy ===`n" -ForegroundColor Cyan

# Registry path
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace"

# Ensure registry path exists
if (-not (Test-Path $regPath)) {
    Write-Host "Registry path not found. Creating: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Set the value to 1 (Enabled, On but disallow access above lock)
try {
    Set-ItemProperty -Path $regPath -Name "AllowWindowsInkWorkspace" -Type DWord -Value 1 -Force
    Write-Host "Set 'AllowWindowsInkWorkspace' = 1 (Enabled: On, but disallow access above lock)" -ForegroundColor Green
}
catch {
    Write-Host "Error setting registry value: $_" -ForegroundColor Red
    exit
}

# Verification
$val = (Get-ItemProperty -Path $regPath -Name "AllowWindowsInkWorkspace" -ErrorAction SilentlyContinue).AllowWindowsInkWorkspace
if ($val -eq 1) {
    Write-Host "Verification successful: Policy configured correctly." -ForegroundColor Green
} else {
    Write-Host "Verification failed: Registry value is not set to 1." -ForegroundColor Red
}

Write-Host "`n===Complete ===`n" -ForegroundColor Cyan
