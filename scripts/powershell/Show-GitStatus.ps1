<#
.SYNOPSIS
    Displays a color-coded status report for all git repositories in immediate subdirectories.

.DESCRIPTION
    Iterates through all depth-1 directories. If a directory is a git repository,
    it checks the status and prints the folder name to the host.
    - Prints "[CLEAN]" in Green if there are no pending changes.
    - Prints "[DIRTY]" in Red if there are uncommitted changes.

.EXAMPLE
    PS C:\MyProjects> Show-GitStatus
    
    repo-api [CLEAN]
    repo-ui  [DIRTY]
#>

Get-ChildItem -Directory | 
Where-Object { Test-Path "$($_.FullName)\.git" } | 
ForEach-Object { 
    if (git -C $_.FullName status --porcelain) { 
        Write-Host "$($_.Name) [DIRTY]" -ForegroundColor Red 
    } else { 
        Write-Host "$($_.Name) [CLEAN]" -ForegroundColor Green 
    } 
}