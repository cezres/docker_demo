FROM ubuntu:16.04

LABEL description="Docker container for Swift Vapor development"

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
# https://swift.org/builds/swift-4.1.2-release/ubuntu1604/swift-4.1.2-RELEASE/swift-4.1.2-RELEASE-ubuntu16.04.tar.gz

ARG SWIFT_PLATFORM=ubuntu16.04
ARG SWIFT_BRANCH=swift-5.0.1-release
ARG SWIFT_VERSION=swift-5.0.1-RELEASE

ENV SWIFT_PLATFORM=$SWIFT_PLATFORM \
    SWIFT_BRANCH=$SWIFT_BRANCH \
    SWIFT_VERSION=$SWIFT_VERSION

# Download the binary and sig files, check the signature, unzip the package and set the correct priviledge.
RUN SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM.tar.gz \
    && curl -fSsL $SWIFT_URL -o swift.tar.gz \
    && curl -fSsL $SWIFT_URL.sig -o swift.tar.gz.sig \
    && export GNUPGHOME="$(mktemp -d)" \
    && set -e; gpg --quiet --keyserver ha.pool.sks-keyservers.net \
        --recv-keys "5E4DF843FB065D7F7E24FBA2EF5430F071E1B235"; \
        gpg --batch --verify --quiet swift.tar.gz.sig swift.tar.gz \
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && chmod -R o+r /usr/lib/swift \
    && rm -r "$GNUPGHOME" swift.tar.gz.sig swift.tar.gz

RUN swift --version
