![Once Human Logo](assets/once-human-logo.webp)

# Once Human Game Server

Dockerized Once Human dedicated server using SteamCMD.

Created and maintained by WickedYoda.

## Quick Start

```bash
cp .env.example .env
# Edit .env with your settings
docker compose up -d --build
```

## Configuration

Server settings are controlled via:
- `.env` — container environment variables
- `config/GameUserSettings.ini` — mounted server config
- `saved/` — persistent world data

### Environment Variables

| Variable | Default | Description |
|---|---|---|
| `SERVER_NAME` | My Once Human Server | Public server name |
| `MAX_PLAYERS` | 16 | Max connected players |
| `SERVER_PASSWORD` | *(empty)* | Required to join |
| `ADMIN_PASSWORD` | *(empty)* | RCON/admin password |
| `PVE_ENABLED` | True | PvE or PvP |
| `DAY_LENGTH` | 60 | Day cycle minutes |
| `NIGHT_LENGTH` | 30 | Night cycle minutes |
| `XP_MULTIPLIER` | 1.0 | XP gain rate |
| `RESOURCE_MULTIPLIER` | 1.0 | Resource gather rate |
| `DROP_MULTIPLIER` | 1.0 | Item drop rate |

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| 27015 | TCP/UDP | Game |
| 27016 | TCP/UDP | Query |
| 27017 | TCP/UDP | RCON |

## Updating

```bash
docker compose pull
docker compose up -d --build
```

## Admin Commands

Connect via RCON or server console. Common commands:
- `listplayers` — show connected players
- `kick <player>` — kick a player
- `ban <player>` — ban a player
- `saveworld` — force save

## Requirements

- Docker + Docker Compose
- 4GB RAM minimum for 1–8 players
- Ports forwarded on router if public

## Docker Compose

```yaml
version: '3.8'

services:
  oncehuman:
    image: once-human:latest
    build:
      context: .
      dockerfile: Dockerfile
    container_name: once-human
    restart: unless-stopped
    ports:
      - "27015:27015/tcp"
      - "27015:27015/udp"
      - "27016:27016/tcp"
      - "27016:27016/udp"
      - "27017:27017/tcp"
      - "27017:27017/udp"
    environment:
      - SERVER_NAME=${SERVER_NAME:-My Once Human Server}
      - MAX_PLAYERS=${MAX_PLAYERS:-16}
      - PVE_ENABLED=${PVE_ENABLED:-true}
      - DAY_LENGTH=${DAY_LENGTH:-60}
      - NIGHT_LENGTH=${NIGHT_LENGTH:-30}
      - XP_MULTIPLIER=${XP_MULTIPLIER:-1.0}
      - RESOURCE_MULTIPLIER=${RESOURCE_MULTIPLIER:-1.0}
      - DROP_MULTIPLIER=${DROP_MULTIPLIER:-1.0}
      - SERVER_PASSWORD=${SERVER_PASSWORD:-}
      - ADMIN_PASSWORD=${ADMIN_PASSWORD:-}
    volumes:
      - ./saves:/home/oncehuman/server/OnceHuman/Saved
      - ./config/GameUserSettings.ini:/home/oncehuman/server/OnceHuman/Saved/Config/LinuxServer/GameUserSettings.ini:ro
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 4G
        reservations:
          cpus: '1.0'
          memory: 2G
```

## Legal

This project is licensed under the GNU General Public License v3.0. See [LICENSE](./LICENSE) for full terms.

- Created and maintained by WickedYoda
- [Terms, Disclaimer, and Limitation of Liability](./TERMS.md)

- [Setup Guide](./HOWTO.md) — step-by-step installation and configuration
- [Security Assessment](./SECURITY.md) — vulnerabilities and hardening recommendations
