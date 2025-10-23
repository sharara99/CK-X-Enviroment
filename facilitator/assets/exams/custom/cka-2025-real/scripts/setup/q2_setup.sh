#!/bin/bash
# Setup for Question 2: Ingress for echoserver-service
# Creates echo-sound namespace and echoserver-service

echo "Setting up Question 2 environment..."

# Create namespace
kubectl create namespace echo-sound

# Create echoserver deployment
kubectl create deployment echoserver --image=k8s.gcr.io/echoserver:1.4 -n echo-sound

# Create echoserver service
kubectl expose deployment echoserver --port=8080 --target-port=8080 --name=echoserver-service -n echo-sound

echo "Question 2 environment ready: echo-sound namespace with echoserver-service"
