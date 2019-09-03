[CmdletBinding()]
Param(
    # Input Path for the Processing Logic
    [Parameter(Mandatory=$True,Position=1)]
	[string]$InputPath,
	
	# Input Path for the Processing Logic
    [Parameter(Mandatory=$True,Position=2)]
	[string]$Filter
)
## powershell ./TrimCsv.ps1 -InputPath "C:\Temp\" -Filter ".csv" 
foreach ($file in Get-ChildItem -Path $InputPath -Filter $Filter) {
	$content = Get-Content $file
	$content | ForEach-Object {$_.TrimEnd()} | Set-Content $file
}