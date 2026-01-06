#!/bin/bash
# q1_s2_validate_sysctl.sh - Validate system parameters are configured

set -e

# Check if all required sysctl parameters are set correctly
# Required parameters:
# - net.ipv6.conf.all.forwarding=1
# - net.ipv4.ip_forward=1
# - net.netfilter.nf_conntrack_max=131072
# - net.bridge.bridge-nf-call-iptables=1

ERROR_COUNT=0

# Check net.ipv6.conf.all.forwarding
if sysctl net.ipv6.conf.all.forwarding 2>/dev/null | grep -q "= 1"; then
    echo "✓ net.ipv6.conf.all.forwarding=1 is set"
else
    echo "✗ net.ipv6.conf.all.forwarding is not set to 1"
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check net.ipv4.ip_forward
if sysctl net.ipv4.ip_forward 2>/dev/null | grep -q "= 1"; then
    echo "✓ net.ipv4.ip_forward=1 is set"
else
    echo "✗ net.ipv4.ip_forward is not set to 1"
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check net.netfilter.nf_conntrack_max
if sysctl net.netfilter.nf_conntrack_max 2>/dev/null | grep -q "= 131072"; then
    echo "✓ net.netfilter.nf_conntrack_max=131072 is set"
else
    echo "✗ net.netfilter.nf_conntrack_max is not set to 131072"
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

# Check net.bridge.bridge-nf-call-iptables
if sysctl net.bridge.bridge-nf-call-iptables 2>/dev/null | grep -q "= 1"; then
    echo "✓ net.bridge.bridge-nf-call-iptables=1 is set"
else
    echo "✗ net.bridge.bridge-nf-call-iptables is not set to 1"
    ERROR_COUNT=$((ERROR_COUNT + 1))
fi

if [ $ERROR_COUNT -eq 0 ]; then
    echo "0"  # Success - all parameters configured correctly
    exit 0
else
    echo "1"  # Failure - one or more parameters not configured
    exit 1
fi
