param(
    $tag = "", 
    $value = ""
)

# Function to securely retrieve secrets from AWS Secrets Manager
function get-secret(){
  param ($secret)
  $secretValue = Get-SECSecretValue -SecretId $secret
  # values are returned in format: {"key":"value"}
  $splitValue = $secretValue.SecretString -Split '"'
  $cleanedSecret = $splitValue[3]
  return $cleanedSecret
}

# Retrieving the IP Address for SQL Server
$acceptableStates = @("pending", "running")
$instances = (Get-EC2Instance -Filter @{Name="tag:$tag";Values="$value"}, @{Name="instance-state-name";Values=$acceptableStates}).Instances 
$sqlIpAddress = $instances[0].PublicIpAddress

Write-Output "  Getting sql passwords from AWS Secrets Manager"
$studentPassword = Get-Secret -secret "STUDENT_SQL_PASSWORD" | ConvertTo-SecureString -AsPlainText -Force
$octopusPassword = Get-Secret -secret "OCTOPUS_SQL_PASSWORD" | ConvertTo-SecureString -AsPlainText -Force
$saPassword = Get-Secret -secret "SYSADMIN_SQL_PASSWORD" | ConvertTo-SecureString -AsPlainText -Force

Write-Output "      Installing NuGet package provider (required for dbatools)..."
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force 
Write-Output "      Installing dbatools..."
Install-Module dbatools -Force

$saUser = "sa"
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $saUser, $saPassword

# Waiting for SQL Server to come online
$sqlOnline = $false
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
while ($sqlOnline -like $false){
  $time = [Math]::Floor([decimal]($stopwatch.Elapsed.TotalSeconds))
  try { 
    Invoke-DbaQuery -SqlInstance $sqlIpAddress -Query 'SELECT @@version' -SqlCredential $cred -EnableException -QueryTimeout 1
    Write-Output "    SQL Server is responding."
    $sqlOnline = $true
  }
  catch {
    Write-Output "        $time seconds: Waiting for SQL Server to come online..."
  }
  Start-Sleep -s 5
}

Write-Output "  Creating student and octopus logins."
New-DbaLogin -SqlInstance $sqlIpAddress -Login student -SecurePassword $studentPassword -SqlCredential $cred
New-DbaLogin -SqlInstance $sqlIpAddress -Login octopus -SecurePassword $octopusPassword -SqlCredential $cred

Write-Output "  Making both student and octopus logins SysAdmins."
Set-DbaLogin -SqlInstance $sqlIpAddress -Login student -AddRole "sysadmin" -SqlCredential $cred
Set-DbaLogin -SqlInstance $sqlIpAddress -Login octopus -AddRole "sysadmin" -SqlCredential $cred
