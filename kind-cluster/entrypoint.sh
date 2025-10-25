#!/bin/sh

# ===============================================================================
#   KIND Cluster Setup Entrypoint Script
#   Purpose: Initialize Docker and create Kind cluster
# ===============================================================================

echo "$(date '+%Y-%m-%d %H:%M:%S') | ===== INITIALIZATION STARTED ====="
echo "$(date '+%Y-%m-%d %H:%M:%S') | Executing container startup script..."

# Execute current entrypoint script
if [ -f /usr/local/bin/startup.sh ]; then
    sh /usr/local/bin/startup.sh &
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') | [INFO] Default startup script not found at /usr/local/bin/startup.sh"
fi

# ===============================================================================
#   Docker Readiness Check
# ===============================================================================

echo "$(date '+%Y-%m-%d %H:%M:%S') | Checking Docker service status..."
DOCKER_CHECK_COUNT=0

# Wait for docker to be ready
while ! docker ps; do   
    DOCKER_CHECK_COUNT=$((DOCKER_CHECK_COUNT+1))
    echo "$(date '+%Y-%m-%d %H:%M:%S') | [WAITING] Docker service not ready yet... (attempt $DOCKER_CHECK_COUNT)"
    sleep 5
done

echo "$(date '+%Y-%m-%d %H:%M:%S') | [SUCCESS] Docker service is ready and operational"

#pull kindest/node image
# docker pull kindest/node:$KIND_DEFAULT_VERSION

#add user for ssh access
adduser -S -D -H -s /sbin/nologin -G sshd sshd

#start ssh service
/usr/sbin/sshd -D &

#install k3d (skip if already installed)
echo "$(date '+%Y-%m-%d %H:%M:%S') | [INFO] Checking k3d installation"
if ! command -v k3d &> /dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') | k3d not found. Attempting installation..."
    TAG=v5.8.3 bash /usr/local/bin/k3d-install.sh
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') | k3d already installed, skipping installation"
fi

# Pre-create k3d cluster for faster exam startup
echo "$(date '+%Y-%m-%d %H:%M:%S') | [INFO] Pre-creating k3d cluster for faster exam startup"
if ! k3d cluster list | grep -q "cluster"; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating pre-configured k3d cluster..."
    
    # Generate optimized k3d config
    cat <<EOF > /tmp/k3d-config.yaml
apiVersion: k3d.io/v1alpha5
kind: Simple
metadata:
  name: cluster
servers: 1
agents: 1
ports:
  - port: "6443:6443"
    nodeFilters:
      - loadbalancer
kubeAPI:
  host: "0.0.0.0"
  hostPort: "6443"
options:
  k3s:
    extraArgs:
      - arg: "--tls-san=k8s-api-server"
        nodeFilters:
          - server:*
      - arg: "--tls-san=127.0.0.1"
        nodeFilters:
          - server:*
      - arg: "--tls-san=localhost"
        nodeFilters:
          - server:*
EOF
    
    k3d cluster create --config /tmp/k3d-config.yaml
    echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ Pre-configured k3d cluster created successfully"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') | k3d cluster already exists, skipping creation"
fi

sleep 1
touch /ready

# Keep container running
tail -f /dev/null