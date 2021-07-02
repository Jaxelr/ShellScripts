[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Source
)

if (!(Test-Path $Source)) {
    Write-Host -Message "No files found on wildcard $Source, Check path. Could be a permission issue?!"
    Exit
}

foreach ($file in Get-ChildItem -Path $Source) {
    if ((Get-Item $file).Length -eq 0) {
        Write-Host "Deleted $file because its empty"
        Remove-Item $file
    }
}
