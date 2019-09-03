[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$True, Position=1)]
    [string]$SmtpServer,

    [Parameter(Mandatory=$True, Position=1)]
    [string]$To,

    [Parameter(Mandatory=$True, Position=1)]
    [string]$From,

    [Parameter(Mandatory=$True, Position=1)]
    [string]$Subject,

    [Parameter(Mandatory=$True, Position=1)]
    [string]$Body
)
## Sample usage of the shell
## powershell .\Sendemail.ps1 -SmtpServer "smtp.server" -To "user@mail.com" -From "automaticscript@mail.com" $Subject "Heres my subject" $Body "Heres my body."

Send-MailMessage -SMTPServer $SmtpServer -To $To -From $From -Subject $Subject -Body $Body