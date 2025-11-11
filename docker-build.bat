@echo off
setlocal

set IMAGE_NAME=cross-platform-hello-builder

where docker >nul 2>nul
if errorlevel 1 (
    echo [docker] Docker CLI not found. Please install Docker Desktop first.
    exit /b 1
)

echo [docker] Building %IMAGE_NAME% image...
docker build -t %IMAGE_NAME% .
if errorlevel 1 (
    echo [docker] Image build failed.
    exit /b 1
)

echo [docker] Running builds inside container...
docker run --rm -v "%cd%:/work" %IMAGE_NAME% ^
    /bin/bash -lc "/work/scripts/build-all.sh"
if errorlevel 1 (
    echo [docker] Container build failed.
    exit /b 1
)

echo [docker] Build complete. See dist\ for outputs.
exit /b 0
