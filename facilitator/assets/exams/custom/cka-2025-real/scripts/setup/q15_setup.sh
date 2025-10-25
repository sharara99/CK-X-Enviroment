#!/bin/bash

# ===============================================================================
#   Question 15: NetworkPolicy Selection Setup
#   Purpose: Create resources for NetworkPolicy selection scenario
# ===============================================================================

echo "$(date '+%Y-%m-%d %H:%M:%S') | Setting up Question 15: NetworkPolicy Selection"

# Create namespaces with labels
kubectl create namespace frontend --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace backend --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace database --dry-run=client -o yaml | kubectl apply -f -

# Add labels to namespaces
kubectl label namespace frontend name=frontend --overwrite
kubectl label namespace backend name=backend --overwrite
kubectl label namespace database name=database --overwrite

# Create frontend deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-app
  namespace: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend-app
  template:
    metadata:
      labels:
        app: frontend-app
    spec:
      containers:
      - name: frontend-app
        image: nginx:alpine
        ports:
        - containerPort: 80
EOF

# Create backend deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-api
  namespace: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend-api
  template:
    metadata:
      labels:
        app: backend-api
    spec:
      containers:
      - name: backend-api
        image: nginx:alpine
        ports:
        - containerPort: 8080
EOF

# Create database deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: database
  namespace: database
spec:
  replicas: 1
  selector:
    matchLabels:
      app: database
  template:
    metadata:
      labels:
        app: database
    spec:
      containers:
      - name: database
        image: mysql:8.0
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "password"
        ports:
        - containerPort: 3306
EOF

# Create sample NetworkPolicies for selection (these will be the "wrong" options)
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

# Wait for deployments to be ready
kubectl wait --for=condition=Available deployment/frontend-app -n frontend --timeout=300s
kubectl wait --for=condition=Available deployment/backend-api -n backend --timeout=300s
kubectl wait --for=condition=Available deployment/database -n database --timeout=300s

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ Question 15 setup completed"
echo "Scenario: Backend pods should only have ingress traffic from the frontend namespace"
echo "Available NetworkPolicies to choose from:"
echo "1. backend-allow-all (allows all traffic)"
echo "2. backend-deny-all (denies all traffic)"
echo "3. Create new NetworkPolicy (correct answer)"
