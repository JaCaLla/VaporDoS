# Phase 1: build
FROM swift:5.10-jammy AS build

WORKDIR /app

# Copy Package.swift and Source folder
COPY Package.swift ./
COPY Sources ./Sources

# (Optional) resolve dependencies before, for cache
RUN swift package resolve

# Compile in release mode
RUN swift build -c release --static-swift-stdlib

# Phase 2: runtime
FROM ubuntu:22.04 AS run

# Minimal runtime dependencies for binary in Swift
RUN apt-get update && \
    apt-get install -y \
    libbsd0 \
    libcurl4 \
    libxml2 \
    libz3-4 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /run

COPY --from=build /app/.build/release/Run ./

EXPOSE 8080

# In order vapor listens inside Docker
ENV PORT=8080
ENV HOSTNAME=0.0.0.0

CMD ["./Run"]
