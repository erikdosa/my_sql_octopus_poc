Write-Host "Getting the name of the current user to replace in the copy ini file."
$user = "$env:UserDomain\$env:USERNAME"
write-host $user

Write-Host "Replacing the placeholder user name with your username"
$replaceText = (Get-Content -path "C:\Startup\scripts\ConfigurationFile.ini" -Raw) -replace "##MyUser##", $user
Set-Content "C:\Startup\scripts\ConfigurationFile.ini" $replaceText

Write-Host "Installing Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "Installing SQL Server with Chocolatey"
choco install sql-server-2019 --params="'/ConfigurationFile:C:\Startup\scripts\ConfigurationFile.ini'" -y