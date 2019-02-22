#!/usr/bin/pwsh
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$PersonalAccessToken,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Username,
    [Parameter(Mandatory = $true)]
    [uri]$Repository
)

# Include LoggingCommandFunctions.ps1
$AzureDevOpsPipelinesPath = Join-Path -Resolve $PSScriptRoot ([string]::Join([System.IO.Path]::DirectorySeparatorChar.ToString(), "..", "..", "Azure-DevOps-Pipelines"))
. (Join-Path $AzureDevOpsPipelinesPath "LoggingCommandFunctions.ps1")

$GitCommand = Get-Command -CommandType Application "git" | Select-Object -First 1
Write-Host (Write-TaskDebug -AsOutput -Message "Located git command: $GitCommand")

$ClonePath = Join-Path $PSScriptRoot ([System.Guid]::NewGuid())
$CloneUriBuilder = New-Object System.UriBuilder @($Repository)
$CloneUriBuilder.UserName = $Username
$CloneUriBuilder.Password = $PersonalAccessToken
$CloneUri = $CloneUriBuilder.Uri
Write-Host (Write-SetProgress -AsOutput -Percent 0 -CurrenOperation "Cloning repository $Repository")
& $GitCommand clone --depth 1 $CloneUri -- $ClonePath
Push-Location $ClonePath

$BranchName = "dev.azure.com/"
$BuildId = $ENV:BUILD_ID
$AgentId = $ENV:AGENT_ID
if ($AgentId) {
    $BranchName += "agent-$AgentId"
} else {
    $BranchName += "agent-$([System.Guid]::NewGuid())"
}
if ($BuildId) {
    $BranchName += "-build-$BuildId"
} else {
    $BranchName += "-build-$([System.Guid]::NewGuid())"
}

Write-Host (Write-SetProgress -AsOutput -Percent 0 -CurrenOperation "Checking out new local branch $BranchName")
& $GitCommand checkout -b $BranchName origin/master

