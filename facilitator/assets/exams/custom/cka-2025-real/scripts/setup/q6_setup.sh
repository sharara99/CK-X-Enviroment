#!/bin/bash
# Setup for Question 6: Service and NodePort for front-end
# Creates sp-culator namespace and front-end deployment

echo "Setting up Question 6 environment..."

# Create namespace (idempotent)
kubectl create namespace sp-culator --dry-run=client -o yaml | kubectl apply -f -

# Create front-end deployment (idempotent)
kubectl create deployment front-end --image=nginx:1.21 -n sp-culator --replicas=2 --dry-run=client -o yaml | kubectl apply -f -

# Add label for service selector (idempotent)
kubectl label deployment front-end app=front-end -n sp-culator --overwrite

echo "Question 6 environment ready: sp-culator namespace with front-end deployment"
