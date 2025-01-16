# tools/chocolateyuninstall.ps1
$ErrorActionPreference = 'Stop'

# Remove the wrapper script
Remove-Item (Join-Path $env:ChocolateyInstall "bin\kubectl-node.cmd") -Force -ErrorAction SilentlyContinue

# Remove the script directory
Remove-Item (Join-Path $env:ChocolateyInstall "lib\kubectl-node-shell") -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "kubectl-node-shell has been uninstalled."