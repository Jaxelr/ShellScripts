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
    Write-Host -Message "No files found on wildcard $Source, Check path. Could be a permission issue?!"
    Exit
}

$TempDestination = Split-Path $Source

if ($Destination -ne "" -And (Test-Path $Destination)) {
    $MoveFlag = 1;
}
else {
    Write-Host "Files will not be moved since Destination param is empty or invalid."
    $MoveFlag = 0;
}

foreach ($file in Get-ChildItem -Path $Source) {
    $ZipPath = Join-Path -Path $TempDestination -ChildPath ((Split-Path $file -Leaf).Replace('csv', 'zip'))
    Compress-Archive -Path $file -DestinationPath $ZipPath -Force

    if ($MoveFlag -eq 1) {
        Move-Item -Path $ZipPath  -Destination $Destination
    }
}

