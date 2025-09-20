#!/usr/bin/env bash
set -euo pipefail

ANTIDOTE_DIR="${HOME}/.antidote"
STARSHIP_BIN="${HOME}/.local/bin"

log() {
  printf '› %s\n' "$1"
}

if [ ! -d "$ANTIDOTE_DIR" ]; then
  log "Installing Antidote..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
  log "Updating Antidote..."
  git -C "$ANTIDOTE_DIR" pull --ff-only --quiet || true
fi

if ! command -v starship >/dev/null 2>&1; then
  log "Installing starship prompt..."
  if command -v brew >/dev/null 2>&1; then
    brew install starship
  else
    mkdir -p "$STARSHIP_BIN"
    curl -fsSL https://starship.rs/install.sh | bash -s -- -y --bin-dir "$STARSHIP_BIN"
  fi
else
  log "starship already installed"
fi
