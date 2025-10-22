#!/bin/bash
# q13_s1_validate_hpa.sh - Validate HPA exists with correct configuration

set -e

# Check if HPA exists
if kubectl get hpa apache-server -n autoscale >/dev/null 2>&1; then
    MIN_REPLICAS=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.minReplicas}')
    MAX_REPLICAS=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.maxReplicas}')
    CPU_TARGET=$(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}')
    
    if [ "$MIN_REPLICAS" = "1" ] && [ "$MAX_REPLICAS" = "4" ] && [ "$CPU_TARGET" = "50" ]; then
        echo "0"  # Success
    else
        echo "1"  # Configuration incorrect
    fi
else
    echo "1"  # HPA doesn't exist
fi
