#!/bin/bash
# Setup for Question 6: Service and NodePort for front-end
# Creates sp-culator namespace and front-end deployment

echo "Setting up Question 6 environment..."

# Create namespace
kubectl create namespace sp-culator

# Create front-end deployment
kubectl create deployment front-end --image=nginx:1.21 -n sp-culator --replicas=2

# Add label for service selector
kubectl label deployment front-end app=front-end -n sp-culator

echo "Question 6 environment ready: sp-culator namespace with front-end deployment"
