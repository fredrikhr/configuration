if (Get-Command "gh" -ErrorAction SilentlyContinue) {
    & ([scriptblock]::Create((& "gh" completion -s powershell | Out-String)))
}
