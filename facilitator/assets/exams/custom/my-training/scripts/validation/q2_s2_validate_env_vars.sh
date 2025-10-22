#!/bin/bash
# q2_s2_validate_env_vars.sh - Validate pod uses ConfigMap as environment variables

set -e

# Check if pod exists and has environment variables from ConfigMap
if kubectl get pod app-pod >/dev/null 2>&1; then
    # Check if environment variables are set
    if kubectl exec app-pod -- env | grep -q "database_url=mysql://localhost:3306/mydb" && \
       kubectl exec app-pod -- env | grep -q "debug=true"; then
        echo "0"  # Success
    else
        echo "1"  # Environment variables not set correctly
    fi
else
    echo "1"  # Pod doesn't exist
fi
