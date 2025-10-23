#!/bin/bash
exec >> /proc/1/fd/1 2>&1


# Log function with timestamp
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Set defaults
NUMBER_OF_NODES=${1:-1}
EXAM_ID=${2:-""}

echo "Exam ID: $EXAM_ID"
echo "Number of nodes: $NUMBER_OF_NODES"

#check docker is running
if ! docker info > /dev/null 2>&1; then
  log "Docker is not running"
  log "Attempting to start docker"
  dockerd &
  sleep 2
  #check docker is running 3 times with 2 second interval
  for i in {1..3}; do
    if docker info > /dev/null 2>&1; then
      log "Docker started successfully"
      break
    fi
    log "Docker failed to start, retrying..."
    sleep 2
  done
fi

log "Starting exam environment preparation with $NUMBER_OF_NODES node(s)"

# Validate input
if ! [[ "$NUMBER_OF_NODES" =~ ^[0-9]+$ ]]; then
  log "ERROR: Number of nodes must be a positive integer"
  exit 1
fi

# Setup kind cluster
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null candidate@k8s-api-server "env-setup $NUMBER_OF_NODES $CLUSTER_NAME"

#Pull assets from URL
curl facilitator:3000/api/v1/exams/$EXAM_ID/assets -o assets.tar.gz

mkdir -p /tmp/exam-assets
#Unzip assets
tar -xzvf assets.tar.gz -C /tmp/exam-assets    

#Remove assets.tar.gz
rm assets.tar.gz

#make every file in /tmp/exam-assets executable
find /tmp/exam-assets -type f -exec chmod +x {} \;

echo "Exam assets downloaded and prepared successfully" 

export KUBECONFIG=/home/candidate/.kube/kubeconfig

sleep 2

#wait till api-server is ready (with timeout)
API_CHECK_COUNT=0
while ! kubectl get nodes > /dev/null 2>&1; do
  API_CHECK_COUNT=$((API_CHECK_COUNT+1))
  if [ $API_CHECK_COUNT -gt 30 ]; then
    log "ERROR: API server not ready after 60 seconds"
    exit 1
  fi
  sleep 2
done

echo "API server is ready"

#Run setup scripts in parallel for faster execution
log "Running setup scripts in parallel..."
for script in /tmp/exam-assets/scripts/setup/q*_setup.sh; do 
  if [ -f "$script" ]; then
    bash "$script" &
  fi
done

# Wait for all background jobs to complete
wait
log "All setup scripts completed"

log "Exam environment preparation completed successfully"
exit 0 