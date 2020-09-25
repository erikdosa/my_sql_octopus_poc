try {
    Remove-IAMRoleFromInstanceProfile -InstanceProfileName RandomQuotes_SQL -RoleName SecretsManager -Force
    Write-Output "Existing SecretsManager role removed from profile RandomQuotes_SQL."
}
catch {
    Write-Output "SecretsManager role is not already added to profile RandomQuotes_SQL"
}
try {
    Remove-IAMInstanceProfile -InstanceProfileName RandomQuotes_SQL -Force
    Write-Output "Removed existing profile RandomQuotes_SQL."
}
catch {
    Write-Output "Profile RandomQuotes_SQL does not already exist."
}

Write-Output "Creating new profile: RandomQuotes_SQL"
New-IAMInstanceProfile -InstanceProfileName RandomQuotes_SQL

Write-Output "Adding SecretsManager role to profile RandomQuotes_SQL."
Add-IAMRoleToInstanceProfile -InstanceProfileName RandomQuotes_SQL -RoleName SecretsManager
