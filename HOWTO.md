# Once Human Dedicated Server — HOWTO

## 1. Prerequisites

- Docker Engine 24+
- Docker Compose v2+
- 4GB RAM minimum
- Ports 27015, 27016, 27017 available

## 2. Initial Setup

```bash
# Clone this repo
git clone https://github.com/wickedyoda/OnceHuman_GameServer.git
cd OnceHuman_GameServer

# Create env file
cp .env.example .env
nano .env
```

Edit `.env` and set:
- `SERVER_NAME`
- `MAX_PLAYERS`
- `SERVER_PASSWORD`
- `ADMIN_PASSWORD`

## 3. Start the Server

```bash
docker compose up -d --build
```

Watch logs:
```bash
docker compose logs -f oncehuman
```

Wait for:
```
Server is ready
```

## 4. Connect

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

If your server doesn’t appear in the browser:
- **PC:** press `` ` `` or `~` to open the console, then type:
  ```
  open <your-public-ip>:27015
  ```
- **Console/Mobile:** use the direct-connect field and enter `<your-public-ip>:27015`

### Connection Checklist

- Ports forwarded: TCP/UDP `27015`, `27016`, `27017`
- Server running: `docker compose ps`
- Using the **public IP**, not a LAN address like `192.168.x.x`
- Same game version — update the server with `docker compose pull && docker compose up -d --build` if needed

### Cross-Platform Notes

Once Human supports crossplay between PC, PS5, Xbox, and mobile. All clients connect the same way via IP or server browser. Players just need their own Once Human account/license and the server password if set.

## 5. Character Transfer

### Important Limitation

Official Once Human servers and custom/community servers are **separate**. According to official announcements and Steam discussions:

- Characters from official servers **do not appear** in custom servers.
- Custom servers **do not support data migration** between scenarios.
- Each character is **bound to the specific server** where it was created.
- When a server is reset, characters retain nickname/appearance, but **all other progress is erased**.

### What This Means for Your Self-Hosted Server

Players joining your self-hosted server will need to **create new characters** there. Their official-server progress cannot be imported or transferred.

### If Transfer Becomes Available

If future updates add export/import functionality:

1. Export the character on the source server.
2. Stop the server here: `docker compose stop oncehuman`
3. Place exported data into the mounted `saved/` directory on the host.
4. Start the server: `docker compose up -d`
5. Confirm the character appears.

### Backup First

Always back up `saved/` before importing any data:
```bash
cp -r saved saved-backup-$(date +%Y%m%d)
```

## 6. Manage the Server

### RCON
Use any RCON client with:
- Host: `localhost:27017`
- Password: value of `ADMIN_PASSWORD`

### Useful Commands
```
listplayers
kick <name>
ban <name>
saveworld
```

### Restart
```bash
docker compose restart oncehuman
```

### Update Server Files
```bash
docker compose pull
docker compose up -d --build
```

## 6. Backup

Back up these directories regularly:
- `saved/` — world save data
- `config/` — server settings

## 7. Port Forwarding

Forward these ports on your router to this host:
- TCP/UDP 27015
- TCP/UDP 27016
- TCP/UDP 27017

## Troubleshooting

**Friends can't connect:**
- Check port forwarding
- Verify firewall allows ports
- Confirm server is running: `docker compose ps`
- Use public IP, not 192.168.x.x

**Server won't start:**
- Check logs: `docker compose logs`
- Verify ports aren't in use
- Ensure enough RAM available

**Performance issues:**
- Reduce `MAX_PLAYERS`
- Lower resource multipliers
- Check CPU/RAM limits in `docker-compose.yml`

## License

This project is licensed under the GNU General Public License v3.0. See the repository [LICENSE](./LICENSE) file for details.
