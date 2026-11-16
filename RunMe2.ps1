Import-Module WebAdministration
$existing = Get-WebConfiguration -PSPath 'MACHINE/WEBROOT/APPHOST' -Filter "system.webServer/staticContent/mimeMap[@fileExtension='.cer']"

if ($existing) {
    Set-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' -Filter "system.webServer/staticContent/mimeMap[@fileExtension='.cer']" -Name 'mimeType' -Value 'application/pkix-cert'
} else {
    Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' -Filter 'system.webServer/staticContent' -Name '.' -Value @{fileExtension='.cer';mimeType='application/pkix-cert'}
}
$cert = New-SelfSignedCertificate -DnsName "SRV01.hexelo.com" -CertStoreLocation "Cert:\LocalMachine\My" -FriendlyName "SRV01 Web TLS"
New-Item -ItemType Directory -Path "C:\inetpub\wwwroot\certs" -Force
Export-Certificate -Cert $cert -FilePath "C:\inetpub\wwwroot\certs\SRV01-Web-TLS.cer"
Test-Path "C:\inetpub\wwwroot\certs\SRV01-Web-TLS.cer"
Invoke-WebRequest -Uri "http://SRV01.hexelo.com/certs/SRV01-Web-TLS.cer" -Method Head