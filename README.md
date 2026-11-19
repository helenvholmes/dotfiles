# dotfiles
Stuff that's worth shuttling from computer to computer, lest I forget

## Layout

| Path | What it is | Where it goes |
| --- | --- | --- |
| `zsh/.zprofile` | PATH and environment: Homebrew, rbenv, fnm, `~/.local/bin`. Also read by GUI apps, so editors and AI tools find the same `node` and `python` | `~/.zprofile` (symlinked) |
| `zsh/.zshrc` | Interactive shell: completion, history, shortcuts, prompt | `~/.zshrc` (symlinked) |
| `iterm/Pastel.json` | iTerm profile: dark violet background, pastel cursor, Nerd Font icons | `…/iTerm2/DynamicProfiles/` (symlinked) |
| `claude/mods/pastel/` | A Claude mod: the Pastel look (dark violet, pink accent) for the whole Claude app, terminal pane included | installed once with `claude plugin` (see below) |
| `.claude-plugin/marketplace.json` | Makes this repo a plugin source, so Claude can install the mods in `claude/mods/` | read by `claude plugin` |
| `starship/starship.toml` | Prompt theme ("little icons") | `~/.config/starship.toml` (symlinked) |
| `starship/starship-plain.toml` | The same prompt with plain Unicode symbols, for the Claude app's terminal, which can't load the Nerd Font | `~/.config/starship-plain.toml` (symlinked) |
| `git/.gitconfig` | Git settings: commit signing through 1Password, pull/push defaults, sign-in through `gh` | `~/.gitconfig` (symlinked) |
| `git/ignore` | Ignores for every repo (`.DS_Store`, `.env`, keys, Claude's local files) | `~/.config/git/ignore` (symlinked) |
| `ssh/config` | SSH settings: use 1Password's agent (keys stay on the machine, never in this repo) | `~/.ssh/config` (symlinked) |
| `git/allowed_signers` | My public signing key, so git can verify my signatures locally | `~/.config/git/allowed_signers` (symlinked) |
| `cursor/settings.json`, `cursor/keybindings.json` | Cursor settings and shortcuts, with a comment on each | `~/Library/Application Support/Cursor/User/` (symlinked) |
| `cursor/snippets/` | Cursor snippets for TS and TSX; `work/` holds the Storybook ones, linked only on a work Mac | `…/Cursor/User/snippets/` (symlinked) |
| `cursor/extensions.txt` | Cursor extensions, one per line | installed when `./install.sh` asks, or with `--extensions` |
| `Brewfile` | What every Mac gets: command-line tools, shared apps, global npm packages, App Store apps | installed by `./install.sh` |
| `Brewfile.work` / `Brewfile.personal` | Apps for a work Mac or my own Mac | `./install.sh` asks which to add |
| `bin/adopt-apps` | Hands apps installed by hand over to Homebrew, so `brew bundle` knows about them | run once on an existing Mac |
| `templates/nextjs/` | `.gitignore`, `.prettierrc`, `tsconfig.json` and `.vscode/settings.json` for a new Next.js project | copy into the project by hand |

## Install

Prerequisite: [Homebrew](https://brew.sh). The Brewfile brings the rest: [Starship](https://starship.rs) for the prompt, [fnm](https://github.com/Schniz/fnm) for Node (`nvm` still works as a shortcut to it) and two zsh add-ons.

After installing, make the **Pastel** profile iTerm's default: Settings → Profiles → select Pastel → Other Actions → *Set as Default*. It inherits everything from your Default profile and adds the background color and the icon font the prompt needs. Then install Node with `nvm install 22 && nvm alias default 22`.

```sh
git clone https://github.com/helenvholmes/dotfiles ~/code/dotfiles
cd ~/code/dotfiles
./install.sh                       # links the dotfiles, then asks what to install
```

The menu asks whether to install Homebrew tools and apps, what kind of Mac this is (personal, work, both, or neither: shared apps only), and whether to install Cursor extensions. To skip the questions, pass flags instead: `--link` (only link), `--brew`, `--work`, `--personal`, `--extensions`.

Any file that's already in the way gets moved to `<file>.backup.<timestamp>` before it's linked, and running the script again is safe. Because everything is symlinked, edits made in place (for example through Cursor's settings screen) show up here as changes to commit.

To start a Next.js project from the templates:

```sh
cp -R ~/code/dotfiles/templates/nextjs/. path/to/project/
```

The `.prettierrc` there needs `prettier-plugin-tailwindcss` installed in the project.

## Claude's Pastel look

The same colors as the iTerm profile and the prompt, for the Claude app (its terminal pane too). Install it once per Mac, from a shell:

```sh
claude plugin marketplace add ~/code/dotfiles
claude plugin install pastel@dotfiles --scope user
```

Or from anywhere, without cloning this repo first: `/plugin install pastel --marketplace helenvholmes/dotfiles` at a Claude Code prompt. To turn it off: `claude plugin disable pastel@dotfiles`. The colors live in `claude/mods/pastel/hooks/register.ts`; edits there apply to new sessions.

## Secrets and machine-specific config

**Never commit secrets here.** API keys, tokens and anything specific to one machine go in `~/.zshrc.local`, which `.zshrc` sources if it exists and which this repo ignores.

```sh
# ~/.zshrc.local
export OPENAI_API_KEY="..."
```

## Updating the Brewfiles

Add new things by hand to whichever Brewfile fits (`brew bundle dump` would merge all three into one). To see what's installed but not listed anywhere:

```sh
cd ~/code/dotfiles && cat Brewfile Brewfile.work Brewfile.personal | brew bundle cleanup --file=-
```

That only lists them; it removes nothing unless you add `--force`.
