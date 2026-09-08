# Once Human Game Server - Setup Guide

Host and play on your own self-hosted Once Human server via Docker + Wine + SteamCMD.

## Quick Start

```bash
git clone https://github.com/wickedyoda/OnceHuman_GameServer.git
cd OnceHuman_GameServer

cp .env.example .env
docker compose up -d --build
```

## Configuration

### Environment Variables (`.env`)

```env
SERVER_NAME=My Once Human Server
MAX_PLAYERS=16
SERVER_PASSWORD=
ADMIN_PASSWORD=
PVE_ENABLED=True
DAY_LENGTH=60
NIGHT_LENGTH=30
```

### GameUserSettings.ini

Located at `config/GameUserSettings.ini`. Edits are picked up on container restart (file is mounted read-only into the container).

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 27015 | TCP/UDP | Game traffic |
| 27016 | TCP/UDP | Query/heartbeat |
| 27017 | TCP | RCON |

Forward these in your router settings.

## Volume Mappings

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `./saves/` | `/home/wineuser/.wine/drive_c/oncehuman/Saved` | World saves, configs, logs |
| `./config/GameUserSettings.ini` | Read-only config | Server settings |

## Running

```bash
# Start
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down
```

## Admin Access

### Find Your Server IP

```bash
curl ifconfig.me
```

### In-Game Server Browser

1. Launch Once Human on PC, PS5, Xbox, or mobile.
2. Open **Servers**, search for your `SERVER_NAME`.
3. Join and enter password if set.

### Direct Connect

- **PC:** press `` ` `` or `~` to open the console, then type:
  ```
  open <your-public-ip>:27015
  ```
- **Console/Mobile:** use the direct-connect field and enter `<your-public-ip>:27015`

### Connection Checklist

- Ports forwarded: TCP/UDP `27015`, `27016`, `27017`
- Server running: `docker compose ps`
- Using the **public IP**, not a LAN address like `192.168.x.x`
- Same game version

### Cross-Platform Notes

Once Human supports crossplay between PC, PS5, Xbox, and mobile.

### RCON

```bash
rcon-cli -host localhost -port 27017 -password <ADMIN_PASSWORD>
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Won't start | `docker compose logs oncehuman` — check Wine errors |
| Port in use | `ss -tlnp \| grep 27015` — kill conflicting process |
| Players can't connect | Verify port forwarding; check firewall |
| Performance | Reduce `MAX_PLAYERS`; increase resources |
| Wine crash | Check `saves/OnceHuman/Saved/Logs/` |
| Save file corrupted | Stop container; restore from backup |

## References

- Server Setup Wiki: https://www.oncehuman.wiki/guides/dedicated-server.html