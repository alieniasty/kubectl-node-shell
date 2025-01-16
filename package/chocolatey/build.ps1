# build.ps1
$ErrorActionPreference = 'Stop'

# Get directories
$scriptPath = $MyInvocation.MyCommand.Path
$chocolateyDir = Split-Path -Parent $scriptPath
$packageDir = Split-Path -Parent $chocolateyDir
$rootDir = Split-Path -Parent $packageDir
$srcDir = Join-Path $rootDir "src"
$toolsDir = Join-Path $chocolateyDir "tools"

# Copy Python script to tools directory
Copy-Item (Join-Path $srcDir "kubectl-node_shell.py") $toolsDir -Force

# Pack the package
choco pack

Write-Host "Build completed. You can now run: choco install kubectl-node-shell -s ."