# Shadow VRChat Devbox Setup Script

This PowerShell script automates the setup of a VRChat development environment on a Shadow cloud-based PC. It installs essential software and configures them to sane defaults ready for VRChat development.

## Quick Start

Run the following command in PowerShell on your Shadow PC:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/zuedev/monorepo/main/unsorted/Shadow%20VRChat%20Devbox/setup.ps1" -OutFile "$env:TEMP\setup-vrchat-devbox.ps1";
PowerShell -ExecutionPolicy Bypass -File "$env:TEMP\setup-vrchat-devbox.ps1"
```
