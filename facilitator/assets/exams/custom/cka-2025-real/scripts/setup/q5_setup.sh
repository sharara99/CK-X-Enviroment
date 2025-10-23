#!/bin/bash
# Setup for Question 5: PriorityClass for busybox-logger
# Creates priority namespace and busybox-logger deployment

echo "Setting up Question 5 environment..."

# Create namespace (idempotent)
kubectl create namespace priority --dry-run=client -o yaml | kubectl apply -f -

# Create busybox-logger deployment (idempotent)
kubectl create deployment busybox-logger --image=busybox:stable -n priority --replicas=1 --dry-run=client -o yaml | kubectl apply -f -

# Add command to keep pod running (idempotent)
kubectl patch deployment busybox-logger -n priority -p '{"spec":{"template":{"spec":{"containers":[{"name":"busybox-logger","image":"busybox:stable","command":["sleep","3600"]}]}}}}' --dry-run=client -o yaml | kubectl apply -f -

echo "Question 5 environment ready: priority namespace with busybox-logger deployment"
