# Once Human Game Server - Setup Guide

Host and play on your own Once Human Private Hive server.

## ⚠️ Official Model Note

Once Human custom servers are **rental-based** through official channels. This container provides a self-hosted alternative using Wine to run the Windows server binary. Character progress from official servers does **not** transfer to self-hosted servers.

Official rental: https://www.oncehuman.game/2026/csfy/

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
# Private Hive license (from https://www.oncehuman.game/2026/csfy/ if you have one):
HIVE_LICENSE=

# Server settings:
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

On the server host:

```bash
curl ifconfig.me
```

Use that public IP for connections from outside your network.

### In-Game Server Browser

1. Launch Once Human on any platform: PC, PS5, Xbox, or mobile.
2. From the main menu, open **Servers**.
3. Search for the `SERVER_NAME` you set in `.env`.
4. Select it and click **Join**.
5. If you set a `SERVER_PASSWORD`, enter it when prompted.

### Direct Connect

If your server doesn't appear in the browser:

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

Once Human supports crossplay between PC, PS5, Xbox, and mobile. All clients connect the same way via IP or server browser. Players just need their own Once Human account/license and the server password if set.

### RCON

```bash
# Example with rcon-cli (install via pip)
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

## Character Transfer

Official Once Human servers and custom/community servers are **separate** per official announcements. Characters created on official servers do **not appear** in custom servers and cannot be imported. Players joining your self-hosted server must create new characters.

## References

- Official Custom Server Guide: https://www.oncehuman.game/2026/csfy/
- Server Setup Wiki: https://www.oncehuman.wiki/guides/dedicated-server.html