# Cross Platform Hello

Simple C++ “Hello World” that builds on Linux, macOS, and Windows using CMake. The repository also ships a GitHub Actions workflow that runs native compilers on each platform, publishes the resulting binaries as artifacts, and automatically creates GitHub Releases when you push a tag.

## Prerequisites

This sample uses wxWidgets 3.2+ for the UI. Install the library (and its headers) on whichever platforms you build natively:

- **macOS**: `brew install wxwidgets`
- **Ubuntu/Debian**: `sudo apt-get install libgtk-3-dev libwxgtk3.2-dev`
- **Fedora/RHEL**: `sudo dnf install wxGTK3-devel`
- **Windows (MSVC)**: download/build wxWidgets and point CMake at the install prefix with `-DwxWidgets_ROOT_DIR=...` (GitHub Actions automates this step).

`cmake` 3.15+ and a C++17 compiler are still required on every platform.

## Build locally

1. Configure the project:

   ```bash
   cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
   ```

2. Build and (optionally) install:

   ```bash
   cmake --build build --config Release
   cmake --install build --config Release --prefix dist
   ```

   The executable ends up in `build/cross_platform_hello` on single-config generators (Linux/macOS) or `build/Release/cross_platform_hello.exe` on multi-config ones such as MSVC.

On macOS you can run everything above with a single helper script (it still uses the locally installed Apple toolchain):

```bash
./build_macos.sh
```

## Build via Docker (no local toolchain)

If you would rather not install any native build tools, use the provided container workflow. It produces Linux binaries natively and Windows binaries via MinGW cross compilation, and the image already includes wxWidgets (Fedora package on Linux, a source-built 3.2.5 tree for MinGW) for both toolchains.

```bash
./docker-build.sh
```

or on Windows:

```bat
docker-build.bat
```

Both scripts build the `cross-platform-hello-builder` image (based on Fedora 40) and run `scripts/build-all.sh` inside it. Results are written to `dist/linux` and `dist/windows`. Generating macOS binaries still requires macOS tooling, so those builds are produced by GitHub-hosted runners only.

Windows outputs are linked against the MinGW wxWidgets packages shipped in the container, so `dist/windows/bin/cross_platform_hello.exe` runs standalone on a vanilla Windows installation.

## Continuous integration

The workflow in `.github/workflows/ci.yml` runs on `ubuntu-latest`, `macos-latest`, and `windows-latest`. Each matrix job:

- Uses the native compiler (`g++`/`clang++` on Linux/macOS, MSVC on Windows)
- Configures and builds the project with CMake
- Installs the executable into a small `dist` directory
- Uploads the directory as a build artifact
- Installs wxWidgets on every runner (apt/brew on Linux/macOS, source build on Windows) before configuring the project

When you push a tag that starts with `v` (for example `v1.0.0`), the workflow bundles the artifacts from every platform, creates a GitHub Release, and attaches the bundled binaries. Pushing to the `main` branch (or opening pull requests) still runs the build matrix but skips the release step.

> ℹ️ MinGW cannot build macOS binaries. macOS builds are only produced by the macOS runner, which has access to Apple toolchains.

## Cutting a release

1. Update the code as needed and commit the changes.
2. Create and push a tag: `git tag v1.0.0 && git push origin v1.0.0`.
3. Wait for the workflow to finish; a release named after the tag appears with platform-specific archives attached.
