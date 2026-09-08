FROM debian:12.15-slim

LABEL maintainer="WickedYoda" \
      description="Once Human Dedicated Server (Wine-based, secure)" \
      license="GPL-3.0"

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    WINEPREFIX=/home/oncehuman/.wine \
    WINEDEBUG=-all \
    DISPLAY=:99 \
    WINEDLLOVERRIDES=mscoree,mshtml= \
    PATH="/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin"

# Install minimal Wine + Xvfb + utils
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates wget unzip gnupg2 \
        xvfb xauth cabextract \
        wine64 wine32 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/* \
    && ln -s /usr/bin/wine64 /usr/local/bin/wine

# Create non-root user
RUN useradd -m -u 1000 oncehuman && \
    mkdir -p /home/oncehuman/server && \
    chown -R oncehuman:oncehuman /home/oncehuman

USER oncehuman
WORKDIR /home/oncehuman/server

# Initialize Wine prefix silently
RUN wineboot --init 2>/dev/null || true

# Download and install SteamCMD
RUN wget -q -O /tmp/steamcmd.zip "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" && \
    unzip -q /tmp/steamcmd.zip -d /home/oncehuman/server/steamcmd && \
    rm /tmp/steamcmd.zip

# Install Once Human server files via Wine SteamCMD (Windows-only app, App ID 2139460)
RUN xvfb-run -a wine /home/oncehuman/server/steamcmd/steamcmd.exe \
    +force_install_dir /home/oncehuman/server/OnceHuman \
    +login anonymous \
    +app_update 2139460 validate \
    +quit 2>&1 || true

# Create config directory
RUN mkdir -p /home/oncehuman/server/OnceHuman/Saved/Config/WindowsServer

# Expose game ports: 27015 (game), 27016 (query), 27017 (RCON)
EXPOSE 27015/tcp 27015/udp 27016/tcp 27016/udp 27017/tcp

COPY --chown=oncehuman:oncehuman entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-log", "-port=27015"]