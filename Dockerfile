FROM fedora:40

RUN dnf install -y \
    cmake \
    ninja-build \
    git \
    gcc \
    gcc-c++ \
    clang \
    zip \
    tar \
    mingw64-gcc \
    mingw64-gcc-c++ \
    mingw64-headers \
    mingw64-crt \
    mingw64-binutils \
    mingw64-winpthreads-static \
    && dnf clean all

WORKDIR /work
