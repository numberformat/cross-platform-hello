#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="cross-platform-hello-builder"

if ! command -v docker >/dev/null 2>&1; then
  echo "[docker] Docker CLI not found. Please install Docker Desktop or Engine."
  exit 1
fi

echo "[docker] Building ${IMAGE_NAME} image..."
docker build -t "${IMAGE_NAME}" .

echo "[docker] Running builds inside container..."
docker run --rm -v "$(pwd):/work" "${IMAGE_NAME}" /bin/bash -lc "/work/scripts/build-all.sh"

echo "[docker] Build complete. See dist/ for outputs."
