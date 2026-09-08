# Once Human Game Server

Dockerized Once Human dedicated server using Wine and SteamCMD.

Created and maintained by WickedYoda.

## ⚠️ Important: Game Server Model

Once Human does **not** provide a traditional self-hosted dedicated server via SteamCMD. The game uses an official rental-based custom server system. This repo provides:

- A **Docker image** running the Once Human client/server binary via Wine (App ID `2139460`)
- **Persistent volume mappings** for saves and configs
- **Security scanning reports**: `trivy-report.json`, `trivy-image-report.json`, `gitleaks-report.json`

If you need a true dedicated server, rent through the official Once Human system: https://www.oncehuman.game/2026/csfy/

---

## Requirements

- Docker v24+ and Docker Compose v2+
- Linux host with 8GB+ RAM (16GB recommended for 16+ players)
- 30GB+ free disk space
- Wine support (included in scottyhardy/docker-wine:latest)

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
      - HIVE_LICENSE=${HIVE_LICENSE:-}
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

Server settings are controlled via:
- `.env` — container environment variables
- `config/GameUserSettings.ini` — mounted server config (read-only)
- `saved/` — persistent world data (host volume)

### Environment Variables

| Variable | Default | Description |
|---|---|---|
| `HIVE_LICENSE` | *(empty)* | Private Hive license token (optional) |
| `SERVER_NAME` | My Once Human Server | Public server name |
| `MAX_PLAYERS` | 16 | Max connected players |
| `SERVER_PASSWORD` | *(empty)* | Required to join |
| `ADMIN_PASSWORD` | *(empty)* | RCON/admin password |
| `PVE_ENABLED` | True | PvE or PvP |

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| 27015 | TCP/UDP | Game traffic |
| 27016 | TCP/UDP | Query/heartbeat |
| 27017 | TCP | RCON (admin) |

## Quick Start

```bash
cp .env.example .env
docker compose up -d --build
```

## Legal

Licensed under GNU GPL v3.0. See [LICENSE](./LICENSE) for full terms.

- [Setup Guide](./HOWTO.md)
- [Security Assessment](./SECURITY.md)
- [Terms](./TERMS.md)