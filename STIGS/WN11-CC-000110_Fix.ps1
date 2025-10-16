 <#
.SYNOPSIS
    This PowerShell script ensures that printing over HTTP is disabled.

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-15
    Last Modified   : 2025-10-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000110

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN11-CC-000110_Fix.ps1 
#>

# Ensure running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"

# Create path if missing
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "Created registry path: $regPath" -ForegroundColor Yellow
}

# Set DisableHTTPPrinting to 1 (Enabled)
Set-ItemProperty -Path $regPath -Name "DisableHTTPPrinting" -Type DWord -Value 1 -Force

# Verify
$val = (Get-ItemProperty -Path $regPath).DisableHTTPPrinting
if ($val -eq 1) {
    Write-Host "Compliance verified: Turn off printing over HTTP = Enabled (1)" -ForegroundColor Green
} else {
    Write-Host "Compliance FAILED: Registry value not set correctly." -ForegroundColor Red
}

Write-Host "HTTP Printing has been disabled" -ForegroundColor Cyan
