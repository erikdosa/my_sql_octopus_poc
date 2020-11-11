# Prerequisites
Write-Output "      Installing new PowerShellGet (required for SQL Change Automation)..."
Install-Module PowerShellGet -MinimumVersion 1.6 -Force -AllowClobber
Write-Output "      Hard deleting the old version of PowerShellGet..."
Remove-Item -LiteralPath "C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1" -Force -Recurse

Write-Output "      Starting a new session to ensure using new version of PowerShellGet..."
Invoke-Command { & "powershell.exe" } -NoNewScope

$log = "C:\StartupLogSession2of2.txt"
Write-Output " Creating a new log file at $log"
Start-Transcript -path $log -append

Write-Output "      Installing SQL Change Automation PowerShell module..."
Install-Module SqlChangeAutomation -AcceptLicense -Force

Write-Output "      Installing SqlServer PowerShell module..."
# This bit is currently broken. Not sure why. Still trying to use the old PowerShellGet
Install-Module -Name SqlServer -AllowClobber -Force
