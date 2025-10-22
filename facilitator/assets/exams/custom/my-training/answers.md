# Custom Training Questions - Answers

## Question 1: Create a Simple Pod

```bash
# Create the pod with label
kubectl run my-pod --image=nginx:latest --labels=app=my-app

# Verify the pod
kubectl get pods my-pod
kubectl get pods my-pod --show-labels
```

## Question 2: Create ConfigMap and Pod with Environment Variables

```bash
# Create ConfigMap
kubectl create configmap my-config \
  --from-literal=database_url=mysql://localhost:3306/mydb \
  --from-literal=debug=true

# Create pod with ConfigMap as environment variables
kubectl run app-pod --image=busybox --env-from=configmap/my-config --command -- sleep 3600

# Verify
kubectl get configmap my-config -o yaml
kubectl exec app-pod -- env | grep -E "(database_url|debug)"
```

## Question 3: Create Deployment and Service

```bash
# Create deployment
kubectl create deployment web-deployment --image=nginx:1.20 --replicas=2

# Expose as service
kubectl expose deployment web-deployment --name=web-service --port=80 --target-port=80

# Verify
kubectl get deployment web-deployment
kubectl get service web-service
kubectl get pods -l app=web-deployment
```
