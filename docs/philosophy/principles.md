---
id: principles
type: reference
purpose: "Define the guiding principles for what belongs in dotfiles and how it should behave."
scope: ["philosophy"]
non_goals: []
tags: ["principles"]
related: ["philosophy/vision.md"]
---

## Purpose

Principles that guide decisions when there's room for interpretation, in priority order.

1. **Nothing secret in the repo.** The repo is public. Tokens, hosts, usernames, key paths, and machine-specific values go in `~/.localrc` or the OS keychain — never in tracked files. Credential caches written by scripts must be user-only (0600) and live under `$HOME`, not `/tmp`.
2. **Idempotent installers.** Every `install.sh` can run repeatedly; it checks before it changes (symlink already correct → skip, tool already installed → skip).
3. **Symlink, don't copy.** Configs are linked from the repo into `$HOME` so edits in either place are the same edit and `git diff` always shows drift.
4. **Only tools actually used.** No aspirational packages. If it hasn't been used in months, remove it — the Brewfile and apt lists should reflect reality.
5. **Guard by platform, not by hope.** Installers that are platform-specific exit cleanly on other platforms instead of erroring halfway.
6. **Convention over wiring.** New config is added by dropping files that match conventions (`topic/*.zsh`, `*.symlink`, `topic/install.sh`) — no central registry to update.
