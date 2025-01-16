@echo off
setlocal enabledelayedexpansion
set SCRIPT_DIR=%~dp0
python "%SCRIPT_DIR%kubectl-node_shell.py" %*