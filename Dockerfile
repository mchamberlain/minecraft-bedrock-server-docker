# syntax=docker/dockerfile:1.3-labs

FROM ubuntu:latest

RUN --mount=type=cache,target=/var/cache/apt \
    apt update && apt upgrade -y && apt install -y unzip wget curl

# if arch, add box64 repo, install box64
ARG TARGETARCH
RUN --mount=type=cache,target=/var/cache/apt <<EOT bash
if [ "$TARGETARCH" == "arm64" ]; then
    wget -O /tmp/box64.deb https://github.com/ryanfortner/box64-debs/raw/master/debian/box64_0.2.1%2B20230110.d1f63fe-1_arm64.deb
    dpkg -i /tmp/box64.deb
    rm /tmp/box64.deb
fi
EOT

ENV MINECRAFT_ROOT=/usr/local/minecraft-bedrock-server
ENV MINECRAFT_ARCH=$TARGETARCH

RUN useradd minecraft
COPY --chown=minecraft:minecraft bedrock-server.zip /tmp/bedrock-server.zip
RUN mkdir -p "$MINECRAFT_ROOT"
RUN chown minecraft:minecraft "$MINECRAFT_ROOT"
USER minecraft
WORKDIR "$MINECRAFT_ROOT"

RUN <<EOT
    unzip /tmp/bedrock-server.zip
    rm /tmp/bedrock-server.zip
EOT

# prepare config: remove config files and symlink to config directory
VOLUME [ "/worlds" ]
VOLUME [ "/config" ]
RUN <<EOT
mkdir -p .defaults/config
for filename in "allowlist.json" "permissions.json" "server.properties"; do
    # Copy config files to default path
    if [ ! -e ".defaults/config/$filename" ]; then
        cp "$filename" ".defaults/config/$filename"
    fi
    rm "$filename"
    ln -s "/config/$filename"
done
    ln -s "/worlds"
EOT

EXPOSE 19132/udp

COPY --chown=minecraft:minecraft run_bedrock_server $MINECRAFT_ROOT/run_bedrock_server

ENTRYPOINT [ "/bin/bash", "run_bedrock_server" ]
