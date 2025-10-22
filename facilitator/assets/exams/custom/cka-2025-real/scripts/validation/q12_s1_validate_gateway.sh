#!/bin/bash
# q12_s1_validate_gateway.sh - Validate Gateway and HTTPRoute exist

set -e

# Check if Gateway and HTTPRoute exist
if kubectl get gateway web-gateway -n default >/dev/null 2>&1 && \
   kubectl get httproute web-route -n default >/dev/null 2>&1; then
    echo "0"  # Success
else
    echo "1"  # Gateway or HTTPRoute doesn't exist
fi
