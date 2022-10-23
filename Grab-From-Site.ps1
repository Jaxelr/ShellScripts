[CmdletBinding()]
Param(
    # Input Path for the Processing Logic
    [Parameter(Mandatory=$True,Position=1)]
    [string]$InputFile,

    # Output Path for the resulting comparison
    [Parameter(Mandatory=$True,Position=2)]
    [string]$OutputFile,

    # Url to scrape for information
    [Parameter(Mandatory=$True,Position=3)]
    [string]$Url,

    # HTML Tag to target
    [Parameter(Mandatory=$True,Position=4)]
    [string]$Tag,

    # Wildcard to apply
    [Parameter(Mandatory=$True,Position=5)]
    [string]$Wildcard

)
## Sample usage of the shell
## powershell .\GrabFromSite.ps1 -InputFile "c:\temp\abc.txt" -OutputFile "c:\temp\xyz.txt" -Url "https://npiprofile.com/npi/"  -Tag "TD" -Wildcard "^40D*"

# This is incredibly client specific
if (!(Test-Path $InputFile)) {
    Write-Error -Message "The File $InputFile doesn't exists or the process doesn't have permissions to view it."
    Exit
}

$lines = Get-Content $InputFile;
Set-Content -Path $OutputFile -Value "Request|Response";

foreach($line in $lines.Split('\n'))
{
    $response = Invoke-WebRequest $Url$line;
    $InnerValue = $response.AllElements | Where-Object {$_.TagName -eq $Tag -and  $_.innerHtml -match $Wildcard } | Select-Object -ExpandProperty InnerHTML;
    $result = $line + "|" + $InnerValue;
    Add-Content -Path $OutputFile -Value $result;
}