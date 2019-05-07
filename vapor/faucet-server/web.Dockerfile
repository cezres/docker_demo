# You can set the Swift version to what you need for your app. Versions can be found here: https://hub.docker.com/_/swift
FROM swift:5.0.1-xenial as builder

# For local build, add `--build-arg env=docker`
# In your application, you can use `Environment.custom(name: "docker")` to check if you're in this env
ARG env

RUN apt-get -qq update && apt-get -q -y install \
  tzdata \
  libsqlite3-dev \
  libsodium-dev \
  libssl-dev \
  pkg-config \
  wget \
  software-properties-common \
  && rm -r /var/lib/apt/lists/*
RUN apt-get -q -y install \
  openssl \
  libssl-dev
RUN wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz \
    && tar xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16 \
    && ./configure && make -j4 && make install \
    && ldconfig
WORKDIR /app
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/ /build/lib
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin

# Production image
FROM ubuntu:16.04
ARG env
RUN apt-get -qq update && apt-get -q -y install \
  tzdata \
  libsqlite3-dev \
  libsodium-dev \
  libssl-dev \
  pkg-config \
  wget \
  software-properties-common \
  && rm -r /var/lib/apt/lists/*


WORKDIR /app
COPY --from=builder /build/bin/Run .
# COPY --from=builder /build/lib/* /usr/lib/

RUN apt-get -qq update && apt-get install -y \
  libicu55 libxml2 libbsd0 libcurl3 libatomic1 \
  tzdata \
  && rm -r /var/lib/apt/lists/*

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

RUN wget -o download.log https://swift.org/builds/swift-5.0.1-release/ubuntu1604/swift-5.0.1-RELEASE/swift-5.0.1-RELEASE-ubuntu16.04.tar.gz

RUN mkdir -p /usr/lib/swift \
    && tar -xvzf swift-5.0.1-RELEASE-ubuntu16.04.tar.gz -C /usr/lib/swift

RUN /usr/lib/swift/swift-5.0.1-RELEASE-ubuntu16.04/usr/bin/swift --version
    # && echo "export PATH=~/swift/swift-5.0.1-RELEASE-ubuntu16.04.tar.gz/usr/bin:$PATH" >> ~/.bashrc
#   && mkdir ~/swift \
#   && echo "export PATH=~/swift/swift-5.0.1-RELEASE-ubuntu16.04.tar.gz/usr/bin:$PATH" >> ~/.bashrc \
#   && swift --version

# Uncomment the next line if you need to load resources from the `Public` directory
#COPY --from=builder /app/Public ./Public
# Uncomment the next line if you are using Leaf
#COPY --from=builder /app/Resources ./Resources
ENV ENVIRONMENT=$env

ENTRYPOINT ./Run serve --env $ENVIRONMENT --hostname 0.0.0.0 --port 80
