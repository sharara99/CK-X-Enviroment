#!/bin/bash

# ===============================================================================
#   CKA 2025 Exam Resources Setup Script
#   Purpose: Create all required namespaces, deployments, services, and resources
#            needed for CKA exam questions
# ===============================================================================

echo "$(date '+%Y-%m-%d %H:%M:%S') | ===== CKA RESOURCES SETUP STARTED ====="

# Wait for cluster to be ready
echo "$(date '+%Y-%m-%d %H:%M:%S') | Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# ===============================================================================
#   Create Namespaces
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating namespaces..."

kubectl create namespace echo-sound --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace priority --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace sp-culator --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace relative-fawn --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace mariadb --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace autoscale --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace nginx-static --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace cert-manager --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace tigera-operator --dry-run=client -o yaml | kubectl apply -f -

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ Namespaces created successfully"

# ===============================================================================
#   Create echo-sound namespace resources (Question 2)
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating echo-sound resources..."

# Create echoserver-service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: echoserver-service
  namespace: echo-sound
spec:
  selector:
    app: echoserver
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
EOF

# Create echoserver deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echoserver
  namespace: echo-sound
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echoserver
  template:
    metadata:
      labels:
        app: echoserver
    spec:
      containers:
      - name: echoserver
        image: k8s.gcr.io/echoserver:1.10
        ports:
        - containerPort: 8080
EOF

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ echo-sound resources created"

# ===============================================================================
#   Create priority namespace resources (Question 5)
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating priority namespace resources..."

# Create busybox-logger deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-logger
  namespace: priority
spec:
  replicas: 1
  selector:
    matchLabels:
      app: busybox-logger
  template:
    metadata:
      labels:
        app: busybox-logger
    spec:
      containers:
      - name: busybox-logger
        image: busybox:stable
        command: ["/bin/sh", "-c", "while true; do echo 'Logging...'; sleep 10; done"]
EOF

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ priority namespace resources created"

# ===============================================================================
#   Create sp-culator namespace resources (Question 6)
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating sp-culator namespace resources..."

# Create front-end deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: front-end
  namespace: sp-culator
spec:
  replicas: 1
  selector:
    matchLabels:
      app: front-end
  template:
    metadata:
      labels:
        app: front-end
    spec:
      containers:
      - name: front-end
        image: nginx:alpine
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
EOF

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ sp-culator namespace resources created"

# ===============================================================================
#   Create default namespace resources (Question 8)
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating default namespace resources..."

# Create synergy-deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: synergy-deployment
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: synergy
  template:
    metadata:
      labels:
        app: synergy
    spec:
      containers:
      - name: synergy
        image: nginx:alpine
        command: ["/bin/sh", "-c", "while true; do echo 'Synergy running...' >> /var/log/synergy-deployment.log; sleep 5; done"]
        volumeMounts:
        - name: shared-logs
          mountPath: /var/log
      volumes:
      - name: shared-logs
        emptyDir: {}
EOF

# Create web service for Gateway API (Question 12)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: default
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
EOF

# Create web deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: nginx:alpine
        ports:
        - containerPort: 80
EOF

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ default namespace resources created"

# ===============================================================================
#   Create relative-fawn namespace resources (Question 10)
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating relative-fawn namespace resources..."

# Create WordPress deployment
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
        command: ["/bin/sh", "-c", "echo 'WordPress initialization complete'"]
      containers:
      - name: wordpress
        image: wordpress:latest
        ports:
        - containerPort: 80
EOF

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ relative-fawn namespace resources created"

# ===============================================================================
#   Create mariadb namespace resources (Question 11)
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating mariadb namespace resources..."

# Create MariaDB deployment
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
        image: mariadb:latest
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "password"
        ports:
        - containerPort: 3306
EOF

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ mariadb namespace resources created"

# ===============================================================================
#   Create autoscale namespace resources (Question 13)
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating autoscale namespace resources..."

# Create apache-server deployment
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
        image: httpd:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
EOF

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ autoscale namespace resources created"

# ===============================================================================
#   Create nginx-static namespace resources (Question 14)
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating nginx-static namespace resources..."

# Create nginx-config ConfigMap (without TLS for exam practice)
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
        listen 80;
        location / {
          root /usr/share/nginx/html;
          index index.html;
        }
      }
    }
EOF

# Create nginx-static deployment (without TLS volumes)
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
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
      volumes:
      - name: nginx-config
        configMap:
          name: nginx-config
EOF

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ nginx-static namespace resources created"

# ===============================================================================
#   Create StorageClass (Question 7)
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Creating StorageClass..."

cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: low-latency
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
EOF

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ StorageClass created"

# ===============================================================================
#   Wait for all deployments to be ready
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | Waiting for all deployments to be ready..."

kubectl wait --for=condition=Available deployment/echoserver -n echo-sound --timeout=300s
kubectl wait --for=condition=Available deployment/busybox-logger -n priority --timeout=300s
kubectl wait --for=condition=Available deployment/front-end -n sp-culator --timeout=300s
kubectl wait --for=condition=Available deployment/synergy-deployment -n default --timeout=300s
kubectl wait --for=condition=Available deployment/web -n default --timeout=300s
kubectl wait --for=condition=Available deployment/wordpress -n relative-fawn --timeout=300s
kubectl wait --for=condition=Available deployment/mariadb -n mariadb --timeout=300s
kubectl wait --for=condition=Available deployment/apache-server -n autoscale --timeout=300s
kubectl wait --for=condition=Available deployment/nginx-static -n nginx-static --timeout=300s

echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ All deployments are ready"

# ===============================================================================
#   Display summary
# ===============================================================================
echo "$(date '+%Y-%m-%d %H:%M:%S') | ===== CKA RESOURCES SETUP COMPLETED ====="
echo "$(date '+%Y-%m-%d %H:%M:%S') | Summary of created resources:"
echo ""
echo "Namespaces:"
kubectl get namespaces | grep -E "(echo-sound|priority|sp-culator|relative-fawn|mariadb|autoscale|nginx-static|argocd|cert-manager|tigera-operator)"
echo ""
echo "Deployments:"
kubectl get deployments --all-namespaces | grep -E "(echoserver|busybox-logger|front-end|synergy-deployment|web|wordpress|mariadb|apache-server|nginx-static)"
echo ""
echo "Services:"
kubectl get services --all-namespaces | grep -E "(echoserver-service|web)"
echo ""
echo "StorageClass:"
kubectl get storageclass
echo ""
echo "$(date '+%Y-%m-%d %H:%M:%S') | ✅ All CKA exam resources are ready!"
