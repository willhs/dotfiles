#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd -P)"

NVIM_SRC="${DOTFILES_ROOT}/nvim"
NVIM_DEST="${HOME}/.config/nvim"

log() {
  printf '› %s\n' "$1"
}

if [ -e "${NVIM_DEST}" ] && [ ! -L "${NVIM_DEST}" ]; then
  log "Backing up existing Neovim config"
  mv "${NVIM_DEST}" "${NVIM_DEST}.backup"
fi

mkdir -p "$(dirname "${NVIM_DEST}")"
if [ "$(readlink "${NVIM_DEST}" 2>/dev/null)" != "${NVIM_SRC}" ]; then
  log "Linking Neovim config"
  ln -sfn "${NVIM_SRC}" "${NVIM_DEST}"
fi
