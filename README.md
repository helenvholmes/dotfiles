# dotfiles
Stuff that's worth shuttling from computer to computer, lest I forget

## Layout

| Path | What it is | Where it goes |
| --- | --- | --- |
| `zsh/.zshrc` | Shell config (oh-my-zsh, nvm, PATH) | `~/.zshrc` (symlinked) |
| `git/.gitconfig` | Git user config | `~/.gitconfig` (symlinked) |
| `git/.gitignore_global` | Ignores for every repo (`.DS_Store`, `.env`, …) | `~/.gitignore_global` (symlinked) |
| `vscode/settings.json` | VS Code user settings | `~/Library/Application Support/Code/User/` (symlinked) |
| `vscode/snippets/` | VS Code user snippets for TS and TSX | `…/Code/User/snippets/` (symlinked) |
| `vscode/extensions.json` | VS Code extensions I use | installed with `./install.sh --extensions` |
| `Brewfile` | Homebrew formulae, casks and global npm packages | installed with `./install.sh --brew` |
| `templates/nextjs/` | `.gitignore`, `.prettierrc`, `tsconfig.json` and `.vscode/settings.json` for a new Next.js project | copy into the project by hand |

## Install

Prerequisites: [Homebrew](https://brew.sh), [oh-my-zsh](https://ohmyz.sh) and [nvm](https://github.com/nvm-sh/nvm).

```sh
git clone https://github.com/helenvholmes/dotfiles ~/code/dotfiles
cd ~/code/dotfiles
./install.sh                       # symlink the dotfiles
./install.sh --brew --extensions   # also install Homebrew packages and VS Code extensions
```

Any file that's already in the way gets moved to `<file>.backup.<timestamp>` before it's linked, and running the script again is safe. Because everything is symlinked, edits made in place (for example through VS Code's settings UI) show up here as changes to commit.

To start a Next.js project from the templates:

```sh
cp -R ~/code/dotfiles/templates/nextjs/. path/to/project/
```

The `.prettierrc` there needs `prettier-plugin-tailwindcss` installed in the project.

## Secrets and machine-specific config

**Never commit secrets here.** API keys, tokens and anything specific to one machine go in `~/.zshrc.local`, which `.zshrc` sources if it exists and which this repo ignores.

```sh
# ~/.zshrc.local
export OPENAI_API_KEY="..."
```

## Updating the Brewfile

```sh
brew bundle dump --no-vscode --force --file=~/code/dotfiles/Brewfile
```
