#!/bin/bash
# q2_s1_validate_ingress.sh - Validate Ingress exists with correct configuration

set -e

# Check if Ingress exists with correct configuration
if kubectl get ingress echo -n echo-sound >/dev/null 2>&1; then
    # Check if host and path are correct
    HOST=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.spec.rules[0].host}')
    PATH=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.spec.rules[0].http.paths[0].path}')
    SERVICE=$(kubectl get ingress echo -n echo-sound -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}')
    
    if [ "$HOST" = "example.org" ] && [ "$PATH" = "/echo" ] && [ "$SERVICE" = "echoserver-service" ]; then
        echo "0"  # Success
    else
        echo "1"  # Configuration incorrect
    fi
else
    echo "1"  # Ingress doesn't exist
fi
