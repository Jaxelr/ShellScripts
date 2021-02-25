[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$File
)

# .\RemoveLatinChars -File="C:\temp\biko.txt" 

$content = Get-Content -Path $File -Encoding Default

$content = $content.ToUpper()

$content = $content -replace "\u00C1", "A"
$content = $content -replace "\u00C9", "E"
$content = $content -replace "\u00CD", "I"
$content = $content -replace "\u00D3", "O"
$content = $content -replace "\u00DA", "U"
$content = $content -replace "\u00D1", "N"

$content | Out-File $File -Encoding Default