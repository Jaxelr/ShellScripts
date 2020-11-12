$User = ""
$PWord = ConvertTo-SecureString -String "" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

Invoke-Command -FilePath ".\DownloadAllReportsReportingServices.ps1" -ComputerName $env:computername -Credential $Credential
