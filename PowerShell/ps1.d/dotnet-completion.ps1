$shimFilePath = Join-Path $PSScriptRoot "dotnet-completion-script.ps1"
if (Test-Path $shimFilePath -NewerThan ([datetime]::Today.Subtract([timespan]::FromDays(7)))) {
    return
}

if (Get-Command "dotnet-suggest" -ErrorAction SilentlyContinue) {
    & ([scriptblock]::Create((& dotnet-suggest script PowerShell | Tee-Object -FilePath $shimFilePath)))
}
