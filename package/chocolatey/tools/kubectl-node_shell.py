# src/kubectl-node_shell.py
#!/usr/bin/env python3

import argparse
import os
import sys
import tempfile
import time
import subprocess
from pathlib import Path

POD_TEMPLATE = """apiVersion: v1
kind: Pod
metadata:
  name: node-shell-{node_name}
  namespace: default
spec:
  hostNetwork: true
  hostPID: true
  hostIPC: true
  priorityClassName: system-node-critical
  priority: 2000001000
  tolerations:
    - operator: Exists
  nodeName: {node_name}
  containers:
    - name: shell
      image: docker.io/library/alpine:3.19
      command: ["nsenter"]
      args: ["-t", "1", "-m", "-u", "-i", "-n", "sleep", "14000"]
      securityContext:
        privileged: true
      terminationMessagePath: /dev/termination-log
      terminationMessagePolicy: File
      imagePullPolicy: IfNotPresent
  serviceAccountName: default
  dnsPolicy: ClusterFirst
  restartPolicy: Never
  terminationGracePeriodSeconds: 0
  schedulerName: default-scheduler
  enableServiceLinks: true
  preemptionPolicy: PreemptLowerPriority
"""

def run_command(cmd, capture_output=True):
    """Run a command and return its output"""
    try:
        result = subprocess.run(cmd, 
                              capture_output=capture_output, 
                              text=True, 
                              check=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {' '.join(cmd)}")
        print(f"Error message: {e.stderr}")
        sys.exit(1)

def wait_for_pod(pod_name, timeout=30):
    """Wait for pod to be ready"""
    print("Waiting for pod to be ready...")
    for _ in range(timeout):
        cmd = ["kubectl", "get", "pod", pod_name, "-n", "default", 
               "-o", "jsonpath={.status.phase}"]
        try:
            output = run_command(cmd)
            if output == "Running":
                return True
        except subprocess.CalledProcessError:
            pass
        time.sleep(1)
    return False

def main():
    parser = argparse.ArgumentParser(description='Get a shell on a Kubernetes node')
    parser.add_argument('node_name', help='Name of the node to shell into')
    args = parser.parse_args()

    # Create manifest in temporary file
    with tempfile.NamedTemporaryFile(mode='w', suffix='.yaml', delete=False) as tmp:
        tmp.write(POD_TEMPLATE.format(node_name=args.node_name))
        manifest_path = tmp.name

    try:
        # Create the pod
        run_command(["kubectl", "create", "-f", manifest_path], capture_output=False)

        pod_name = f"node-shell-{args.node_name}"

        # Wait for pod to be ready
        if not wait_for_pod(pod_name):
            print("Timeout waiting for pod to be ready")
            sys.exit(1)

        # Execute shell in pod
        subprocess.run(["kubectl", "exec", "-it", pod_name, "-n", "default", "--", "sh"])

    finally:
        # Cleanup
        try:
            run_command(["kubectl", "delete", "pod", f"node-shell-{args.node_name}", 
                        "-n", "default"])
        except subprocess.CalledProcessError:
            print("Warning: Failed to delete pod")

        # Remove temporary file
        os.unlink(manifest_path)

if __name__ == "__main__":
    main()