#!/bin/bash
# q7_s1_validate_storage_class.sh - Validate StorageClass exists with correct configuration

set -e

# Check if StorageClass exists
if kubectl get storageclass low-latency >/dev/null 2>&1; then
    PROVISIONER=$(kubectl get storageclass low-latency -o jsonpath='{.provisioner}')
    BINDING_MODE=$(kubectl get storageclass low-latency -o jsonpath='{.volumeBindingMode}')
    
    if [ "$PROVISIONER" = "rancher.io/local-path" ] && [ "$BINDING_MODE" = "WaitForFirstConsumer" ]; then
        echo "0"  # Success
    else
        echo "1"  # Configuration incorrect
    fi
else
    echo "1"  # StorageClass doesn't exist
fi
