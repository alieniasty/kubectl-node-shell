# tools/chocolateyinstall.ps1
$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Python version check...

$scriptDir = Join-Path $env:ChocolateyInstall "lib\kubectl-node-shell\scripts"
if (!(Test-Path $scriptDir)) {
    New-Item -ItemType Directory -Path $scriptDir -Force | Out-Null
}

Copy-Item (Join-Path $toolsDir "kubectl-node_shell.py") $scriptDir -Force

$wrapperContent = @"
@echo off
setlocal enabledelayedexpansion
if "%1"=="shell" (
    python "$scriptDir\kubectl-node_shell.py" %2
) else (
    python "$scriptDir\kubectl-node_shell.py" %*
)
"@

# Save as .cmd file
Set-Content -Path (Join-Path $env:ChocolateyInstall "bin\kubectl-node.cmd") -Value $wrapperContent -Force