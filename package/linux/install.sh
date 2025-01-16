#!/bin/bash
set -e

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$(cd "${SCRIPT_DIR}/../../src" && pwd)"

# Check Python version
python3_version=$(python3 -V 2>&1 | awk '{print $2}')
required_version="3.10.0"

if [ "$(printf '%s\n' "$required_version" "$python3_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo "Error: Python 3.10.0 or later is required"
    exit 1
fi

# Create wrapper script
cat > /tmp/kubectl-node << 'EOF'
#!/bin/bash
if [ "$1" = "shell" ]; then
    shift
    python3 /usr/local/bin/kubectl-node_shell.py "$@"
else
    python3 /usr/local/bin/kubectl-node_shell.py "$@"
fi
EOF

# Install files
sudo cp /tmp/kubectl-node /usr/local/bin/kubectl-node
sudo cp "${SRC_DIR}/kubectl-node_shell.py" /usr/local/bin/kubectl-node_shell.py
sudo chmod +x /usr/local/bin/kubectl-node
sudo chmod +x /usr/local/bin/kubectl-node_shell.py

# Clean up
rm /tmp/kubectl-node

echo "kubectl-node-shell has been installed. You can use 'kubectl node shell <node-name>' to access nodes."