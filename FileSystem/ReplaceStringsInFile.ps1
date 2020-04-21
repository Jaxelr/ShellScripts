[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$InputFile
)

if (!(Test-Path $InputFile)) {
    Write-Error -Message "The File $InputFile doesn't exists or the process doesn't have permissions to view it."
    Exit
}

$content = Get-Content -Path $InputFile

# Use `r`n if you want to split lines with CRLF instead of LF
$content = $content -replace '"string"', 'string' -join "`n" 

$content | Out-File $InputFile