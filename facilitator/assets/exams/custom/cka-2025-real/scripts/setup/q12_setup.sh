#!/bin/bash
# Setup for Question 12: Migration from Ingress to Gateway API
# Creates web service and web-tls secret in default namespace

echo "Setting up Question 12 environment..."

# Create web service
kubectl create deployment web --image=nginx:1.21 --replicas=2
kubectl expose deployment web --port=80 --target-port=80 --name=web

# Create web-tls secret
kubectl create secret tls web-tls --cert=/dev/null --key=/dev/null --dry-run=client -o yaml | kubectl apply -f -

# Create old ingress web (to be migrated)
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
  namespace: default
spec:
  rules:
  - host: gateway.web.k8s.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web
            port:
              number: 80
EOF

echo "Question 12 environment ready: web service and web-tls secret in default namespace"
