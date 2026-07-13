---
id: roadmap
type: note
purpose: "Outline the Now/Next/Later priorities for the dotfiles repo."
scope: ["work"]
non_goals: []
tags: ["roadmap", "planning"]
related: ["ops/runbook.md"]
---

## Purpose

Now/Next/Later priorities. Seeded from the July 2026 security and completeness audit (token cache perms, `./bin` in PATH, and dead ssh aliases were fixed in that pass).

## Now

- Fix or remove broken git aliases: `promote`, `wtf`, `rank-contributors` in `git/gitconfig.symlink` point to `$DOTFILES/bin/git-*` scripts that don't exist.
- Add an OS guard to `ubuntu/install.sh` (workstation profile includes it, so it currently sprays `sudo apt` errors on macOS).
- Move the Claude Island hook socket off the fixed world-writable path `/tmp/claude-island.sock` (permission decisions could be spoofed by another local user).

## Next

- Add a LICENSE (public repo — currently no reuse rights).
- Add a tracked `localrc.example` documenting expected vars (`DOTFILES`, `LIGHTSAIL`, etc.) — `~/.localrc` is load-bearing but undocumented.
- Scope the eza apt key with `signed-by` instead of `/etc/apt/trusted.gpg.d/` (currently trusted for all repos).
- Minimal CI: shellcheck over `script/` and `*/install.sh`, `python -m py_compile` over `ai/claude/**/*.py`.

## Later

- Consolidate the duplicate PATH setup in `zsh/path.zsh` and `system/_path.zsh`.
- Docker smoke test that runs `script/bootstrap` with the server profile on a clean Ubuntu image.
- Have `script/bootstrap` record the repo location so `$DOTFILES` doesn't silently default wrong when cloned outside `~/dotfiles`.
