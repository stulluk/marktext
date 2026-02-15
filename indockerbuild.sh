#!/usr/bin/env bash
# Run the MarkText Linux build inside Docker (same pattern as manifest-1.1).
# Usage: ./indockerbuild.sh [number_of_cpus]
#   number_of_cpus: optional, default = all CPUs. Build runs in container with TOPDIR mounted, as current user.
#set -euo pipefail
#set -x

TOPDIR=$(pwd)

# Optional: limit CPUs (first argument)
TOTAL_CPUS=$(nproc --all 2>/dev/null || echo 4)
if [ "$#" -ge 1 ]; then
  CPU_SET=$1
  if ! [[ $CPU_SET =~ ^[0-9]+$ ]]; then
    echo "Error: First argument must be a number (CPUs to use)."
    exit 1
  fi
  if [ "$CPU_SET" -gt "$TOTAL_CPUS" ] || [ "$CPU_SET" -lt 1 ]; then
    echo "Error: CPUs must be between 1 and ${TOTAL_CPUS}."
    exit 1
  fi
else
  CPU_SET=$TOTAL_CPUS
fi

CONTAINER_IMAGE="marktext-build:latest"

cleanup_docker() {
  docker ps --filter "ancestor=${CONTAINER_IMAGE}" --format "{{.ID}}" | xargs -r docker stop > /dev/null 2>&1 || true
}

trap cleanup_docker EXIT

# Pass host UID/GID so builder.sh can chown artifacts to host user (container runs as root for postinstall)
HOST_UID=$(id -u)
HOST_GID=$(id -g)

# Optional: mount .ssh for git (read-only)
SSH_MOUNT=""
if [ -d "${HOME}/.ssh" ]; then
  SSH_MOUNT="--volume=${HOME}/.ssh:${HOME}/.ssh:ro"
fi

docker run --cpuset-cpus="0-$(($CPU_SET - 1))" --rm \
  -v "${TOPDIR}:${TOPDIR}" \
  --volume="/etc/group:/etc/group:ro" \
  --volume="/etc/passwd:/etc/passwd:ro" \
  --volume="/etc/shadow:/etc/shadow:ro" \
  ${SSH_MOUNT} \
  -e MARKTEXT_IS_STABLE=1 \
  -e HOST_UID="${HOST_UID}" \
  -e HOST_GID="${HOST_GID}" \
  -w "${TOPDIR}" \
  ${CONTAINER_IMAGE} \
  /bin/bash -c "cd ${TOPDIR} && time ./builder.sh ${TOPDIR}"
