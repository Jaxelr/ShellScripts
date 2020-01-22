[CmdletBinding()]
Param(
    # Input Path for the Processing Logic
    [Parameter(Mandatory=$True,Position=1)]
    [string]$InputFile,

    # Input Path for the Processing Logic
    [Parameter(Mandatory=$True,Position=2)]
    [string]$OutputFile
)

# This is incredibly client specific
if (!(Test-Path $InputFile)) {
    Write-Error -Message "The File $InputFile doesn't exists or the process doesn't have permissions to view it."
    Exit
}

$lines = Get-Content $InputFile;
$url = "https://npiprofile.com/npi/";

Set-Content -Path $OutputFile -Value "Npi|Clia";

foreach($line in $lines.Split('\n'))
{
    $response = Invoke-WebRequest $url$line;
    $InnerValue = $response.AllElements | Where-Object {$_.TagName -eq "TD" -and  $_.innerHtml -match "^40D*" } | Select-Object -ExpandProperty InnerHTML;
    $result = $line + "|" + $InnerValue;
    Add-Content -Path $OutputFile -Value $result;
}