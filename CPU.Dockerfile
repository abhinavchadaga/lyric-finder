FROM node:20 as frontend_builder

WORKDIR /app/frontend
COPY frontend/package*.json .
RUN npm install
COPY frontend/ .

RUN npm run build
#################################################################################
FROM ubuntu:22.04 as cpp_builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    gdb \
    libboost-all-dev \
    ca-certificates \
    ninja-build

WORKDIR /app
COPY backend/ .

RUN mkdir Release && \
    cd Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -G Ninja .. && \
    cmake --build .

#################################################################################
FROM ubuntu:22.04 AS runtime

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

WORKDIR /app

COPY --from=cpp_builder /app/Release/lyric-finder-server /app/Release/lyric-finder-server
COPY --from=cpp_builder /app/db/ /app/db/
COPY --from=frontend_builder /app/frontend/dist /app/dist/

RUN chown appuser:appuser /app/Release/lyric-finder-server && \
    chmod +x /app/Release/lyric-finder-server

USER appuser

EXPOSE 8000

WORKDIR /app/Release/

ENTRYPOINT ["/app/Release/lyric-finder-server"]
