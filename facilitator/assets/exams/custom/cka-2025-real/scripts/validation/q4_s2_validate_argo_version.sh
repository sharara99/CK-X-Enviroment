#!/bin/bash
# q4_s2_validate_argo_version.sh - Validate template contains Argo CD v7.7.3

set -e

# Check if template contains Argo CD v7.7.3
if [ -f "/argo-helm.yaml" ] && grep -q "7.7.3" /argo-helm.yaml; then
    echo "0"  # Success
else
    echo "1"  # Version not found in template
fi
