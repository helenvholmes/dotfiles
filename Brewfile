# Brewfile — everything every Mac gets: command-line tools, the shell setup and the apps
# I use on any machine. Apps for one kind of Mac live in Brewfile.work and
# Brewfile.personal; ./install.sh asks which to add.
#
# Apps were installed by hand on the Mac this repo came from, so there they're adopted
# once with `bin/adopt-apps` (asks for your password). Most apps update themselves, and
# `brew upgrade` leaves those alone.

# ── Command-line tools ──────────────────────────────────────────────────────
tap "homebrew/services"
# Turso's own taps. Homebrew won't install from a third-party tap until it's trusted;
# install.sh runs `brew trust libsql/sqld` before `brew bundle`.
tap "libsql/sqld"
tap "tursodatabase/tap"
# Cross-platform make
brew "cmake"
# Play, record, convert, and stream select audio and video codecs
brew "ffmpeg"
# GitHub command-line tool
brew "gh"
# Distributed revision control system
brew "git"
# Fast Node version manager (stands in for nvm)
brew "fnm"
# Simple zero-configuration command-line HTTP server
brew "http-server"
# Port scanning utility for large networks
brew "nmap"
# Ruby version manager
brew "rbenv"
# Search tool like grep and The Silver Searcher
brew "ripgrep"
# Safe, concurrent, practical language
brew "rust"
# Nodejs-based tool for optimizing SVG vector graphics files
brew "svgo"
# Cross-shell prompt (config in starship/starship.toml)
brew "starship"
# Python versions, packages and tools (uv python install / uvx)
brew "uv"
# Turso CLI (libSQL databases); brings sqld, the local database server, with it
brew "tursodatabase/tap/turso"
# Installs App Store apps from the Brewfile (`mas` lines below)
brew "mas"
# Internet file retriever
brew "wget"
# Feature-rich command-line audio/video downloader
brew "yt-dlp"
# Fish-like autosuggestions for zsh
brew "zsh-autosuggestions"
# Fish shell like syntax highlighting for zsh
brew "zsh-syntax-highlighting"

# ── Apps ────────────────────────────────────────────────────────────────────
# Browsers
cask "brave-browser"
cask "firefox"
cask "google-chrome"
# Code and AI
cask "claude"
cask "cursor"
cask "iterm2"
# Design and notes
cask "figma"
cask "notion"
# Work and chat (on every Mac)
cask "airtable"
cask "slack"
cask "zoom"
# Passwords
cask "1password"

# ── System add-ons ──────────────────────────────────────────────────────────
# Nerd Font icons only, used by the Starship prompt alongside Monaco
cask "font-symbols-only-nerd-font"

# ── Global npm packages ─────────────────────────────────────────────────────
# Installed into fnm's default Node (run `brew bundle` from a shell where fnm is set up).
# pnpm comes from Corepack, which ships with Node: `corepack enable pnpm`.
npm "@qwen-code/qwen-code"
npm "npm-check-updates"
npm "vercel"

# ── App Store ───────────────────────────────────────────────────────────────
# Installed with mas from my App Store account (sign in to the App Store first).
mas "Amphetamine", id: 937984704
