[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$Server,

    [Parameter(Mandatory=$True,Position=2)]
    [string]$Query,

    [Parameter(Mandatory=$True,Position=3)]
    [string]$OutputFile
)

Invoke-Sqlcmd -Query $Query -ServerInstance $Server -QueryTimeout 30 # | Out-File -FilePath $OutputFile

