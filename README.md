# kubectl-node-shell

A kubectl plugin for getting shell access to Kubernetes nodes using privileged containers.

## Prerequisites

- Python 3.10+
- kubectl

## Installation

### Windows
```powershell
choco install kubectl-node-shell
```

### Linux
```bash
git clone https://github.com/alieniasty/kubectl-node-shell.git
cd kubectl-node-shell/package/linux
sudo ./install.sh
```

## Uninstallation

### Windows
```powershell
choco uninstall kubectl-node-shell
```

### Linux
```bash
cd kubectl-node-shell/package/linux
sudo ./uninstall.sh
```

## Usage

Get shell access to a node:
```bash
kubectl node shell <node-name>
```

## How it Works

The plugin creates a privileged pod on the specified node using nsenter to access the node's namespaces. This provides direct shell access to the node.

The pod specification:
- Uses Alpine Linux image
- Runs with hostPID, hostNetwork, and hostIPC
- Configured with highest priority to ensure scheduling
- Uses nsenter to access host namespaces
- Automatically cleans up after shell session ends

## Security

This plugin creates privileged containers with root access to the host node. Use with caution in production environments.