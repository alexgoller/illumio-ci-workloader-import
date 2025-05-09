FROM alpine

# Set version - adjust as needed
ARG WORKLOADER_VERSION=12.0.14
ARG WORKLOADER_ARCH=arm
ARG WORKLOADER_OS=linux

# Install required dependencies
RUN apk add --no-cache curl jq bash

# Create directories for workloader
RUN mkdir -p /app/workloader /app/data /app/config

# Download and install workloader binary
RUN curl -L -o /tmp/workloader.zip \
    https://github.com/brian1917/workloader/releases/download/v${WORKLOADER_VERSION}/linux_arm-v${WORKLOADER_VERSION}.zip && \
    mkdir -p /app/workloader && \
    unzip -j -d /app/workloader /tmp/workloader.zip && \
    chmod +x /app/workloader/workloader && \
    ln -s /app/workloader/workloader /usr/local/bin/workloader && \
    rm /tmp/workloader.zip

# Add scripts
COPY scripts/entrypoint.sh /app/
COPY scripts/setup-pce.sh /app/
RUN chmod +x /app/entrypoint.sh /app/setup-pce.sh

# Set working directory
WORKDIR /app/data

# Volumes for data persistence and configuration
VOLUME ["/app/data", "/app/config"]

# Entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Default command if none specified
CMD ["--help"]
