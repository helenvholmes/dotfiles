# oh-my-zsh — see https://github.com/ohmyzsh/ohmyzsh/wiki for the full list of options
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Aliases
alias python=/usr/bin/python3

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# PATH
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"  # Homebrew Ruby is keg-only
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# GPG
# export GPG_TTY=$(tty)

# Secrets and machine-specific config live here, never in this repo
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
