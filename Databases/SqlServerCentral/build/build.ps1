param
(
      [string]$packageVersion = '0.3',
      [string]$packageID = 'SqlServerCentral',
      [string]$packagePath = 'C:\packages',
      [string]$testPath = 'C:\testResults',
      [string]$targetServerInstance = 'EC2AMAZ-HDUULL0',
      [string]$targetDatabase  = 'SqlServerCentral_Integration'
)

$errorActionPreference = "stop"

Import-Module SqlChangeAutomation -ErrorAction silentlycontinue -ErrorVariable +ImportErrors

"***** PARAMETERS *****
packageVersion is $packageVersion
packageID is $packageID
packagePath is $packagePath
testPath is $testPath
**********************" | write-output

# Searching in the parent directory for a state folder
$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptsFolder = Join-Path -Path $myDir -ChildPath '..\state'
$scriptsFolder
if (-not (Test-Path -PathType Container $scriptsFolder))
{
      Write-error "$scriptsFolder could not be found"
}

#Using Redgate SCA to validate the code in the state directory
try
{
      $validatedScriptsFolder = Invoke-DatabaseBuild $scriptsFolder -TemporaryDatabaseServer "Data Source=$targetServerInstance" #-SQLCompareOptions 'NoTransactions'
}
catch #
{
      $_.Exception.Message
      "$($Database.Name;) couldn't be validated because $($_.Exception.Message)" | Foreach{
            write-error $_
      }
}

# Export NuGet package
 $databasePackage = New-DatabaseBuildArtifact $validatedScriptsFolder -PackageId $packageID -PackageVersion $packageVersion
 Export-DatabaseBuildArtifact $databasePackage -Path $packagePath

# Run tests
 $testResultsFile = "$testPath\$packageID.junit.$packageVersion.xml"
 $results = Invoke-DatabaseTests $databasePackage
 Export-DatabaseTestResults $results -OutputFile $testResultsFile

# Sync a test database
 $targetDB = New-DatabaseConnection -ServerInstance $targetServerInstance -Database $targetDatabase
 Test-DatabaseConnection $targetDB
 Sync-DatabaseSchema -Source $databasePackage -Target $targetDB
