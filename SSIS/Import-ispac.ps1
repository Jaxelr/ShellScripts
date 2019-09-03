[CmdletBinding()]
Param(
    # Deployment Package Name (use same folder as powershell)
    [Parameter(Mandatory=$True,Position=1)]
    [string]$IsPacFile,
     
    # Destination Server 
    [Parameter(Mandatory=$True,Position=2)]
    [string]$ServerName,
     
    # Folder on the Destination Server
    [Parameter(Mandatory=$True,Position=3)]
    [string]$ProjectFolder,

    # ProjectName is required
    [Parameter(Mandatory=$True,Position=4)]
    [string]$ProjectName,

    # Environment
    [Parameter(Mandatory=$True,Position=5)]
    [string]$Environment,

    # Folder Description to attach to the Folder Name if created.
    [Parameter(Mandatory=$False,Position=6)]
    [string]$FolderDescription,

    # Filename of the parameter json file.
    [Parameter(Mandatory=$False,Position=7)]
    [string]$Parameters
)

# Invoking this script (sample):
# powershell -File .\Import-ispac.ps1 -IsPacFile 
# "ProviderDirectory.ispac" -ServerName 
# "tsaisdev" -ProjectFolder "Provider" 
# -ProjectName "ProviderDirectory" 
# -Environment "Test" 
# -FolderDescription "This is a test." 
# -Parameters "params.json"

# pwd
$currentDirectory = Split-Path $MyInvocation.MyCommand.Path

$currentParams = Join-Path $currentDirectory $parameters
$ProjectFilePath = Join-Path $currentDirectory (Split-Path $IsPacFile -Leaf)

#Project location validation
if (!(Test-Path $ProjectFilePath))
{
    if (!(Test-Path $IsPacFile))
    {
        Write-Error -Message "Ispac file $ProjectFilePath doesn't exists!"
        exit
    }
    else 
    {
        $ProjectFilePath = $IsPacFile
    }
}

Write-Host "Ispac found... starting process..."    

# Load the IntegrationServices Assembly
[System.Reflection.Assembly]::Load("Microsoft.SQLServer.Management.IntegrationServices, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91, processorArchitecture=MSIL") | Out-Null;


# Store the IntegrationServices Assembly namespace to avoid typing it every time
$ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

Write-Host "Connecting to server $ServerName ..."

# Create a connection to the server
$sqlConnectionString = "Data Source=" + $ServerName + ";Initial Catalog=master;Integrated Security=SSPI;"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

# Create the Integration Services object
$integrationServices = New-Object $ISNamespace".IntegrationServices" $sqlConnection

# Check if connection succeeded
if (!($integrationServices))
{
    Write-Error "Failed to connect to server $ServerName ..."
    exit
}
else
{
    Write-Host "Connected to server $ServerName ..."
}

# Check if catalog doesnt exists
if (!($integrationServices.Catalogs["SSISDB"]))
{
    Write-Error "SSIS Catalog doesn't exists on this server $ServerName ..."
    exit
}
else 
{
    Write-Host "Catalog SSISDB exists ..."
    $catalog = $integrationServices.Catalogs["SSISDB"]    
}


#Check if Folder is already present, if not create it.
if (!($catalog.Folders.Item($ProjectFolder)))
{
    Write-Host "Folder $ProjectFolder doesn't exists..."
    Write-Host "Creating Folder $ProjectFolder ..."
    (New-Object $ISNamespace".CatalogFolder" ($catalog, $ProjectFolder, $FolderDescription)).Create()
}
else
{
    Write-Host "Folder $ProjectFolder exists..."
}

$ssisFolder = $catalog.Folders.Item($ProjectFolder)


Write-Host "Deploying $ProjectName project ..."

# Read the project file, and deploy it to the folder
[byte[]] $projectFile = [System.IO.File]::ReadAllBytes($ProjectFilePath)
$ssisFolder.DeployProject($ProjectName, $projectFile)
$Project = $ssisFolder.Projects[$ProjectName]

if (!($Project))
{
    Write-Host "Something went wrong deploying the package, Aborting!!!"
    Write-Error "Deploying Error!"
    exit
}

if (!(Test-Path $currentParams))
{
    Write-Host "No params file found, ...skipping parameter configuration."
}
else
{
    $poco = (Get-Content $Parameters -Raw) | ConvertFrom-Json | Select-Object -expand environments

    if ($poco.environment -eq $Environment)
    {
        "Configuring variables for $Environment environment..."

        $poco = $poco.Where({$_.environment -eq $Environment})

        foreach($variable in $poco.variables)
        {
             # Loop through all project parameters
            foreach ($Parameter in $Project.Parameters)
            {
                if ($Parameter.Name.StartsWith("CM.", "CurrentCultureIgnoreCase"))
                {
                    #Ignore
                }
                if ($Parameter.Name.StartsWith("INTERN_", "CurrentCultureIgnoreCase"))
                {
                    #Ignore
                }
                
                if ($variable.variableName -eq $Parameter.Name)
                {
                    $Project.Parameters[$Parameter.Name].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, $Parameter.Name)
                    $Project.Alter()
                }
            }

            # Loop through all package parameters
            foreach ($Package in $Project.Packages)
            {
                foreach ($PackageParameter in $Package.Parameters)
                {
                    if ($PackageParameter.Name.StartsWith("CM.", "CurrentCultureIgnoreCase"))
                    {
                        #Ignore
                    }
                    if ($PackageParameter.Name.StartsWith("INTERN_", "CurrentCultureIgnoreCase"))
                    {
                        #Ignore
                    }

                    if ($variable.variableName -eq $PackageParameter.Name)
                    {
                        $Package.Parameters[$PackageParameter.Name].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced, $PackageParameter.Name)
                        $Package.Alter()
                    }
                }
            }            
        }            
    }
}

Write-Host "All done."