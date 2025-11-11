#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="build/macos"
INSTALL_PREFIX="dist/macos"
WX_CONFIG="$(command -v wx-config || true)"

if [[ -z "${WX_CONFIG}" ]]; then
  echo "[macOS] wx-config not found. Install wxWidgets first (brew install wxwidgets)."
  exit 1
fi

echo "[macOS] Configuring with CMake..."
cmake -S . -B "${BUILD_DIR}" -DCMAKE_BUILD_TYPE=Release -DwxWidgets_CONFIG_EXECUTABLE="${WX_CONFIG}" "${@}"

echo "[macOS] Building..."
cmake --build "${BUILD_DIR}" --config Release

echo "[macOS] Installing to ${INSTALL_PREFIX}..."
cmake --install "${BUILD_DIR}" --config Release --prefix "${INSTALL_PREFIX}"

echo "[macOS] Done. Binary is in ${INSTALL_PREFIX}/bin."
