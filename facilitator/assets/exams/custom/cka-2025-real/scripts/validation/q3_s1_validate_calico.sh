#!/bin/bash
# q3_s1_validate_calico.sh - Validate Calico operator pods are running

set -e

# Check if Calico operator pods are running
if kubectl get pods -n tigera-operator --no-headers | grep -q "Running"; then
    echo "0"  # Success
else
    echo "1"  # Pods not running
fi
