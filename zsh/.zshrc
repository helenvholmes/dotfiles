# ~/.zshrc — runs for every new interactive shell, after ~/.zprofile.
# Lives in ~/code/dotfiles/zsh/.zshrc. Every choice below has its reason above it.

# ── Homebrew ────────────────────────────────────────────────────────────────
# `brew shellenv` in ~/.zprofile normally sets HOMEBREW_PREFIX. The fallback keeps
# this file working if ~/.zprofile didn't run (some editors start shells without it).
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

# ── Completion ──────────────────────────────────────────────────────────────
# Tab completes commands, git branches, flags and file names.
# Homebrew installs completions for its tools (gh, fnm, uv, starship…) in site-functions,
# so that folder has to be on FPATH before compinit runs.
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
autoload -Uz compinit && compinit
# Case-insensitive: `cd doc<Tab>` finds Documents
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Tab twice shows the matches as a menu you can move through with the arrow keys
zstyle ':completion:*' menu select

# ── History ─────────────────────────────────────────────────────────────────
# Same file and size oh-my-zsh used, so no history was lost in the switch.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
# SHARE_HISTORY: a command run in one window can be recalled in the others
# EXTENDED_HISTORY: keeps a timestamp with each entry (the file already has them)
# HIST_IGNORE_ALL_DUPS: running a command again moves it to the end instead of duplicating it
# HIST_IGNORE_SPACE: start a command with a space to keep it out of history (handy for secrets)
setopt SHARE_HISTORY EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE

# Up/down arrows search history for lines that start with what you've typed:
# type `git` then ↑ to step back through only your git commands. oh-my-zsh did this too.
# Two codes per key because terminals send either depending on their mode.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search '^[OB' down-line-or-beginning-search

# ── Small conveniences ──────────────────────────────────────────────────────
# Type a folder's name on its own to cd into it
setopt AUTO_CD
# Colored output from ls (folders, links and executables in different colors)
export CLICOLOR=1

# ── Shortcuts kept from oh-my-zsh ───────────────────────────────────────────
# The only three of its ~150 aliases that show up in my history.
alias gp='git push'
alias la='ls -lAh'   # long list, including hidden files, human-readable sizes
alias ..='cd ..'

# ── Node ────────────────────────────────────────────────────────────────────
# fnm itself is set up in ~/.zprofile, so editors and AI tools find the same node.
# `nvm` kept as a command because it's muscle memory. Each nvm command is translated
# to its fnm equivalent; anything not listed (use, install, uninstall…) is the same
# word in both, so it's passed straight through.
nvm() {
  local cmd="$1"
  (( $# )) && shift
  case "$cmd" in
    ls|list)       fnm list "$@" ;;
    ls-remote)     fnm list-remote "$@" ;;
    current)       fnm current ;;
    alias)         if [[ "$1" == default ]]; then fnm default "$2"; else fnm alias "$@"; fi ;;
    exec)          local v="$1"; shift; fnm exec --using="$v" "$@" ;;
    run)           local v="$1"; shift; fnm exec --using="$v" node "$@" ;;
    which)         fnm exec --using="${1:-default}" which node ;;
    ""|help)       echo "nvm here is fnm underneath. Common: nvm use, nvm install, nvm ls, nvm alias default <v>"; fnm --help ;;
    *)             fnm "$cmd" "$@" ;;
  esac
}

# ── Python ──────────────────────────────────────────────────────────────────
# Python comes from uv (installed with Homebrew), not pyenv, Homebrew's python@ formulae
# or the Python.org installer. uv installs Python itself and links `python` and `python3`
# into ~/.local/bin (put on PATH in ~/.zprofile), so both names run the same Python (3.12).
#   New default version:  uv python install --default 3.13
#   Run a tool once:      uvx <tool>         e.g. `uvx poetry install` for Poetry projects
#   Install packages:     uv pip install … inside a project's venv, or `uv add` in a uv project

# ── Secrets ─────────────────────────────────────────────────────────────────
# API keys and anything specific to one machine live in ~/.zshrc.local, which is
# never committed. Loaded near the end so it can override anything above.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# ── Prompt and add-ons ──────────────────────────────────────────────────────
# Grey suggestions from history as you type; press → to accept one.
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Starship draws the prompt ("little icons" theme, ~/.config/starship.toml). It's a single
# fast binary updated by `brew upgrade`, so nothing nags to update itself on startup.
# The Claude app's terminal can't load the Nerd Font the icons come from, so there it
# uses starship-plain.toml: the same prompt with ordinary Unicode symbols (✿ ♥ ⎇ ⬢).
[[ "$TERM_PROGRAM" == claude-desktop ]] && export STARSHIP_CONFIG="$HOME/.config/starship-plain.toml"
eval "$(starship init zsh)"
# Colors commands as you type, red if the command doesn't exist. Must load last:
# it wraps the keyboard handlers everything above has already set up.
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
