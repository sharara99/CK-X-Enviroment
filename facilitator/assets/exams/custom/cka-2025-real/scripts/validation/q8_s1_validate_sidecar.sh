#!/bin/bash
# q8_s1_validate_sidecar.sh - Validate sidecar container exists in deployment

set -e

# Check if sidecar container exists in deployment
if kubectl get deployment synergy-deployment -n default >/dev/null 2>&1; then
    SIDECAR_EXISTS=$(kubectl get deployment synergy-deployment -n default -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].name}')
    if [ "$SIDECAR_EXISTS" = "sidecar" ]; then
        echo "0"  # Success
    else
        echo "1"  # Sidecar not found
    fi
else
    echo "1"  # Deployment doesn't exist
fi
