[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Path,
    [Parameter(Mandatory=$True, Position=2)]
    [string]$Pattern
)

Get-ChildItem $Path -r | Select-String -Pattern $Pattern