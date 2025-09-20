#!/usr/bin/env bash
#
# macOS provisioning entrypoint
# Ensures Homebrew is available, applies Brewfile, software updates,
# and opinionated defaults so a new machine feels familiar quickly.

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  # Nothing to do on non-macOS hosts.
  exit 0
fi

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
BREWFILE_PATH="${DOTFILES_ROOT}/macos/Brewfile"
DEFAULTS_SCRIPT="${DOTFILES_ROOT}/macos/set-defaults.sh"

log() {
  printf '\n👉 %s\n' "$1"
}

post_brew_setup() {
  if ! command -v brew >/dev/null 2>&1; then
    return
  fi

  local fzf_installer="$(brew --prefix)/opt/fzf/install"
  if [[ -x "$fzf_installer" ]]; then
    log "Configuring fzf key bindings"
    "$fzf_installer" --key-bindings --completion --no-bash --no-fish --no-update-rc || true
  fi
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Homebrew installs into different prefixes depending on architecture.
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

brew_bundle() {
  if [[ ! -f "${BREWFILE_PATH}" ]]; then
    printf 'Brewfile not found at %s\n' "${BREWFILE_PATH}" >&2
    return
  fi

  log "Installing packages from Brewfile"
  brew update
  brew bundle --file="${BREWFILE_PATH}" --no-lock
}

run_software_update() {
  if ! command -v softwareupdate >/dev/null 2>&1; then
    return
  fi

  log "Running macOS software update"
  sudo softwareupdate -i -a || true
}

apply_defaults() {
  if [[ ! -x "${DEFAULTS_SCRIPT}" ]]; then
    return
  fi

  log "Applying macOS defaults"
  "${DEFAULTS_SCRIPT}"
}

ensure_homebrew
brew_bundle
post_brew_setup
run_software_update
apply_defaults

log "macOS provisioning complete"
