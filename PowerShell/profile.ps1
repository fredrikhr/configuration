Get-ChildItem -File -Path (Join-Path $PSScriptRoot "ps1.d") | ForEach-Object {
    $ps1d = $_.FullName
    . $ps1d
}
