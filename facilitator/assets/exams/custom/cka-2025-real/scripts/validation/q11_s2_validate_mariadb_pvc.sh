#!/bin/bash
# q11_s2_validate_mariadb_pvc.sh - Validate MariaDB uses PVC for storage

set -e

# Check if MariaDB deployment uses PVC
if kubectl get deployment mariadb -n mariadb >/dev/null 2>&1; then
    PVC_NAME=$(kubectl get deployment mariadb -n mariadb -o jsonpath='{.spec.template.spec.volumes[0].persistentVolumeClaim.claimName}')
    MOUNT_PATH=$(kubectl get deployment mariadb -n mariadb -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[0].mountPath}')
    
    if [ "$PVC_NAME" = "mariadb" ] && [ "$MOUNT_PATH" = "/var/lib/mysql" ]; then
        echo "0"  # Success
    else
        echo "1"  # PVC not configured correctly
    fi
else
    echo "1"  # Deployment doesn't exist
fi
