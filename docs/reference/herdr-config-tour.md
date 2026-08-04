---
id: herdr-config-tour
type: reference
purpose: "Tour of herdr's full configuration, theme, integration, and plugin surface, with recommendations for a Manager/Steady-centric AI-agent workflow."
scope: ["herdr", "dotfiles"]
non_goals: ["Rewriting herdr/config.toml", "Building a plugin (scoped separately)"]
tags: ["herdr", "config", "plugins", "themes", "integrations", "agents"]
related: ["../../herdr/config.toml", "../design/architecture.md"]
---

# herdr config tour & extensibility review

> Snapshot: herdr **0.8.0** (stable channel), installed via Homebrew, server running.
> Sources: `herdr --default-config`, `herdr <cmd> --help`, the shipped `CHANGELOG.md`,
> and the official docs (`herdr.dev/docs/{configuration,integrations,socket-api,plugins}`).
> Our config lives at `herdr/config.toml`, symlinked to `~/.config/herdr/config.toml`.

## TL;DR

- **What herdr is**: an agent multiplexer for the terminal — workspaces → tabs → panes,
  mouse-native, with first-class *agent state* (idle / working / blocked / done) surfaced
  per pane. Think tmux, but it understands that a pane is running Claude Code and whether
  it's waiting on you.
- **Our config today** is intentionally thin: it only remaps keys to mirror our tmux muscle
  memory (`ctrl+a` prefix, `|`/`-` splits, `shift+HJKL` tab nav). Everything else is default.
- **How deep does it go?** Deeper than the CLI's top-level `--help` suggests. There is a
  full **v1 plugin system** (git-installable, event hooks, custom actions, managed panes,
  link handlers), a documented **socket/JSON-RPC API** (75 methods), **agent lifecycle
  integrations** that install hooks into each agent's config dir, and **theme customisation**
  down to individual colour tokens with light/dark auto-switching.
- **Biggest unrealised wins for us**: (1) `herdr integration install claude` for real
  blocked/done detection + session restore; (2) `[theme].auto_switch`; (3) a small
  **`herdr-steady` plugin** bridging herdr's agent-state events to Manager/Steady. Details below.

---

## 1. The config surface (`config.toml`)

herdr reads one TOML file. `herdr --default-config` prints the whole annotated reference;
`herdr server reload-config` (bound to `prefix+r` for us) hot-reloads a running server.
Unknown top-level sections now warn on load instead of being silently ignored.

Sections and the knobs worth knowing:

| Section | What it controls | Notable knobs we don't use yet |
|---|---|---|
| `[theme]` | Built-in theme + overrides | `name`, `auto_switch`, `dark_name`/`light_name`, `[theme.custom]` token overrides |
| `[terminal]` | New-pane shell behaviour | `default_shell`, `shell_mode` (`auto`/`login`/`non_login`), `new_cwd` (`follow`/`home`/`current`/fixed path) |
| `[update]` | Channel + background checks | `channel` (`stable`/`preview`), `version_check`, `manifest_check` |
| `[keys]` | Prefix + all bindings | `[[keys.command]]` custom commands (shell/pane/plugin_action), `[keys.indexed]` legacy direct 1..9 |
| `[ui]` | Layout, mouse, sidebar | `pane_borders`, `pane_gaps`, `agent_panel_sort` (`spaces`/`priority`), `accent`, `mouse_capture`, `mobile_width_threshold`, `sidebar_width`/`sidebar_max_width`, `[ui.sidebar.*]` row tokens |
| `[ui.toast]` | Background notifications | `delivery` (`off`/`herdr`/`terminal`/`system`), in-app position, clipboard-copy toast |
| `[ui.sound]` | Per-state / per-agent sounds | custom mp3 paths, `[ui.sound.agents]` per-agent `on`/`off` (droid muted by default) |
| `[session]` | Restore behaviour | `resume_agents_on_restore` (default **true**) — resumes native agent sessions after a server restart |
| `[remote]` | SSH bridge | `manage_ssh_config` (keepalive fallback for `herdr --remote`) |
| `[worktrees]` | Worktree location | `directory` (default `~/.herdr/worktrees`) |
| `[experimental]` | Opt-in bleeding edge | `allow_nested`, `kitty_graphics`, `pane_history`, CJK/IME cursor reveal knobs |
| `[advanced]` | Buffers | `scrollback_limit_bytes` (default 10 MB, Ghostty-like) |

### Sidebar rows — `[ui.sidebar.agents]` / `[ui.sidebar.spaces]`

The expanded sidebar's row composition is configurable as token lists (added in **0.7.4**).
Agent tokens: `state_icon`, `state_text`, `workspace`, `tab`, `pane`, `agent`, `terminal_title`,
`terminal_title_stripped` (spinner glyph removed), `$custom`. Any token may be an inline table
carrying `fg`/`bold`/`dim`.

The **default** agent rows are `[state_icon, workspace, tab]` + `[agent]` — i.e. every agent row
is labelled with its *space* name. That's actively misleading in our setup, because Manager drops
unrelated jobs into an existing space as extra panes, so several different worktrees all render
under one label. Leading with `terminal_title_stripped` shows Claude Code's own task summary
instead. Ours:

```toml
[ui.sidebar.agents]
rows = [
  ["state_icon", "terminal_title_stripped"],
  [{ token = "workspace", dim = true }],
]
```

Gotchas:

- **A row whose tokens all resolve to `None` is dropped entirely.** `terminal_title*` is `None`
  when the pane sets no OSC title, so keep an always-present token (`workspace`) on its own row
  as fallback identity.
- **Keep rows short.** At our ~30-column sidebar, three tokens on one row truncates all three
  (`add-w… · claude · idle`). `agent` is always `claude` for us and `state_text` just repeats
  `state_icon` — both dropped.
- **Unknown keys *inside* a known section are silently ignored** — only unknown *top-level*
  sections warn. On 0.7.1 the whole `[ui.sidebar]` table was discarded with
  `status: applied, diagnostics: []`, and the API omitted `terminal_title` (it's
  `skip_serializing_if = Option::is_none`), which reads exactly like "the agent isn't emitting
  titles". `herdr config check` against a current binary is the reliable validator.
- It's `[ui.sidebar.agents]`, not `[sidebar.agents]` — `SidebarConfig` hangs off `UiConfig`.

### Custom command bindings — the "no-plugin" extension point

Before you reach for a plugin, `[[keys.command]]` already lets you bind a key to a command:

```toml
[[keys.command]]
key = "prefix+alt+g"
type = "pane"          # "shell" = detached background; "pane" = temp pane, closes on exit
command = "lazygit"
description = "Open lazygit"   # shown in the keybind help panel (0.6.6+)
```

`type = "plugin_action"` (below) targets a plugin action instead of a shell string.

---

## 2. Themes & colours

**Built-in themes (11):** `catppuccin`, `terminal`, `tokyo-night`, `dracula`, `nord`,
`gruvbox`, `one-dark`, `solarized`, `kanagawa`, `rose-pine`, `vesper`.

You are not limited to picking one:

```toml
[theme]
name = "catppuccin"
auto_switch = true            # follow host terminal light/dark and swap themes
dark_name  = "catppuccin"
light_name = "catppuccin-latte"

[theme.custom]                # override individual tokens on top of the base theme
accent   = "#f5c2e7"
red      = "#ff6188"
green    = "#a6e3a1"
panel_bg = "reset"            # "reset" = inherit host terminal, don't paint

[ui]
accent = "cyan"               # separate accent for borders/nav UI; hex, named, or rgb()
```

Colour tokens accept hex (`#rrggbb`), named colours, `rgb(r,g,b)`, or the special
`"reset"`. There is **no theme file format or gallery** — "custom themes" means overriding
tokens on a built-in base, not shipping a standalone `.theme` file. The host-terminal
colour work (OSC 10/11/4 handling, live light/dark refresh) is mature, so `panel_bg = "reset"`
+ `auto_switch` makes herdr blend into whatever WezTerm theme is active.

**Recommendation:** we run WezTerm; turn on `auto_switch` (or `panel_bg = "reset"`) so herdr
tracks the terminal instead of hard-committing to one palette. Low-risk, purely visual.

---

## 3. Agent integrations (the important, under-used bit)

`herdr integration install <agent>` installs a small **state-reporting hook** into that
agent's own config directory. Supported: `pi`, `omp`, `claude`, `codex`, `copilot`,
`devin`, `droid`, `kimi`, `opencode`, `kilo`, `hermes`, `qodercli`, `cursor`.

For Claude Code it writes `~/.claude/hooks/herdr-agent-state.sh`. `herdr integration status`
shows install state per agent. **Currently everything reads `not installed` on this machine.**

Two capability tiers (from the changelog):

- **Full lifecycle** (Pi, OMP, OpenCode, Kilo, Hermes, custom socket integrations): the hook
  reports idle/working/**blocked**/done directly. Most accurate.
- **Session-identity only** (Claude Code, Codex, Copilot, Droid, Kimi, Qoder, Cursor): the
  hook reports the native *session id* (enabling resume, e.g. `claude --resume <id>` after a
  server restart), while herdr's screen-detection engine infers state from the visible pane.

herdr's screen detection is genuinely good — `herdr agent explain <target>` shows exactly
which manifest rule matched and why a pane is idle/working/blocked, and remote agent-detection
manifests auto-update. So even without the hook you get state; the hook adds **session restore**
and, for lifecycle agents, more reliable blocked detection.

**Recommendation:** run `herdr integration install claude` (and `codex` if used interactively).
It's additive, reversible (`herdr integration uninstall claude`), and gives us
resume-after-restart + cleaner "blocked / needs input" signals in the Agents panel. Worth
noting the two Claude hook files won't collide — herdr's is `herdr-agent-state.sh`, ours is
`claude-island-state.py`/`bash-antipattern-guard.py`.

---

## 4. The socket / JSON-RPC API — herdr as a scriptable server

herdr runs a background server exposing a Unix-socket JSON-RPC API (75 methods,
`~/.config/herdr/herdr.sock`). Every `herdr <noun> <verb>` CLI command is a thin wrapper over
it, so anything the CLI does is scriptable, and so is a lot it doesn't surface. Surfaces:

- **workspace / tab / pane / worktree** — list, create, focus, rename, close, split, swap,
  move, zoom, resize; `pane.move` relocates a *running* pane to another tab/workspace without
  restarting its process.
- **agent** — `list`, `get`, `read` (scrape a pane's output), `send` (type into an agent),
  `rename`, `focus`, `start ... -- <argv>`, `explain`, and **`wait --status idle|working|blocked`**.
- **wait** — block a script until a pane's output matches text/regex, or until an agent hits a
  state. This is the automation primitive: "dispatch agent, wait for blocked, notify".
- **notification.show** — push a titled toast with optional `none`/`done`/`request` sound.
- **layout.export / layout.apply** — snapshot a pane layout and re-apply it (project templates).
- **events (subscribe/wait)** — subscribe to the event stream (see plugin events below).

The full event set the server emits: `WorkspaceCreated/Renamed/Closed/Focused/Updated`,
`WorktreeCreated/Opened/Removed`, `TabCreated/Renamed/Closed/Focused`,
`PaneCreated/Closed/Focused/Moved/Exited/OutputChanged`, `PaneAgentDetected`,
`PaneAgentStatusChanged`.

---

## 5. The plugin system (v1, shipped in 0.7.0)

This is the answer to "how deep is the configurability / is it worth building my own plugins":
**there is a real plugin system**, it's just not advertised in the top-level `herdr --help`
(the `plugin` subcommand and `plugin.*` RPC methods are present but quiet).

CLI: `herdr plugin install <owner>/<repo>[/subdir] [--ref] [--yes]` /
`link <path>` / `unlink` / `enable` / `disable` / `list [--json]` / `config-dir <id>` /
`action <list|invoke>` / `log list` / `pane <open|focus|close>`.

**Manifest** = `herdr-plugin.toml` in the repo root:

```toml
id = "will.steady"
name = "Steady bridge"
version = "0.1.0"
min_herdr_version = "0.7.0"
platforms = ["macos"]

# Runs on plugin install (not link), before registration, no socket/runtime env.
[[build]]
command = ["npm", "ci"]

# Invokable from context menus / keybindings; resolves globally as plugin.id.action.
[[actions]]
id = "dispatch"
title = "Dispatch as Steady task"
contexts = ["workspace"]           # where it's offered
command = ["node", "dist/dispatch.js"]

# Fires a command on a herdr event.
[[events]]
on = "worktree.created"            # event names mirror the event set in §4
command = ["node", "dist/on-worktree.js"]

# Managed pane the plugin can open/focus/close.
[[panes]]
id = "board"
title = "Steady board"
placement = "split"                # overlay (default) | popup | split | tab | zoomed
command = ["node", "dist/board.js"]

# Ctrl+click a matching URL in any pane → run an action.
[[link_handlers]]
id = "steady-task"
title = "Open Steady task"
pattern = "^https://steady\\.[^/]+/tasks/[0-9a-f-]+$"
action = "open"
```

Key facts:

- **Any language.** Plugins are just executables (Node, Python, Bash, Rust, Go, Lua…). herdr
  injects env: `HERDR_SOCKET_PATH`, `HERDR_BIN_PATH`, `HERDR_PLUGIN_{ID,ROOT,CONFIG_DIR,STATE_DIR}`,
  `HERDR_{WORKSPACE,TAB,PANE}_ID`, `HERDR_PLUGIN_CONTEXT_JSON`, and for hooks/handlers
  `HERDR_PLUGIN_EVENT` + `HERDR_PLUGIN_EVENT_JSON` / `HERDR_PLUGIN_CLICKED_URL`.
- **Distribution.** Ordinary GitHub repos; public repos tagged `herdr-plugin` are auto-indexed
  by a marketplace (~30-min refresh). Local dev via `herdr plugin link /path`. No update
  command — reinstall to refresh.
- **Keybinding integration.** `[[keys.command]] type = "plugin_action"`,
  `command = "will.steady.dispatch"`.
- **Security.** No sandbox — plugins run as you with full env. Install only what you trust
  (for us, that means our own).

---

## 6. Fit with our workflow (Manager / Steady / worktrees)

Our stack: **Manager** (daemon on this MacBook) spawns Claude Code sessions in **git worktrees**
to complete **Steady** tasks. herdr overlaps this in three useful places:

1. **Worktrees.** herdr has native worktree support (`herdr worktree create --branch … --base …`,
   and worktree-created panes fire plugin lifecycle events). Manager already owns worktree
   lifecycle for headless jobs, so don't duplicate that — but for *interactive* work herdr's
   worktree panes are a nice manual complement.
2. **Agent visibility.** herdr already knows when a Claude pane is blocked/working/done. Manager
   tracks job state server-side. A bridge could make each visible to the other.
3. **Notifications.** `herdr notification show` / `notification.show` RPC is an easy target for
   Manager to call when a job needs a human (`manager_needs_human`), surfacing it in whatever
   herdr session is attached.

### Should we build our own plugin? — Yes, one, and it's small.

A `will-steady` (or `will-manager`) herdr plugin is the highest-leverage custom work here,
and the plugin API is a clean fit because Steady/Manager already expose CLIs + MCP tools:

- **Link handler** — ctrl+click a Steady task/goal URL (or Manager job id) in any pane to open
  it, or invoke an action against it. Zero server needed; just a regex + a script.
- **Workspace action** — "Create Steady task from this workspace" / "Dispatch focused worktree
  as a Steady job", wired to a `prefix+…` key via `type = "plugin_action"`.
- **Event hook** on `PaneAgentStatusChanged` → when an interactive agent goes **blocked**, ping
  Manager or fire a `notification.show`; on **done**, optionally mark/advance the task.
- **Plugin pane** — a live "today" Steady board or Manager job queue rendered in a split/overlay
  pane, refreshed off the existing MCP/CLI.

Scope guardrails: this only matters for **interactive** herdr sessions. Manager's headless jobs
run detached and shouldn't depend on a herdr server being attached. Start with the read-only
pieces (link handler + board pane) before anything that writes task state.

---

## 7. Concrete recommendations (ordered by value ÷ effort)

1. **`herdr integration install claude`** (and `codex` if used interactively). Additive,
   reversible, gives session-restore + better blocked detection. *(config-free, do first)*
2. **`[theme].auto_switch = true`** or `[theme.custom] panel_bg = "reset"` so herdr tracks
   WezTerm's light/dark instead of a fixed palette. *(one-line config)*
3. **`[ui].agent_panel_sort = "priority"`** — surface the agent most needing attention first,
   which matches a multi-agent, "who's blocked?" workflow. *(one-line, taste)*
4. **`[ui.toast].delivery`** + `[ui.sound]` tuning — decide how background agent state reaches
   you (in-app toast vs. system notification vs. sound). *(taste)*
5. **Prototype a read-only `will-steady` plugin** — link handler + board pane via
   `herdr plugin link`, iterate locally, publish as a private repo tagged `herdr-plugin` if it
   earns its keep. *(a session's worth of work; scope as its own Steady task)*

Non-actions we should *skip*: authoring a "custom theme" (no file format — just override tokens);
preview channel (`herdr channel set preview`) unless we want early fixes; `experimental.*`
(kitty graphics, nested herdr) unless a specific need appears.

---

## Installed plugins

- **`vim-herdr-navigation`** (vendored, Alt-chord fork of
  [paulbkim-dev/vim-herdr-navigation](https://github.com/paulbkim-dev/vim-herdr-navigation)).
  Seamless `Alt+h/j/k/l` navigation across Neovim splits and herdr panes
  (vim-tmux-navigator, ported). We use **Alt** rather than upstream Ctrl so it
  doesn't shadow readline `Ctrl+L`/`Ctrl+K` in shells or collide with our
  JetBrains-style `<C-h>`/`<C-l>` jump aliases in nvim.
  - herdr side: `herdr/plugins/vim-herdr-navigation/` (manifest + `navigate.sh`),
    linked by `herdr/install.sh`, keybindings in `herdr/config.toml`.
  - editor side: `nvim/lua/herdr-nav.lua`, required from `nvim/init.lua`.
  - After a fresh checkout / worktree merge: run `herdr/install.sh` (relinks the
    plugin to the canonical path) then `herdr server reload-config`.

## Appendix — command cheatsheet

```
herdr                         launch/attach the persistent session
herdr status                  client + server status
herdr integration install claude   install agent state hook
herdr agent list              all agents + states
herdr agent explain <target>  why a pane is idle/working/blocked
herdr agent wait <t> --status blocked   block until state
herdr notification show "title" --body … --sound request
herdr layout export / apply   snapshot & restore pane layouts
herdr plugin link <path>      dev-install a local plugin
herdr plugin list --json      installed plugins
herdr server reload-config    hot-reload config.toml   (our prefix+r)
```
