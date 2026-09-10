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

# Install agent state-reporting integrations (pi extension, claude/codex hooks).
# Without these herdr falls back to terminal-title/screen detection and pi gets no
# loading states at all (see docs/reference/herdr-config-tour.md §3). Idempotent:
# skip while "current", reinstall when missing or outdated (e.g. after herdr bumps
# the integration version) on the next `script/install` run.
if command -v herdr >/dev/null 2>&1; then
  # status writes to stderr; capture once — repeated calls right after an install
  # can race with the server's view of the integration version.
  integration_status="$(herdr integration status 2>&1 || true)"
  for agent in pi claude codex; do
    if grep -qF "${agent}: current" <<<"${integration_status}"; then
      log "herdr integration up to date: ${agent}"
    elif herdr integration install "${agent}" >/dev/null 2>&1; then
      log "Installed herdr integration: ${agent}"
    else
      log "Skipped herdr integration ${agent} (install failed?)"
    fi
  done
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
