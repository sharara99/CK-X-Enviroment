#!/bin/bash
# q1_s1_validate_pod.sh - Validate pod exists and is running

set -e

# Check if pod exists and is running
if kubectl get pod my-pod >/dev/null 2>&1; then
    STATUS=$(kubectl get pod my-pod -o jsonpath='{.status.phase}')
    if [ "$STATUS" = "Running" ]; then
        echo "0"  # Success
    else
        echo "1"  # Pod exists but not running
    fi
else
    echo "1"  # Pod doesn't exist
fi
