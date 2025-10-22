#!/bin/bash
# q10_s1_validate_replicas.sh - Validate WordPress deployment has 3 replicas

set -e

# Check if WordPress deployment has 3 replicas
if kubectl get deployment wordpress -n relative-fawn >/dev/null 2>&1; then
    REPLICAS=$(kubectl get deployment wordpress -n relative-fawn -o jsonpath='{.spec.replicas}')
    READY_REPLICAS=$(kubectl get deployment wordpress -n relative-fawn -o jsonpath='{.status.readyReplicas}')
    
    if [ "$REPLICAS" = "3" ] && [ "$READY_REPLICAS" = "3" ]; then
        echo "0"  # Success
    else
        echo "1"  # Replica count incorrect
    fi
else
    echo "1"  # Deployment doesn't exist
fi
