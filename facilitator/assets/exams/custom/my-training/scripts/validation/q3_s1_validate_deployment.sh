#!/bin/bash
# q3_s1_validate_deployment.sh - Validate deployment exists with correct replicas

set -e

# Check if deployment exists and has 2 replicas
if kubectl get deployment web-deployment >/dev/null 2>&1; then
    REPLICAS=$(kubectl get deployment web-deployment -o jsonpath='{.spec.replicas}')
    READY_REPLICAS=$(kubectl get deployment web-deployment -o jsonpath='{.status.readyReplicas}')
    
    if [ "$REPLICAS" = "2" ] && [ "$READY_REPLICAS" = "2" ]; then
        echo "0"  # Success
    else
        echo "1"  # Replica count incorrect
    fi
else
    echo "1"  # Deployment doesn't exist
fi
