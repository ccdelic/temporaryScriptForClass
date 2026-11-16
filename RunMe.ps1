$folder = "C:\ProgramData\SECX15"
$file = "$folder\admin1-telemetry-validation.txt"
New-Item -ItemType Directory -Path $folder -Force | Out-Null

$start = Get-Date
cmd.exe /c echo SECX15-PROC
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "Write-Output 'SECX15-SCRIPTBLOCK'"
Start-Sleep -Seconds 10

$wsh = Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name Enabled -ErrorAction SilentlyContinue
$process = auditpol /get /subcategory:"Process Creation" | Out-String
$cmdline = Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit" -Name ProcessCreationIncludeCmdLine_Enabled -ErrorAction SilentlyContinue
$scriptblock = Get-ItemPropertyValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name EnableScriptBlockLogging -ErrorAction SilentlyContinue
$module = Get-ItemPropertyValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging" -Name EnableModuleLogging -ErrorAction SilentlyContinue
$modules = (Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames" -ErrorAction SilentlyContinue).'*'

$event4688 = @(Get-WinEvent -FilterHashtable @{LogName="Security";ID=4688;StartTime=$start} -ErrorAction SilentlyContinue | Where-Object {$_.Message -match "SECX15-PROC"}).Count
$event4104 = @(Get-WinEvent -FilterHashtable @{LogName="Microsoft-Windows-PowerShell/Operational";ID=4104;StartTime=$start} -ErrorAction SilentlyContinue | Where-Object {$_.Message -match "SECX15-SCRIPTBLOCK"}).Count

$report = @()
$report += "WSH"
$report += "Enabled = $wsh"
$report += ""
$report += "Process Creation audit"
$report += $process
$report += "Command-line process auditing"
$report += "Enabled = $cmdline"
$report += ""
$report += "PowerShell Script Block Logging"
$report += "Enabled = $scriptblock"
$report += ""
$report += "PowerShell Module Logging"
$report += "Enabled = $module"
$report += "ModuleNames (*) = $modules"
$report += ""
$report += "Generated marker: SECX15-PROC"
$report += "Generated marker: SECX15-SCRIPTBLOCK"
$report += ""
$report += "Security Event 4688 matches: $event4688"
$report += "PowerShell Operational Event 4104 matches: $event4104"

$report | Set-Content -Path $file -Encoding UTF8
notepad.exe $file
