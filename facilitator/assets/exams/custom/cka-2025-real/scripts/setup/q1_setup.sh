#!/bin/bash
# q1_setup.sh - Setup script for Question 1: Installing cri-dockerd and configuring sysctl

set -e

echo "Setting up Question 1: cri-dockerd installation and sysctl configuration"

# Create directory for deb package
mkdir -p /tmp/q1

# Download cri-dockerd deb package
# Using the specific version required for the exam
CRI_DOCKERD_VERSION="0.3.9"
CRI_DOCKERD_DEB="cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb"
CRI_DOCKERD_URL="https://github.com/Mirantis/cri-dockerd/releases/download/v${CRI_DOCKERD_VERSION}/${CRI_DOCKERD_DEB}"

echo "Downloading cri-dockerd package to /tmp/q1..."
cd /tmp/q1

# Try downloading the specific version first
if wget -q --timeout=30 "${CRI_DOCKERD_URL}" -O "${CRI_DOCKERD_DEB}" 2>/dev/null; then
    echo "✓ Package downloaded successfully from GitHub releases"
else
    echo "Warning: Failed to download specific version, trying latest release..."
    # Fallback: try to get latest release
    LATEST_URL=$(curl -s --max-time 10 https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest 2>/dev/null | grep "browser_download_url.*amd64.deb" | head -1 | cut -d '"' -f 4)
    if [ -n "$LATEST_URL" ]; then
        if wget -q --timeout=30 "${LATEST_URL}" -O "${CRI_DOCKERD_DEB}" 2>/dev/null; then
            echo "✓ Package downloaded successfully from latest release"
        else
            echo "✗ Warning: Failed to download from latest release"
        fi
    else
        echo "✗ Warning: Could not determine download URL"
    fi
fi

# Verify package was downloaded
if [ -f "/tmp/q1/${CRI_DOCKERD_DEB}" ]; then
    echo "✓ Package downloaded successfully to /tmp/q1/${CRI_DOCKERD_DEB}"
    ls -lh /tmp/q1/${CRI_DOCKERD_DEB}
else
    echo "✗ ERROR: Package download failed. The package should be available at:"
    echo "  URL: ${CRI_DOCKERD_URL}"
    echo "  Or latest: https://github.com/Mirantis/cri-dockerd/releases/latest"
fi

# Note: The actual installation will be done by the candidate
# This script only prepares the environment by downloading the package

echo "Setup complete. Package is available at /tmp/q1/${CRI_DOCKERD_DEB}"

