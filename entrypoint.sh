#!/bin/bash
set -e

SERVER_DIR="/home/oncehuman/server"
WINEPREFIX="/home/oncehuman/.wine"

export WINEPREFIX

# Initialize Wine prefix if needed
if [ ! -f "${WINEPREFIX}/system.reg" ]; then
    echo "Initializing Wine prefix..."
    wineboot --init 2>/dev/null || true
fi

# Install via SteamCMD if not already installed
if [ ! -d "${SERVER_DIR}/OnceHuman/Binaries" ]; then
    echo "Installing Once Human server files via SteamCMD..."
    
    cd /home/oncehuman
    
    # Run SteamCMD - the -overrideminos needs to come early
    echo "Running SteamCMD install..."
    xvfb-run -a wine /opt/steamcmd-win/steamcmd.exe \
        -overrideminos \
        +force_install_dir "${SERVER_DIR}" \
        +login anonymous \
        +app_update 2139460 validate \
        +quit 2>&1
    
    STEAM_EXIT=$?
    echo "SteamCMD exited with code: ${STEAM_EXIT}"
    
    # Check if installation worked
    if [ -d "${SERVER_DIR}/OnceHuman/Binaries" ]; then
        echo "Server files installed successfully"
        ls -la "${SERVER_DIR}/OnceHuman/Binaries/" | head -10
    else
        echo "WARNING: Server binaries not found after SteamCMD install"
        ls -la "${SERVER_DIR}/" 2>/dev/null || echo "No OnceHuman directory found"
    fi
fi

echo "Starting Once Human server..."
if [ -f "${SERVER_DIR}/OnceHuman/Binaries/Win64/OnceHumanServer-Win64-Shipping.exe" ]; then
    exec xvfb-run -a wine "${SERVER_DIR}/OnceHuman/Binaries/Win64/OnceHumanServer-Win64-Shipping.exe" -server -log "$@"
else
    echo "ERROR: Server executable not found!"
    echo "Steam App ID 2139460 may require Steam ownership"
    exit 1
fi