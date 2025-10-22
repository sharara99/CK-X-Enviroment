#!/bin/bash
# q14_s1_validate_tls_config.sh - Validate ConfigMap allows only TLSv1.3

set -e

# Check if ConfigMap allows only TLSv1.3
if kubectl get configmap nginx-config -n nginx-static >/dev/null 2>&1; then
    TLS_PROTOCOLS=$(kubectl get configmap nginx-config -n nginx-static -o jsonpath='{.data.nginx\.conf}' | grep ssl_protocols)
    
    if echo "$TLS_PROTOCOLS" | grep -q "TLSv1.3" && ! echo "$TLS_PROTOCOLS" | grep -q "TLSv1.2"; then
        echo "0"  # Success
    else
        echo "1"  # TLS configuration incorrect
    fi
else
    echo "1"  # ConfigMap doesn't exist
fi
