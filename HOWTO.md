# Once Human Game Server - Setup Guide

Host and play on your own Once Human Private Hive server.

## ⚠️ Official Model Note

Once Human custom servers are **rental-based** through official channels. This container provides a self-hosted alternative using Wine to run the Windows server binary. Character progress from official servers does **not** transfer to self-hosted servers.

Official rental: https://www.oncehuman.game/2026/csfy/

---

## Quick Start

```bash
git clone https://github.com/wickedyoda/OnceHuman_GameServer.git
cd OnceHuman_GameServer

cp .env.example .env
cp config/GameUserSettings.ini.example config/GameUserSettings.ini
cp .env.example config/GameUserSettings.ini.example  # if missing

docker compose up -d --build
```

---

## Configuration

### Environment Variables (`.env`)

```env
# Required (for Private Hive):
# HIVE_LICENSE=  # Get from https://www.oncehuman.game/2026/csfy/

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

Located at `config/GameUserSettings.ini`:

```ini
[/Script/OnceHuman.GameUserSettings]
ServerName=My Once Human Server
MaxPlayers=16
ServerPassword=
AdminPassword=
PvEEnabled=True
DayLength=60
Night_LENGTH=30
XPMultiplier=1.0
ResourceMultiplier=1.0
DropMultiplier=1.0
```

---

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 27015 | TCP/UDP | Game traffic |
| 27016 | TCP/UDP | Query/heartbeat |
| 27017 | TCP | RCON (admin) |

Forward these in your router settings.

---

## Volume Mappings

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `./saves/` | `/home/wineuser/.wine/drive_c/oncehuman/Saved` | World saves, configs, logs |
| `./config/GameUserSettings.ini` | Read-only config | Server settings |

---

## Running

```bash
# Start
docker compose up -d

# View logs
docker compose logs -f

# Stop
docker compose down
```

---

## Admin Access

### In-Game
Connect to your server, open console, use `/admin` commands.

### RCON
```bash
# Example with rcon-cli (install via pip)
rcon-cli -host localhost -port 27017 -password <ADMIN_PASSWORD>
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Won't start | `docker compose logs oncehuman` — check for Wine errors |
| Port in use | `ss -tlnp \| grep 27015` — kill conflicting process |
| Players can't connect | Verify port forwarding; check firewall (`ufw status`) |
| Performance | Reduce `MAX_PLAYERS`; increase allocated RAM/CPU |
| Wine crash | Check `saves/OnceHuman/Saved/Logs/` for errors |
| Save file corrupted | Stop container; restore from backup |

---

## Character Transfer

Once Human custom servers have **separate character data** from official servers. Use the in-game "Server Transfer" feature if available.

---

## References

- Official Custom Server Guide: https://www.oncehuman.game/2026/csfy/
- Server Setup Wiki: https://www.oncehuman.wiki/guides/dedicated-server.html