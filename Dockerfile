FROM debian:12-slim

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    WINEPREFIX=/home/wineuser/.wine \
    WINEDEBUG=-all \
    DISPLAY=:0 \
    SERVER_NAME="My Once Human Server" \
    MAX_PLAYERS=16 \
    PVE_ENABLED=True \
    DAY_LENGTH=60 \
    NIGHT_LENGTH=30 \
    XP_MULTIPLIER=1.0 \
    RESOURCE_MULTIPLIER=1.0 \
    DROP_MULTIPLIER=1.0

# Install Wine (64-bit + 32-bit support), SteamCMD, and utilities
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates wget unzip gnupg2 software-properties-common \
        xvfb xauth cabextract \
        wine64 wine32 \
    && rm -rf /var/lib/apt/lists/*

# Create wine user and install Wine
RUN useradd -m -u 1000 wineuser && \
    mkdir -p /home/wineuser/.wine/drive_c/steamcmd && \
    mkdir -p /home/wineuser/.wine/drive_c/oncehuman && \
    # Initialize Wine prefix silently
    sudo -u wineuser sh -c 'WINEDLLOVERRIDES="mscoree,mshtml=" wineboot --init 2>/dev/null || true' && \
    # Download and install SteamCMD
    wget -q -O /tmp/steamcmd.zip "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" && \
    unzip -q /tmp/steamcmd.zip -d /home/wineuser/.wine/drive_c/steamcmd && \
    rm /tmp/steamcmd.zip && \
    chown -R 1000:1000 /home/wineuser

USER wineuser
WORKDIR /home/wineuser/.wine/drive_c/steamcmd

# Install Once Human server files via Wine SteamCMD (App ID 2139460)
RUN xvfb-run -a wine steamcmd.exe +login anonymous +force_install_dir C:\oncehuman +app_update 2139460 +quit 2>&1 | tail -n 20

WORKDIR /home/wineuser/.wine/drive_c/oncehuman

EXPOSE 27015/tcp 27015/udp 27016/tcp 27016/udp 27017/tcp

COPY --chown=1000:1000 entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-log", "-port=27015"]