# Prerequisites
Write-Output "      Installing new PowerShellGet (required for SQL Change Automation)..."
Install-Module PowerShellGet -MinimumVersion 1.6 -Force -AllowClobber
Write-Output "      Hard deleting the old version of PowerShellGet..."
Remove-Item -LiteralPath "C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1" -Force -Recurse

Write-Output "      Installing SQL Change Automation PowerShell module..."
Invoke-Command { & "powershell.exe" 'Install-Module SqlChangeAutomation -AcceptLicense -Force' } -NoNewScope

Write-Output "      Installing SqlServer PowerShell module..."
Invoke-Command { & "powershell.exe" 'Install-Module -Name SqlServer -AllowClobber -Force' } -NoNewScope
