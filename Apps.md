# Apps Homebrew can't install

Everything else comes from the Brewfiles (`./install.sh`). These are reinstalled by hand.
`bin/apps-check` reads the first column of the table below, so keep each app's name there
exactly as it appears in Applications (without `.app`).

| App | What it's for | Where to get it |
| --- | --- | --- |
| Dots | Status line and hooks for Claude Code (`~/.claude/settings.json` calls it) | Dots, from its maker's site (it updates itself from dotsapp.cloudaeri.com) |
| Wonder | Desktop app; also an MCP server in Claude | Wonder's site (bundle `so.wonder.desktop`) |
| Grok Bot | Grok desktop app | its maker's site |
| ArtCraft Launcher | ArtCraft, an AI design tool | the ArtCraft project (bundle `ai.storyteller.artcraft-launcher`) |
| VectorCraft | Vector drawing, from the ArtCraft team (open source) | the VectorCraft project (bundle `ai.storyteller.vectorcraft`) |
| LiveSurface | Product and packaging mockups | [livesurface.com](https://www.livesurface.com) |
| DecentSampler | Free sampler for sample-library instruments | Decent Samples (by Decidedly) |
| qbittorrent | Torrents. Homebrew disabled its cask in 2026 (fails Gatekeeper) | [qbittorrent.org](https://www.qbittorrent.org) |
| OpenEmu | Retro game emulator. Homebrew disabled its cask in 2026 | [openemu.org](https://openemu.org) |
| BookBox | A Safari web app for my book-box project | Safari → open the site → File → Add to Dock |

**Steam games** (Hollow Knight, Disco Elysium, GRIS…) come back from the Steam library;
Steam makes their `~/Applications` shortcuts itself.
