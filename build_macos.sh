#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="build/macos"
INSTALL_PREFIX="dist/macos"

echo "[macOS] Configuring with CMake..."
cmake -S . -B "${BUILD_DIR}" -DCMAKE_BUILD_TYPE=Release "${@}"

echo "[macOS] Building..."
cmake --build "${BUILD_DIR}" --config Release

echo "[macOS] Installing to ${INSTALL_PREFIX}..."
cmake --install "${BUILD_DIR}" --config Release --prefix "${INSTALL_PREFIX}"

echo "[macOS] Done. Binary is in ${INSTALL_PREFIX}/bin."
