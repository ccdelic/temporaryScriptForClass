Invoke-WebRequest -Uri "http://SRV01.hexelo.com/certs/SRV01-Web-TLS.cer" -OutFile "$env:USERPROFILE\Documents\SRV01-Web-TLS.cer"
Get-PfxCertificate -FilePath "$env:USERPROFILE\Documents\SRV01-Web-TLS.cer" | Format-List Subject,Thumbprint
Import-Certificate -FilePath "$env:USERPROFILE\Documents\SRV01-Web-TLS.cer" -CertStoreLocation "Cert:\LocalMachine\Root"
Get-ChildItem Cert:\LocalMachine\Root | Where-Object { $_.Subject -eq "CN=SRV01.hexelo.com" }