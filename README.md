# dotfiles

Opinionated dotfiles for quickly installing my shell, editor, and tooling across Unix-based systems (macOS, Ubuntu, WSL). The goal is a repeatable bootstrap with only the tools I actually rely on.

## Install

```sh
git clone https://github.com/will/dotfiles.git ~/dotfiles
cd ~/dotfiles
script/bootstrap
```

- macOS extras: `macos/install.sh` installs Homebrew, applies the Brewfile, runs `softwareupdate`, and applies defaults.
- Ubuntu/WSL extras: `ubuntu/install.sh` installs apt packages and CLI tools (curl, git, zsh, neovim, fzf, eza, zoxide, etc.).

Re-run the platform script later to pick up updates.

## What it sets up

- Shell: zsh configuration, aliases, functions, and PATH management sourced from `zsh/` and `system/`.
- Tooling: Homebrew or apt provisioning plus helper scripts under `bin/`.
- Editors: Neovim configuration ready to link into `$HOME` via `script/bootstrap`.
- Git: Global git config, aliases, and helpers under `git/`.
- Extras: Optional configs in `misc/` for tmux, i3, and other utilities.

Files ending in `.symlink` are linked into `$HOME` by `script/bootstrap`. All `*.zsh` files are auto-sourced by the loader in `zsh/zshrc.symlink`. Sensitive, host-specific environment variables belong in `~/.localrc`, which remains untracked but is sourced automatically if present.
