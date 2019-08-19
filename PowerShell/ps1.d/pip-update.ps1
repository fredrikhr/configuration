#! /usr/bin/pwsh

# Update script for pip. Automatically updates all pip installed packages

function Update-PipPackages {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(ValueFromPipeline=$true)]
        [PSObject[]]$PythonCommand,
        [string[]]$ExcludePackages,
        [switch]$UserInstall=$false,
        [switch]$UpdatePip=$false
    )

    if (-not $PythonCommand) {
        $PythonResolvedCommand = Get-Command -CommandType Application python
        if (-not $PythonResolvedCommand) {
            Write-Error "No python command found."
            return
        }
        $PythonCommand = $PythonResolvedCommand
    }

    $PipInstallArgs = @("-m", "pip", "install", "-U")
    if ($UserInstall) {
        $PipInstallArgs += "--user"
    }
    foreach ($PyCmd in $PythonCommand) {
        if ($PyCmd.PSobject.Properties.Name -contains "Path") {
            $PyPath = $PyCmd.Path
        } else {
            $PyPath = "$PyCmd"
        }
        if ($UpdatePip) {
            if ($PSCmdlet.ShouldProcess("$PyPath -m pip", "Update pip before determining outdated packages?", "$PyPath $PipInstallArgs pip")) {
                $PSCmdlet.WriteVerbose("$PyPath $PipInstallArgs pip")
                & $PyPath $PipInstallArgs pip
                if ($LASTEXITCODE) {
                    $PSCmdlet.WriteError("Command invocation `"$PyPath -m pip`" returned with exit code $LASTEXITCODE")
                    return
                }
            }
        }
        $PSCmdlet.WriteVerbose("$PyPath -m pip list --outdated")
        [string[]]$PipPackages = (& $PyPath -m pip list --outdated --format=freeze | ForEach-Object { $_.Split("=", 2) | Select-Object -First 1 } | Where-Object { $_ -inotin $ExcludePackages })
        $PSCmdlet.WriteError("Command invocation `"$PyPath -m pip`" returned with exit code $LASTEXITCODE")
        return
        if ($PipPackages) {
            if ($PSCmdlet.ShouldProcess("$PyPath -m pip", "Update the following pip packages?`n$PipPackages", "$PyPath $PipInstallArgs $PipPackages")) {
                $PSCmdlet.WriteVerbose("$PyPath $PipInstallArgs $PipPackages")
                & $PyPath $PipInstallArgs $PipPackages
            }
        } else {
            $PSCmdlet.WriteWarning("No packages to upgrade")
        }
    }
}
