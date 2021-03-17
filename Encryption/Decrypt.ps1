[CmdletBinding()]
Param(
    # Text string to decrypt
    [Parameter(Mandatory=$False,Position=1)]
    [string]$SecureText,

    # Input 
    [Parameter(Mandatory=$False,Position=2)]
    [string]$SecureFile

)

## Sample usage of the shell
## powershell .\Decrypt.ps1 -SecureText "Secure String" 
## powershell .\Decrypt.ps1 -SecureFile "C:\Temp\SecureString.txt" 

if ($SecureFile -ne '' -And (Test-Path $SecureFile)) {
    $SecureText = Get-Content -Path $SecureFile;

}

if ($SecureText -ne '') {
    $DecryptedText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::
    SecureStringToBSTR($($SecureText| Convertto-SecureString))); 

    Return $DecryptedText;
}

Write-Error "Nothing to decrypt";