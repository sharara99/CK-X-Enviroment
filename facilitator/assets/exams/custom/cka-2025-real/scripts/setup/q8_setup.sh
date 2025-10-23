#!/bin/bash
# Setup for Question 8: Sidecar for synergy-deployment
# Creates synergy-deployment in default namespace

echo "Setting up Question 8 environment..."

# Create synergy-deployment
kubectl create deployment synergy-deployment --image=nginx:1.21 --replicas=1

# Add label for identification
kubectl label deployment synergy-deployment app=synergy-deployment

echo "Question 8 environment ready: synergy-deployment in default namespace"
