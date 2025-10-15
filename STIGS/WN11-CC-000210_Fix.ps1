 <#
.SYNOPSIS
    This PowerShell script enables Microsoft Defender SmartScreen.

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-14
    Last Modified   : 2025-10-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000210

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN11-CC-000210_Fix.ps1 
#>

# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n=== Configuring Windows Defender SmartScreen for File Explorer ===`n" -ForegroundColor Cyan

# Registry path for SmartScreen policy
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

# Ensure registry path exists
if (-not (Test-Path $regPath)) {
    Write-Host "Registry path not found. Creating it..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

# Define policy values
$EnableSmartScreenName = "EnableSmartScreen"
$SmartScreenLevelName = "ShellSmartScreenLevel"

try {
    # Set EnableSmartScreen to 1 (Enabled)
    Set-ItemProperty -Path $regPath -Name $EnableSmartScreenName -Type DWord -Value 1 -Force
    Write-Host "Set EnableSmartScreen = 1 (Enabled)" -ForegroundColor Green

    # Set ShellSmartScreenLevel to "Block" (Warn and prevent bypass)
    Set-ItemProperty -Path $regPath -Name $SmartScreenLevelName -Type String -Value "Block" -Force
    Write-Host "Set ShellSmartScreenLevel = 'Block' (Warn and prevent bypass)" -ForegroundColor Green
}
catch {
    Write-Host "Error configuring SmartScreen settings: $_" -ForegroundColor Red
}

# Verification
$verify = Get-ItemProperty -Path $regPath
if (($verify.EnableSmartScreen -eq 1) -and ($verify.ShellSmartScreenLevel -eq "Block")) {
    Write-Host "Verification successful: SmartScreen is ENABLED with 'Warn and prevent bypass'." -ForegroundColor Green
} else {
    Write-Host "Verification failed: SmartScreen is not configured correctly." -ForegroundColor Red
}

Write-Host "`n=== SmartScreen has been enabled ===`n" -ForegroundColor Cyan
