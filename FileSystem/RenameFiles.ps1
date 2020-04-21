[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Path,

    [Parameter(Mandatory=$True,Position=2)]
    [string]$From,

    [Parameter(Mandatory=$True,Position=3)]
    [string]$To
)

## Sample usage of the shell
## cd to this folder...
## powershell .\RenameFiles.ps1 -Path "C:\Temp\*.txt" -From "replaceme" -To "replaced"

if (!(Test-Path $Path)) {
    Write-Error -Message "The File $Path doesn't exists or the process doesn't have permissions to view it."
    Exit
}

Get-ChildItem $Path | rename-item -newname { $_.name -replace $From, $To };