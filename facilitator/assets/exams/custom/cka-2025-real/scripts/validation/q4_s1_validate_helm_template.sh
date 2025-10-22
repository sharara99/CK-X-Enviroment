#!/bin/bash
# q4_s1_validate_helm_template.sh - Validate Helm template file exists

set -e

# Check if Helm template file exists
if [ -f "/argo-helm.yaml" ]; then
    echo "0"  # Success
else
    echo "1"  # Template file not found
fi
