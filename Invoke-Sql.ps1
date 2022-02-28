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
# This requires that the following tools be installe
# https://docs.microsoft.com/en-us/sql/powershell/download-sql-server-ps-module?view=sql-server-ver15
Invoke-Sqlcmd -Query $Query -ServerInstance $Server -QueryTimeout 30 # | Out-File -FilePath $OutputFile

