# Get current PowerShell version
$PSVersion = $PSVersionTable.PSVersion

# Output something
Write-Host "Testing out some PowerShell ($PSVersion) on MacOS."
Write-Host "Is this MacOS? " -NoNewline

# Am I running on MacOS? y/n
if ($IsMacOS) {
    Write-Host "Yes" -ForegroundColor "Green"
} else {
    Write-Host "No" -ForegroundColor "Red"
}