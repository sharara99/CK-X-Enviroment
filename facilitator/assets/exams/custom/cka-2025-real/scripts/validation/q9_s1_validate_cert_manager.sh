#!/bin/bash
# q9_s1_validate_cert_manager.sh - Validate cert-manager pods are running

set -e

# Check if cert-manager pods are running
if kubectl get pods -n cert-manager --no-headers | grep -q "Running"; then
    echo "0"  # Success
else
    echo "1"  # Pods not running
fi
