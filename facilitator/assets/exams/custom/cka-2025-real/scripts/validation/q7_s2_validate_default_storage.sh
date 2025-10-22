#!/bin/bash
# q7_s2_validate_default_storage.sh - Validate StorageClass is set as default

set -e

# Check if StorageClass is set as default
if kubectl get storageclass low-latency >/dev/null 2>&1; then
    IS_DEFAULT=$(kubectl get storageclass low-latency -o jsonpath='{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}')
    if [ "$IS_DEFAULT" = "true" ]; then
        echo "0"  # Success
    else
        echo "1"  # Not set as default
    fi
else
    echo "1"  # StorageClass doesn't exist
fi
