# CKA 2025 Real Exam Questions - Complete Solutions

## Question 1: Setting Up kubeadm and cri-dockerd

```bash
# Install cri-dockerd package
sudo dpkg -i ~/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb

# Enable and start cri-docker service
sudo systemctl enable cri-docker
sudo systemctl start cri-docker

# Configure system parameters
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.netfilter.nf_conntrack_max=131072

# Create persistent sysctl configuration
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables=1
net.ipv6.conf.all.forwarding=1
net.netfilter.nf_conntrack_max=131072
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Verify services are running
systemctl status cri-docker
```

## Question 2: Ingress for echoserver-service

```bash
# Create Ingress YAML
cat <<EOF > echo-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  namespace: echo-sound
spec:
  rules:
  - host: example.org
    http:
      paths:
      - path: /echo
        pathType: Prefix
        backend:
          service:
            name: echoserver-service
            port:
              number: 8080
EOF

# Apply Ingress
kubectl apply -f echo-ingress.yaml

# Test endpoint
curl -o /dev/null -s -w "%{http_code}\n" http://example.org/echo

# Debug if needed
kubectl describe ingress echo -n echo-sound
```

## Question 3: Installing CNI (Calico)

```bash
# Install Calico operator
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml

# Verify operator pods are running
kubectl get pods -n tigera-operator

# Check if Network Policy support is available
kubectl get crd | grep networkpolicy
```

## Question 4: Argo CD with Helm

```bash
# Add Argo Helm repository
helm repo add argo https://argoproj.github.io/argo-helm

# Update Helm repositories
helm repo update

# List repositories
helm repo list

# Search Argo CD
helm search repo argo

# Generate template for Argo CD v7.7.3 without CRDs
helm template argocd argo/argo-cd --version 7.7.3 --namespace argocd --set crds.install=false > /argo-helm.yaml

# Verify template was created
ls -la /argo-helm.yaml
```

## Question 5: PriorityClass for busybox-logger

```bash
# Check existing PriorityClasses
kubectl get priorityclass

# Create PriorityClass (assuming highest value is 1000000000)
cat <<EOF > priorityclass.yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 999999999
globalDefault: false
EOF

# Apply PriorityClass
kubectl apply -f priorityclass.yaml

# Edit busybox-logger deployment
kubectl edit deployment busybox-logger -n priority

# Add to spec.template.spec:
# priorityClassName: high-priority

# Restart deployment
kubectl rollout restart deployment busybox-logger -n priority
```

## Question 6: Service and NodePort for front-end

```bash
# Edit front-end deployment to add container port
kubectl -n sp-culator edit deployment front-end

# Add to spec.template.spec.containers[0].ports:
# - containerPort: 80
#   name: http
#   protocol: TCP

# Create NodePort service
cat <<EOF > front-end-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: front-end-svc
  namespace: sp-culator
spec:
  selector:
    app: front-end
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080
  type: NodePort
EOF

# Apply service
kubectl apply -f front-end-svc.yaml

# Verify service
kubectl get svc -n sp-culator
```

## Question 7: StorageClass (low-latency)

```bash
# Create StorageClass
cat <<EOF > low-latency-sc.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: low-latency
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
EOF

# Apply StorageClass
kubectl apply -f low-latency-sc.yaml

# Verify StorageClass
kubectl get sc

# Delete any old default StorageClass if needed
# kubectl delete sc <old-default-sc-name>
```

## Question 8: Sidecar for synergy-deployment

```bash
# Edit synergy-deployment
kubectl edit deployment synergy-deployment -n default

# Add to spec.template.spec:
# volumes:
# - name: shared-logs
#   emptyDir: {}
# containers:
# - name: sidecar
#   image: busybox:stable
#   command: ["/bin/sh", "-c", "tail -n+1 -f /var/log/synergy-deployment.log"]
#   volumeMounts:
#   - name: shared-logs
#     mountPath: /var/log

# Check sidecar logs
kubectl logs <pod-name> -c sidecar -n default
```

## Question 9: cert-manager CRDs

```bash
# Verify cert-manager pods are running
kubectl get pods -n cert-manager

# Extract cert-manager CRDs
kubectl get crd | grep cert-manager > ~/resources.yaml

# Extract Certificate CRD subject specification
kubectl explain certificate.spec.subject > ~/subject.yaml

# Verify files were created
ls -la ~/resources.yaml ~/subject.yaml
```

## Question 10: WordPress Resource Requests

```bash
# Check allocatable resources
kubectl describe node node01 | grep -A 5 Allocatable

# Example calculation (assuming CPU: 2000m, Memory: 4000Mi):
# 10% for node: CPU = 200m, Memory = 400Mi
# 90% for WordPress: CPU = 1800m, Memory = 3600Mi
# Per pod (3 replicas): CPU = 600m, Memory = 1200Mi

# Edit WordPress deployment
kubectl edit deployment wordpress -n relative-fawn

# Update spec:
# replicas: 3
# template:
#   spec:
#     containers:
#     - name: wordpress
#       resources:
#         requests:
#           cpu: 600m
#           memory: 1200Mi
#     initContainers:
#     - name: init-wordpress
#       resources:
#         requests:
#           cpu: 600m
#           memory: 1200Mi

# Verify deployment
kubectl get deployment wordpress -n relative-fawn
kubectl get pods -n relative-fawn
```

## Question 11: MariaDB and PVC

```bash
# Create PVC
cat <<EOF > mariadb-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: mariadb
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
EOF

# Apply PVC
kubectl apply -f mariadb-pvc.yaml

# Edit MariaDB deployment
kubectl edit deployment mariadb -n mariadb

# Add to spec.template.spec:
# volumes:
# - name: mariadb-storage
#   persistentVolumeClaim:
#     claimName: mariadb
# containers:
# - name: mariadb
#   volumeMounts:
#   - name: mariadb-storage
#     mountPath: /var/lib/mysql

# Apply deployment
kubectl apply -f ~/mariadb-deploy.yaml

# Verify pods
kubectl get pods -n mariadb
```

## Question 12: Migration from Ingress to Gateway API

```bash
# Create Gateway
cat <<EOF > web-gateway.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
  namespace: default
spec:
  gatewayClassName: nginx
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: gateway.web.k8s.local
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: web-tls
EOF

# Create HTTPRoute
cat <<EOF > web-route.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: default
spec:
  parentRefs:
  - name: web-gateway
  hostnames:
  - gateway.web.k8s.local
  rules:
  - backendRefs:
    - kind: Service
      name: web
      port: 80
EOF

# Apply Gateway and HTTPRoute
kubectl apply -f web-gateway.yaml
kubectl apply -f web-route.yaml

# Test HTTPS endpoint
curl https://gateway.web.k8s.local

# Delete old Ingress
kubectl delete ingress web -n default
```

## Question 13: HorizontalPodAutoscaler (HPA) for apache-server

```bash
# Create HPA
cat <<EOF > apache-hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: apache-server
  namespace: autoscale
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: apache-server
  minReplicas: 1
  maxReplicas: 4
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
EOF

# Apply HPA
kubectl apply -f apache-hpa.yaml

# Verify HPA
kubectl get hpa -n autoscale

# Verify target deployment
kubectl get deployment apache-server -n autoscale
```

## Question 14: NGINX ConfigMap for TLSv1.3

```bash
# Edit nginx-config ConfigMap
kubectl edit configmap nginx-config -n nginx-static

# Update nginx.conf data section:
# data:
#   nginx.conf: |
#     events {}
#     http {
#       server {
#         listen 443 ssl;
#         ssl_certificate /etc/nginx/tls/tls.crt;
#         ssl_certificate_key /etc/nginx/tls/tls.key;
#         ssl_protocols TLSv1.3;
#         location / {
#           root /usr/share/nginx/html;
#           index index.html;
#         }
#       }
#     }

# Restart deployment
kubectl rollout restart deployment nginx-static -n nginx-static

# Test TLSv1.2 failure (should fail)
curl --tls-max 1.2 https://web.k8s.local

# Test TLSv1.3 (should work)
curl --tls-max 1.3 https://web.k8s.local
```

## Exam Day Tips

- Use `k` instead of `kubectl` to save time
- Always use `-n <namespace>` for namespace-specific commands
- Practice `kubectl edit` and `kubectl apply` daily
- Skip tough questions and return later
- If cluster has issues, check with `crictl ps -a`
- Verify your work before moving to next question
