#!/usr/bin/env bash
# Runs inside the marktext-build container. Produces Linux amd64 .deb (and other artifacts).
# Invoked by indockerbuild.sh from the host: docker run ... "cd ${TOPDIR} && time ./builder.sh"
# Container runs as root so postinstall can write to node_modules; we chown results to HOST_UID:HOST_GID at the end.
set -e
export MARKTEXT_IS_STABLE=1
TOPDIR="${1:-.}"
cd "${TOPDIR}"

# So container root can run node-gyp/electron-builder without EACCES on leftover host-owned dirs
if [ -n "${HOST_UID:-}" ] && [ -n "${HOST_GID:-}" ]; then
  chown -R root:root node_modules build 2>/dev/null || true
fi

echo "==> Installing dependencies (yarn install)..."
yarn install --check-files --frozen-lockfile

if [ -x node_modules/vscode-ripgrep/bin/rg ]; then
  echo "==> Stripping ripgrep binary..."
  strip node_modules/vscode-ripgrep/bin/rg || true
fi

echo "==> Building Linux amd64 (deb, AppImage, rpm, tar.gz)..."
yarn run release:linux

echo "==> Build artifacts in build/:"
ls -la build/ 2>/dev/null || true
if ls build/*.deb 1>/dev/null 2>&1; then
  echo "==> .deb package(s):"
  ls -la build/*.deb
else
  echo "==> No .deb found!"
  exit 1
fi

# So host user owns build artifacts and node_modules (container runs as root)
if [ -n "${HOST_UID:-}" ] && [ -n "${HOST_GID:-}" ]; then
  echo "==> Fixing ownership to ${HOST_UID}:${HOST_GID}..."
  chown -R "${HOST_UID}:${HOST_GID}" build node_modules 2>/dev/null || true
fi
