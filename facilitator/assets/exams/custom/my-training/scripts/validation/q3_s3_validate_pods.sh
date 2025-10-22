#!/bin/bash
# q3_s3_validate_pods.sh - Validate all pods are running and ready

set -e

# Check if all pods from the deployment are running
PODS=$(kubectl get pods -l app=web-deployment --no-headers | wc -l)
RUNNING_PODS=$(kubectl get pods -l app=web-deployment --no-headers | grep "Running" | wc -l)

if [ "$PODS" = "2" ] && [ "$RUNNING_PODS" = "2" ]; then
    echo "0"  # Success
else
    echo "1"  # Not all pods are running
fi
