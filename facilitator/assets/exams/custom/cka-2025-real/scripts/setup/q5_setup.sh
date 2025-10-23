#!/bin/bash
# Setup for Question 5: PriorityClass for busybox-logger
# Creates priority namespace and busybox-logger deployment

echo "Setting up Question 5 environment..."

# Create namespace
kubectl create namespace priority

# Create busybox-logger deployment
kubectl create deployment busybox-logger --image=busybox:stable -n priority --replicas=1

# Add command to keep pod running
kubectl patch deployment busybox-logger -n priority -p '{"spec":{"template":{"spec":{"containers":[{"name":"busybox-logger","command":["sleep","3600"]}]}}}}'

echo "Question 5 environment ready: priority namespace with busybox-logger deployment"
