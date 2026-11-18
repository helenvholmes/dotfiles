# ~/.zprofile — runs once when a login shell starts, before ~/.zshrc.
# Lives in ~/code/dotfiles/zsh/.zprofile. Every choice below has its reason above it.
#
# What goes here: anything that sets up PATH or the environment. Every iTerm window is a
# login shell, so this runs there. It also runs for the hidden login shells that GUI apps
# (Cursor, the Claude app, editors) start to find out your PATH. Those don't read ~/.zshrc,
# so anything a tool needs to find (node, python, claude, brew packages) belongs here.
# Things that only matter while typing (prompt, completion, aliases) go in ~/.zshrc.

# ── Homebrew ────────────────────────────────────────────────────────────────
# Puts /opt/homebrew/bin on PATH and sets HOMEBREW_PREFIX, which ~/.zshrc uses to find
# the zsh add-ons. Everything installed from the Brewfile depends on this line.
eval "$(/opt/homebrew/bin/brew shellenv)"

# ── Ruby ────────────────────────────────────────────────────────────────────
# rbenv picks the Ruby version: 3.2.9 by default, or whatever a project's .ruby-version
# says. --no-rehash skips rebuilding its shims on every shell start, which is slow;
# rbenv rehashes by itself after `gem install`.
eval "$(rbenv init - --no-rehash zsh)"

# ── Node ────────────────────────────────────────────────────────────────────
# fnm instead of nvm: same job, but written in Rust, so it adds ~5 ms to startup instead
# of nvm's ~300 ms. Set up here rather than in ~/.zshrc so editors and AI tools get the
# same node as the terminal.
# --use-on-cd switches Node automatically when you cd into a folder with an .nvmrc or
# .node-version; "recursive" also checks parent folders. (The `nvm` command that
# translates to fnm is in ~/.zshrc, since it's only for typing.)
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"

# ── ~/.local/bin ────────────────────────────────────────────────────────────
# Holds Claude Code, llama, and uv's `python`/`python3`. It goes first so these win over
# older copies with the same name elsewhere on PATH (macOS's own python3, for one).
export PATH="$HOME/.local/bin:$PATH"
