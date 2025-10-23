#!/bin/bash
# Setup for Question 11: MariaDB and PVC
# Creates mariadb namespace and mariadb deployment

echo "Setting up Question 11 environment..."

# Create namespace
kubectl create namespace mariadb

# Create mariadb deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: mariadb:10.6
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "rootpassword"
        - name: MYSQL_DATABASE
          value: "testdb"
        - name: MYSQL_USER
          value: "testuser"
        - name: MYSQL_PASSWORD
          value: "testpass"
EOF

echo "Question 11 environment ready: mariadb namespace with mariadb deployment"
