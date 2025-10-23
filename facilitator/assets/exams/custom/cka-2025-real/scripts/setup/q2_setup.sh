#!/bin/bash
# Setup for Question 2: Ingress for echoserver-service
# Creates echo-sound namespace and echoserver-service

echo "Setting up Question 2 environment..."

# Create namespace (idempotent)
kubectl create namespace echo-sound --dry-run=client -o yaml | kubectl apply -f -

# Create echoserver deployment (idempotent)
kubectl create deployment echoserver --image=k8s.gcr.io/echoserver:1.4 -n echo-sound --dry-run=client -o yaml | kubectl apply -f -

# Create echoserver service (idempotent)
kubectl expose deployment echoserver --port=8080 --target-port=8080 --name=echoserver-service -n echo-sound --dry-run=client -o yaml | kubectl apply -f -

echo "Question 2 environment ready: echo-sound namespace with echoserver-service"
