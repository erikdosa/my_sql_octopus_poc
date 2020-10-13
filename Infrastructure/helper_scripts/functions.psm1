
# Helper function to read and encoding the VM startup scripts
Function Get-UserData {
    param (
        $fileName,
        $octoUrl,
        $role,
        $sql_ip = "unknown"
    )
    
    # retrieving raw source code
    $userDataPath = "$PSScriptRoot\$filename"
    if (-not (Test-Path $userDataPath)){
        Write-Error "No UserData (VM startup script) found at $userDataPath!"
    }
    $userData = Get-Content -Path $userDataPath -Raw
    
    # replacing placeholder text
    $userData = $userData.replace("__OCTOPUSURL__",$octoUrl)
    $userData = $userData.replace("__ENV__",$tagValue)
    $userData = $userData.replace("__ROLE__",$role)
    $userData = $userData.replace("__SQLSERVERIP__",$sql_ip)

    # Base 64 encoding the userdata file (required by EC2)
    $encodedDbUserData = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($userData))

    # returning encoded userdata
    return $encodedDbUserData
}

# Helper function to get all the existing servers of a particular role
Function Get-Servers {
    param (
        $role,
        $value = $tagValue,
        [switch]$includePending
    )
    $acceptableStates = "running"
    if($includePending){
        $acceptableStates = @("pending", "running")
    }
    $instances = (Get-EC2Instance -Filter @{Name="tag:$role";Values=$value}, @{Name="instance-state-name";Values=$acceptableStates}).Instances 
    return $instances
}

# Helper function to build any servers that don't already exist
Function Build-Servers {
    param (
        $role,
        $value = $tagValue,
        $encodedUserData,
        $required = 1
    )
    $existingServers = Get-Servers -role $role -value $value -includePending
    $required = $required - $existingServers.count
    if ($required -gt 0){
        $NewInstance = New-EC2Instance -ImageId $ami -MinCount $required -MaxCount $required -InstanceType $instanceType -UserData $encodedUserData -KeyName RandomQuotes_SQL -SecurityGroup RandomQuotes_SQL -IamInstanceProfile_Name RandomQuotes_SQL
        # Tagging all the instances
        ForEach ($InstanceID  in ($NewInstance.Instances).InstanceId){
            New-EC2Tag -Resources $( $InstanceID ) -Tags @(
                @{ Key=$role; Value=$value}
            );
        }
    }    
}

# Helper function to remove an Octopus Tentacle with a given IP address 
function Remove-OctopusMachine {
    param (
        $octoUrl,
        $ip,
        $octoApiHeader
    )
    $allMachines = ((Invoke-WebRequest ($octoUrl + "/api/machines") -Headers $octoApiHeader -UseBasicParsing).content | ConvertFrom-Json).items
    $targetMachine = $allMachines | Where-Object {$_.Uri -like "*$ip*"}
    $id = $targetMachine.Id
    try {
        Invoke-RestMethod -Uri "$octoUrl/api/machines/$id" -Headers $octoApiHeader -Method Delete
        return "          Removed Octopus Machine $id with IP $ip"
    }
    catch {
        return "          No Octopus Machine found with IP $ip"
    }    
}

# Helper functions to ping the instances
function Test-SQL {
    param (
        $ip,
        $cred
    )
    try { 
        Invoke-DbaQuery -SqlInstance $ip -Query 'SELECT @@version' -SqlCredential $cred -EnableException -QueryTimeout 1
    }
    catch {
        return $false
    }
    return $true
}

function Test-IIS {
    param (
        $ip
    )
    try { 
        $content = Invoke-WebRequest -Uri $ip -TimeoutSec 1 -UseBasicParsing
    }
    catch {
        return $false
    }
    if ($content.toString() -like "*iisstart.png*"){
    return $true
    }
}

function Test-Tentacle {
    param (
        $octoUrl,
        $envId,
        $ip,
        $header
    )
    $uri = "https://" + $ip + ":10933/"
    $environmentMachines = "/api/Spaces-1/environments/$envId/machines"
    $machines = ((Invoke-WebRequest ($octoUrl + $environmentMachines) -Headers $header -UseBasicParsing).content | ConvertFrom-Json).items
    $uriList = @()
    $uriList += $machines.Uri 
    if ($uriList -contains $uri){
        return $true
    }
    else {
        return $false
    }
}

# Helper functions to create and compare current and required inventories of servers 
function Get-CurrentInfraTotals {
    param (
        $environment,
        $rolePrefix
    )
    $sqlVms = Get-Servers -role "$rolePrefix-DbServer" -value $environment -$includePending
    $jumpVms = Get-Servers -role "$rolePrefix-DbJumpbox" -value $environment -$includePending
    $webVms = Get-Servers -role "$rolePrefix-WebServer" -value $environment -$includePending

    $CurrentInfra = @{ sqlVms = $sqlVms.count; jumpVms = $jumpVms.count; webVms = $webVms.count}

    return $CurrentInfra
}

function Get-ExistingInfraTotals {
    param (
        $environment,
        $rolePrefix
    )
    $sqlVms = Get-Servers -role "$rolePrefix-DbServer" -value $environment -$includePending
    $jumpVms = Get-Servers -role "$rolePrefix-DbJumpbox" -value $environment -$includePending
    $webVms = Get-Servers -role "$rolePrefix-WebServer" -value $environment -$includePending

    $CurrentInfra = @{ sqlVms = $sqlVms.count; jumpVms = $jumpVms.count; webVms = $webVms.count}

    return $CurrentInfra
}

function Get-RequiredInfraTotals {
    param (
        $numWebServers
    )
    $sqlVms = 1
    $jumpVms = 1
    $webVms = $numWebServers

    $CurrentInfra = @{ sqlVms = $sqlVms; jumpVms = $jumpVms; webVms = $webVms}

    return $CurrentInfra
}

function Write-InfraInventory {
    param (
        $vmHash
    )
    $returnString = ""
    try {
        $returnString = "SQL Server VMs: " + $vmHash.sqlVms + ", SQL Jumpbox VMs: " + $vmHash.jumpVms + ", Web Server VMs: " + $vmHash.webVms
        return $returnString
    }
    catch {
        Write-Error "VM hash not in the write format. Try using either the Get-CurrentInfraTotals or Get-RequiredInfraTotals cmdlets to create it."
    }
}