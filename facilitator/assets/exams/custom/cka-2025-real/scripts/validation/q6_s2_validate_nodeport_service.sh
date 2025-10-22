#!/bin/bash
# q6_s2_validate_nodeport_service.sh - Validate NodePort service exists with correct configuration

set -e

# Check if NodePort service exists
if kubectl get service front-end-svc -n sp-culator >/dev/null 2>&1; then
    SERVICE_TYPE=$(kubectl get service front-end-svc -n sp-culator -o jsonpath='{.spec.type}')
    NODE_PORT=$(kubectl get service front-end-svc -n sp-culator -o jsonpath='{.spec.ports[0].nodePort}')
    
    if [ "$SERVICE_TYPE" = "NodePort" ] && [ "$NODE_PORT" = "30080" ]; then
        echo "0"  # Success
    else
        echo "1"  # Configuration incorrect
    fi
else
    echo "1"  # Service doesn't exist
fi
