[CmdletBinding()]
Param(
    # Input Path for the Processing Logic
    [Parameter(Mandatory=$True,Position=1)]
    [string]$InputPath,

    # Output Path for the Copy action
    [Parameter(Mandatory=$True,Position=2)]
    [string]$OutputPath
)

## powershell .\CopyFolderStructure.ps1 -InputPath "C:\Temp\In" -DestinationPath "C:\Temp\Out"

Copy-Item $InputPath $OutputPath -Filter {PSIsContainer} -Recurse -Force