#!/bin/bash

POD_NAME="busybox-all-probes"
# EXPECTED_IMAGE="nginx"
# EXPECTED_PORT=80
# EXPECTED_LIVENESS_INITIAL_DELAY=5
# EXPECTED_LIVENESS_PERIOD=3
# EXPECTED_LIVENESS_FAILURE_THRESHOLD=8

if ! kubectl get pod "$POD_NAME" -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "Pod '$POD_NAME' does not exist in namespace '$NAMESPACE'."
    exit 1
fi

echo "Pod '$POD_NAME' exists in namespace '$NAMESPACE'."