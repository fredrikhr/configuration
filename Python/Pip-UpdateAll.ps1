[CmdletBinding(SupportsShouldProcess = $true)]
param (
    # The python versions to invoke
    [Parameter()]
    [string[]]
    $PythonVersions = @("2", "3"),
    # Whether to skip upgrading pip befire proceeding
    [Parameter()]
    [switch]
    $SkipUpgradePip,
    # Whether to use the user local site, or the system-wide site for installing
    # Installing into the system-wide site may require administraive privileges.
    [Parameter()]
    [switch]
    $UserSite,
    # Packages to exclude from upgrade
    [Parameter()]
    [string[]]
    $Exclude
)

$ErrorActionPreference = 'Stop'
if (-not $Exclude) {
    [string[]]$Exclude = @()
}
[System.Collections.Generic.HashSet[string]]$ExcludeSet = [System.Collections.Generic.HashSet[string]]::new($Exclude)

function Get-PythonCommandArguments {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [string]
        $Version = ""
    )

    begin {
        [System.PlatformID]$Platform = [System.Environment]::OSVersion.Platform
        [System.PlatformID[]]$WindowsPlatforms = @(
            [System.PlatformID]::Win32NT,
            [System.PlatformID]::Win32S,
            [System.PlatformID]::Win32Windows,
            [System.PlatformID]::WinCE,
            [System.PlatformID]::Xbox
        )
    }

    process {
        if ($Platform -in $WindowsPlatforms) {
            $PyLauncherCommand = Get-Command "py" -CommandType Application `
            | Select-Object -First 1
            if ($PyLauncherCommand) {
                if ([string]::IsNullOrWhiteSpace($Version)) {
                    return @($PyLauncherCommand)
                }
                return @($PyLauncherCommand, "-$Version")
            }
            else {
                $excpt = New-Object System.IO.FileNotFoundException `
                    -ArgumentList @($null, "py")
                $PSCmdlet.WriteWarning($excpt.Message)
            }
        }

        $PythonCommand = Get-Command "python$Version" -CommandType Application `
        | Select-Object -First 1
        if (-not $PythonCommand) {
            $excpt = New-Object System.IO.FileNotFoundException `
                -ArgumentList @($null, "python$Version")
            throw $excpt
        }

        return @($PythonCommand)
    }
}

$pipArgs = @("-m", "pip")
foreach ($pyver in $PythonVersions) {
    [object[]]$pyarray = Get-PythonCommandArguments $pyver
    $pycmd = $pyarray[0]
    [string[]]$pyargs = $pyarray | Select-Object -Skip 1
    $pipTarget = $pyarray + $pipArgs

    if (-not $SkipUpgradePip) {
        $packages = @("pip", "setuptools", "wheel")
        $pipCmdArgs = @("install", "--upgrade")
        if ($UserSite) {
            $pipCmdArgs += "--user"
        }
        $pipCmdArgs += $packages

        if ($PSCmdlet.ShouldProcess($pipTarget, $pipCmdArgs)) {
            & $pycmd $pyargs $pipArgs $pipCmdArgs
            [System.Console]::ResetColor()
            if ($LASTEXITCODE -ne 0) {
                break
            }
        }
    }

    $pipCmdArgs = @("list", "--outdated", "--format=freeze")
    $PSCmdlet.WriteVerbose("Performing the operation `"$pipCmdArgs`" on target `"$pipTarget`".")
    $pipFreeze = & $pycmd $pyargs $pipArgs $pipCmdArgs
    [System.Console]::ResetColor()
    if ($LASTEXITCODE -ne 0) {
        break
    }
    $packages = $pipFreeze | ForEach-Object { $_.Split("==", 2)[0] }
    $pipFreeze | Select-Object -Property @{ Name = "Package"; Expression = { $_.Split("==", 2)[0] } },`
    @{ Name = "Version"; Expression = { $_.Split("==", 2)[1] } },`
    @{ Name = "Excluded"; Expression = { $ExcludeSet.Contains($_.Split("==", 2)[0]) } } | Format-Table
    if (-not $packages) {
        $PSCmdlet.WriteVerbose("No packages to upgrade")
        continue
    }
    [System.Collections.Generic.HashSet[string]]$packagesSet = [System.Collections.Generic.HashSet[string]]::new($packages)
    $packagesSet.ExceptWith($ExcludeSet)

    $pipCmdArgs = @("install", "--upgrade")
    if ($UserSite) {
        $pipCmdArgs += "--user"
    }
    $pipCmdArgs += $packagesSet

    if ($PSCmdlet.ShouldProcess($pipTarget, $pipCmdArgs)) {
        & $pycmd $pyargs $pipArgs $pipCmdArgs
        [System.Console]::ResetColor()
        if ($LASTEXITCODE -ne 0) {
            break
        }
    }
}
