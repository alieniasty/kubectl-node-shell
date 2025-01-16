# tools/chocolateyinstall.ps1
$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Check Python version
try {
    $pythonVersionOutput = (python -V 2>&1).ToString()
    if (-not $pythonVersionOutput.StartsWith("Python 3.")) {
        throw "Python 3.x is required. Found: $pythonVersionOutput"
    }
    
    $versionMatch = $pythonVersionOutput -match 'Python (\d+)\.(\d+)\.(\d+)'
    if (-not $versionMatch) {
        throw "Unable to parse Python version from: $pythonVersionOutput"
    }
    
    $major = [int]$matches[1]
    $minor = [int]$matches[2]
    
    if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 10)) {
        throw "Python 3.10 or later is required. Found: $pythonVersionOutput"
    }
    
    Write-Host "Found compatible Python version: $pythonVersionOutput"
} catch {
    throw "Python 3.10 or later is required but not found. Please install Python first. Error: $_"
}

# Create script directory
$scriptDir = Join-Path $env:ChocolateyInstall "lib\kubectl-node-shell\scripts"
if (!(Test-Path $scriptDir)) {
    New-Item -ItemType Directory -Path $scriptDir -Force | Out-Null
}

# Copy Python script from tools directory
Copy-Item (Join-Path $toolsDir "kubectl-node_shell.py") $scriptDir -Force

# Create wrapper script
$wrapperContent = @"
@echo off
setlocal enabledelayedexpansion
if "%1"=="shell" (
    python "$scriptDir\kubectl-node_shell.py" %2
) else (
    python "$scriptDir\kubectl-node_shell.py" %*
)
"@

# Save the wrapper
$destDir = Join-Path $env:ChocolateyInstall "bin"
Set-Content -Path (Join-Path $destDir "kubectl-node.cmd") -Value $wrapperContent -Force

Write-Host "kubectl-node-shell has been installed. You can use 'kubectl node shell <node-name>' to access nodes."