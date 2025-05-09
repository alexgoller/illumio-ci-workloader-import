FROM golang:1.21-alpine AS builder

# Set version - adjust as needed
ARG WORKLOADER_VERSION=12.0.15
ARG TARGETARCH=arm64

# Install required build dependencies
RUN apk add --no-cache git ca-certificates tzdata

# Download source code
RUN git clone https://github.com/brian1917/workloader.git /go/src/github.com/brian1917/workloader && \
    cd /go/src/github.com/brian1917/workloader && \
    git checkout v${WORKLOADER_VERSION}

# Build workloader for target architecture
WORKDIR /go/src/github.com/brian1917/workloader
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -a -installsuffix cgo -o workloader .

# Create final image
FROM alpine:latest

# Install required runtime dependencies
RUN apk add --no-cache jq bash ca-certificates tzdata

# Create directories for workloader
RUN mkdir -p /app/workloader /app/data /app/config

# Copy built binary from builder stage
COPY --from=builder /go/src/github.com/brian1917/workloader/workloader /app/workloader/workloader
RUN chmod +x /app/workloader/workloader && \
    ln -s /app/workloader/workloader /usr/local/bin/workloader

# Add scripts
COPY scripts/entrypoint.sh /app/
COPY scripts/setup-pce.sh /app/
COPY workloader-linux-arm /app/workloader/
RUN chmod +x /app/entrypoint.sh /app/setup-pce.sh

# Set working directory
WORKDIR /app/data

# Volumes for data persistence and configuration
VOLUME ["/app/data", "/app/config"]

# Entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Default command if none specified
CMD ["--help"]
