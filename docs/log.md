---
id: log
type: note
purpose: "Chronological log of changes to the docs/ knowledge base."
scope: ["docs"]
non_goals: []
tags: ["log", "docs"]
related: ["index.md"]
---

# docs/ Log

## [2026-08-11] update | Wire herdr agent integrations into install.sh

The pi state-reporting integration was never installed (`herdr integration status` read
"pi: not installed"), so herdr showed no loading states for pi panes — its extension
(`~/.pi/agent/extensions/herdr-agent-state.ts`, reporting working/blocked/idle over the
herdr socket) was simply missing, while claude/codex hooks had been installed manually.
Added idempotent install/refresh of `pi`, `claude`, `codex` integrations to
`herdr/install.sh` (skip while current, reinstall on version bump; note `herdr
integration status` writes to stderr), and refreshed the stale "not installed" notes in
`reference/herdr-config-tour.md`.

## [2026-08-08] update | README install/topic accuracy (dream cycle)

Fixed a wrong clone URL in `README.md` (`github.com/will/dotfiles` → `github.com/willhs/dotfiles`,
matching `origin` and `docs/ops/runbook.md`, which already had it right) and added the missing
terminal (`wezterm/`, `herdr/`) and AI tooling (`ai/`) topics to the "What it sets up" list, which
had drifted behind `docs/design/architecture.md`. `CLAUDE.md` has the same staleness (missing
`ai/`, `herdr/`, `profiles/`, `wezterm/` in its Topic Areas) but is a symlink to an untracked,
gent-managed file outside this worktree — filed as a Steady idea instead of edited directly.

## [2026-08-04] update | herdr config tour & extensibility review

Added a `[ui.sidebar.agents]` section documenting the sidebar row-token system (0.7.4+) and why we
lead with `terminal_title_stripped` instead of the default `workspace` label — Manager packs
unrelated worktrees into one space, so space names identify nothing. Captured four gotchas, the
sharpest being that unknown keys *inside* a known section are silently ignored: on 0.7.1 the whole
`[ui.sidebar]` table was discarded while `reload-config` still reported `applied` with no
diagnostics. Refreshed the version snapshot to 0.8.0.

## [2026-07-21] update | Add vim-herdr-navigation plugin (Alt-chord fork)

Vendored `paulbkim-dev/vim-herdr-navigation` as an Alt+h/j/k/l fork under `herdr/plugins/`, wired the editor side into `nvim/` (`lua/herdr-nav.lua`, required from `init.lua`), added `alt+*` bindings to `herdr/config.toml`, and made `herdr/install.sh` link vendored plugins idempotently. Alt avoids clobbering readline Ctrl+L/K and the JetBrains `<C-h>`/`<C-l>` jump aliases. Documented in the config tour.

## [2026-07-21] create | herdr config tour & extensibility review

Surveyed herdr 0.7.1 end-to-end (default config, all CLI subcommands, shipped CHANGELOG, and herdr.dev docs). Documented the config surface, 11 built-in themes + token overrides, agent integrations, the 75-method socket API, and the v1 plugin system (git-installable, event hooks, actions, panes, link handlers). Added `reference/herdr-config-tour.md` with ordered recommendations and a scoped `will-steady` plugin proposal.

## [2026-07-12] create | Initial docs/ knowledge base

Scaffolded the standard docs/ set (index, vision, principles, architecture, roadmap, runbook, templates, front-matter schema) and populated it from the existing repo plus the July 2026 security/completeness audit.
