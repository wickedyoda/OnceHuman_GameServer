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

- In-game: add server via IP `your-public-ip:27015`
- Direct connect: `your-public-ip:27015`
- Enter server password if set

## 5. Manage the Server

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
