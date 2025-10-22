#!/bin/bash
# q11_s1_validate_pvc.sh - Validate PVC exists with correct configuration

set -e

# Check if PVC exists
if kubectl get pvc mariadb -n mariadb >/dev/null 2>&1; then
    STORAGE=$(kubectl get pvc mariadb -n mariadb -o jsonpath='{.spec.resources.requests.storage}')
    ACCESS_MODE=$(kubectl get pvc mariadb -n mariadb -o jsonpath='{.spec.accessModes[0]}')
    
    if [ "$STORAGE" = "250Mi" ] && [ "$ACCESS_MODE" = "ReadWriteOnce" ]; then
        echo "0"  # Success
    else
        echo "1"  # Configuration incorrect
    fi
else
    echo "1"  # PVC doesn't exist
fi
