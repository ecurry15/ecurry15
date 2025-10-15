<#
.SYNOPSIS
    This PowerShell script sets the lockout threshold to 3 failed logon attempts within the account lockout policy. 

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-15
    Last Modified   : 2025-10-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000010

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN11-AC-000010_Fix.ps1 
#>

# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "`n=== Configuring Account Lockout Threshold ===`n" -ForegroundColor Cyan

# Desired setting (3 invalid attempts)
$DesiredThreshold = 3

# Retrieve current lockout threshold
$currentSetting = (net accounts | Select-String "Lockout threshold").ToString()
$currentThreshold = [int]($currentSetting -replace '[^\d]', '')

Write-Host "Current Account Lockout Threshold: $currentThreshold" -ForegroundColor Yellow

# Apply the configuration if not compliant
if ($currentThreshold -eq 0 -or $currentThreshold -gt $DesiredThreshold) {
    Write-Host "Setting Account Lockout Threshold to $DesiredThreshold invalid attempts..." -ForegroundColor Yellow
    net accounts /lockoutthreshold:$DesiredThreshold | Out-Null

    # Also configure related lockout durations for security consistency
    # These can be adjusted per policy, but defaults below are STIG-aligned
    net accounts /lockoutduration:15 | Out-Null          # Lockout lasts 15 minutes
    net accounts /lockoutwindow:15 | Out-Null            # Reset counter after 15 minutes

    Write-Host "Configuration applied successfully." -ForegroundColor Green
} else {
    Write-Host "Account Lockout Threshold already meets STIG requirements." -ForegroundColor Cyan
}

# Verify the result
$verifySetting = (net accounts | Select-String "Lockout threshold").ToString()
$verifyThreshold = [int]($verifySetting -replace '[^\d]', '')

if ($verifyThreshold -le $DesiredThreshold -and $verifyThreshold -ne 0) {
    Write-Host "Verification successful: Lockout threshold is set to $verifyThreshold (compliant)." -ForegroundColor Green
} else {
    Write-Host "Verification failed: Lockout threshold is $verifyThreshold (non-compliant)." -ForegroundColor Red
}

Write-Host "`n=== STIG WN11-AC-000010 compliance check complete ===`n" -ForegroundColor Cyan
