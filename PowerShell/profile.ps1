Get-ChildItem -File -Path (Join-Path (Join-Path $profile "..") "ps1.d") | ForEach-Object {
    $ps1d = $_.FullName
    . $ps1d
}
