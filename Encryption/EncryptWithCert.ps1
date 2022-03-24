$certName="{name}"

# Create certificate 
New-SelfSignedCertificate -DnsName $certName -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsage KeyEncipherment,DataEncipherment, KeyAgreement -Type DocumentEncryptionCert

# See the cert on the store
Get-Childitem -Path Cert:\CurrentUser\My -DocumentEncryptionCert

# Encrypt the file using the cert just generated
Get-Content file.txt | Protect-CmsMessage -To cn=$certName -OutFile C:\temp\secret.txt

# Decrypt the file
Unprotect-CmsMessage -Path C:\temp\secret.txt