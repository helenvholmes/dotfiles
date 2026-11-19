# zsh/ai.zsh — helpers for AI tools and the skills they share. Loaded by .zshrc.
# Run `ai-help` for the list. Every choice below has its reason above it.

# This repo, found from this file's own location (it's loaded through the ~/.zshrc link)
DOTFILES="${${(%):-%x}:A:h:h}"

# Where each agent looks for skills. ~/.agents/skills is the shared store `npx skills`
# installs into; it links each skill into the agents' own folders.
typeset -gA AI_SKILL_DIRS=(
  shared  "$HOME/.agents/skills"
  claude  "$HOME/.claude/skills"
  codex   "$HOME/.codex/skills"
  cursor  "$HOME/.cursor/skills-cursor"
)

ai-help() {
  cat <<'EOF'
ai-keys                 which API keys this shell has (only the last 4 characters shown)
ai-status               versions of the AI tools installed
skills-ls [agent]       skills each agent can see (shared, claude, codex, cursor)
skills-add <repo> ...   install skills globally with `npx skills add -g`, then update ai/skill-lock.json
skills-update           update every global skill, then update ai/skill-lock.json
skills-restore          reinstall every skill in ai/skill-lock.json (a new Mac)
skills-dev [dir]        link the skills you're writing (default ~/code/skills) into Claude
skills-undev [dir]      undo skills-dev, putting the installed versions back
EOF
}

# Shows which keys are set without printing them, so ~/.zshrc.local can be checked safely
ai-keys() {
  local name val
  for name in ANTHROPIC_API_KEY OPENAI_API_KEY GEMINI_API_KEY OPENROUTER_API_KEY \
              HF_TOKEN VERCEL_TOKEN GITHUB_TOKEN; do
    val="${(P)name}"
    if [[ -n "$val" ]]; then
      printf '  %-20s set (…%s)\n' "$name" "${val[-4,-1]}"
    else
      printf '  %-20s -\n' "$name"
    fi
  done
  [[ -f "$HOME/.zshrc.local" ]] || echo "note: no ~/.zshrc.local, which is where keys belong"
}

# Only tools actually installed are listed, so the output stays short
ai-status() {
  local tool
  for tool in claude cursor codex gemini; do
    (( $+commands[$tool] )) || continue
    printf '  %-8s %s\n' "$tool" "${$("$tool" --version 2>/dev/null | head -1):-installed}"
  done
}

skills-ls() {
  local agent dir entry
  for agent in ${1:-shared claude codex cursor}; do
    dir="${AI_SKILL_DIRS[$agent]}"
    [[ -n "$dir" ]] || { echo "unknown agent: $agent (try: ${(k)AI_SKILL_DIRS})" >&2; return 1; }
    echo "$agent  ${dir/#$HOME/~}"
    for entry in "$dir"/*(N); do
      [[ -f "$entry/SKILL.md" ]] || continue
      if [[ -L "$entry" ]]; then
        echo "  ${entry:t}  -> $(readlink "$entry" | sed "s|^$HOME|~|")"
      else
        echo "  ${entry:t}"
      fi
    done
  done
}

# Copies the list `npx skills` keeps into the repo, so a new Mac can reinstall the same set
_skills-save-lock() {
  cp "$HOME/.agents/.skill-lock.json" "$DOTFILES/ai/skill-lock.json" && echo "updated ai/skill-lock.json (commit it)"
}

skills-add() {
  (( $# )) || { echo "usage: skills-add <owner/repo> [npx skills add options]" >&2; return 1; }
  npx -y skills add -g "$@" && _skills-save-lock
}

skills-update() {
  npx -y skills update -g -y && _skills-save-lock
}

# One `npx skills add` per source repo, asking only for the skills the lock lists
skills-restore() {
  local lock="$DOTFILES/ai/skill-lock.json" source names
  [[ -f "$lock" ]] || { echo "no $lock" >&2; return 1; }
  python3 - "$lock" <<'PY' | while IFS=$'\t' read -r source names; do
import json, sys, collections
by_source = collections.defaultdict(list)
for name, s in json.load(open(sys.argv[1]))["skills"].items():
    by_source[s["source"]].append(name)
for source, names in sorted(by_source.items()):
    print(f"{source}\t{','.join(sorted(names))}")
PY
    echo "→ $source: ${names//,/, }"
    npx -y skills add "$source" -g -y --skill "${(s:,:)names}" </dev/null
  done
}

# Points ~/.claude/skills/<name> at the skill folders you're writing, so edits show up in
# the next Claude session without reinstalling. Replaces the installed link while it's on.
skills-dev() {
  local src="${1:-$HOME/code/skills}" skill dest="${AI_SKILL_DIRS[claude]}"
  src="${src:A}"
  [[ -d "$src/skills" ]] && src="$src/skills"
  mkdir -p "$dest"
  for skill in "$src"/*/SKILL.md(N); do
    skill="${skill:h}"
    if [[ -e "$dest/${skill:t}" && ! -L "$dest/${skill:t}" ]]; then
      echo "skip     ${skill:t} (a real folder is already there)"
      continue
    fi
    ln -sfn "$skill" "$dest/${skill:t}" && echo "linked   ${skill:t} -> your working copy"
  done
}

# Removes skills-dev's links and points each skill back at the installed version, if any
skills-undev() {
  local src="${1:-$HOME/code/skills}" link name dest="${AI_SKILL_DIRS[claude]}"
  src="${src:A}"
  [[ -d "$src/skills" ]] && src="$src/skills"
  for link in "$dest"/*(N@); do
    [[ "$(readlink "$link")" == "$src"/* ]] || continue
    name="${link:t}"
    rm "$link"
    if [[ -d "${AI_SKILL_DIRS[shared]}/$name" ]]; then
      ln -s "../../.agents/skills/$name" "$link" && echo "restored $name -> installed version"
    else
      echo "unlinked $name"
    fi
  done
}
