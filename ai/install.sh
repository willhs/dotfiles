#!/bin/bash
# Install Claude Code and symlink agents/skills from dotfiles

DOTFILES_AI="$(cd "$(dirname "$0")" && pwd)"

# --- Install Claude Code ---
if ! command -v claude >/dev/null 2>&1; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "Claude Code already installed"
fi

# --- Gent (AI agent config manager) ---
GENT_DIR="$HOME/projects/gent"
if [ ! -d "$GENT_DIR" ]; then
  echo "Cloning gent..."
  mkdir -p "$HOME/projects"
  git clone https://github.com/willhs/gent "$GENT_DIR"
else
  echo "Updating gent..."
  git -C "$GENT_DIR" pull --ff-only --quiet || true
fi

if [ -x "$GENT_DIR/bin/gent" ]; then
  echo "Running gent init --global..."
  "$GENT_DIR/bin/gent" init --global
fi

# --- Claude Agents ---
echo "Linking Claude agents..."
CLAUDE_AGENTS="$HOME/.claude/agents"
mkdir -p "$CLAUDE_AGENTS"

for agent in "$DOTFILES_AI/claude/agents"/*.md; do
  [ -e "$agent" ] || continue
  name=$(basename "$agent")
  target="$CLAUDE_AGENTS/$name"

  # Skip if already correctly symlinked
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$agent" ]; then
    echo "  ✓ $name (already linked)"
    continue
  fi

  # Remove existing file and create symlink
  rm -f "$target"
  ln -s "$agent" "$target"
  echo "  → $name"
done

# --- Gent Skills ---
echo "Linking skills to gent..."
GENT_SKILLS="$HOME/.config/gent/skills"
mkdir -p "$GENT_SKILLS"

for skill in "$DOTFILES_AI/skills"/*/; do
  [ -d "$skill" ] || continue
  name=$(basename "$skill")
  target="$GENT_SKILLS/$name"

  # Skip if already correctly symlinked
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$skill" ]; then
    echo "  ✓ $name (already linked)"
    continue
  fi

  # Remove existing file/dir and create symlink
  rm -rf "$target"
  ln -s "$skill" "$target"
  echo "  → $name"
done
