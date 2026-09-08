# Once Human Dedicated Server

**⚠️ As of 2026-09-08, a self-hosted Once Human dedicated server is not currently possible.**

The developer has not released the server-side files needed to run a self-hosted instance. SteamCMD returns `Missing configuration` for App ID 2139460 because the server binaries are not available for anonymous/public download.

This repository remains as a **research archive** documenting the attempted approach using Docker + Wine + SteamCMD.

---

## Status

| Item | State |
|---|---|
| Server files publicly available | ❌ No |
| Anonymous SteamCMD download | ❌ Fails with `Missing configuration` |
| Official self-hosted server tool | ❌ Not released |
| Docker image build | ✅ Builds successfully |
| Wine + SteamCMD setup | ✅ Proven in container |
| Security scanning | ✅ Trivy + Gitleaks integrated |

---

## Why It Doesn't Work

After extensive testing:

- SteamCMD `app_update 2139460` fails with `Missing configuration` for anonymous users
- App ID 2139460 requires Steam account ownership; there is no free server download
- The oncehuman.wiki guide references `OnceHumanServer.sh`, but this binary is not accessible via public SteamCMD
- The game's official "Custom Servers" program is a **rental service** hosted by NetEase/Starry Studio, not a self-hostable release

---

## What This Repo Contains

Even though the server cannot be run, this repo preserves the complete Docker build infrastructure:

- `Dockerfile` — Debian 12 + Wine + Windows SteamCMD setup
- `entrypoint.sh` — Wine prefix initialization + SteamCMD install logic
- `docker-compose.yml` — Production-ready compose with resource limits
- `.github/workflows/docker.yml` — Multi-arch GHCR build on merge
- `SECURITY.md` — Container/network/Wine/SteamCMD security guidance
- `config/GameUserSettings.ini` — Server config template
- `.security-reports/` — Trivy + Gitleaks scan reports

---

## If the Developer Releases Server Files

When/if the Once Human developer releases server binaries, this repo can be reactivated by:

1. Confirming the correct Steam App ID or direct download URL
2. Updating `entrypoint.sh` with the correct install path and executable
3. Rebuilding and pushing the Docker image

---

## License

GNU General Public License v3.0 — see [LICENSE](LICENSE) for the full text.

**Created and maintained by WickedYoda.**

---

## References

- [Once Human Official Site](https://www.oncehuman.game/)
- [Once Human Custom Servers (rental)](https://www.oncehuman.game/2026/csfy/)
- [Once Human Wiki](https://www.oncehuman.wiki/)
- [SteamCMD Documentation](https://developer.valvesoftware.com/wiki/SteamCMD)