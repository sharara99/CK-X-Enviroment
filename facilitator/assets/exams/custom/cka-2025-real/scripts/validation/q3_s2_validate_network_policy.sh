#!/bin/bash
# q3_s2_validate_network_policy.sh - Validate Network Policy support is available

set -e

# Check if NetworkPolicy CRD exists
if kubectl get crd networkpolicies.crd.projectcalico.org >/dev/null 2>&1; then
    echo "0"  # Success
else
    echo "1"  # NetworkPolicy CRD not found
fi
