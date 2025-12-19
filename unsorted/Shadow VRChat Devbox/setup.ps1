<#
.SYNOPSIS
    Setup VRChat Devbox on Shadow PC

.DESCRIPTION
    This script installs necessary software for VRChat development on a Shadow cloud-based PC.

.NOTES
    Shadow: https://shadow.tech/
    VRChat: https://vrchat.com/
#>

# Are we in an elevated session?
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script! Please re-run this script as an Administrator!"
    Break
}

# is chocolatey installed?
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    # Install Chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# pass -y to all choco installs
choco feature enable -n allowGlobalConfirmation

# disable checksum checks
choco feature disable -n checksumFiles

# Download and install Winget v1.6.3482 as Shadow's default Winget version is broken
$targetWingetVersion = "v1.6.3482"
$currentWingetVersion = (winget --version 2>$null)

if ($currentWingetVersion -ne $targetWingetVersion) {
    Write-Host "Current Winget version ($currentWingetVersion) differs from target ($targetWingetVersion). Downgrading..."
    Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.6.3482/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "C:\Users\Shadow\Downloads\Winget_Old.msixbundle"

    # Install the downloaded Winget package
    Add-AppxPackage -Path "C:\Users\Shadow\Downloads\Winget_Old.msixbundle"

    # Clean up downloaded Winget package
    Remove-Item -Path "C:\Users\Shadow\Downloads\Winget_Old.msixbundle" -Force
} else {
    Write-Host "Winget is already at the target version ($targetWingetVersion). Skipping downgrade."
}

# Reset Winget source and remove msstore (has certificate issues on Shadow)
winget source reset --force
winget source remove msstore

# mass-install required software that doesn't need special setup
winget install Unity.Unity.2022 -v "2022.3.22f1" # current LTS version vrchat uses
winget install Unity.UnityHub # needed because life is pain
winget install anatawa12.ALCOM # better vrchat creator companion
winget install Git.Git # version control
winget install tailscale.tailscale # private network connectivity
winget install motrix.Motrix # download manager
winget install 7zip.7zip # archive manager
winget install microsoft.VisualStudioCode # code editor
choco install googlechrome # browser

# install and set up oh my posh
winget install JanDeDobbeleer.OhMyPosh
oh-my-posh font install Meslo

# set powershell prompt to oh my posh
$profilePath = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

if (-not (Test-Path -Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force
}

$ohMyPoshInit = 'oh-my-posh init pwsh | Invoke-Expression'

if (-not (Get-Content $profilePath | Select-String -Pattern 'oh-my-posh')) {
    Add-Content -Path $profilePath -Value $ohMyPoshInit
}

# update windows terminal font
$wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

if (Test-Path $wtSettingsPath) {
    $wtSettings = Get-Content $wtSettingsPath | ConvertFrom-Json
    foreach ($profile in $wtSettings.profiles.list) {
        $profile.fontFace = "MesloLGS NF"
    }
    $wtSettings | ConvertTo-Json -Depth 32 | Set-Content $wtSettingsPath
}

# Remove all stuff from desktop (both user and public desktop)
Remove-Item -Path "C:\Users\Shadow\Desktop\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\Public\Desktop\*" -Recurse -Force -ErrorAction SilentlyContinue

# Reload environment variables to ensure newly installed software is recognized
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Set desktop wallpaper to vrchat
$wallpaperUrl = "https://images.squarespace-cdn.com/content/v1/5f0770791aaf57311515b23d/1608240505246-O7TI4Z68YP4JF0MULQPT/VRC_Treehouse_5.png"
$wallpaperPath = "C:\Users\Shadow\Pictures\vrchat_wallpaper.png"
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $wallpaperPath, 3)

# Set Unity Hub to use installed Unity version
$unityHubConfigPath = "C:\Users\Shadow\AppData\Roaming\UnityHub\preferences.json"
if (Test-Path $unityHubConfigPath) {
    $config = Get-Content $unityHubConfigPath | ConvertFrom-Json
    $config.defaultUnityVersion = "2022.3.22f1"
    $config | ConvertTo-Json | Set-Content $unityHubConfigPath
}

# Set Git global configuration
git config --global user.name "zuedev"
git config --global user.email "zuedev@gmail.com"

# show file extensions in explorer
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# show hidden files in explorer
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1

# reload explorer to apply changes
Stop-Process -Name explorer -Force

# Final message
Write-Host "VRChat Devbox setup complete."