# Prerequisites
Write-Output "      Installing new PowerShellGet (required for SQL Change Automation)..."
Install-Module PowerShellGet -MinimumVersion 1.6 -Force -AllowClobber
# Hard deleting the old version of PowerShellGet
Remove-Item -LiteralPath "C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1" -Force -Recurse

# Creating a new session to install SqlChangeAutomation and SqlServer to ensure correct version of PowerShellGet is used
Invoke-Command { & "powershell.exe" } -NoNewScope

Write-Output "      Installing SQL Change Automation PowerShell modules..."
Install-Module SqlChangeAutomation -AcceptLicense -Force

Write-Output "      Installing SqlServer PowerShell module..."
# This bit is currently broken. Not sure why. Still trying to use the old PowerShellGet
Install-Module -Name SqlServer -AllowClobber -Force
