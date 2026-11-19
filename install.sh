#!/usr/bin/env bash
# Sets up a Mac from this repo. Always symlinks the dotfiles into place (anything already
# there is moved to <file>.backup.<timestamp>), then optionally installs Homebrew packages
# and apps. Safe to run again.
#
#   ./install.sh                     asks what to install (a menu)
#   ./install.sh --link              only link the dotfiles, no questions
#   ./install.sh --brew              also install Brewfile (tools and shared apps)
#   ./install.sh --work              …plus Brewfile.work (implies --brew)
#   ./install.sh --personal          …plus Brewfile.personal (implies --brew)
#   ./install.sh --extensions        also install Cursor extensions
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CURSOR_USER="$HOME/Library/Application Support/Cursor/User"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
  local src="$DOTFILES/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "already linked  $dest"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.backup.$STAMP"
    echo "backed up       $dest -> $dest.backup.$STAMP"
  fi
  ln -s "$src" "$dest"
  echo "linked          $dest"
}

link zsh/.zprofile                    "$HOME/.zprofile"
link zsh/.zshrc                       "$HOME/.zshrc"
link starship/starship.toml           "$HOME/.config/starship.toml"
link starship/starship-plain.toml     "$HOME/.config/starship-plain.toml"
link iterm/Pastel.json                "$HOME/Library/Application Support/iTerm2/DynamicProfiles/Pastel.json"
link git/.gitconfig                   "$HOME/.gitconfig"
link git/ignore                       "$HOME/.config/git/ignore"
link git/allowed_signers              "$HOME/.config/git/allowed_signers"
link ssh/config                       "$HOME/.ssh/config"
link cursor/settings.json             "$CURSOR_USER/settings.json"
link cursor/keybindings.json          "$CURSOR_USER/keybindings.json"
link cursor/snippets/typescript.json      "$CURSOR_USER/snippets/typescript.json"
link cursor/snippets/typescriptreact.json "$CURSOR_USER/snippets/typescriptreact.json"

command -v starship >/dev/null || echo "note: run ./install.sh --brew for starship, fnm and the zsh add-ons"
touch "$HOME/.hushlogin"  # an empty ~/.hushlogin hides "Last login: …" in new terminal windows

[ -f "$HOME/.zshrc.local" ] || echo "note: no ~/.zshrc.local yet — put secrets and machine-specific exports there"

# ── What to install ─────────────────────────────────────────────────────────
brew=false work=false personal=false extensions=false

ask_yes() {  # ask_yes "Question" default(y/n) → returns 0 for yes
  local reply hint="[y/N]"; [ "$2" = y ] && hint="[Y/n]"
  read -r -p "$1 $hint " reply
  reply="${reply:-$2}"
  [[ "$reply" =~ ^[Yy] ]]
}

if [ $# -eq 0 ] && [ -t 0 ]; then
  echo
  if ask_yes "Install Homebrew tools and apps?" y; then
    brew=true
    echo
    echo "What kind of Mac is this?"
    echo "  1) Personal   shared apps + Brewfile.personal"
    echo "  2) Work       shared apps + Brewfile.work"
    echo "  3) Both       shared apps + both"
    echo "  4) Neither    shared tools and apps only"
    while :; do
      read -r -p "Choose 1-4: " kind
      case "$kind" in
        1) personal=true; break ;;
        2) work=true; break ;;
        3) personal=true; work=true; break ;;
        4) break ;;
        *) echo "Type 1, 2, 3 or 4." ;;
      esac
    done
  fi
  echo
  ask_yes "Install Cursor extensions?" n && extensions=true
else
  for arg in "$@"; do
    case "$arg" in
      --link) ;;
      --brew) brew=true ;;
      --work) brew=true; work=true ;;
      --personal) brew=true; personal=true ;;
      --extensions) extensions=true ;;
      *) echo "unknown option: $arg (see the top of install.sh)" >&2; exit 1 ;;
    esac
  done
fi

# ── Work-only setup ─────────────────────────────────────────────────────────
# Storybook snippets are for work projects, so only a work Mac gets them
if $work; then
  link cursor/snippets/work/storybook.code-snippets "$CURSOR_USER/snippets/storybook.code-snippets"
fi

# ── Homebrew ────────────────────────────────────────────────────────────────
if $brew; then
  # Turso's formula needs sqld from libSQL's tap, and Homebrew won't install from a
  # third-party tap until it's trusted. It's Turso's own project; trusted on purpose.
  brew tap libsql/sqld && brew trust libsql/sqld
  files=(Brewfile)
  $work && files+=(Brewfile.work)
  $personal && files+=(Brewfile.personal)
  for f in "${files[@]}"; do
    echo; echo "── brew bundle: $f"
    brew bundle --file="$DOTFILES/$f" || echo "note: some of $f didn't install; run it again or check the messages above"
  done
  command -v corepack >/dev/null && corepack enable pnpm  # pnpm through Corepack, see Brewfile
fi

# ── Cursor extensions ───────────────────────────────────────────────────────
if $extensions; then
  cursor="$(command -v cursor || echo "/Applications/Cursor.app/Contents/Resources/app/bin/cursor")"
  grep -vE '^[[:space:]]*(#|$)' "$DOTFILES/cursor/extensions.txt" |
    while read -r ext; do "$cursor" --install-extension "$ext"; done
fi
