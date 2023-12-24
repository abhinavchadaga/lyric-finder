FROM node:20 as frontend_builder

WORKDIR /app/frontend
COPY frontend/package*.json .
RUN npm install
COPY frontend/ .

RUN npm run build
#################################################################################
FROM nvidia/cuda:11.7.1-devel-ubuntu22.04 AS cuda_builder

# install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cmake \
    git \
    gdb \
    libboost-all-dev \
    ninja-build

# copy source code
WORKDIR /app
COPY backend/ .

# Build the application
RUN mkdir Release && \
    cd Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -G Ninja .. && \
    cmake --build .

#################################################################################
FROM nvidia/cuda:11.7.1-runtime-ubuntu22.04 AS runtime

### Create a non-privileged user that the app will run under.
### See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Set the working directory
WORKDIR /app

## Copy executable and db file from builder stage
COPY --from=cuda_builder /app/Release/lyric-finder-server /app/Release/lyric-finder-server
COPY --from=cuda_builder /app/db/ /app/db/
COPY --from=frontend_builder /app/frontend/dist /app/dist/

# Set permissions
RUN chown appuser:appuser /app/Release/lyric-finder-server && \
    chmod +x /app/Release/lyric-finder-server

USER appuser

EXPOSE 8000

WORKDIR /app/Release/

# Set the entrypoint to your application executable
ENTRYPOINT ["/app/Release/lyric-finder-server"]
