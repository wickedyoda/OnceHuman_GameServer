#!/bin/bash
# Once Human Server Startup Script
# Installs server files on first run via Windows SteamCMD + Wine, then starts the server

set -e

SERVER_DIR="/home/oncehuman/server"
LOG_FILE="${SERVER_DIR}/OnceHuman/Logs/server.log"

# Initialize Wine prefix if needed
if [ ! -f "/home/oncehuman/.wine/system.reg" ]; then
    echo "Initializing Wine prefix..."
    export WINEPREFIX="/home/oncehuman/.wine"
    xvfb-run -a wineboot --init 2>/dev/null || true
fi

# Install via SteamCMD if not already installed
if [ ! -d "${SERVER_DIR}/OnceHuman/Binaries" ]; then
    echo "Installing Once Human server files via SteamCMD..."
    
    # First update SteamCMD itself
    xvfb-run -a wine /opt/steamcmd-win/steamcmd.exe \
        +force_install_dir /tmp/steamcmd-update \
        +login anonymous \
        +app_update 2139460 validate \
        +quit 2>&1 || echo "SteamCMD install attempted"
    
    # Check if installation worked
    if [ -d "${SERVER_DIR}/OnceHuman/Binaries" ]; then
        echo "Server files installed successfully"
    else
        echo "WARNING: Server binaries not found after SteamCMD install"
        echo "This may indicate: No subscription / Missing configuration"
        ls -la "${SERVER_DIR}/OnceHuman/" 2>/dev/null || echo "No OnceHuman directory found"
    fi
fi

echo "Starting Once Human server..."
exec xvfb-run -a wine "${SERVER_DIR}/OnceHuman/Binaries/Win64/OnceHumanServer-Win64-Shipping.exe" -server -log "$@" 2>&1 || \
echo "Server failed to start - check if server binary exists"