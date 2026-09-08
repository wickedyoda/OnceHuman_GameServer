# Once Human Game Server - Security Considerations

## Overview

This document covers the security posture of the Once Human Dedicated Server Docker container and recommendations for production deployment.

## Container Security

### Non-Root Execution
The server runs as user `oncehuman` (UID 1000), not root. This limits the impact of any potential exploit.

### Read-Only Root Filesystem
The container root filesystem is mounted read-only (`read_only: true` in docker-compose). Only specific directories are writable:
- `/tmp` (tmpfs)
- `/run` (tmpfs)
- `/home/oncehuman/.wine` (tmpfs or host volume)

### No-New-Privileges
Security option `no-new-privileges:true` prevents processes from gaining additional privileges via setuid binaries or capabilities.

### tmpfs Mounts
Temporary filesystems for `/tmp`, `/run`, and `.wine` prevent persistent storage of sensitive data on the host.

## Network Security

### Port Exposure
Only required ports are exposed:
- 27015 (TCP/UDP) - game traffic
- 27016 (TCP/UDP) - query/heartbeat  
- 27017 (TCP) - RCON

### Firewall Considerations
- Ensure host firewall allows only these ports
- Use a reverse proxy if exposing RCON externally (not recommended for untrusted networks)
- Keep RCON password strong and unique

## SteamCMD Security

### Steam Account
- Use a dedicated Steam account for the server, not your personal account
- Enable Steam Guard (2FA)
- Do not share Steam credentials

### SteamCMD Downloads
- Always validate downloads (`validate` flag in SteamCMD)
- Verify file integrity after download
- Run SteamCMD as a non-root user

## Wine Security

### Wine Prefix Isolation
- Wine prefix (`~/.wine`) contains registry and system files
- Keep it writable only by the `oncehuman` user
- Do not mount host paths into the Wine prefix

### Wine Binary
- Use official Wine packages from Debian repositories
- Verify package signatures on installation

## Host Security

### Volume Mounts
- `./saves` - world data, may contain player data (GDPR consideration)
- `./config/GameUserSettings.ini` - mounted read-only, no host writes
- Ensure host directories have appropriate permissions (owned by Docker user or root)

### Docker Socket
- Do not mount Docker socket into the container
- Container should not have privileged mode

### Resource Limits
- CPU and memory limits prevent resource exhaustion
- Configure limits appropriate to your hardware

## Monitoring

- Monitor container logs for unexpected behavior
- Watch for unusual network connections
- Track resource usage (CPU, memory, disk)

## Known Limitations

- The server runs Windows binaries via Wine — inherent limitations of Wine on Linux apply
- SteamCMD requires Steam account credentials at runtime
- Multi-arch builds (arm64) require WineARM64 — not tested in this setup

## Updates

Keep the base image updated:
```bash
docker compose pull
docker compose up -d
```

Or rebuild locally to pick up security patches:
```bash
docker compose build --no-cache
docker compose up -d
```

## License

GPL-3.0 — Created and maintained by WickedYoda