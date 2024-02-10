[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$Path
)

$foldersToDelete = @("bin", "obj")

Get-ChildItem $Path -Recurse -Directory | Where-Object { $foldersToDelete -contains $_.Name } | ForEach-Object {
    Write-Host "Deleting $($_.FullName)..."
    Remove-Item $_.FullName -Recurse -Force
}