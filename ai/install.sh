#!/bin/bash
# Symlink Claude Code agents and skills from dotfiles

DOTFILES_AI="$(cd "$(dirname "$0")" && pwd)"

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
