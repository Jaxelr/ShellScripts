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
## powershell .\ArchiveByUpdateDate.ps1 -InputPath "C:\Temp\SSIS\*.*" -DestinationPath "C:\Temp\SSIS\" -MoveFiles 1
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

foreach ($file in Get-ChildItem -Path $InputPath) {
	$LastWrite = (Get-Item $file).LastWriteTime

    $Day = $LastWrite.Day
    $Month = $LastWrite.Month

    # Adding 0 if the day or month is less than 10.
    if ($LastWrite.Day -lt 10) {
        $Day = "0" + $Day
    }

    if ($LastWrite.Month -lt 10) {
        $Month = "0" + $Month
    }

    $FullPath = Join-Path -Path $DestinationPath -ChildPath $LastWrite.Year | 
        Join-Path -ChildPath $Month | 
        Join-Path -ChildPath $Day

    New-Item -ItemType Directory -Force -Path $FullPath

    if ($MoveFiles -eq 1) {
        Move-Item -Path $file -Destination $FullPath
    }
    else {
        Copy-Item -Path $file -Destination $FullPath
    }

    Write-Output "Files copied successfully."
}


