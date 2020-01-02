#To install Reporting Tools.
#Invoke-Expression (Invoke-WebRequest https://aka.ms/rstools)
#This is also on github (https://github.com/Microsoft/ReportingServicesTools)

#Declare SSRS URI
$sourceRsUri = 'http://PSM-SRV-12/ReportServer/ReportService2010.asmx?wsdl'

#Select Your Destination Path
$destination = 'C:\temp'

#Declare Proxy so we dont need to connect with every command
$proxy = New-RsWebServiceProxy -ReportServerUri $sourceRsUri

#Output ALL Catalog items to file system
Out-RsFolderContent -Proxy $proxy -RsFolder / -Destination $destination -Recurse