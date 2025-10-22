#!/bin/bash
# q1_s2_validate_sysctl.sh - Validate system parameters are configured

set -e

# Check if sysctl parameters are set
if sysctl net.bridge.bridge-nf-call-iptables | grep -q "1" && \
   sysctl net.ipv4.ip_forward | grep -q "1" && \
   sysctl net.ipv6.conf.all.forwarding | grep -q "1"; then
    echo "0"  # Success
else
    echo "1"  # Parameters not configured
fi
