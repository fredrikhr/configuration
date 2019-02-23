#!/usr/bin/pwsh
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$PersonalAccessToken,
    [ValidateNotNullOrEmpty()]
    [string]$Username = "couven92",
    [ValidateNotNull()]
    [uri]$Repository = "https://github.com/thnetii/dotnet-common.git"
)

# Include LoggingCommandFunctions.ps1
$AzureDevOpsPipelinesPath = Join-Path -Resolve $PSScriptRoot ([string]::Join([System.IO.Path]::DirectorySeparatorChar.ToString(), "..", "..", "Azure-DevOps-Pipelines"))
. (Join-Path $AzureDevOpsPipelinesPath "LoggingCommandFunctions.ps1")

$GitCommand = Get-Command -CommandType Application "git" | Select-Object -First 1
Write-Host (Write-TaskDebug -AsOutput -Message "Located git command: $GitCommand")

[uri]$BuildRepositoryUri = $ENV:BUILD_REPOSITORY_URI
if (-not $BuildRepositoryUri) {
    [string[]]$BuildRepositoryUriLines = & $GitCommand remote get-url origin
    [uri]$BuildRepositoryUri = $BuildRepositoryUriLines | Select-Object -First 1
}
$BuildSourceVersion = $ENV:BUILD_SOURCEVERSION
if (-not $BuildSourceVersion) {
    [string[]]$BuildSourceVersionLines = & $GitCommand rev-parse HEAD
    $BuildSourceVersion = $BuildSourceVersionLines | Select-Object -First 1
}
$BuildRepositorySegments = $BuildRepositoryUri.Segments | Select-Object -Last 2
$BuildRepositoryOwner = $BuildRepositorySegments[0].TrimEnd('/')
$BuildRepositoryName = [System.IO.Path]::GetFileNameWithoutExtension($BuildRepositorySegments[1])

$BuildRequestedForName = $ENV:BUILD_REQUESTEDFOR
if (-not $BuildRequestedForName) {
    [string]$BuildRequestedForName = & $GitCommand log -1 --pretty=format:'%an'
}
$BuildRequestedForEmail = $ENV:BUILD_REQUESTEDFOREMAIL
if (-not $BuildRequestedForName) {
    [string]$BuildRequestedForEmail = & $GitCommand log -1 --pretty=format:'%ae'
}
$RepositorySegments = $Repository.Segments | Select-Object -Last 2
$RepositoryOwner = $RepositorySegments[0].TrimEnd('/')
$RepositoryName = [System.IO.Path]::GetFileNameWithoutExtension($RepositorySegments[1])

[System.Net.ServicePointManager]::SecurityProtocol = `
    [System.Net.ServicePointManager]::SecurityProtocol -bor `
    [System.Net.SecurityProtocolType]::Tls12
$GitHubGraphQLHeaders = @{
    Authorization = "Bearer $PersonalAccessToken"
}
Write-Host (Write-TaskDebug -AsOutput -Message "Retrieving repository and user information (including previously opened Pull Requests to close)")
$BuildCommitQuery = @{
    query = "query(
  `$sourceOwner: String!
  `$sourceRepository: String!
  `$sourceCommit: String!
  `$targetOwner: String!
  `$targetRepository: String!
  `$username: String!
) {
  sourceRepository: repository(owner: `$sourceOwner, name: `$sourceRepository) {
    url
    object(expression: `$sourceCommit) {
      commitUrl
    }
  }
  targetRepository: repository(owner: `$targetOwner, name: `$targetRepository) {
    id
    refs(refPrefix: `"refs/heads/dev.azure.com/`", first: 100) {
      nodes {
        name
        associatedPullRequests(states: OPEN, first: 100) {
          nodes {
            id
            number
            url
          }
        }
      }
    }
  }
  user(login: `$username) {
    id
  }
}"
    variables = @{
        sourceOwner = $BuildRepositoryOwner
        sourceRepository = $BuildRepositoryName
        sourceCommit = $BuildSourceVersion
        targetOwner = $RepositoryOwner
        targetRepository = $RepositoryName
        username = $Username
    }
} | ConvertTo-Json -Compress
$GitHubCommitResponse = Invoke-RestMethod -Body $BuildCommitQuery `
    -Method Post -Uri "https://api.github.com/graphql" `
    -Headers $GitHubGraphQLHeaders -SessionVariable HttpWebSession `
    -Verbose -ContentType "application/json"
if ($GitHubCommitResponse.errors) {
    throw $GitHubCommitResponse.errors
}
$BuildRepositoryProjectUrl = $GitHubCommitResponse.data.sourceRepository.url
$BuildSourceCommitUrl = $GitHubCommitResponse.data.sourceRepository.object.commitUrl
$RepositoryId = $GitHubCommitResponse.data.targetRepository.id
$GitHubUserId = $GitHubCommitResponse.data.user.id

Write-Host (Write-TaskDebug -AsOutput -Message "Cloning repository $Repository")
$ClonePath = Join-Path $PSScriptRoot ([System.Guid]::NewGuid())
$CloneUriBuilder = New-Object System.UriBuilder @($Repository)
$CloneUriBuilder.UserName = $Username
$CloneUriBuilder.Password = $PersonalAccessToken
$CloneUri = $CloneUriBuilder.Uri
& $GitCommand clone --depth 1 $CloneUri -- $ClonePath
if ($LASTEXITCODE -ne 0) {
    throw "Clone failed"
}
Push-Location $ClonePath
[string[]]$BaseBranchNameLines = & $GitCommand rev-parse --abbrev-ref HEAD
$BaseBranchName = $BaseBranchNameLines | Select-Object -First 1

Write-Host (Write-TaskDebug -AsOutput -Message "Configuring git user")
& $GitCommand config --local user.name "$BuildRequestedForName"
& $GitCommand config --local user.email "$BuildRequestedForEmail"

$AgentId = $ENV:AGENT_ID
if (-not $AgentId) {
    $AgentId = [System.Guid]::NewGuid().ToString()
}
$BuildId = $ENV:BUILD_BUILDID
if (-not $BuildId) {
    $BuildId = [System.Guid]::NewGuid().ToString()
}
$BranchName = "dev.azure.com/agent-$AgentId-build-$BuildId"

Write-Host (Write-TaskDebug -AsOutput -Message "Checking out new local branch $BranchName")
& $GitCommand checkout -b $BranchName $BaseBranchName

Write-Host (Write-TaskDebug -AsOutput -Message "Copying files from source to local branch")
$SyncFilesRoot = Get-Content (Join-Path $PSScriptRoot "sync-files.json") | ConvertFrom-Json
$SyncFilesList = $SyncFilesRoot.files
$SourceRootPath = Join-Path -Resolve $PSScriptRoot "../.."
foreach ($SyncFileItem in $SyncFilesList) {
    $SourceFileFilter = $SyncFileItem.source
    [System.IO.FileSystemInfo[]]$SourceFileInfos = Get-ChildItem $SourceRootPath -Force -Filter $SourceFileFilter
    $DestinationPath = $SyncFileItem.destinationFolder
    Write-Host (Write-TaskDebug -AsOutput -Message ("Copying files from source to local branch:" + [System.Environment]::NewLine + "`t" + [string]::Join([System.Environment]::NewLine + "`t", $SourceFileInfos) + [System.Environment]::NewLine + "Destination: $DestinationPath"))
    if (-not (Test-Path $DestinationPath -PathType Container)) {
        New-Item -ItemType Directory $DestinationPath -Force -Verbose | Out-Null
    }
    if ($SourceFileInfos.Length -gt 1 -or -not $SyncFileItem.filename) {
        $SourceFileInfos | Copy-Item -Destination $DestinationPath -Force -Verbose
    } else {
        $DestinationPath = Join-Path $DestinationPath $SyncFileItem.filename
        $SourceFileInfos | Copy-Item -Destination $DestinationPath -Force -Verbose
    }
}

Write-Host (Write-TaskDebug -AsOutput -Message "Staging all changes")
& $GitCommand add .
& $GitCommand status
Write-Host (Write-TaskDebug -AsOutput -Message "Creating new commit")
$CommitMessage = "Synced files from commit $BuildSourceCommitUrl"
& $GitCommand commit --allow-empty -m "$CommitMessage"
if ($LASTEXITCODE -ne 0) {
    throw "Commit failed"
}
Write-Host (Write-TaskDebug -AsOutput -Message "Pushing commit to remote")
& $GitCommand push --force $CloneUri "HEAD:$BranchName"
if ($LASTEXITCODE -ne 0) {
    throw "Push failed"
}

$ClientMutationId = [System.Guid]::NewGuid().ToString()
Write-Host (Write-TaskDebug -AsOutput -Message "Creating Pull Request")
$PullRequestMutation = @{
    query = "mutation(`$repositoryId: ID!, `$branch: String!, `$target: String!, `$title: String!, `$body: String, `$clientMutationId: String) {
  createPullRequest(
    input: {
      repositoryId: `$repositoryId
      baseRefName: `$target
      headRefName: `$branch
      title: `$title
      body: `$body
      clientMutationId: `$clientMutationId
    }
  ) {
    pullRequest {
      id
      number
      url
      changedFiles
    }
    clientMutationId
  }
}"
    variables = @{
        repositoryId = $RepositoryId
        branch = $BranchName
        target = $BaseBranchName
        title = "Sync files from $BuildRepositoryProjectUrl"
        body = $CommitMessage
        clientMutationId = $ClientMutationId
    }
} | ConvertTo-Json -Compress
$GitHubGraphQLHeaders["Accept"] = "application/vnd.github.ocelot-preview+json"
$PullRequestResponse = Invoke-RestMethod `
    -Method Post -Uri "https://api.github.com/graphql" -Body $PullRequestMutation `
    -Headers $GitHubGraphQLHeaders -WebSession $HttpWebSession `
    -Verbose -ContentType "application/json"
if ($PullRequestResponse.errors) {
    throw $PullRequestResponse.errors
}
$PullRequestId = $PullRequestResponse.data.createPullRequest.pullRequest.id
$PullRequestNumber = $PullRequestResponse.data.createPullRequest.pullRequest.number
$PullRequestUrl = $PullRequestResponse.data.createPullRequest.pullRequest.url
[int]$PullRequestChanges = $PullRequestResponse.data.createPullRequest.pullRequest.changedFiles
$ClientMutationId = $PullRequestResponse.data.createPullRequest.clientMutationId
Write-Host "Created Pull Request #$PullRequestNumber in $Repository at $PullRequestUrl"
Write-Host (Write-TaskDebug -AsOutput -Message "Assigning Pull Request to $Username")
$GitHubGraphQLHeaders["Accept"] = "application/vnd.github.starfire-preview+json"
$PullRequestMutation = @{
    query = "mutation(`$pullRequestId: ID!, `$userId: ID!, `$clientMutationId: String) {
  addAssigneesToAssignable(
    input: {
      assignableId: `$pullRequestId
      assigneeIds: [`$userId]
      clientMutationId: `$clientMutationId
    }
  ) {
    clientMutationId
  }
}"
    variables = @{
        pullRequestId = $PullRequestId
        userId = $GitHubUserId
        clientMutationId = $ClientMutationId
    }
} | ConvertTo-Json -Compress
$PullRequestResponse = Invoke-RestMethod `
    -Method Post -Uri "https://api.github.com/graphql" -Body $PullRequestMutation `
    -Headers $GitHubGraphQLHeaders -WebSession $HttpWebSession `
    -Verbose -ContentType "application/json"
if ($PullRequestResponse.errors) {
    throw $PullRequestResponse.errors
}
$ClientMutationId = $PullRequestResponse.data.addAssigneesToAssignable.clientMutationId

[System.Collections.Generic.List[string]]$PreviousBranches = [System.Collections.Generic.List[string]]::new()
[System.Collections.ArrayList]$PreviousPullRequests = New-Object System.Collections.ArrayList
foreach ($RepositoryRef in $GitHubCommitResponse.data.targetRepository.refs.nodes) {
    $PreviousBranches.Add("dev.azure.com/" + $RepositoryRef.name) | Out-Null
    foreach ($RepositoryOldPullRequest in $RepositoryRef.associatedPullRequests.nodes) {
        $PreviousPullRequests.Add($RepositoryOldPullRequest) | Out-Null
    }
}

[bool]$NeedClosePullRequests = $false
[System.Text.StringBuilder]$QueryBuilder = New-Object System.Text.StringBuilder
$QueryBuilder.AppendLine("mutation(`$clientMutationId: String) {") | Out-Null
if ($PullRequestChanges -lt 1) {
    Write-Host "Closing newly created Pull Request because of unaffected changes"
    $PreviousBranches.Add($BranchName) | Out-Null
    $QueryBuilder.AppendLine("  pr0: closePullRequest(
    input: {
      pullRequestId: `"$($PullRequestId)`"
      clientMutationId: `$clientMutationId
    }
  ) {
    clientMutationId
  }") | Out-Null
    $NeedClosePullRequests = $true
}
$PreviousPullRequestIdx = 1
foreach ($PullRequest in $PreviousPullRequests) {
    Write-Host (Write-TaskDebug -AsOutput -Message "Closing previous Pull Request #$($PullRequest.number) ($($PullRequest.url))")

    $PullRequestName = "pr$($PreviousPullRequestIdx.ToString([System.Globalization.CultureInfo]::InvariantCulture))"
    $QueryBuilder.AppendLine("  $($PullRequestName): closePullRequest(
    input: {
      pullRequestId: `"$($PullRequest.id)`"
      clientMutationId: `$clientMutationId
    }
  ) {
    clientMutationId
  }") | Out-Null

    $NeedClosePullRequests = $true
    $PreviousPullRequestIdx++
}
$QueryBuilder.AppendLine("}") | Out-Null
if ($NeedClosePullRequests) {
    $ClosePullRequestPayload = @{
        query = $QueryBuilder.ToString()
        variables = @{ clientMutationId = $ClientMutationId }
    } | ConvertTo-Json -Compress
    $GitHubGraphQLHeaders["Accept"] = "application/vnd.github.ocelot-preview+json"
    $ClosePullRequestResponse = Invoke-RestMethod `
        -Method Post -Uri "https://api.github.com/graphql" -Body $ClosePullRequestPayload `
        -Headers $GitHubGraphQLHeaders -WebSession $HttpWebSession `
        -Verbose -ContentType "application/json"
    if ($ClosePullRequestResponse.errors) {
        throw $ClosePullRequestResponse.errors
    }
}

foreach ($ObsoleteBranchName in $PreviousBranches) {
    Write-Host "Deleting remote branch $ObsoleteBranchName"
    & $GitCommand push $CloneUri ":$ObsoleteBranchName"
}

Pop-Location
Remove-Item $ClonePath -Force -Recurse
