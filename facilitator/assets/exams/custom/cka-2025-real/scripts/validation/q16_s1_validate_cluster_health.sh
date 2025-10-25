#!/bin/bash

# ===============================================================================
#   Question 16: Troubleshooting kube-apiserver and kube-scheduler Validation
#   Purpose: Validate that kube-apiserver and kube-scheduler are working properly
# ===============================================================================

echo "$(date '+%Y-%m-%d %H:%M:%S') | Validating Question 16: Troubleshooting kube-apiserver and kube-scheduler"

# Check if kube-apiserver is running
echo "Checking kube-apiserver status..."
if systemctl is-active --quiet kube-apiserver; then
    echo "✅ kube-apiserver service is running"
else
    echo "❌ kube-apiserver service is not running"
fi

# Check if kube-scheduler is running
echo "Checking kube-scheduler status..."
if systemctl is-active --quiet kube-scheduler; then
    echo "✅ kube-scheduler service is running"
else
    echo "❌ kube-scheduler service is not running"
fi

# Check if etcd is running
echo "Checking etcd status..."
if systemctl is-active --quiet etcd; then
    echo "✅ etcd service is running"
else
    echo "❌ etcd service is not running"
fi

# Check if kube-controller-manager is running
echo "Checking kube-controller-manager status..."
if systemctl is-active --quiet kube-controller-manager; then
    echo "✅ kube-controller-manager service is running"
else
    echo "❌ kube-controller-manager service is not running"
fi

# Check if kubelet is running
echo "Checking kubelet status..."
if systemctl is-active --quiet kubelet; then
    echo "✅ kubelet service is running"
else
    echo "❌ kubelet service is not running"
fi

# Check cluster connectivity
echo "Checking cluster connectivity..."
if kubectl get nodes >/dev/null 2>&1; then
    echo "✅ Cluster is accessible via kubectl"
    kubectl get nodes
else
    echo "❌ Cluster is not accessible via kubectl"
fi

# Check system pods
echo "Checking system pods..."
kubectl get pods -n kube-system

# Check API server logs for errors
echo "Checking recent API server logs for errors..."
journalctl -u kube-apiserver --since "5 minutes ago" --no-pager | grep -i error | tail -5

# Check scheduler logs for errors
echo "Checking recent scheduler logs for errors..."
journalctl -u kube-scheduler --since "5 minutes ago" --no-pager | grep -i error | tail -5

# Check configuration files exist
echo "Checking configuration files..."
if [ -f "/etc/kubernetes/manifests/kube-apiserver.yaml" ]; then
    echo "✅ kube-apiserver manifest exists"
else
    echo "❌ kube-apiserver manifest missing"
fi

if [ -f "/etc/kubernetes/manifests/kube-scheduler.yaml" ]; then
    echo "✅ kube-scheduler manifest exists"
else
    echo "❌ kube-scheduler manifest missing"
fi

# Check certificate files
echo "Checking certificate files..."
CERT_DIR="/etc/kubernetes/pki"
if [ -d "$CERT_DIR" ]; then
    echo "✅ Certificate directory exists"
    ls -la $CERT_DIR/apiserver*
else
    echo "❌ Certificate directory missing"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ Question 16 validation completed"
