#!/bin/bash
set -e

# Remove installed files
sudo rm -f /usr/local/bin/kubectl-node
sudo rm -f /usr/local/bin/kubectl-node_shell.py

echo "kubectl-node-shell has been uninstalled."