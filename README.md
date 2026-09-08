# Once Human Dedicated Server

**Self-host your own Once Human game server in Docker.**

This repo provides a Dockerized dedicated server for Once Human (Steam App ID: 2139460), running via Wine on Linux. Built for self-hosted deployment on your own hardware.

> Created and maintained by **WickedYoda**.
> Licensed under **GNU General Public License v3.0 (GPLv3)**.

---

## Quick Start

### Prerequisites
- Docker + Docker Compose v2
- Steam account with Once Human (free)
- Ports 27015-27017 forwarded on your router (TCP+UDP)

### 1. Clone & Configure

```bash
git clone https://github.com/wickedyoda/OnceHuman_GameServer.git
cd OnceHuman_GameServer
cp .env.example .env
```

Edit `.env` to set server name, passwords, and multipliers. Edit `config/GameUserSettings.ini` for advanced settings.

### 2. Build & Run

```bash
docker compose build
docker compose up -d
```

The first run will:
- Initialize a Wine prefix
- Download server files via SteamCMD (~130 GB, requires Steam login)
- Start the server

Subsequent runs start immediately — files persist in `./saves`.

### 3. Connect

Find your public IP:
```bash
curl ifconfig.me
```

In-game: Servers → search for your server name → join.

Direct connect: Open console (`~`) and type:
```
open <your-public-ip>:27015
```

### 4. Admin

RCON via `rcon-cli`:
```bash
rcon-cli -host localhost -port 27017 -password "your-admin-password"
```

---

## Host Volume Mounts

| Host Path | Container Path | Purpose |
|---|---|---|
| `./saves` | `/home/oncehuman/server/OnceHuman/Saved` | World saves, configs, logs |
| `./config/GameUserSettings.ini` | `/home/oncehuman/server/OnceHuman/Saved/Config/WindowsServer/GameUserSettings.ini:ro` | Server settings (read-only) |

**Production on recipe-host:** Use host path mounts:
- `/root/once-human-saves` → `/home/oncehuman/server/OnceHuman/Saved`
- `/root/once-human-config/GameUserSettings.ini` → container config (read-only)

---

## Configuration

### `.env` Variables

| Variable | Default | Description |
|---|---|---|
| `SERVER_NAME` | "My Once Human Server" | Server name shown in browser |
| `MAX_PLAYERS` | 16 | Max concurrent players |
| `SERVER_PASSWORD` | "" | Join password (leave empty for public) |
| `ADMIN_PASSWORD` | "" | RCON admin password |
| `PVE_ENABLED` | True | PvE mode (False = PvP) |
| `DAY_LENGTH` | 60 | Day cycle length (minutes) |
| `NIGHT_LENGTH` | 30 | Night cycle length (minutes) |
| `XP_MULTIPLIER` | 1.0 | Experience gain multiplier |
| `RESOURCE_MULTIPLIER` | 1.0 | Resource drop multiplier |
| `DROP_MULTIPLIER` | 1.0 | Item drop multiplier |

### `config/GameUserSettings.ini`

Advanced settings file. Mount as read-only into the container. See `config/GameUserSettings.ini` for the template.

---

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| 27015 | TCP + UDP | Game traffic |
| 27016 | TCP + UDP | Query/Heartbeat |
| 27017 | TCP | RCON |

Forward all three (TCP+UDP on 27015/27016, TCP on 27017) on your router to the Docker host IP.

---

## Security

- Runs as non-root user `oncehuman` (UID 1000)
- Read-only root filesystem (`read_only: true`)
- No-new-privileges security opt
- tmpfs for `/tmp`, `/run`, and Wine prefix
- Host files mounted read-only where applicable

---

## Resource Limits

| Players | CPU Limit | RAM Limit |
|---|---|---|
| 1-8 | 2.0 / 1.0 reserved | 4GB / 2GB reserved |

For larger servers (9-16 players), increase to 4 cores / 8GB RAM.

---

## Troubleshooting

| Issue | Fix |
|---|---|
| Server not visible in browser | Forward ports 27015-27017 (TCP+UDP); wait 2-5 min for query registration |
| "Missing configuration" from SteamCMD | Use `+login <your_steam_user> <password>` instead of anonymous |
| Wine prefix errors | Delete `/home/oncehuman/.wine` and restart; will reinitialize |
| Players can't connect | Verify public IP, not LAN IP; check firewall |

---

## Files

```
.
├── Dockerfile              # Debian:12.15-slim + Wine + SteamCMD
├── docker-compose.yml      # Service definition + resource limits
├── entrypoint.sh           # Wine prefix init + SteamCMD install + server start
├── .env.example            # Environment variables template
├── config/
│   └── GameUserSettings.ini
├── saved/
│   └── .gitkeep
├── LICENSE                 # GPLv3
├── README.md               # This file
├── HOWTO.md                # Detailed setup guide
├── SECURITY.md             # Security considerations
├── TERMS.md                # Terms of use reference
└── .dockerignore           # Excludes docs/configs from build context
```

---

## License

GNU General Public License v3.0 — see [LICENSE](LICENSE) for the full text.

**Created and maintained by WickedYoda.**

---

## Acknowledgments

- SteamCMD by Valve Corporation — https://developer.valvesoftware.com/wiki/SteamCMD
- Wine — https://www.winehq.org/
- Once Human — https://www.oncehuman.game/