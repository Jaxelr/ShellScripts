[CmdletBinding()]
Param(
    # Input Path for the Processing Logic
    [Parameter(Mandatory=$True,Position=1)]
    [string]$InputPath,
    
    # Output Path for the resulting comparison
    [Parameter(Mandatory=$True,Position=2)]
    [string]$DestinationPath,

    # The filter
    [Parameter(Mandatory=$True,Position=3)]
    [scriptblock]$filter = {$true}
)

if (!(Test-Path $InputPath))
{
    Write-Error -Message "The File $input doesn't exists or the process doesn't have permissions to view it."
    Exit
}

# Read the JSON file and convert it to a PowerShell object
$json = Get-Content -Path $InputPath  | ConvertFrom-Json

# Filter the objects based on the property you want
$filteredObjects = $json | Where-Object $filter

# Convert the filtered objects back to JSON and save it to a new file
$filteredObjects | ConvertTo-Json | Out-File -FilePath $DestinationPath