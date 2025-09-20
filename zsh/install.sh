#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd -P)"

ANTIDOTE_DIR="${HOME}/.antidote"
STARSHIP_BIN="${HOME}/.local/bin"
STARSHIP_CONFIG_SRC="${DOTFILES_ROOT}/zsh/starship/starship.toml"
STARSHIP_CONFIG_DEST="${HOME}/.config/starship.toml"

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
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y --bin-dir "$STARSHIP_BIN"
  fi
else
  log "starship already installed"
fi

if [ -f "${STARSHIP_CONFIG_DEST}" ] && [ ! -L "${STARSHIP_CONFIG_DEST}" ]; then
  log "Backing up existing starship config"
  mv "${STARSHIP_CONFIG_DEST}" "${STARSHIP_CONFIG_DEST}.backup"
fi

mkdir -p "$(dirname "${STARSHIP_CONFIG_DEST}")"
if [ "$(readlink "${STARSHIP_CONFIG_DEST}" 2>/dev/null)" != "${STARSHIP_CONFIG_SRC}" ]; then
  log "Linking starship config"
  ln -sfn "${STARSHIP_CONFIG_SRC}" "${STARSHIP_CONFIG_DEST}"
fi
