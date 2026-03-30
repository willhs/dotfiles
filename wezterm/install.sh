#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

WEZTERM_SRC="${SCRIPT_DIR}/wezterm.lua"
WEZTERM_DEST="${HOME}/.config/wezterm/wezterm.lua"

log() {
  printf '› %s\n' "$1"
}

# Clean up legacy symlink
if [ -L "${HOME}/.wezterm.lua" ]; then
  log "Removing legacy ~/.wezterm.lua symlink"
  rm "${HOME}/.wezterm.lua"
fi

if [ -e "${WEZTERM_DEST}" ] && [ ! -L "${WEZTERM_DEST}" ]; then
  log "Backing up existing WezTerm config"
  mv "${WEZTERM_DEST}" "${WEZTERM_DEST}.backup"
fi

mkdir -p "$(dirname "${WEZTERM_DEST}")"
if [ "$(readlink "${WEZTERM_DEST}" 2>/dev/null)" != "${WEZTERM_SRC}" ]; then
  log "Linking WezTerm config"
  ln -sfn "${WEZTERM_SRC}" "${WEZTERM_DEST}"
fi
