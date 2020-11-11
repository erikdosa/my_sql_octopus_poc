# Prerequisites
Write-Output "      Installing new PowerShellGet (required for SQL Change Automation)..."
Install-Module PowerShellGet -MinimumVersion 1.6 -Force -AllowClobber
# Hard deleting the old version of PowerShellGet
Remove-Item -LiteralPath "C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1" -Force -Recurse

# Creating a new session to install SqlChangeAutomation and SqlServer to ensure correct version of PowerShellGet is used
$s = New-PSSession
Write-Output "      Installing SQL Change Automation and SqlServer PowerShell modules..."
$script = @"
Install-Module SqlChangeAutomation -AcceptLicense -Force

# This bit is currently broken. Not sure why. Still trying to use the old PowerShellGet
# Install-Module -Name SqlServer -AllowClobber -Force
"@
Invoke-Command -Session $s -ScriptBlock {$script} -AsJob
