foreach ($ps1d in Get-ChildItem -File -Path (Join-Path (Join-Path $profile "..") "ps1.d")) {
    Write-Verbose $ps1d
    . $ps1d.FullName
}