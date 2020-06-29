& {
    if (Get-Command "dotnet" -ErrorAction SilentlyContinue) {
        & "dotnet" complete | Out-Null
        if ($LASTEXITCODE -eq 0) {
            $local:scriptblock = {
                param($wordToComplete, $commandAst, $cursorPosition)
                dotnet complete --position $cursorPosition $commandAst.ToString() | ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                }
            }
            Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock $local:scriptblock
        } else {
            $LASTEXITCODE = 0
        }
    }
}

& {
    if (Get-Command "dotnet-suggest" -ErrorAction SilentlyContinue) {
        & ([scriptblock]::Create((& "dotnet-suggest" script PowerShell | Out-String)))
    }
}
