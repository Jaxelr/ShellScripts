#To install Reporting Tools.
#Invoke-Expression (Invoke-WebRequest https://aka.ms/rstools)

#Declare SSRS URI
$sourceRsUri = 'http://localhost/ReportServer/ReportService2010.asmx?wsdl'

#Declare Proxy so we dont need to connect with every command
$proxy = New-RsWebServiceProxy -ReportServerUri $sourceRsUri

#Output ALL Catalog items to file system
Out-RsFolderContent -Proxy $proxy -RsFolder / -Destination 'C:\temp' -Recurse