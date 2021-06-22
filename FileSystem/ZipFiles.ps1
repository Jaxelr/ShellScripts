[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Source,

    [Parameter(Mandatory=$False,Position=2)]
    [string]$Destination
)

## Sample usage of the shell
## cd to this folder...
## .\ZipFiles.ps1 -Source "C:\temp\*.csv" -Destination "C:\temp\out"
## Or
## ## .\ZipFiles.ps1 -Source "C:\temp\*.csv" 

if (!(Test-Path $Source)) {
    Write-Error -Message "The path $Source doesn't exists or the process doesn't have permissions to view it."
    Exit
}

$TempDestination = Split-Path $Source

if ($Destination -ne $null -And (Test-Path $Destination)) {
    $MoveFlag = 1;
}
else {
    $MoveFlag = 0;
}

foreach ($file in Get-ChildItem -Path $Source) {
    $ZipPath = Join-Path -Path $TempDestination -ChildPath ((Split-Path $file -Leaf).Replace('csv', 'zip'))
    Compress-Archive -Path $file -DestinationPath $ZipPath -Force

    if ($MoveFlag -eq 1) {
        Move-Item -Path $ZipPath  -Destination $Destination
    }
}

