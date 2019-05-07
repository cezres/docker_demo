FROM ubuntu:16.04

# Install related packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    git \
    curl \
    cmake \
    wget \
    ninja-build \
    clang \
    python \
    uuid-dev \
    libicu-dev \
    icu-devtools \
    libbsd-dev \
    libedit-dev \
    libxml2-dev \
    libsqlite3-dev \
    swig \
    libpython-dev \
    libncurses5-dev \
    pkg-config \
    libblocksruntime-dev \
    libcurl4-openssl-dev \
    systemtap-sdt-dev \
    tzdata \
    rsync && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Swift down URL pattern:
# https://swift.org/builds/swift-5.0.1-release/ubuntu1604/swift-5.0.1-RELEASE/swift-5.0.1-RELEASE-ubuntu16.04.tar.gz

ARG SWIFT_PLATFORM=ubuntu16.04
ARG SWIFT_BRANCH=swift-5.0.1-release
ARG SWIFT_VERSION=swift-5.0.1-RELEASE

ENV SWIFT_PLATFORM=$SWIFT_PLATFORM \
    SWIFT_BRANCH=$SWIFT_BRANCH \
    SWIFT_VERSION=$SWIFT_VERSION

# Vapor setup
RUN /bin/bash -c "$(wget -qO- https://apt.vapor.sh)"

# Install vapor and clean
RUN apt-get install vapor -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    libsodium-dev

# Download the binary and sig files, check the signature, unzip the package and set the correct priviledge.
RUN SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM.tar.gz \
    && curl -SL $SWIFT_URL -o swift.tar.gz

# RUN mkdir -r /usr/lib/swift \
#     && export GNUPGHOME="$(mktemp -d)" \
#     # && tar -xzf swift.tar.gz --directory / --strip-components=1 \
#     && chmod -R o+r /usr/lib/swift \
#     && rm -r "$GNUPGHOME" swift.tar.gz

RUN mkdir -p /usr/swift \
    # && chmod -R o+r /usr/lib/swift \
    # && rm -r /usr/swift \
    && tar -xzf swift.tar.gz -C /usr/swift --strip-components=2 \
    && rm -r swift.tar.gz

RUN apt-get install wget -y && wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz \
    && tar xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16 \
    && ./configure && make -j4 && make install \
    && ldconfig

RUN swift --version && vapor --version

# ENTRYPOINT vapor build && vapor run --hostname=0.0.0.0
