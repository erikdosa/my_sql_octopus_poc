# Function to securely retrieve secrets from AWS Secrets Manager
function get-secret(){
  param ($secret)
  $secretValue = Get-SECSecretValue -SecretId $secret
  # values are returned in format: {"key":"value"}
  $splitValue = $secretValue.SecretString -Split '"'
  $cleanedSecret = $splitValue[3]
  return $cleanedSecret
}

Write-Output "  Getting sql passwords from AWS Secrets Manager"
$studentPassword = Get-Secret -secret "STUDENT_PASSWORD" | ConvertTo-SecureString -AsPlainText -Force
$octopusPassword = Get-Secret -secret "OCTOPUS_PASSWORD" | ConvertTo-SecureString -AsPlainText -Force
$saPassword = Get-Secret -secret "SQL_SA_PASSWORD" | ConvertTo-SecureString -AsPlainText -Force

if ($Installedmodules.name -contains "dbatools"){
    Write-Output "  Module dbatools is already installed "
}
else {
    Write-Output "  dbatools is not installed."
    Write-Output "    Installing dbatools..."
    Install-Module dbatools -Force
}

$saUser = "sa"
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $saUser, $saPassword

Write-Output "  Creating student and octopus logins."
New-DbaLogin -SqlInstance . -Login student -SecurePassword $studentPassword -SqlCredential $cred
New-DbaLogin -SqlInstance . -Login octopus -SecurePassword $octopusPassword -SqlCredential $cred

Write-Output "  Making both student and octopus logins SysAdmins."
Set-DbaLogin -SqlInstance . -Login student -AddRole "sysadmin" -SqlCredential $cred
Set-DbaLogin -SqlInstance . -Login octopus -AddRole "sysadmin" -SqlCredential $cred