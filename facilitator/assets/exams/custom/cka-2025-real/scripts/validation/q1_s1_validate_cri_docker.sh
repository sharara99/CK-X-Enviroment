#!/bin/bash
# q1_s1_validate_cri_docker.sh - Validate cri-docker service is running

set -e

# Check if cri-docker service is running
if systemctl is-active --quiet cri-docker; then
    echo "0"  # Success
else
    echo "1"  # Service not running
fi
