$PSVersion = $PSVersionTable.PSVersion
Write-Host "Testing out some PowerShell ($PSVersion) on MacOS."
Write-Host "Is this MacOS? " -NoNewline
if ($IsMacOS) {
    Write-Host "Yes" -ForegroundColor "Green"
} else {
    Write-Host "No" -ForegroundColor "Red"
}