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

# Link vendored herdr plugins (idempotent; needs a running herdr server + CLI).
if command -v herdr >/dev/null 2>&1; then
  for plugin_dir in "${SCRIPT_DIR}"/plugins/*/; do
    [ -f "${plugin_dir}herdr-plugin.toml" ] || continue
    plugin_id="$(basename "${plugin_dir%/}")"
    # Match id AND path, so a link left pointing at an old checkout (e.g. a
    # removed worktree) gets relinked to this canonical path rather than skipped.
    if herdr plugin list 2>/dev/null | grep -qF "local:${plugin_dir%/}"; then
      log "herdr plugin already linked: ${plugin_id}"
    else
      herdr plugin unlink "${plugin_id}" >/dev/null 2>&1 || true
      if herdr plugin link "${plugin_dir%/}" >/dev/null 2>&1; then
        log "Linked herdr plugin: ${plugin_id}"
      else
        log "Skipped herdr plugin ${plugin_id} (no running server?)"
      fi
    fi
  done
fi
