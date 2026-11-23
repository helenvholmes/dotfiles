# dotfiles
Stuff that's worth shuttling from computer to computer, lest I forget

## Layout

| Path | What it is | Where it goes |
| --- | --- | --- |
| `zsh/.zprofile` | PATH and environment: Homebrew, rbenv, fnm, `~/.local/bin`. Also read by GUI apps, so editors and AI tools find the same `node` and `python` | `~/.zprofile` (symlinked) |
| `zsh/.zshrc` | Interactive shell: completion, history, shortcuts, prompt | `~/.zshrc` (symlinked) |
| `iterm/Pastel.json` | iTerm profile: dark violet background, pastel cursor, Nerd Font icons | `…/iTerm2/DynamicProfiles/` (symlinked) |
| `ai/CLAUDE.md` | Instructions Claude Code follows in every project | `~/.claude/CLAUDE.md` (symlinked) |
| `ai/settings.json` | Claude Code user settings: permissions, hooks, status line, plugins, and no Claude attribution on commits or PRs | `~/.claude/settings.json` (symlinked) |
| `ai/skill-lock.json` | The agent skills installed with `npx skills` (mine, Emil Kowalski's, Vercel's) | reinstalled when `./install.sh` asks, or with `--skills` |
| `zsh/ai.zsh` | Shell helpers for API keys and skills (`ai-help` lists them) | loaded by `.zshrc` |
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
| `Apps.md` | The apps Homebrew can't install, and where to get each | read by hand on a new Mac |
| `bin/apps-check` | Reports apps, Homebrew packages and skills that the repo doesn't list (or lists but aren't installed) | run any time |
| `bin/adopt-apps` | Hands apps installed by hand over to Homebrew, so `brew bundle` knows about them | run once on an existing Mac |

## Install

On a new Mac, in this order:

1. **git**, from Apple's [Command Line Tools](https://developer.apple.com/xcode/resources/) (no need for all of Xcode). Running `git` for the first time offers to install them, or:

   ```sh
   xcode-select --install
   ```

2. **[Homebrew](https://brew.sh)**, which needs those tools. The command from its site:

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **This repo**, then the install script:

   ```sh
   git clone https://github.com/helenvholmes/dotfiles ~/code/dotfiles
   cd ~/code/dotfiles
   ./install.sh                       # links the dotfiles, then asks what to install
   ```

   The Brewfile brings the rest: [Starship](https://starship.rs) for the prompt, [fnm](https://github.com/Schniz/fnm) for Node (`nvm` still works as a shortcut to it), the zsh add-ons and the apps.

4. **By hand afterwards:**
   - Install Node: `nvm install 22 && nvm alias default 22`.
   - Make **Pastel** iTerm's default profile: Settings → Profiles → select Pastel → Other Actions → *Set as Default*. It inherits everything from your Default profile and adds the colors and the icon font the prompt needs.
   - Install Claude's Pastel look (see [below](#claudes-pastel-look)).
   - Reinstall the apps Homebrew can't: [Apps.md](Apps.md).

The menu asks whether to install Homebrew tools and apps, what kind of Mac this is (personal, work, both, or neither: shared apps only), whether to install Cursor extensions, and whether to reinstall agent skills. To skip the questions, pass flags instead: `--link` (only link), `--brew`, `--work`, `--personal`, `--extensions`, `--skills`.

Any file that's already in the way gets moved to `<file>.backup.<timestamp>` before it's linked, and running the script again is safe. Because everything is symlinked, edits made in place (for example through Cursor's settings screen) show up here as changes to commit.

## AI helpers

`zsh/ai.zsh` adds a few commands; `ai-help` lists them. The useful ones:

- `ai-keys` shows which API keys the shell has, with only the last 4 characters, to check `~/.zshrc.local` without printing secrets.
- `skills-ls` lists the skills each agent sees. `skills-add <owner/repo>` installs more and `skills-update` updates them; both copy the new list into `ai/skill-lock.json` to commit. `skills-restore` (or `./install.sh --skills`) reinstalls the lot on a new Mac.
- `skills-dev` links the skills I'm writing in `~/code/skills` into Claude so edits show up in the next session; `skills-undev` puts the installed versions back.

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

Run `bin/apps-check` now and then. It lists any app, Homebrew package or agent skill that this Mac has and the repo doesn't (or the reverse), and changes nothing.

Add new things by hand to whichever Brewfile fits (`brew bundle dump` would merge all three into one). To see what's installed but not listed anywhere:

```sh
cd ~/code/dotfiles && cat Brewfile Brewfile.work Brewfile.personal | brew bundle cleanup --file=-
```

That only lists them; it removes nothing unless you add `--force`.
