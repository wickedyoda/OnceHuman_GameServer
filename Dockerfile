FROM scottyhardy/docker-wine:latest

SHELL ["/bin/bash", "-lc"]

# Environment variables for server configuration
ENV SERVER_NAME="My Once Human Server" \
    MAX_PLAYERS=16 \
    PVE_ENABLED=True \
    DAY_LENGTH=60 \
    NIGHT_LENGTH=30 \
    XP_MULTIPLIER=1.0 \
    RESOURCE_MULTIPLIER=1.0 \
    DROP_MULTIPLIER=1.0 \
    WINEDEBUG=-all \
    DISPLAY=:0

USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget unzip xvfb && \
    rm -rf /var/lib/apt/lists/*

# Install SteamCMD into the Wine prefix
RUN mkdir -p /home/wineuser/.wine/drive_c/steamcmd && \
    wget -q -O /tmp/steamcmd.zip "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" && \
    unzip -q /tmp/steamcmd.zip -d /home/wineuser/.wine/drive_c/steamcmd && rm /tmp/steamcmd.zip

# Download Once Human server files via Wine SteamCMD
# App ID 2139460 = Once Human (includes dedicated server files)
RUN export DISPLAY=:0 && \
    echo "+login anonymous" > /tmp/steamcmd_script.txt && \
    echo "+force_install_dir C:\\oncehuman" >> /tmp/steamcmd_script.txt && \
    echo "+app_update 2139460" >> /tmp/steamcmd_script.txt && \
    echo "+quit" >> /tmp/steamcmd_script.txt && \
    cat /tmp/steamcmd_script.txt && \
    cd /home/wineuser/.wine/drive_c/steamcmd && \
    wine steamcmd.exe +@sSteamID 0 +login anonymous +force_install_dir C:\\oncehuman +app_update 2139460 +quit 2>&1 | grep -iE "update|complete|missing|error|install|extract|2139460|manifest" | tail -n 40

WORKDIR /home/wineuser/.wine/drive_c/oncehuman

# Expose required ports
# 27015 - game, 27016 - query, 27017 - RCON
EXPOSE 27015/tcp 27015/udp 27016/tcp 27016/udp 27017/tcp

# Copy startup script
COPY --chown=1000:1000 entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-log", "-port=27015"]
