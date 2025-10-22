#!/bin/bash
# q2_s1_validate_configmap.sh - Validate ConfigMap exists with correct data

set -e

# Check if ConfigMap exists and has correct data
if kubectl get configmap my-config >/dev/null 2>&1; then
    # Check for database_url
    if kubectl get configmap my-config -o jsonpath='{.data.database_url}' | grep -q "mysql://localhost:3306/mydb"; then
        # Check for debug
        if kubectl get configmap my-config -o jsonpath='{.data.debug}' | grep -q "true"; then
            echo "0"  # Success
        else
            echo "1"  # debug value incorrect
        fi
    else
        echo "1"  # database_url value incorrect
    fi
else
    echo "1"  # ConfigMap doesn't exist
fi
