<#
.SYNOPSIS
    This PowerShell script disables PowerShell 2.0.

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-14
    Last Modified   : 2025-10-14
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

$powershell2 = Get-WindowsOptionalFeature -online -featurename MicrosoftWindowsPowershellV2
if ($powershell2.State -eq 'Enabled') {
    write-host "PowershellV2 detected - Removing"
    Disable-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowershellV2 -Online -NoRestart
}
$PowerShellV2Root = Get-WindowsOptionalFeature -online -featurename MicrosoftWindowsPowerShellV2Root
if ($PowerShellV2Root.State -eq 'Enabled') {
    write-host "PowerShellV2Root detected - Removing"
    Disable-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2Root -Online -NoRestart
}
