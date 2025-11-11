#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="build/macos"
INSTALL_PREFIX="dist/macos"

if ! command -v xcrun >/dev/null 2>&1; then
    echo "[macOS] xcrun not found. Please install Xcode Command Line Tools." >&2
    exit 1
fi

SDK_PATH="$(xcrun --sdk macosx --show-sdk-path 2>/dev/null || true)"
if [[ -z "${SDK_PATH}" ]]; then
    echo "[macOS] Failed to determine the macOS SDK path via xcrun." >&2
    exit 1
fi
echo "[macOS] Using SDK at ${SDK_PATH}"

STDCPP_INCLUDE="${SDK_PATH}/usr/include/c++/v1"
if [[ ! -d "${STDCPP_INCLUDE}" ]]; then
    echo "[macOS] Could not find libc++ headers at ${STDCPP_INCLUDE}." >&2
    exit 1
fi

export SDKROOT="${SDK_PATH}"
if [[ -n "${CPLUS_INCLUDE_PATH:-}" ]]; then
    export CPLUS_INCLUDE_PATH="${STDCPP_INCLUDE}:${CPLUS_INCLUDE_PATH}"
else
    export CPLUS_INCLUDE_PATH="${STDCPP_INCLUDE}"
fi

echo "[macOS] Configuring with CMake..."
cmake -S . -B "${BUILD_DIR}" -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_SYSROOT="${SDK_PATH}" "$@"

echo "[macOS] Building..."
cmake --build "${BUILD_DIR}" --config Release

echo "[macOS] Installing to ${INSTALL_PREFIX}..."
cmake --install "${BUILD_DIR}" --config Release --prefix "${INSTALL_PREFIX}"

echo "[macOS] Done. Binary is in ${INSTALL_PREFIX}/bin."
