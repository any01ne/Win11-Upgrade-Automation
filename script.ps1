# Enable error handling
$ErrorActionPreference = "Stop"

# Check if the system is Windows 11 25H2 (build 26000+)
$winVer  = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
if ([int]$winVer -ge 26000) {
    Write-Output "The system already has Windows 11 25H2 or newer."
    exit 1001
}

# ISO for the upgrade
$ISOPath = "C:\windows11.iso"

if (-not (Test-Path -LiteralPath $ISOPath)) {
    Write-Error "Required ISO not found: $ISOPath"
    exit 1201
}

# Installation directory and logs
$InstallPath = "C:\Install\Win11Upgrade"
if (-not (Test-Path $InstallPath)) {
    New-Item -Path $InstallPath -ItemType Directory -Force | Out-Null
}
$LogPath = Join-Path $InstallPath "Windows11Upgrade_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

Start-Transcript -Path $LogPath

try {
    # Check for administrator privileges
    $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $IsAdmin) {
        throw "This script must be run with administrator privileges."
    }

    # Remove AppLocker contents (except for user Alfa and the startup folder)
    Write-Output "Removing AppLocker folder contents..."
    Remove-Item -Path "C:\Windows\System32\AppLocker\*" -Force -Recurse -ErrorAction SilentlyContinue

    # Mount the ISO
    Write-Output "Mounting ISO: $ISOPath"
    $MountResult = Mount-DiskImage -ImagePath $ISOPath -PassThru
    Start-Sleep -Seconds 3 # give it a moment to mount
    $DriveLetter = ($MountResult | Get-Volume).DriveLetter

    if (-not $DriveLetter) {
        throw "ISO mounting failed."
    }

    Write-Output "ISO mounted on drive: ${DriveLetter}:"

    $SetupPath = "${DriveLetter}:\setup.exe"
    if (-not (Test-Path $SetupPath)) {
        throw "setup.exe not found in the mounted ISO."
    }

    Write-Output "Starting Windows 11 upgrade..."

    $SetupArgs = @(
        "/auto", "upgrade",
        "/quiet",
        "/eula", "accept",
        "/ResizeRecoveryPartition", "Enable",
        "/dynamicupdate", "disable",
        "/compat", "ignorewarning",
        "/copylogs", "$InstallPath\Setup.log"
    )
    Start-Process -FilePath $SetupPath -ArgumentList $SetupArgs -Wait

    Write-Output "Upgrade process has started."

    # Save upgrade info to registry
    $regPath  = "HKLM:\Software\UpgradeStatus"
    $regName  = "WindowsUpgrade"
    $regValue = 1
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    New-ItemProperty -Path $regPath -Name $regName -Value $regValue -PropertyType DWORD -Force | Out-Null
}
catch {
    Write-Error "An error occurred: $_"
    throw $_
}
finally {
    # Unmount ISO regardless of the result
    if ($MountResult) {
        Dismount-DiskImage -ImagePath $ISOPath -ErrorAction SilentlyContinue
    }
    Stop-Transcript
}
