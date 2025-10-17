 <#
.SYNOPSIS
    This PowerShell script enables PowerShell script Block Logging.

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-16
    Last Modified   : 2025-10-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000326

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN11-CC-000326_Fix.ps1 
#>

# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n=== Configuring 'Turn on PowerShell Script Block Logging' policy ===`n" -ForegroundColor Cyan

# Registry path
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"

# Create registry path if it does not exist
if (-not (Test-Path $regPath)) {
    Write-Host "Registry path not found. Creating: $regPath" -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Set EnableScriptBlockLogging to 1 (Enabled)
try {
    Set-ItemProperty -Path $regPath -Name "EnableScriptBlockLogging" -Type DWord -Value 1 -Force
    Write-Host "Set 'EnableScriptBlockLogging' to 1 (Enabled)" -ForegroundColor Green
}
catch {
    Write-Host "Error setting registry value: $_" -ForegroundColor Red
    exit
}

# Verification
$val = (Get-ItemProperty -Path $regPath -Name "EnableScriptBlockLogging" -ErrorAction SilentlyContinue).EnableScriptBlockLogging
if ($val -eq 1) {
    Write-Host "Verification successful: Script Block Logging is ENABLED." -ForegroundColor Green
} else {
    Write-Host "Verification failed: Registry value is not set correctly." -ForegroundColor Red
}

Write-Host "`n=== Block logging is enabled ===`n" -ForegroundColor Cyan
