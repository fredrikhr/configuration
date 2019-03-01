function prompt {
    [string]::Join([System.Environment]::NewLine,
        "PS $($ExecutionContext.SessionState.Path.CurrentLocation)",
        "$('>' * ($nestedPromptLevel + 1)) "
    )
}

$Script:DOTNET_SUGGEST_COMMAND = Get-Command -CommandType Application "dotnet-suggest" -ErrorAction SilentlyContinue
if (-not $Script:DOTNET_SUGGEST_COMMAND) {
    $Script:DotnetCommand = Get-Command -CommandType Application "dotnet" | Select-Object -First 1
    if ($Script:DotnetCommand) {
        Write-Host "Installing global tool `"dotnet-suggest`"."
        Write-Verbose "Command: $Script:DotnetCommand tool install dotnet-suggest -g --add-source https://dotnet.myget.org/F/system-commandline/api/v3/index.json --version 1.*"
        & $Script:DotnetCommand tool install dotnet-suggest -g --add-source https://dotnet.myget.org/F/system-commandline/api/v3/index.json --version 1.*
    }
}
[uri]$Script:DOTNET_SUGGEST_SCRIPT_URL = "https://github.com/dotnet/command-line-api/raw/master/src/System.CommandLine.Suggest/dotnet-suggest-shim.ps1"
[string]$Script:DOTNET_SUGGEST_SCRIPT_FILENAME = ($Script:DOTNET_SUGGEST_SCRIPT_URL.Segments | Select-Object -Last 1)
$Script:DOTNET_SUGGEST_SCRIPT_PATH = Join-Path $PSScriptRoot $Script:DOTNET_SUGGEST_SCRIPT_FILENAME
if (-not (Test-Path -PathType Leaf $Script:DOTNET_SUGGEST_SCRIPT_PATH)) {
    [System.Net.ServicePointManager]::SecurityProtocol = `
        [System.Net.ServicePointManager]::SecurityProtocol -bor `
        [System.Net.SecurityProtocolType]::Tls12
    Write-Host "Downloading $Script:DOTNET_SUGGEST_SCRIPT_FILENAME"
    Invoke-WebRequest -Uri $Script:DOTNET_SUGGEST_SCRIPT_URL -OutFile $Script:DOTNET_SUGGEST_SCRIPT_PATH
}
if (Test-Path -PathType Leaf $Script:DOTNET_SUGGEST_SCRIPT_PATH) {
    . $Script:DOTNET_SUGGEST_SCRIPT_PATH
}
