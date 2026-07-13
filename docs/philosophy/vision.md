---
id: vision
type: reference
purpose: "Capture the north star for the dotfiles repo."
scope: ["philosophy"]
non_goals: []
tags: ["vision"]
related: ["philosophy/principles.md"]
---

## Purpose

A new machine — macOS laptop, Ubuntu server, or WSL box — should go from fresh install to a familiar, fully-working shell environment with one clone and one command (`script/bootstrap`), installing only the tools actually relied on day to day.

## Concept

The repo is the single source of truth for personal machine configuration: shell (zsh + starship), editor (Neovim), terminal (WezTerm, tmux), git identity and helpers, macOS defaults, and AI tooling (Claude Code scripts, hooks, and gent-managed agent config). Configuration lives in topic directories; installers are idempotent so re-running is always safe.

## Constraints

- Public repo: nothing sensitive is ever tracked. Host-specific and secret values live in `~/.localrc` (untracked, sourced automatically).
- Multi-platform: everything either works on macOS, Ubuntu, and WSL, or guards itself to the platforms it supports.
- Profiles (`profiles/*.conf` + `~/.dotfiles-profile`) select which topics install per machine class (workstation vs server).

## Success Looks Like

- Bootstrap on a clean machine completes without manual fixes.
- Re-running any installer is a no-op when nothing changed.
- No secrets or infrastructure details in the repo or its history.
