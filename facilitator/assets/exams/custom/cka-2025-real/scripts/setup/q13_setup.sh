#!/bin/bash
# Setup for Question 13: HorizontalPodAutoscaler (HPA) for apache-server
# Creates autoscale namespace and apache-server deployment

echo "Setting up Question 13 environment..."

# Create namespace
kubectl create namespace autoscale

# Create apache-server deployment with resource requests for HPA
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-server
  namespace: autoscale
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache-server
  template:
    metadata:
      labels:
        app: apache-server
    spec:
      containers:
      - name: apache-server
        image: httpd:2.4
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
EOF

echo "Question 13 environment ready: autoscale namespace with apache-server deployment"
