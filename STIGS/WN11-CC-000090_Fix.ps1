<#
.SYNOPSIS
    This PowerShell script first checks if the registry path 
    "HKLM\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}" exists and will create the path if it doesn't. 
    Next, it will set the value NoGPOListChanges to 0, which will process even if the GPOs have not changed.

.NOTES
    Author          : Edward Campbell
    LinkedIn        : https://www.linkedin.com/in/edwardcampbell15/
    GitHub          : https://github.com/ecurry15
    Date Created    : 2025-10-13
    Last Modified   : 2025-10-13
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000090

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    PS C:\> .\STIG-ID-WN11-CC-000090_Fix.ps1 
#>


# Ensure the script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
$valueName = "NoGPOListChanges"
$desiredValue = 0  # 0 = Process even if GPOs have not changed

# Check if the registry path exists
if (-not (Test-Path $regPath)) {
    Write-Host "Registry path does not exist. Creating it now..." -ForegroundColor Yellow
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy" `
        -Name "{35378EAC-683F-11D2-A89A-00C04FBBCFA2}" -Force | Out-Null
    Write-Host "Registry path created successfully." -ForegroundColor Green
} else {
    Write-Host "Registry path already exists. Continuing..." -ForegroundColor Cyan
}

# Create or update the registry value
$currentValue = (Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue).$valueName

if ($null -eq $currentValue) {
    # Create new value
    New-ItemProperty -Path $regPath -Name $valueName -PropertyType DWord -Value $desiredValue -Force | Out-Null
    Write-Host "Created new registry value '$valueName' with value $desiredValue." -ForegroundColor Green
} elseif ($currentValue -ne $desiredValue) {
    # Update existing incorrect value
    Set-ItemProperty -Path $regPath -Name $valueName -Value $desiredValue
    Write-Host "Updated registry value '$valueName' to $desiredValue." -ForegroundColor Green
} else {
    Write-Host "Registry value '$valueName' is already correctly configured." -ForegroundColor Cyan
}

# Verification step
$verify = (Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue).$valueName
if ($verify -eq $desiredValue) {
    Write-Host "Verification successful: STIG WN11-CC-000090 is compliant." -ForegroundColor Green
} else {
    Write-Host "Verification failed: STIG WN11-CC-000090 is NOT compliant." -ForegroundColor Red
}

# Optional: Apply Group Policy immediately
# Uncomment the following line to enforce immediately:
# gpupdate /target:computer /force
