FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    make \
    clang \
    libstdc++-12-dev \
    libstdc++6 \
    curl \
    lz4 \
    wget \
    sudo \
    xz-utils \
    ca-certificates

# Install Theos
RUN git clone --recursive https://github.com/theos/theos.git /root/theos

# Setup iOS SDK (minimal)
RUN mkdir -p /root/theos/sdks/iPhoneOS18.0.sdk && \
    cp -r /root/theos/vendor/include/* /root/theos/sdks/iPhoneOS18.0.sdk/ && \
    mkdir -p /root/theos/toolchain/linux/iphone/bin

# Create a simple wrapper script for clang
RUN echo '#!/bin/bash\nclang "$@"' > /root/theos/toolchain/linux/iphone/bin/clang && \
    chmod +x /root/theos/toolchain/linux/iphone/bin/clang && \
    echo '#!/bin/bash\nclang++ "$@"' > /root/theos/toolchain/linux/iphone/bin/clang++ && \
    chmod +x /root/theos/toolchain/linux/iphone/bin/clang++

ENV THEOS=/root/theos
ENV PATH=$THEOS/bin:$THEOS/toolchain/linux/iphone/bin:$PATH

WORKDIR /work

CMD ["make", "package"]
