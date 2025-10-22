#!/bin/bash
# q9_s2_validate_crd_files.sh - Validate CRD files are extracted correctly

set -e

# Check if CRD files exist
if [ -f "~/resources.yaml" ] && [ -f "~/subject.yaml" ]; then
    echo "0"  # Success
else
    echo "1"  # Files not found
fi
