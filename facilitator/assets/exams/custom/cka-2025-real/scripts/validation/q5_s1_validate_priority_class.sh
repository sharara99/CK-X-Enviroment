#!/bin/bash
# q5_s1_validate_priority_class.sh - Validate PriorityClass exists with correct value

set -e

# Check if PriorityClass exists
if kubectl get priorityclass high-priority >/dev/null 2>&1; then
    VALUE=$(kubectl get priorityclass high-priority -o jsonpath='{.value}')
    if [ "$VALUE" = "999999999" ]; then
        echo "0"  # Success
    else
        echo "1"  # Value incorrect
    fi
else
    echo "1"  # PriorityClass doesn't exist
fi
