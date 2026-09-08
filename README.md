# Once Human Dedicated Server

**⚠️ IMPORTANT: Self-Hosted Server NOT Available**

After extensive testing, **Once Human does not provide a self-hostable dedicated server**. The `app_update 2139460` is the full game client (~131 GB), and SteamCMD returns "Missing configuration" for anonymous downloads because the app requires Steam ownership.

## Official Solution: NetEase Custom Servers

Once Human officially launched **Custom Servers** on June 18, 2025. These are NetEase-hosted rental servers where you:
- Rent an official server instance from in-game
- Customize world rules and settings
- Control your own multiplayer experience

### How to Access:
1. Launch Once Human on Steam
2. In-game, navigate to **Custom Server** creation
3. Rent a server with your preferred settings

## What This Repo Documents

This repository documents the **attempted** self-hosting approach that does not work:

- Docker image build process
- Valve SteamCMD usage
- Wine configuration for Windows games
- Security hardening patterns

**It does NOT provide a functional Once Human dedicated server.**

## Technical Details

### Why SteamCMD Fails
```
ERROR! Failed to install app '2139460' (Missing configuration)
```

App ID 2139460 requires:
- Steam account ownership
- No public anonymous download endpoint

### Related Research
- [Once Human Custom Servers Announcement](https://www.oncehuman.game/2026/csfy/)
- [NetEase News: Custom Servers Launch](https://www.neteasegames.com/news/20250620/37000_1242171.html)