#!/bin/bash
# q3_s2_validate_service.sh - Validate service exists and targets deployment

set -e

# Check if service exists and targets the deployment
if kubectl get service web-service >/dev/null 2>&1; then
    # Check if service is ClusterIP type
    SERVICE_TYPE=$(kubectl get service web-service -o jsonpath='{.spec.type}')
    if [ "$SERVICE_TYPE" = "ClusterIP" ]; then
        # Check if service targets the deployment pods
        SELECTOR=$(kubectl get service web-service -o jsonpath='{.spec.selector}')
        if echo "$SELECTOR" | grep -q "app=web-deployment"; then
            echo "0"  # Success
        else
            echo "1"  # Service selector incorrect
        fi
    else
        echo "1"  # Service type incorrect
    fi
else
    echo "1"  # Service doesn't exist
fi
