#!/bin/bash
# Fast-track setup for CKA 2025 exam questions - OPTIMIZED FOR SPEED
# This script creates only essential resources quickly

echo "$(date '+%Y-%m-%d %H:%M:%S') | 🚀 Starting FAST CKA 2025 exam setup..."

# Pre-pull only essential images
echo "$(date '+%Y-%m-%d %H:%M:%S') | 📦 Pre-pulling essential images..."
docker pull k8s.gcr.io/echoserver:1.4 &
docker pull busybox:stable &
docker pull nginx:1.21 &
wait
echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ Essential images pre-pulled"

# Create essential namespaces only
echo "$(date '+%Y-%m-%d %H:%M:%S') | 📁 Creating essential namespaces..."
kubectl create namespace echo-sound --dry-run=client -o yaml | kubectl apply -f - &
kubectl create namespace priority --dry-run=client -o yaml | kubectl apply -f - &
kubectl create namespace sp-culator --dry-run=client -o yaml | kubectl apply -f - &
wait

# Create only essential deployments (skip heavy ones like wordpress, mariadb)
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Creating essential deployments..."

# Question 2: echoserver (essential)
kubectl create deployment echoserver --image=k8s.gcr.io/echoserver:1.4 -n echo-sound --dry-run=client -o yaml | kubectl apply -f - &
kubectl expose deployment echoserver --port=8080 --target-port=8080 --name=echoserver-service -n echo-sound --dry-run=client -o yaml | kubectl apply -f - &

# Question 5: busybox-logger (lightweight)
kubectl create deployment busybox-logger --image=busybox:stable -n priority --replicas=1 --dry-run=client -o yaml | kubectl apply -f - &

# Question 6: front-end (nginx)
kubectl create deployment front-end --image=nginx:1.21 -n sp-culator --replicas=2 --dry-run=client -o yaml | kubectl apply -f - &

# Question 8: synergy-deployment (default namespace)
kubectl create deployment synergy-deployment --image=nginx:1.21 -n default --dry-run=client -o yaml | kubectl apply -f - &

wait

# Quick readiness check (reduced timeout)
echo "$(date '+%Y-%m-%d %H:%M:%S') | ⏳ Quick readiness check..."
kubectl wait --for=condition=available --timeout=15s deployment/echoserver -n echo-sound || true
kubectl wait --for=condition=available --timeout=15s deployment/busybox-logger -n priority || true
kubectl wait --for=condition=available --timeout=15s deployment/front-end -n sp-culator || true
kubectl wait --for=condition=available --timeout=15s deployment/synergy-deployment -n default || true

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ FAST CKA 2025 exam setup completed!"
echo "$(date '+%Y-%m-%d %H:%M:%S') | 📋 Created essential resources:"
echo "  - Namespaces: echo-sound, priority, sp-culator"
echo "  - Deployments: echoserver, busybox-logger, front-end, synergy-deployment"
echo "  - Services: echoserver-service"

exit 0
