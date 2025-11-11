FROM fedora:40

ARG WX_VERSION=3.2.5

RUN dnf install -y \
    cmake \
    ninja-build \
    git \
    gcc \
    gcc-c++ \
    clang \
    curl \
    zip \
    tar \
    wxGTK-devel \
    mingw64-gcc \
    mingw64-gcc-c++ \
    mingw64-headers \
    mingw64-crt \
    mingw64-binutils \
    mingw64-winpthreads-static \
    && dnf clean all

RUN curl -L "https://github.com/wxWidgets/wxWidgets/releases/download/v${WX_VERSION}/wxWidgets-${WX_VERSION}.tar.bz2" -o /tmp/wxWidgets.tar.bz2 \
    && tar -xf /tmp/wxWidgets.tar.bz2 -C /tmp \
    && cd /tmp/wxWidgets-${WX_VERSION} \
    && mkdir build-mingw && cd build-mingw \
    && ../configure \
        --host=x86_64-w64-mingw32 \
        --build=$(gcc -dumpmachine) \
        --target=x86_64-w64-mingw32 \
        --disable-shared \
        --enable-unicode \
        --with-msw \
        --prefix=/opt/mingw-wx \
    && make -j"$(nproc)" \
    && make install \
    && rm -rf /tmp/wxWidgets-${WX_VERSION} /tmp/wxWidgets.tar.bz2

WORKDIR /work
