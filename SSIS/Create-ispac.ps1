[CmdletBinding()]
Param(
    # Deployment Package Name (use same folder as powershell)
    [Parameter(Mandatory=$True,Position=1)]
    [string]$ServerName,

    [Parameter(Mandatory=$True,Position=2)]
    [string]$OutputFilePath,

    [Parameter(Mandatory=$False,Position=3)]
    [string]$ProjectName
)

## Sample execution of the shell
## cd to this folder...
## powershell ./Create-ispac.ps1 -ServerName "tsaisdev" -OutputFilePath "C:\Temp\SSIS\" -ProjectName "ProviderDirectory"

# Load the IntegrationServices Assembly 
[System.Reflection.Assembly]::Load("Microsoft.SQLServer.Management.IntegrationServices, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91, processorArchitecture=MSIL") | Out-Null;
 
# Store the IntegrationServices Assembly namespace to avoid typing it every time 
$ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices" 
 
Write-Host "Connecting to server ... $ServerName" 
 
# Create a connection to the server 
$sqlConnectionString = "Data Source=$ServerName;Initial Catalog=master;Integrated Security=SSPI;" 
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString 
 
# Create the Integration Services object 
$integrationServices = New-Object $ISNamespace".IntegrationServices" $sqlConnection 
 
if ($integrationServices.Catalogs.Count -gt 0)  
{  
    $catalog = $integrationServices.Catalogs["SSISDB"] 
 
    write-host "Looking on folders..." 
 
    $folders = $catalog.Folders 
 
    if ($folders.Count -gt 0) 
    { 
        # Loop through each folder
        foreach ($folder in $folders) 
        { 
            $projects = $folder.Projects 
            if ($projects.Count -gt 0) 
            { 
                # Loop through each project
                foreach($project in $projects) 
                {
                    if ($ProjectName -eq $project.Name -or !($ProjectName)) # Compare the parameter with project looped and generate an ispac.
                    {
                        $fullpath = $OutputFilePath + "\" + $project.Name + ".ispac" 
                        Write-Host "Exporting" $project.Name "to $fullpath ..." 
                        [System.IO.File]::WriteAllBytes($fullpath, $project.GetProjectBytes()) 
                    }
                } 
            } 
        } 
    } 
} 
 
Write-Host "Finished."