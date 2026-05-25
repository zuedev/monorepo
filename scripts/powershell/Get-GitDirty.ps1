<#
.SYNOPSIS
    Lists immediate subdirectories containing git repositories with pending changes.

.DESCRIPTION
    This script scans all depth-1 directories in the current location. 
    It filters for valid git repositories and checks if 'git status' returns any output.
    Only the names of repositories with uncommitted changes (dirty) are returned.

.EXAMPLE
    PS C:\MyProjects> Get-GitDirty

    Returns a list of folder names that have pending changes.
#>

Get-ChildItem -Directory | 
Where-Object { Test-Path "$($_.FullName)\.git" } | 
Where-Object { git -C $_.FullName status --porcelain } | 
Select-Object Name