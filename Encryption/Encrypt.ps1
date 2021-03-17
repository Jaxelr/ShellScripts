[CmdletBinding()]
Param(
    # Text string to encrypt
    [Parameter(Mandatory=$True,Position=1)]
    [string]$Text,

    # Output of the secure txt
    [Parameter(Mandatory=$False,Position=2)]
    [string]$OutputFile

)
## Sample usage of the shell
## powershell .\Encrypt.ps1 -Text "Secure String" -OutputFile "C:\Temp" 
$secure_str = ConvertTo-SecureString -String $Text -AsPlainText -Force | ConvertFrom-SecureString;

if ($OutputFile -ne '' -And (Test-Path $OutputFile)) {
    $FullPath = $OutputFile + "\SecureString.txt";
    $secure_str | Out-File -FilePath $FullPath -Encoding ascii -Force;
}
Else {
    Return $secure_str
}
