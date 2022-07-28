[CmdletBinding()]
Param(
    # Path to Search
    [Parameter(Mandatory=$True,Position=1)]
    [string]$Path
)


Get-ChildItem -path $Path -ErrorAction silentlycontinue -Recurse |
Sort-Object -Property length -Descending |
Select-Object -First 100 |
Format-Table -autosize -wrap -property Length, FullName, LastAccessTimeUtc, LastWriteTimeUtc |
Out-File c:\temp\bigFiles.log