param(
    $instanceType = "t2.micro", # 1 vCPU, 1GiB Mem, free tier elligible: https://aws.amazon.com/ec2/instance-types/
    $ami = "ami-0d2455a34bf134234", # Microsoft Windows Server 2019 Base with Containers
    $numWebServers = 1,
    $timeout = 1800, # 30 minutes, in seconds
    $octoApiKey = "",
    $sqlOctoPassword = "",
    $octoUrl = "",
    $envId = "",
    $environment = "Manual run"
)

Import-Module -Name "$PSScriptRoot\functions.psm1" -Force

$ErrorActionPreference = "Stop"
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

Write-Output "    Auto-filling missing parameters from Octopus System Variables..."

# Initialising variables
$rolePrefix = ""
try {
    $rolePrefix = $OctopusParameters["Octopus.Project.Name"]
    Write-Output "      Detected Octopus Project: $rolePrefix"
}
catch {
    $rolePrefix = "RandomQuotes_SQL"
}

$tagValue = ""
try {
    $tagValue = $OctopusParameters["Octopus.Environment.Name"]
    Write-Output "      Detected Octopus Environment Name: $tagValue"
}
catch {
    $tagValue = $environment
}

if ($octoUrl -like ""){
    try {
        $octoUrl = $OctopusParameters["Octopus.Web.ServerUri"]
        Write-Output "      Detected Octopus URL: $octoUrl"
    }
    catch {
        Write-Error "Please provide a value for -octoUrl"
    }
}

if ($envId -like ""){
    try {
        $envId = $OctopusParameters["Octopus.Environment.Id"]
        Write-Output "      Detected Octopus Environment ID: $envId"
    }
    catch {
        Write-Error "Please provide a value for -envId"
    }
}

if ($octoApiKey -like ""){
    try {
        $octoApiKey = $OctopusParameters["API_KEY"]
    }
    catch {
        Write-Error "Please provide a value for -octoApiKey"
    }
}

$checkSql = $true
if ($sqlOctoPassword -like ""){
    try {
        $sqlOctoPassword = $OctopusParameters["sqlOctopusPassword"] | ConvertTo-SecureString -AsPlainText -Force
    }
    catch {
        Write-Warning "No octopus password provided for SQL Server. Skipping check to see if/when SQL Server comes online"
        $checkSql = $false
    }
}

$webServerRole = "$rolePrefix-WebServer"
$dbServerRole = "$rolePrefix-DbServer"
$dbJumpboxRole = "$rolePrefix-DbJumpbox"

$octoApiHeader = @{ "X-Octopus-ApiKey" = $octoApiKey }

# Reading and encoding the VM startup scripts
$webServerUserData = Get-UserData -fileName "VM_UserData_WebServer.ps1" -octoUrl $octoUrl -role $webServerRole
$dbServerUserData = Get-UserData -fileName "VM_UserData_DbServer.ps1" -octoUrl $octoUrl -role $dbServerRole

Write-Output "    Checking infrastructure that's already running..."

# Checking to see if SQL Server instance and jumpbox are required
$deploySql = $true
$dbServerInstances = Get-Servers -role $dbServerRole -includePending
if ($dbServerInstances.count -eq 0){
    Write-Output "      SQL Server deployment is required."
    $deploySql = $true
}
else {
    Write-Output "      SQL Server is already running."
    $deploySql = $false
}
$deployJump = $true
$dbJumpboxInstances = Get-Servers -role $dbJumpboxRole -includePending
if ($dbJumpboxInstances.count -eq 0){
    Write-Output "      SQL Jumpbox required."
}
elseif (($dbJumpboxInstances.count -gt 0) -and ($deploySql)){
    Write-Output "      Building a new SQL Server instance so need to re-deploy the Jumpbox too..."
    Write-Output "        Deleting old SQL Jumpbox(es)..."
    foreach ($jumpbox in $dbJumpboxInstances){
        $id = $jumpbox.InstanceId
        $ip = $jumpbox.PublicIpAddress
        Write-Output "        Removing instance $id at $ip"
        Remove-EC2Instance -InstanceId $id -Force | out-null
    }
} 
else {
    Write-Output "      SQL Jumpbox already deployed."
    $deployJump = $false
}

$deployWebServers = $true
$webServers = Get-Servers -role $webServerRole -includePending

if (($webServers.count -gt 0) -and ($deploySql)){
    Write-Output "      Building a new SQL Server instance so need to re-deploy all web servers too..."
    Write-Output "        Deleting old web server(s)..."
    foreach ($webServer in $webServers){
        $id = $webServer.InstanceId
        $ip = $webServer.PublicIpAddress
        Write-Output "        Removing instance $id at $ip"
        Remove-EC2Instance -InstanceId $id -Force | out-null
    }
    $deployWebServers = $true
}

$webServers = Get-Servers -role $webServerRole -includePending
if (($webServers.count -eq $numWebServers) -and (-not $deploySql)){
    Write-Output "      No additional web servers required."
    $deployWebServers = $false
}
if ($webServers.count -gt $numWebServers){
    Write-Warning "More web servers are already deployed than are necesary."
} 

# Building all the servers
if($deploySql){
    Write-Output "    Launching SQL Server"
    Build-Servers -role $dbServerRole -encodedUserData $dbServerUserData 
}
if($deployWebServers){
    Write-Output "    Launching Web Server(s)"
    Build-Servers -role $webServerRole -encodedUserData $webServerUserData -required $numWebServers    
}

# Checking all the instances
$dbServerInstances = Get-Servers -role $dbServerRole -includePending
$webServerInstances = Get-Servers -role $webServerRole -includePending

# Logging all the instance details
Write-Output "      Verifying instances: "
ForEach ($instance in $dbServerInstances){
    $id = $instance.InstanceId
    $state = $instance.State.Name
    Write-Output "        SQL Server $id is in state: $state"
}

ForEach ($instance in $webServerInstances){
    $id = $instance.InstanceId
    $state = $instance.State.Name
    Write-Output "        Web server $id is in state: $state"
}

# Checking we've got all the right instances
$instancesFailed = $false
$errMsg = ""
if ($dbServerInstances.count -ne 1){
    $instancesFailed = $true
    $num = $dbServerInstances.count
    $errMsg = "$errMsg Expected 1 SQL Server instance but have $num instance(s)."
}
if ($webServerInstances.count -ne $numWebServers){
    $instancesFailed = $true
    $num = $webServerInstances.count
    $errMsg = "$errMsg Expected $numWebServers Web Server instance(s) but have $num instance(s)."
}
if ($instancesFailed){
    Write-Error $errMsg
}
else {
    Write-Output "    All instances launched successfully!"
}

Write-Output "      Waiting for instances to start... (This normally takes about 30 seconds.)"

$allRunning = $false
$runningDbServerInstances = @()
$runningWebServerInstances = @()
$sqlIp = ""

While (-not $allRunning){
    $totalRequired = $numWebServers + 1 # Web Servers + SQL Server.
                                        # We'll launch the jumpbox after we know the SQL IP address.

    $runningDbServerInstances = Get-Servers -role $dbServerRole
    $runningWebServerInstances = Get-Servers -role $webServerRole

    $NumRunning = $runningDbServerInstances.count + $runningWebServerInstances.count

    if ($NumRunning -eq ($totalRequired)){
        $allRunning = $true
        $sqlIp = $runningDbServerInstances[0].PublicIpAddress

        $webIps = ""
        ForEach ($instance in $runningWebServerInstances){
            $thisIp = $instance.PublicIpAddress
            if ($webIps -like ""){
                $webIps = "$thisIp" # The first IP address in the list
            }
            else {
                $webIps = "$webIps, $thisIp" # All subsequent IP addresses
            }
        }

        # Logging all the IP addresses
        Write-Output "    SQL Server machine and all web servers are running!"
        Write-Output "      SQL Server: $sqlIp"
        Write-Output "      Web Server(s): $webIps"
        break
    }
    else {
        Write-Output "        $NumRunning out of $totalRequired instances are running."
    }
    Start-Sleep -s 15
}

# Now we know the SQL Server IP, we can launch the jumpbox
if ($deployJump){
    Write-Output "    Launching SQL Jumpbox"
    $jumpServerUserData = Get-UserData -fileName "VM_UserData_DbJumpbox.ps1" -octoUrl $octoUrl -role $dbJumpboxRole -sql_ip $sqlIp
    Build-Servers -role $dbJumpboxRole -encodedUserData $jumpServerUserData
}

# Installing dbatools PowerShell module so that we can ping sql server instance
try {
    Import-Module dbatools
}
catch {
    Write-Output "    Installing dbatools so that we can ping SQL Server..."
    Write-Output "      (This takes a couple of minutes)"
    Install-Module dbatools -Force
}

if ($deployJump){
    # Checking to see if the jumpbox came online
    $dbJumpboxInstances = Get-Servers -role $dbJumpboxRole -includePending
    if ($dbJumpboxInstances.count -ne 1){
        $instancesFailed = $true
        $num = $dbJumpboxInstances.count
        $errMsg = "$errMsg Expected 1 SQL Jumpbox instance but have $num instance(s)."
    }
    $jumpboxRunning = $false
    $runningDbJumpboxInstances = @()
    While (-not $jumpboxRunning){

        $runningDbJumpboxInstances = Get-Servers -role $dbJumpboxRole
        $NumRunning = $runningDbJumpboxInstances.count

        if ($NumRunning -eq 1){
            $jumpboxRunning = $true
            $jumpIp = $runningDbJumpboxInstances[0].PublicIpAddress

            # Logging all the IP addresses
            Write-Output "    SQL Jumpbox is running!"
            Write-Output "      SQL Jumpbox: $jumpIp"
            break
        }
        else {
            Write-Output "      Waiting for SQL Jumpbox to start..."
        }
        Start-Sleep -s 15
    }
}

# Populating our table of VMs
$vms = New-Object System.Data.Datatable
[void]$vms.Columns.Add("ip")
[void]$vms.Columns.Add("role")
[void]$vms.Columns.Add("sql_running")
[void]$vms.Columns.Add("iis_running")
[void]$vms.Columns.Add("tentacle_listening")

$sqlrunning = $null
if ($checkSql){
    $sqlrunning = $false
}

ForEach ($instance in $runningDbServerInstances){
    [void]$vms.Rows.Add($instance.PublicIpAddress,$dbServerRole,$sqlrunning,$null,$null)
}
ForEach ($instance in $runningDbJumpboxInstances){
    [void]$vms.Rows.Add($instance.PublicIpAddress,$dbJumpboxRole,$null,$null,$false)
}
ForEach ($instance in $runningWebServerInstances){
    [void]$vms.Rows.Add($instance.PublicIpAddress,$webServerRole,$null,$false,$false)
}
        
Write-Output "    Waiting for all instances to complete setup..."
Write-Output "      Once an instance is running, setup usually takes roughly:"
Write-Output "        - Jumpbox tentacles: 270-330 seconds"
Write-Output "        - Web server IIS installs: 350-400 seconds"
Write-Output "        - Web server tentacles: 450-500 seconds"
Write-Output "        - SQL Server install: 600-750 seconds"

# Waiting to see if they all come online
$allVmsConfigured = $false
$runningWarningGiven = $false
$octoCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "octopus", $sqlOctoPassword
$sqlDeployed = $false

While (-not $allVmsConfigured){
    # Checking whether anything new has come online    
    ## SQL Server
    $pendingSqlServers = $vms.Select("sql_running like '$false'")
    forEach ($ip in $pendingSqlServers.ip){
        $sqlDeployed = Test-SQL -ip $ip -cred $octoCred
        if ($sqlDeployed){
            Write-Output "      SQL Server is listening at: $ip"
            $thisVm = ($vms.Select("ip = '$ip'"))
            $thisVm[0]["sql_running"] = $true
        }
    }

    ## IIS
    $pendingIisInstalls = $vms.Select("iis_running like '$false'")
    forEach ($ip in $pendingIisInstalls.ip){
        $iisDeployed = Test-IIS -ip $ip
        if ($iisDeployed){
            Write-Output "      IIS is running on web server: $ip"
            $thisVm = ($vms.Select("ip = '$ip'"))
            $thisVm[0]["iis_running"] = $true
        }
    }

    ## Tentacles
    $pendingTentacles = $vms.Select("tentacle_listening like '$false'")
    forEach ($ip in $pendingTentacles.ip){
        $tentacleDeployed = Test-Tentacle -octoUrl $octoUrl -envId $envId -ip $ip -header $octoApiHeader
        if ($tentacleDeployed){
            $thisVm = ($vms.Select("ip = '$ip'"))
            $thisVm[0]["tentacle_listening"] = $true
            $thisVmRole = "Web server"
            if ($thisVm[0]["role"] -like "*jump*"){
                $thisVmRole = "SQL Jumpbox"
            }
            Write-Output "      $thisVmRole tentacle is listening on: $ip"

        }
    }

    # Checking if there is anything left that needs to be configured on any VMs
    $allVmsConfigured = $true
    ForEach ($vm in $vms){
        if ($vm.ItemArray -contains "False"){
            $allVmsConfigured = $false
        }
    }

    # Getting the time
    $time = [Math]::Floor([decimal]($stopwatch.Elapsed.TotalSeconds))

    # Logging the current status
    ## SQL Server
    $currentStatus = "$time seconds |"
    if ($sqlDeployed){
        $currentStatus = "$currentStatus SQL Server: Running  - "
    } 
    else {
        $currentStatus = "$currentStatus SQL Server: Pending  - "
    }
    ## IIS
    $vmsWithIis = ($vms.Select("iis_running = '$true'"))
    $numIisInstalls = $vmsWithIis.count
    $currentStatus = "$currentStatus IIS Installs: $numIisInstalls/$numWebServers  - "
    ## Tentacles
    $vmsWithTentacles = ($vms.Select("tentacle_listening = '$true'"))
    $numTentacles = $vmsWithTentacles.count
    $tentaclesRequired = $numWebServers + 1 
    $currentStatus = "$currentStatus Tentacles deployed: $numTentacles/$tentaclesRequired"
    Write-Output "        $currentStatus"
    
    if ($allVmsConfigured){
        Write-Output "SUCCESS! Environment built successfully."
        break
    }
    if (($time -gt 1200) -and (-not $runningWarningGiven)){
        Write-Warning "EC2 instances are taking an unusually long time to start."
        $runningWarningGiven = $true
    }

    if (($time -gt $timeout)-and (-not $allVmsConfigured)){
        Write-Error "Timed out. Timeout currently set to $timeout seconds. There is a parameter on this script to adjust the default timeout."
    }   
    Start-Sleep -s 10
}