$ghCompletionFilePath = Join-Path $PSScriptRoot "github-completion-script.ps1"
if (Test-Path $ghCompletionFilePath -NewerThan ([datetime]::Today.Subtract([timespan]::FromDays(7)))) {
    return
}

if (Get-Command "gh" -ErrorAction SilentlyContinue) {
    & ([scriptblock]::Create((& "gh" completion -s powershell | Tee-Object -FilePath $ghCompletionFilePath | Out-String)))
}
