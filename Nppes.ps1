[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$OutputPath
)

## Sample usage of the shell
## cd to this folder...
## powershell .\Nppes.ps1 -OutputPath "C:\Temp\"

if (!(Test-Path $OutputPath)) {
    Write-Error -Message "The File $OutputPath doesn't exists or the process doesn't have permissions to view it."
    Exit
}

# $month = (Get-Culture).DateTimeFormat.GetMonthName(3);
$month = (Get-Culture).DateTimeFormat.GetMonthName((Get-Date).Month);
$year = (Get-Date).Year;

$filename = "NPPES_Data_Dissemination_{0}_{1}.zip" -f $month,$year

$FullOutputPath = Join-Path -Path $OutputPath -ChildPath $filename

$url = "https://download.cms.gov/nppes/{0}" -f $filename

Write-Host $FullOutputPath
Write-Host $url

if (Test-Path $FullOutputPath) {
    Write-Host "The File $FullOutputPath was already downloaded, skipping download."
    Exit
}

try 
{
    Invoke-WebRequest -Uri $url -OutFile $FullOutputPath
} 
catch 
{
    switch ($_.Exception.Response.StatusCode.Value__)
    {
        404 { 
                Write-Error "(404) File not found for path."
                Exit
            }
    }
}

$FullOutputPath = Join-Path -Path $OutputPath -ChildPath *

# We removed the saved items
Remove-Item $FullOutputPath -Filter *.zip -Exclude $filename