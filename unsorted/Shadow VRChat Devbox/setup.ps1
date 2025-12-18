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

# Install required software using Winget
winget install Unity.Unity.2022 -v "2022.3.22f1" # current LTS version vrchat uses
winget install Unity.UnityHub # needed because life is pain
winget install anatawa12.ALCOM # better vrchat creator companion
winget install Git.Git # version control

# Remove all stuff from desktop
Remove-Item -Path "C:\Users\Shadow\Desktop\*" -Recurse -Force

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

# Make Windows Terminal default terminal
$terminalSettingsPath = "C:\Users\Shadow\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $terminalSettingsPath) {
    $settings = Get-Content $terminalSettingsPath | ConvertFrom-Json
    $settings.defaultProfile = $settings.profiles.list | Where-Object { $_.name -eq "Windows PowerShell" } | Select-Object -ExpandProperty guid
    $settings | ConvertTo-Json | Set-Content $terminalSettingsPath
}

# Final message
Write-Host "VRChat Devbox setup complete."