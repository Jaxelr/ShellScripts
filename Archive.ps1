[CmdletBinding()]
Param(
    # Deployment Package Name (use same folder as powershell)
    [Parameter(Mandatory=$True,Position=1)]
    [string]$InputPath,

    [Parameter(Mandatory=$True,Position=2)]
    [string]$DestinationPath,

    [Parameter(Mandatory=$False,Position=3)]
    [bool]$MoveFiles
)

## Sample usage of the shell
## cd to this folder...
## powershell .\Archive.ps1 -InputPath "C:\Temp\SSIS\*.*" -DestinationPath "C:\Temp\SSIS\" -MoveFiles 1
if (!(Test-Path $InputPath)) {
    Write-Error -Message "The File $InputPath doesn't exists or the process doesn't have permissions to view it."
    Exit
}

if (!(Test-Path $DestinationPath) -and ((Split-Path $DestinationPath -Leaf) -ne $Archive)) {
    Write-Error -Message "The File $DestinationPath doesn't exists or the process doesn't have permissions to view it."
    Exit
}

$Archive = "Archive" #As ordered, every output folder must include the Archive folder.

if ((Split-Path $DestinationPath -Leaf) -ne $Archive) {
    $DestinationPath = Join-Path -Path $DestinationPath -ChildPath $Archive
    New-Item -ItemType Directory -Force -Path $DestinationPath
}

#We use today's date to generate the structure inside the path.
$Today = Get-Date
$Day = $Today.Day
$Month = $Today.Month

# Adding 0 if the day or month is less than 10.
if ($Today.Day -lt 10) {
    $Day = "0" + $Day
}

if ($Today.Month -lt 10) {
    $Month = "0" + $Month
}

$FullPath = Join-Path -Path $DestinationPath -ChildPath $Today.Year | 
    Join-Path -ChildPath $Month | 
    Join-Path -ChildPath $Day

New-Item -ItemType Directory -Force -Path $FullPath

if ($MoveFiles -eq 1) {
    Move-Item -Path $InputPath -Destination $FullPath
}
else {
    Copy-Item -Path $InputPath -Destination $FullPath
}

Write-Output "Files copied successfully."