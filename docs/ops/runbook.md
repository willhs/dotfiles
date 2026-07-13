---
id: runbook
type: runbook
purpose: "How to bootstrap a machine, re-run installers, add a topic, and recover from common breakage."
scope: ["ops"]
non_goals: []
tags: ["runbook", "ops"]
related: ["design/architecture.md"]
---

## Purpose

Operational procedures for setting up and maintaining machines from this repo.

## New Machine Setup

```sh
git clone https://github.com/willhs/dotfiles.git ~/dotfiles
cd ~/dotfiles
echo workstation > ~/.dotfiles-profile   # or: server
script/bootstrap
```

If cloning somewhere other than `~/dotfiles`, add `export DOTFILES="<repo path>"` to `~/.localrc` **before** the first shell restart — the zsh loader globs `$DOTFILES/**/*.zsh` and silently loads nothing if the path is wrong.

## Re-running Installers

- All topic installers for the active profile: `script/install`
- One topic: `sh <topic>/install.sh`
- macOS provisioning (brew bundle, softwareupdate, defaults): `macos/install.sh`
- Re-link symlinks after adding a `*.symlink` file: `script/bootstrap` (prompts on conflicts: skip/overwrite/backup)

## Adding a New Topic

1. Create `topicname/` with any of: `*.zsh` (auto-sourced), `*.symlink` (linked to `~/.<name>`), `install.sh` (idempotent!).
2. Add the topic name to the relevant `profiles/*.conf` files if it has an installer.
3. Run `script/bootstrap`.

## Common Issues

- **Shell config not loading at all** → `$DOTFILES` points at a directory that doesn't exist. Check `echo $DOTFILES` and fix the export in `~/.localrc`.
- **Alias references an unset variable** → the value belongs in `~/.localrc` (untracked); check there before assuming breakage.
- **Installer fails mid-run** → all installers are idempotent; fix the failing step and re-run the same script.
- **Claude statusline/usage stale** → `ai/claude/fetch-usage.py` caches the OAuth token at `~/.claude/.token_cache` (0600, 15-min TTL) and usage at `/tmp/.claude_usage_cache`; delete either to force refresh.
- **Prompt noise in agent sessions** → `zshrc.symlink` exits early when `$ANTIGRAVITY_AGENT` is set or `$TERM` is `dumb`; that's intentional.
