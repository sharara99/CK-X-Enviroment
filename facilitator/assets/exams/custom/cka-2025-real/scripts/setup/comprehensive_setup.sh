#!/bin/bash
# Comprehensive setup for CKA 2025 exam questions
# This script creates all required namespaces, deployments, and services

echo "$(date '+%Y-%m-%d %H:%M:%S') | 🚀 Starting comprehensive CKA 2025 exam setup..."

# Pre-pull common images for faster deployments
echo "$(date '+%Y-%m-%d %H:%M:%S') | 📦 Pre-pulling common images..."
docker pull k8s.gcr.io/echoserver:1.4 &
docker pull busybox:stable &
docker pull nginx:1.21 &
docker pull wordpress:latest &
docker pull mariadb:latest &
docker pull httpd:latest &
docker pull nginx:latest &
wait
echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ Images pre-pulled successfully"

# Create all required namespaces in parallel
echo "$(date '+%Y-%m-%d %H:%M:%S') | 📁 Creating namespaces..."
kubectl create namespace echo-sound --dry-run=client -o yaml | kubectl apply -f - &
kubectl create namespace priority --dry-run=client -o yaml | kubectl apply -f - &
kubectl create namespace sp-culator --dry-run=client -o yaml | kubectl apply -f - &
kubectl create namespace relative-fawn --dry-run=client -o yaml | kubectl apply -f - &
kubectl create namespace mariadb --dry-run=client -o yaml | kubectl apply -f - &
kubectl create namespace autoscale --dry-run=client -o yaml | kubectl apply -f - &
kubectl create namespace nginx-static --dry-run=client -o yaml | kubectl apply -f - &
kubectl create namespace app-team1 --dry-run=client -o yaml | kubectl apply -f - &
wait

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ All namespaces created"

# Question 2: Create echoserver deployment and service in echo-sound namespace
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Setting up Question 2: echoserver-service..."
kubectl create deployment echoserver --image=k8s.gcr.io/echoserver:1.4 -n echo-sound --dry-run=client -o yaml | kubectl apply -f -
kubectl expose deployment echoserver --port=8080 --target-port=8080 --name=echoserver-service -n echo-sound --dry-run=client -o yaml | kubectl apply -f -

# Question 5: Create busybox-logger deployment in priority namespace
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Setting up Question 5: busybox-logger..."
kubectl create deployment busybox-logger --image=busybox:stable -n priority --replicas=1 --dry-run=client -o yaml | kubectl apply -f -
kubectl patch deployment busybox-logger -n priority -p '{"spec":{"template":{"spec":{"containers":[{"name":"busybox-logger","image":"busybox:stable","command":["sleep","3600"]}]}}}}' --dry-run=client -o yaml | kubectl apply -f -

# Question 6: Create front-end deployment in sp-culator namespace
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Setting up Question 6: front-end..."
kubectl create deployment front-end --image=nginx:1.21 -n sp-culator --replicas=2 --dry-run=client -o yaml | kubectl apply -f -
kubectl label deployment front-end app=front-end -n sp-culator --overwrite

# Question 8: Create synergy-deployment in default namespace
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Setting up Question 8: synergy-deployment..."
kubectl create deployment synergy-deployment --image=nginx:1.21 -n default --dry-run=client -o yaml | kubectl apply -f -

# Question 10: Create wordpress deployment in relative-fawn namespace
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Setting up Question 10: wordpress..."
kubectl create deployment wordpress --image=wordpress:latest -n relative-fawn --replicas=3 --dry-run=client -o yaml | kubectl apply -f -

# Question 11: Create mariadb deployment in mariadb namespace
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Setting up Question 11: mariadb..."
kubectl create deployment mariadb --image=mariadb:latest -n mariadb --dry-run=client -o yaml | kubectl apply -f -

# Question 13: Create apache-server deployment in autoscale namespace
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Setting up Question 13: apache-server..."
kubectl create deployment apache-server --image=httpd:latest -n autoscale --dry-run=client -o yaml | kubectl apply -f -

# Question 14: Create nginx-static deployment and configmap in nginx-static namespace
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Setting up Question 14: nginx-static..."
kubectl create deployment nginx-static --image=nginx:latest -n nginx-static --dry-run=client -o yaml | kubectl apply -f -
kubectl create configmap nginx-config -n nginx-static --from-literal=nginx.conf='events {}
http {
  server {
    listen 80;
    location / {
      root /usr/share/nginx/html;
      index index.html;
    }
  }
}' --dry-run=client -o yaml | kubectl apply -f -

# Question 15: Create NetworkPolicy scenario resources
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Setting up Question 15: NetworkPolicy Selection..."
kubectl create namespace frontend --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace backend --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace database --dry-run=client -o yaml | kubectl apply -f -
kubectl label namespace frontend name=frontend --overwrite
kubectl label namespace backend name=backend --overwrite
kubectl label namespace database name=database --overwrite

# Create frontend deployment
kubectl create deployment frontend-app --image=nginx:alpine -n frontend --replicas=2 --dry-run=client -o yaml | kubectl apply -f -

# Create backend deployment
kubectl create deployment backend-api --image=nginx:alpine -n backend --replicas=2 --dry-run=client -o yaml | kubectl apply -f -

# Create database deployment
kubectl create deployment database --image=mysql:8.0 -n database --replicas=1 --dry-run=client -o yaml | kubectl apply -f -

# Create sample NetworkPolicies for selection
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-allow-all
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend-api
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - {}
  egress:
  - {}
EOF

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-deny-all
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend-api
  policyTypes:
  - Ingress
  - Egress
EOF

# Question 16: Troubleshooting scenario (no additional resources needed)
echo "$(date '+%Y-%m-%d %H:%M:%S') | 🔧 Setting up Question 16: Troubleshooting kube-apiserver and kube-scheduler..."
echo "Scenario: kube-apiserver and kube-scheduler are not working"
echo "etcd, kube-controller-manager, and kubelet are working"

# Wait for deployments to be ready - OPTIMIZED (reduced timeout)
echo "$(date '+%Y-%m-%d %H:%M:%S') | ⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=30s deployment/echoserver -n echo-sound || true
kubectl wait --for=condition=available --timeout=30s deployment/busybox-logger -n priority || true
kubectl wait --for=condition=available --timeout=30s deployment/front-end -n sp-culator || true
kubectl wait --for=condition=available --timeout=30s deployment/synergy-deployment -n default || true
kubectl wait --for=condition=available --timeout=30s deployment/wordpress -n relative-fawn || true
kubectl wait --for=condition=available --timeout=30s deployment/mariadb -n mariadb || true
kubectl wait --for=condition=available --timeout=30s deployment/apache-server -n autoscale || true
kubectl wait --for=condition=available --timeout=30s deployment/nginx-static -n nginx-static || true
kubectl wait --for=condition=available --timeout=30s deployment/frontend-app -n frontend || true
kubectl wait --for=condition=available --timeout=30s deployment/backend-api -n backend || true
kubectl wait --for=condition=available --timeout=30s deployment/database -n database || true

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ CKA 2025 exam setup completed successfully!"
echo "$(date '+%Y-%m-%d %H:%M:%S') | 📋 Created resources:"
echo "  - Namespaces: echo-sound, priority, sp-culator, relative-fawn, mariadb, autoscale, nginx-static, app-team1, frontend, backend, database"
echo "  - Deployments: echoserver, busybox-logger, front-end, synergy-deployment, wordpress, mariadb, apache-server, nginx-static, frontend-app, backend-api, database"
echo "  - Services: echoserver-service"
echo "  - ConfigMaps: nginx-config"
echo "  - NetworkPolicies: backend-allow-all, backend-deny-all (for selection)"

exit 0
