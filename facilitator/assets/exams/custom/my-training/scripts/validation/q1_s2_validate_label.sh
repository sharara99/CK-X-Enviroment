#!/bin/bash
# q1_s2_validate_label.sh - Validate pod has correct label

set -e

# Check if pod has the correct label
if kubectl get pod my-pod --show-labels | grep -q "app=my-app"; then
    echo "0"  # Success
else
    echo "1"  # Label not found
fi
