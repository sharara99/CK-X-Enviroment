#!/bin/bash
# Setup for Question 9: cert-manager CRDs
# Installs cert-manager

echo "Setting up Question 9 environment..."

# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

# Wait for cert-manager to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=cert-manager -n cert-manager --timeout=300s

echo "Question 9 environment ready: cert-manager installed"
