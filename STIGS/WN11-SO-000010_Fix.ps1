<#
.SYNOPSIS
    This PowerShell script disables the Windows 11 Guest account.

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-14
    Last Modified   : 2025-10-14
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000010

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN11-SO-000010_Fix.ps1 
#>

# Ensure the script is running with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

# Get the Guest account
$guest = Get-LocalUser -Name "Guest" -ErrorAction SilentlyContinue

if ($null -eq $guest) {
    Write-Host "Guest account not found on this system." -ForegroundColor Yellow
} else {
    # Disable the account if it is enabled
    if ($guest.Enabled -eq $true) {
        Disable-LocalUser -Name "Guest"
        Write-Host "Guest account has been successfully disabled." -ForegroundColor Green
    } else {
        Write-Host "Guest account is already disabled." -ForegroundColor Cyan
    }
}

# Optional: Confirm status
$updatedGuest = Get-LocalUser -Name "Guest" -ErrorAction SilentlyContinue
if ($updatedGuest.Enabled -eq $false) {
    Write-Host "Verification: Guest account is disabled." -ForegroundColor Green
} else {
    Write-Host "Warning: Guest account is still enabled!" -ForegroundColor Red
}
