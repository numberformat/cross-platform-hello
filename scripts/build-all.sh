#!/usr/bin/env bash
set -euo pipefail

WORKDIR="/work"
BUILD_DIR="${WORKDIR}/build"
DIST_DIR="${WORKDIR}/dist"
LINUX_WX_CONFIG="$(command -v wx-config || true)"
WINDOWS_WX_CONFIG="/opt/mingw-wx/bin/wx-config"

if [[ -z "${LINUX_WX_CONFIG}" || ! -x "${WINDOWS_WX_CONFIG}" ]]; then
  echo "[docker] wx-config binaries not found. Did the image install wxWidgets packages?"
  exit 1
fi

echo "[docker] Cleaning previous build outputs..."
rm -rf "${BUILD_DIR}" "${DIST_DIR}"
mkdir -p "${BUILD_DIR}/linux" "${BUILD_DIR}/windows" "${DIST_DIR}"

echo "[docker] Building native Linux binary..."
cmake -S "${WORKDIR}" -B "${BUILD_DIR}/linux" -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DwxWidgets_CONFIG_EXECUTABLE="${LINUX_WX_CONFIG}"
cmake --build "${BUILD_DIR}/linux" --config Release
cmake --install "${BUILD_DIR}/linux" --config Release --prefix "${DIST_DIR}/linux"

echo "[docker] Cross-compiling Windows binary via MinGW..."
cmake -S "${WORKDIR}" -B "${BUILD_DIR}/windows" -G Ninja \
  -DCMAKE_SYSTEM_NAME=Windows \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc \
  -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++ \
  -DCMAKE_RC_COMPILER=x86_64-w64-mingw32-windres \
  -DwxWidgets_CONFIG_EXECUTABLE="${WINDOWS_WX_CONFIG}" \
  -DwxWidgets_ROOT_DIR="/opt/mingw-wx"
cmake --build "${BUILD_DIR}/windows" --config Release
cmake --install "${BUILD_DIR}/windows" --config Release --prefix "${DIST_DIR}/windows"

echo "[docker] Done. Artifacts are under dist/linux and dist/windows."
