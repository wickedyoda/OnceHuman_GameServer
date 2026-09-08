FROM debian:12.15-slim

LABEL maintainer="WickedYoda" \
      description="Once Human Dedicated Server (Wine-based, self-hosted)" \
      license="GPL-3.0"

ENV DEBIAN_FRONTEND=noninteractive \
    STEAM_APP_ID=2139460 \
    SERVER_NAME="My Once Human Server" \
    MAX_PLAYERS=16

# Enable multiarch and install Wine + dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wine \
        wine32 \
        wine64 \
        xvfb \
        xauth \
        wget \
        unzip \
        ca-certificates \
        libgl1 \
        libglib2.0-0 \
        libgtk-3-0 \
        libx11-6 \
        libxcb1 \
        libxrender1 \
        libxtst6 \
        libxi6 \
        libsm6 \
        && rm -rf /var/lib/apt/lists/*

# Download Windows SteamCMD
RUN mkdir -p /opt/steamcmd-win && \
    wget -q -O /tmp/steamcmd_win.zip "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" && \
    unzip -q /tmp/steamcmd_win.zip -d /opt/steamcmd-win && \
    rm /tmp/steamcmd_win.zip && \
    chmod -R 755 /opt/steamcmd-win

# Create non-root user
RUN useradd -m -s /bin/bash oncehuman && \
    mkdir -p /home/oncehuman/.wine /home/oncehuman/server && \
    chown -R oncehuman:oncehuman /home/oncehuman && \
    chmod 777 /opt/steamcmd-win

# Copy entrypoint
COPY entrypoint.sh /home/oncehuman/entrypoint.sh
RUN chmod +x /home/oncehuman/entrypoint.sh

USER oncehuman
WORKDIR /home/oncehuman
EXPOSE 27015/tcp 27015/udp 27016/tcp 27016/udp 27017/tcp

ENTRYPOINT ["/home/oncehuman/entrypoint.sh"]