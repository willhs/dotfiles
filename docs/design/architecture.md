---
id: architecture
type: spec
purpose: "Describe the topic-centric layout, symlink conventions, zsh loading order, bootstrap flow, and profiles."
scope: ["design", "architecture"]
non_goals: []
tags: ["architecture"]
related: ["design/adr/", "ops/runbook.md"]
---

## Purpose

Describe the end-to-end shape of the dotfiles system so contributors (human or agent) understand how a file placed in the repo ends up affecting a live shell.

## Topic-Centric Layout

Each top-level directory is a *topic* — an area of configuration that owns its files end to end (based on Holman's dotfiles architecture):

| Topic | Owns |
|-------|------|
| `zsh/` | Shell config, plugin manager (antidote), starship prompt, zshrc entry point |
| `system/` | Cross-shell PATH, env vars, aliases |
| `git/` | gitconfig, gitignore, aliases, completion |
| `nvim/` | Neovim config (linked as a whole directory to `~/.config/nvim`) |
| `wezterm/`, `herdr/` | Terminal emulator / multiplexer configs linked into `~/.config` |
| `macos/` | Brewfile, system defaults, provisioning (Darwin-only) |
| `ubuntu/` | apt packages and CLI tool installs (Ubuntu/WSL) |
| `ai/` | Claude Code scripts/hooks/commands, gent config, MCP config |
| `misc/` | tmux, i3, and other optional extras |
| `bin/` | Scripts added to `$PATH` on every machine |

## File Conventions

- `topic/*.symlink` → linked to `~/.<name>` by `script/bootstrap` (finds them at maxdepth 3).
- `topic/*.zsh` → auto-sourced by `zsh/zshrc.symlink` on shell start.
- `topic/path.zsh` → sourced first (PATH setup); `topic/completion.zsh` → sourced last (after `compinit`).
- `topic/install.sh` → run by `script/install`, filtered by the active profile.

## Bootstrap Flow

```
script/bootstrap
├── setup_gitconfig          # interactive; writes git/gitconfig.local.symlink (untracked)
├── install_dotfiles         # links every *.symlink into $HOME
└── script/install
    ├── reads ~/.dotfiles-profile → profiles/<name>.conf
    └── runs each listed topic's install.sh (all installers if no profile)
```

Profiles: `workstation.conf` (full dev machine) and `server.conf` (lean hosting box). Installers are idempotent — safe to re-run any time.

## Shell Startup (zsh loading order)

1. `zshrc.symlink` exports `$DOTFILES` (default `~/dotfiles`; overridden in `~/.localrc`) and `$PROJECTS`.
2. Sources `~/.localrc` — private env vars, machine-specific overrides. **Load-bearing on machines where the repo isn't at `~/dotfiles`.**
3. Globs `$DOTFILES/**/*.zsh` and sources: `path.zsh` files → everything else → `compinit` → `completion.zsh` files.
4. rbenv / nvm init.

## Key Constraints

- The repo is public — see [`philosophy/principles.md`](../philosophy/principles.md) principle 1.
- `~/.localrc` and `git/gitconfig.local.symlink` are the two untracked escape hatches for private/machine-specific config.
- AI tooling in `ai/` is symlinked into `~/.claude/` by `ai/install.sh`, so edits in the repo are live immediately.
