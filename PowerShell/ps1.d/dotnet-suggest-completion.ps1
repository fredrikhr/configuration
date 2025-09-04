$shimFilePath = Join-Path $PSScriptRoot "dotnet-suggest-completion-script.ps1"
if (Test-Path $shimFilePath -NewerThan ([datetime]::Today.Subtract([timespan]::FromDays(7)))) {
    return
}

if (Get-Command "dotnet-suggest" -ErrorAction SilentlyContinue) {
    & dotnet-suggest script PowerShell | Out-File -Force -LiteralPath $shimFilePath
    . $shimFilePath
}
