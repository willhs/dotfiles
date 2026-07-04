#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

HERDR_SRC="${SCRIPT_DIR}/config.toml"
HERDR_DEST="${HOME}/.config/herdr/config.toml"

log() {
  printf '› %s\n' "$1"
}

if [ -e "${HERDR_DEST}" ] && [ ! -L "${HERDR_DEST}" ]; then
  log "Backing up existing herdr config"
  mv "${HERDR_DEST}" "${HERDR_DEST}.backup"
fi

mkdir -p "$(dirname "${HERDR_DEST}")"
if [ "$(readlink "${HERDR_DEST}" 2>/dev/null)" != "${HERDR_SRC}" ]; then
  log "Linking herdr config"
  ln -sfn "${HERDR_SRC}" "${HERDR_DEST}"
fi
