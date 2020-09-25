$workingDir = "C:\Startup\SqlInstall"
$isoLocation = "C:\Startup\SQLServer2019-x64-ENU-Dev.iso"
$pathToConfigurationFile = "C:\Startup\scripts\ConfigurationFile.ini"
$copyFileLocation = "$workingDir\ConfigurationFile.ini"
$errorOutputFile = "$workingDir\ErrorOutput.txt"
$standardOutputFile = "$workingDir\StandardOutput.txt"

Write-Host "Copying the ini file."

New-Item $workingDir -ItemType "Directory" -Force
Remove-Item $errorOutputFile -Force
Remove-Item $standardOutputFile -Force
Copy-Item $pathToConfigurationFile $copyFileLocation -Force

Write-Host "Getting the name of the current user to replace in the copy ini file."
$user = "$env:UserDomain\$env:USERNAME"
write-host $user

Write-Host "Replacing the placeholder user name with your username"
$replaceText = (Get-Content -path $copyFileLocation -Raw) -replace "##MyUser##", $user
Set-Content $copyFileLocation $replaceText

Write-Host "Installing Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "Installing SQL Server with Chocolatey"
choco install sql-server-2019 --params="'/ConfigurationFile:C:\Startup\SqlInstall\ConfigurationFile.ini'" -y