# Once Human Game Server

Dockerized Once Human dedicated server using SteamCMD.

Created and maintained by WickedYoda.

![Once Human Logo](assets/once-human-logo.webp)

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

## Legal

See [TERMS.md](./TERMS.md) for terms of use, disclaimer, and limitation of liability.
