#!/bin/bash

# ===============================================================================
#   Question 15: NetworkPolicy Selection Validation
#   Purpose: Validate that the correct NetworkPolicy has been selected/applied
# ===============================================================================

echo "$(date '+%Y-%m-%d %H:%M:%S') | Validating Question 15: NetworkPolicy Selection"

# Check if namespaces exist
echo "Checking namespaces..."
kubectl get namespace frontend
kubectl get namespace backend
kubectl get namespace database

# Check if deployments exist
echo "Checking deployments..."
kubectl get deployment frontend-app -n frontend
kubectl get deployment backend-api -n backend
kubectl get deployment database -n database

# Check NetworkPolicies
echo "Checking NetworkPolicies..."
kubectl get networkpolicy -n backend
kubectl get networkpolicy -n frontend
kubectl get networkpolicy -n database

# Validate the correct NetworkPolicy exists
echo "Validating NetworkPolicy configuration..."

# Check if there's a NetworkPolicy that allows frontend to backend
BACKEND_NP=$(kubectl get networkpolicy -n backend -o json | jq -r '.items[] | select(.spec.ingress[]?.from[]?.namespaceSelector?.matchLabels?.name == "frontend") | .metadata.name')

if [ -n "$BACKEND_NP" ]; then
    echo "✅ Found NetworkPolicy '$BACKEND_NP' that allows frontend namespace to access backend"
    
    # Check if it only allows frontend (not all traffic)
    ALLOW_ALL=$(kubectl get networkpolicy $BACKEND_NP -n backend -o json | jq -r '.spec.ingress[]? | select(.from == null or (.from | length) == 0)')
    
    if [ -z "$ALLOW_ALL" ]; then
        echo "✅ NetworkPolicy correctly restricts access to frontend namespace only"
    else
        echo "❌ NetworkPolicy allows all traffic (incorrect)"
    fi
else
    echo "❌ No NetworkPolicy found that allows frontend namespace to access backend"
fi

# Check if pods are running
echo "Checking pod status..."
kubectl get pods -n frontend
kubectl get pods -n backend
kubectl get pods -n database

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ Question 15 validation completed"
