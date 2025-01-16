# tools/chocolateyuninstall.ps1
$ErrorActionPreference = 'Stop'

Remove-Item (Join-Path $env:ChocolateyInstall "bin\kubectl-node.cmd") -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path $env:ChocolateyInstall "lib\kubectl-node-shell") -Recurse -Force -ErrorAction SilentlyContinue