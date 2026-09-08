#!/bin/bash
# Once Human Server Startup Script
# Uses Wine to run the Windows server binary in a Linux container

set -e

SERVER_DIR="/home/wineuser/.wine/drive_c/oncehuman"
CONFIG_DIR="${SERVER_DIR}/OnceHuman/Saved/Config/WindowsServer"

# Create config directory if it doesn't exist
mkdir -p "${CONFIG_DIR}"

# Create default GameUserSettings.ini from environment or defaults
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

# Start the server via Wine with virtual framebuffer
cd "${SERVER_DIR}"
exec xvfb-run -a wine OnceHumanServer.exe -log -port=27015 -queryport=27016 -rconport=27017 "$@"