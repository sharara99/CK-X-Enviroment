#!/bin/bash
# Setup for Question 14: NGINX ConfigMap for TLSv1.3
# Creates nginx-static namespace, nginx-static deployment, and nginx-config ConfigMap

echo "Setting up Question 14 environment..."

# Create namespace
kubectl create namespace nginx-static

# Create nginx-config ConfigMap with TLSv1.2 and TLSv1.3 (to be modified to TLSv1.3 only)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: nginx-static
data:
  nginx.conf: |
    events {}
    http {
      server {
        listen 443 ssl;
        ssl_certificate /etc/nginx/tls/tls.crt;
        ssl_certificate_key /etc/nginx/tls/tls.key;
        ssl_protocols TLSv1.2 TLSv1.3;
        location / {
          root /usr/share/nginx/html;
          index index.html;
        }
      }
    }
EOF

# Create nginx-static deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-static
  namespace: nginx-static
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-static
  template:
    metadata:
      labels:
        app: nginx-static
    spec:
      containers:
      - name: nginx-static
        image: nginx:1.21
        ports:
        - containerPort: 443
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        - name: tls-certs
          mountPath: /etc/nginx/tls
      volumes:
      - name: nginx-config
        configMap:
          name: nginx-config
      - name: tls-certs
        secret:
          secretName: nginx-tls
EOF

# Create TLS secret
kubectl create secret tls nginx-tls --cert=/dev/null --key=/dev/null --dry-run=client -o yaml | kubectl apply -f -

echo "Question 14 environment ready: nginx-static namespace with nginx-static deployment and nginx-config ConfigMap"
