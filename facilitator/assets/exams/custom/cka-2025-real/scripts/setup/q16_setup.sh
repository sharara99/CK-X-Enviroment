#!/bin/bash

# ===============================================================================
#   Question 16: Troubleshooting kube-apiserver and kube-scheduler Setup
#   Purpose: Create a scenario where kube-apiserver and kube-scheduler are not working
# ===============================================================================

echo "$(date '+%Y-%m-%d %H:%M:%S') | Setting up Question 16: Troubleshooting kube-apiserver and kube-scheduler"

# This question doesn't require additional resources as it's about troubleshooting
# existing cluster components. The scenario will be simulated by:
# 1. Stopping the services (simulated)
# 2. Creating configuration issues (simulated)
# 3. Providing troubleshooting steps

echo "Scenario Setup:"
echo "kube-apiserver and kube-scheduler are not working"
echo "etcd, kube-controller-manager, and kubelet are working"
echo ""
echo "Common issues to troubleshoot:"
echo "1. Check systemd service status"
echo "2. Check service logs"
echo "3. Check configuration files"
echo "4. Check certificates"
echo "5. Check resources (disk, memory, CPU)"
echo "6. Check network connectivity"
echo ""
echo "Troubleshooting commands:"
echo "systemctl status kube-apiserver"
echo "systemctl status kube-scheduler"
echo "journalctl -u kube-apiserver -f"
echo "journalctl -u kube-scheduler -f"
echo "ls -la /etc/kubernetes/manifests/"
echo "cat /etc/kubernetes/manifests/kube-apiserver.yaml"
echo "cat /etc/kubernetes/manifests/kube-scheduler.yaml"
echo ""
echo "Fix commands:"
echo "kubeadm init phase certs apiserver"
echo "kubeadm init phase certs apiserver-kubelet-client"
echo "systemctl restart kube-apiserver"
echo "systemctl restart kube-scheduler"
echo ""
echo "Verification:"
echo "kubectl get nodes"
echo "kubectl get pods -n kube-system"

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ Question 16 setup completed"
echo "Note: This is a troubleshooting scenario - no additional resources needed"
