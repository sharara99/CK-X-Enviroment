#!/bin/bash
# q5_s2_validate_deployment_priority.sh - Validate deployment uses PriorityClass

set -e

# Check if deployment uses PriorityClass
if kubectl get deployment busybox-logger -n priority >/dev/null 2>&1; then
    PRIORITY_CLASS=$(kubectl get deployment busybox-logger -n priority -o jsonpath='{.spec.template.spec.priorityClassName}')
    if [ "$PRIORITY_CLASS" = "high-priority" ]; then
        echo "0"  # Success
    else
        echo "1"  # PriorityClass not set
    fi
else
    echo "1"  # Deployment doesn't exist
fi
