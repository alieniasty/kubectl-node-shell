# kubectl-node-shell

A kubectl plugin for getting shell access to Kubernetes nodes using privileged containers.

## Prerequisites

- Windows
- Python 3.10+
- Chocolatey package manager
- kubectl

## Installation

```powershell
choco install kubectl-node-shell
```

## Usage

Get shell access to a node:
```powershell
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

## Development

To build and install locally:

1. Clone the repository
2. Navigate to package/chocolatey directory
3. Run:
```powershell
choco pack
choco install kubectl-node-shell -s . -y
```

## Security

This plugin creates privileged containers with root access to the host node. Use with caution in production environments.