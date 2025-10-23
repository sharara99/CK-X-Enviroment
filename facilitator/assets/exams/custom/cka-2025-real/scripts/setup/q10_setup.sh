#!/bin/bash
# Setup for Question 10: WordPress Resource Requests
# Creates relative-fawn namespace and wordpress deployment

echo "Setting up Question 10 environment..."

# Create namespace
kubectl create namespace relative-fawn

# Create wordpress deployment with init container
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  namespace: relative-fawn
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      initContainers:
      - name: init-wordpress
        image: busybox:stable
        command: ['sh', '-c', 'echo "WordPress init complete"']
      containers:
      - name: wordpress
        image: wordpress:5.8
        ports:
        - containerPort: 80
        env:
        - name: WORDPRESS_DB_HOST
          value: "localhost"
        - name: WORDPRESS_DB_USER
          value: "wordpress"
        - name: WORDPRESS_DB_PASSWORD
          value: "wordpress"
        - name: WORDPRESS_DB_NAME
          value: "wordpress"
EOF

echo "Question 10 environment ready: relative-fawn namespace with wordpress deployment"
