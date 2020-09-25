# Creating RDP and Octopus users
function get-secret(){
  param ($secret)
  $secretValue = Get-SECSecretValue -SecretId $secret
  # values are returned in format: {"key":"value"}
  $splitValue = $secretValue.SecretString -Split '"'
  $cleanedSecret = $splitValue[3]
  return $cleanedSecret
}

Write-Output "  Retrieving user passwords from AWS Secrets Manager"

$rdpUser = "student"
$rdpPwd = Get-Secret -secret "STUDENT_PASSWORD"
$octoUser = "octopus"
$octoPwd = Get-Secret -secret "OCTOPUS_PASSWORD"

Write-Output "  Creating users"

function New-User {
    param ($user, $password)
    Write-Output "    Creating a user: $user."
    New-LocalUser -Name $user -Password $password -AccountNeverExpires | out-null
    Write-Output "    Making $user an admin."
    Add-LocalGroupMember -Group "Administrators" -Member $user
}
New-User -user $rdpUser -password $rdpPwd
New-User -user $octoUser -password $octoPwd