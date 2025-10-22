#!/bin/bash
# q2_s2_validate_endpoint.sh - Validate Ingress endpoint is accessible

set -e

# Test if endpoint is accessible (simplified check)
if kubectl get ingress echo -n echo-sound >/dev/null 2>&1; then
    # Check if Ingress has an IP or hostname assigned
    IP=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    HOSTNAME=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
    
    if [ -n "$IP" ] || [ -n "$HOSTNAME" ]; then
        echo "0"  # Success - Ingress has external access
    else
        echo "1"  # No external access configured
    fi
else
    echo "1"  # Ingress doesn't exist
fi
