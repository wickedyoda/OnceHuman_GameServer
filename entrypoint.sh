#!/bin/bash
# Once Human Server Startup Script (Wine-based, Linux container)
# Installs server files on first run, then starts the once-human server

set -e

SERVER_DIR="/home/oncehuman/server/OnceHuman"
CONFIG_DIR="${SERVER_DIR}/Saved/Config/WindowsServer"
STEAMCMD="/home/oncehuman/server/steamcmd/steamcmd.exe"
WINE_PREFIX="/home/oncehuman/.wine"

# Initialize Wine prefix if it doesn't exist
if [ ! -d "${WINE_PREFIX}" ]; then
    echo "Initializing Wine prefix..."
    export WINEPREFIX="${WINE_PREFIX}"
    xvfb-run -a wineboot --init 2>/dev/null || true
fi

export WINEPREFIX="${WINE_PREFIX}"

# Check if server files are already installed
if [ ! -f "${SERVER_DIR}/OnceHumanServer.exe" ]; then
    echo "Installing Once Human server files via SteamCMD..."
    xvfb-run -a wine ${STEAMCMD} \
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update 2139460 validate \
        +quit 2>&1 || true
fi

# Create config directory
mkdir -p "${CONFIG_DIR}"

# Copy config from mounted volume if present
if [ -f "/config/GameUserSettings.ini" ]; then
    cp /config/GameUserSettings.ini "${CONFIG_DIR}/GameUserSettings.ini"
fi

# Create default GameUserSettings.ini if not present
if [ ! -f "${CONFIG_DIR}/GameUserSettings.ini" ]; then
    cat > "${CONFIG_DIR}/GameUserSettings.ini" << EOF
[/Script/OnceHuman.GameUserSettings]
ServerName=${SERVER_NAME:-My Once Human Server}
MaxPlayers=${MAX_PLAYERS:-16}
ServerPassword=${SERVER_PASSWORD:-}
AdminPassword=${ADMIN_PASSWORD:-}
PvEEnabled=${PVE_ENABLED:-True}
DayLength=${DAY_LENGTH:-60}
NightLength=${NIGHT_LENGTH:-30}
XPMultiplier=${XP_MULTIPLIER:-1.0}
ResourceMultiplier=${RESOURCE_MULTIPLIER:-1.0}
DropMultiplier=${DROP_MULTIPLIER:-1.0}
EOF
fi

# Copy saves from mounted volume if present
if [ -d "/saves" ]; then
    cp -r /saves/* "${SERVER_DIR}/Saved/" 2>/dev/null || true
fi

# Start the server via Wine with virtual framebuffer
cd "${SERVER_DIR}"
exec xvfb-run -a wine OnceHumanServer.exe -log -port=27015 -queryport=27016 -rconport=27017 "$@"