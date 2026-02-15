#!/usr/bin/env bash
# Build the MarkText Linux build Docker image.
# Logs to container-build-log-YYYY-MM-DD-HH-MM-SS.log.txt (same pattern as manifest-1.1).
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg USER=$USER -t marktext-build:latest . 2>&1 | tee "container-build-log-$(date +'%Y-%m-%d-%H-%M-%S').log.txt"
echo "Image marktext-build:latest built successfully."
