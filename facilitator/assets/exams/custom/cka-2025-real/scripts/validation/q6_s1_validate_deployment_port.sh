#!/bin/bash
# q6_s1_validate_deployment_port.sh - Validate deployment exposes port 80

set -e

# Check if deployment exposes port 80
if kubectl get deployment front-end -n sp-culator >/dev/null 2>&1; then
    PORT=$(kubectl get deployment front-end -n sp-culator -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}')
    if [ "$PORT" = "80" ]; then
        echo "0"  # Success
    else
        echo "1"  # Port not configured
    fi
else
    echo "1"  # Deployment doesn't exist
fi
