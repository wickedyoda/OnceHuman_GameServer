# Once Human Game Server — Security Assessment

## Findings

### High

1. **RCON exposed without bind restriction**
   - `27017` is published to `0.0.0.0` in compose.
   - Impact: anyone on the network/internet can attempt RCON brute-force if the host firewall doesn’t restrict it.
   - Fix: bind RCON to `127.0.0.1` and expose only game/query ports, or restrict via host firewall.

2. **Secrets in environment variables**
   - `SERVER_PASSWORD` and `ADMIN_PASSWORD` are passed via compose env.
   - Impact: visible in `docker inspect`, process lists, and potentially logs.
   - Fix: use Docker secrets or a restricted `.env` file with `chmod 600`.

3. **Running as non-root but with broad home directory**
   - User `oncehuman` owns `/opt/oncehuman`.
   - Impact: if the game server process is compromised, attacker has write access to server binaries.
   - Fix: split runtime writable paths from install path; make server install read-only.

### Medium

4. **No image provenance or signature verification**
   - Base image `steamcmd/steamcmd:latest` is pulled without digest pinning.
   - Impact: supply-chain compromise via upstream image change.
   - Fix: pin to a digest SHA and enable Docker Content Trust.

5. **No resource hard limit enforcement on some hosts**
   - `deploy.resources` only works in swarm/with `--compatibility`.
   - Impact: a runaway server can starve the host.
   - Fix: add `mem_limit`/`cpus` at top level or run on a constrained VM/container host.

6. **Saved/config world data not encrypted at rest**
   - `saved/` is bind-mounted as plain files.
   - Impact: host compromise exposes world state and player data.
   - Fix: optional host-level encryption on the mount path.

### Low

7. **Anonymous SteamCMD login**
   - `+login anonymous` is standard for public servers.
   - Impact: minimal; Valve’s anonymous install is intended for this use.
   - Mitigation: restrict outbound Steam traffic if policy requires.

8. **Port forwarding exposure**
   - Game ports open to internet increases scan surface.
   - Impact: DDoS, probing, exploit attempts against game service.
   - Fix: place behind Cloudflare Spectrum/IPTables rate limits or run a VPN-only allowlist.

## Recommended Hardening

- Add `read_only: true` to the service and use tmpfs for writable runtime dirs.
- Move RCON to a unix socket or localhost-only bind.
- Add `.env` to `.gitignore` (already present) and enforce `chmod 600 .env`.
- Pin base image by digest and scan with Trivy/Grype on update.
- Run `docker compose up` with `--pull always` in CI and diff updated binaries.
