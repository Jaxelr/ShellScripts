[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Source
)

## Sample usage of the shell
## cd to this folder...
## .\ReplaceWithZip.ps1 -Source "C:\temp\*.csv"

if (!(Test-Path $Source)) {
    Write-Host -Message "No files found on wildcard $Source, Check path. Could be a permission issue?!"
    Exit
}

foreach ($file in Get-ChildItem -Path $Source) {
    $Zip = Join-Path -Path (Split-Path $file) -ChildPath (-Join ((Split-Path $file -Leaf), '.zip'))
    Compress-Archive -Path $file -DestinationPath $Zip  -Force
    Remove-Item -Path $file
}
