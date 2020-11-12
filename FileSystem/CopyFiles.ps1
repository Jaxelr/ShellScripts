[CmdletBinding()]
Param(
    # Input Path for the Processing Logic
    [Parameter(Mandatory=$True,Position=1)]
    [string]$InputPath,

    # Output Path for the Copy action
    [Parameter(Mandatory=$True,Position=2)]
    [string]$OutputPath
)

if (!(Test-Path $InputPath)) {
    Write-Error -Message "The File $InputPath doesn't exists or the process doesn't have permissions to view it."
    Exit
}

if (!(Test-Path $OutputPath)) {
    New-Item -Path $OutputPath -ItemType Directory
}

Copy-Item -Path $InputPath -Destination $OutputPath -Force