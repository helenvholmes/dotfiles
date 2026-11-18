#!/usr/bin/env bash
# Symlinks these dotfiles into place. Existing files are moved to <file>.backup.<timestamp>.
#
#   ./install.sh               link dotfiles
#   ./install.sh --extensions  also install VS Code extensions
#   ./install.sh --brew        also run `brew bundle`
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
VSCODE_USER="$HOME/Library/Application Support/Code/User"
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
link iterm/Pastel.json                "$HOME/Library/Application Support/iTerm2/DynamicProfiles/Pastel.json"
link git/.gitconfig                   "$HOME/.gitconfig"
link git/ignore                       "$HOME/.config/git/ignore"
link git/allowed_signers              "$HOME/.config/git/allowed_signers"
link ssh/config                       "$HOME/.ssh/config"
link vscode/settings.json             "$VSCODE_USER/settings.json"
link vscode/snippets/typescript.json      "$VSCODE_USER/snippets/typescript.json"
link vscode/snippets/typescriptreact.json "$VSCODE_USER/snippets/typescriptreact.json"

command -v starship >/dev/null || echo "note: run ./install.sh --brew for starship, fnm and the zsh add-ons"
touch "$HOME/.hushlogin"  # an empty ~/.hushlogin hides "Last login: …" in new terminal windows

[ -f "$HOME/.zshrc.local" ] || echo "note: no ~/.zshrc.local yet — put secrets and machine-specific exports there"

for arg in "$@"; do
  case "$arg" in
    --extensions)
      code="$(command -v code || echo "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code")"
      sed -n 's/^ *"\([^"]*\.[^"]*\)",\{0,1\}$/\1/p' "$DOTFILES/vscode/extensions.json" |
        while read -r ext; do "$code" --install-extension "$ext"; done
      ;;
    --brew)
      brew bundle --file="$DOTFILES/Brewfile"
      ;;
    *)
      echo "unknown option: $arg" >&2
      exit 1
      ;;
  esac
done
