#!/bin/bash
# q10_s2_validate_resources.sh - Validate resource requests are configured correctly

set -e

# Check if WordPress has resource requests configured
if kubectl get deployment wordpress -n relative-fawn >/dev/null 2>&1; then
    CPU_REQUEST=$(kubectl get deployment wordpress -n relative-fawn -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')
    MEMORY_REQUEST=$(kubectl get deployment wordpress -n relative-fawn -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')
    
    if [ -n "$CPU_REQUEST" ] && [ -n "$MEMORY_REQUEST" ]; then
        echo "0"  # Success
    else
        echo "1"  # Resource requests not configured
    fi
else
    echo "1"  # Deployment doesn't exist
fi
