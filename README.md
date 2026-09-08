# Once Human Game Server

Dockerized Once Human dedicated server using Wine and SteamCMD.

Created and maintained by WickedYoda.

![Once Human Logo](assets/once-human-logo.webp)

## ⚠️ Note

Once Human server binaries run on Windows. This image uses Wine via SteamCMD to install and run the server on Linux. Saves and configs are mapped to the host so they persist across container updates.

## Requirements

- Docker v24+ and Docker Compose v2+
- Linux host with 8GB+ RAM (16GB recommended for 16+ players)
- 30GB+ free disk space
- Wine support (included in scottyhardy/docker-wine:latest)

## Quick Start

```bash
cp .env.example .env
docker compose up -d --build
```

## Docker Compose

```yaml
version: '3.8'

services:
  oncehuman:
    build: .
    image: ghcr.io/wickedyoda/oncehuman_gameserver:latest
    container_name: oncehuman
    restart: unless-stopped
    ports:
      - "27015:27015/udp"
      - "27015:27015/tcp"
      - "27016:27016/tcp"
      - "27016:27016/udp"
      - "27017:27017/tcp"
    volumes:
      - ./saves:/home/wineuser/.wine/drive_c/oncehuman/Saved
      - ./config/GameUserSettings.ini:/home/wineuser/.wine/drive_c/oncehuman/OnceHuman/Saved/Config/WindowsServer/GameUserSettings.ini:ro
    environment:
      - SERVER_NAME=${SERVER_NAME:-My Once Human Server}
      - MAX_PLAYERS=${MAX_PLAYERS:-16}
      - SERVER_PASSWORD=${SERVER_PASSWORD:-}
      - ADMIN_PASSWORD=${ADMIN_PASSWORD:-}
      - PVE_ENABLED=${PVE_ENABLED:-True}
      - DAY_LENGTH=${DAY_LENGTH:-60}
      - NIGHT_LENGTH=${NIGHT_LENGTH:-30}
      - XP_MULTIPLIER=${XP_MULTIPLIER:-1.0}
      - RESOURCE_MULTIPLIER=${RESOURCE_MULTIPLIER:-1.0}
      - DROP_MULTIPLIER=${DROP_MULTIPLIER:-1.0}
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 4G
        reservations:
          cpus: '1.0'
          memory: 2G
```

## Configuration

- `.env` — container environment variables
- `config/GameUserSettings.ini` — mounted server config (read-only)
- `saved/` — persistent world data

### Environment Variables

| Variable | Default | Description |
|---|---|---|
| `SERVER_NAME` | My Once Human Server | Public server name |
| `MAX_PLAYERS` | 16 | Max connected players |
| `SERVER_PASSWORD` | *(empty)* | Join password |
| `ADMIN_PASSWORD` | *(empty)* | RCON/admin password |
| `PVE_ENABLED` | True | PvE or PvP |

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| 27015 | TCP/UDP | Game |
| 27016 | TCP/UDP | Query |
| 27017 | TCP | RCON |

## Admin Commands

- `listplayers` — show connected players
- `kick <player>` — kick a player
- `ban <player>` — ban a player
- `saveworld` — force save

## Legal

Licensed under GNU GPL v3.0. See [LICENSE](./LICENSE).

- [Setup Guide](./HOWTO.md)
- [Security Assessment](./SECURITY.md)
- [Terms](./TERMS.md)