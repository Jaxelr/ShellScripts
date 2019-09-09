[CmdletBinding()]
Param(
    # Deployment Package Name (use same folder as powershell)
    [Parameter(Mandatory=$True,Position=1)]
    [string]$SiteName,
     
    # Destination server 
    [Parameter(Mandatory=$True,Position=2)]
    [string]$FilePath,
     
    # Application pool name
    [Parameter(Mandatory=$True,Position=3)]
    [string]$ApplicationPoolName,

    # App pool version as based on the plausible values
    [Parameter(Mandatory=$True,Position=4)]
    [string]$ApplicationPoolVersion
)

## Sample usage of the shell
## cd to this folder...
## powershell .\create-site.ps1 -SiteName "C:\Temp\Package" -FilePath "C:\inetpub\wwwroot\Destination" 
## -ApplicationPoolName "DestinatPool" -ApplicationPoolVersion "v4.0"

Import-Module WebAdministration

#navigate to the app pools root
Set-Location IIS:\AppPools\

#check if the app pool exists
if (!(Test-Path $ApplicationPoolName -pathType container))
{
    #create the app pool
    $appPool = New-Item $ApplicationPoolName
    $appPool | Set-ItemProperty -Name "managedRuntimeVersion" -Value $ApplicationPoolVersion
}

#navigate to the sites root
Set-Location IIS:\Sites\

#check if the site exists
if (Test-Path $SiteName -pathType container)
{
    return
}

#create the site
$iisApp = New-Item $iisAppName -bindings @{protocol="http";bindingInformation=":80:" + $iisAppName} -physicalPath $FilePath
$iisApp | Set-ItemProperty -Name "applicationPool" -Value $ApplicationPoolName