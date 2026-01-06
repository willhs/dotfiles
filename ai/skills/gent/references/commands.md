# Gent CLI Reference

## Commands

### `gent init [--global]`
Initialize gent and link all supported agents.

```bash
# Local (project) mode
gent init

# Global (user) mode
gent init --global
```

**What it does:**
1. Creates gent config directory (`.gent/` or `~/.config/gent/`)
2. Backs up existing agent configs
3. Creates symlinks from agent configs to central rules
4. Syncs MCP server configurations
5. Links skills directories

### `gent link <agent> [--global]`
Link a specific agent to gent's central config.

```bash
gent link claude --global
gent link codex --global
gent link windsurf --global
```

**Supported agents:**
- `claude` or `claude code` - Claude Code
- `codex` - OpenAI Codex
- `windsurf` - Windsurf

### `gent unlink <agent> [--global]`
Restore an agent to its original (pre-gent) configuration.

```bash
gent unlink claude --global
```

**What it does:**
1. Removes symlink from agent config
2. Restores original config from backup (if available)
3. Restores MCP config backup
4. Restores skills directory

### `gent sync [--global]`
Resync linked agents with current gent configuration.

```bash
gent sync --global
```

**Use when:**
- Gent directory was moved
- Config files were manually edited
- Symlinks appear broken
- After updating gent itself

### `gent list [--global]`
Show status of all agents and their link state.

```bash
gent list --global
```

**Output example:**
```
Global Configuration (~/.config/gent/)
  claude code: linked → ~/.config/gent/rules.claude.md
  codex: linked → ~/.config/gent/rules.md
  windsurf: not linked
```

---

## Config File Formats

### rules.md
Main rules file for all agents. Markdown format.

```markdown
# Agent Instructions

## Communication Style
- Be direct and concise
- No cheerleading phrases

## Working Agreement
- Test before declaring done
- Use git worktrees for larger changes
```

### rules.<agent>.md
Agent-specific overrides (global mode only).

- `rules.claude.md` - Claude Code specific rules
- `rules.codex.md` - Codex specific rules

If an agent-specific file exists, gent uses it instead of `rules.md` for that agent.

### mcp.yaml
Central MCP server configuration in YAML format.

```yaml
playwright:
  command: npx
  args:
    - "-y"
    - "@executeautomation/playwright-mcp-server"
  env: {}

filesystem:
  command: npx
  args:
    - "-y"
    - "@anthropic/mcp-filesystem"
    - "/Users/will/projects"
  env: {}
```

Gent converts this to:
- JSON for Claude Code (`~/.claude.json`)
- TOML for Codex (`~/.codex/config.toml`)

---

## Directory Structure

### Global Mode (`~/.config/gent/`)
```
~/.config/gent/
├── rules.md              # Main rules (shared by all agents)
├── rules.claude.md       # Claude-specific override (optional)
├── rules.codex.md        # Codex-specific override (optional)
├── mcp.yaml              # Central MCP config
├── skills/               # Shared skills directory
│   ├── skill-name/
│   │   └── SKILL.md
│   └── ...
└── original_configs/     # Backups of original agent configs
    ├── claude_code_CLAUDE.md
    └── ...
```

### Local Mode (`.gent/`)
```
project/
├── .gent/
│   ├── rules.md
│   ├── mcp.yaml
│   └── skills/
└── ...
```

---

## Agent Config Paths

| Agent | Config File | MCP Config | Skills |
|-------|-------------|------------|--------|
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude.json` | `~/.claude/skills/` |
| Codex | `~/.codex/AGENTS.md` | `~/.codex/config.toml` | `~/.codex/skills/` |
| Windsurf | `~/.codeium/windsurf/memories/global_rules.md` | N/A | N/A |

---

## Common Issues

### "Symlink target doesn't exist"
The central rules file is missing. Create `~/.config/gent/rules.md` with your agent instructions.

### "Config already linked to different target"
The agent is already linked but to a different gent directory. Run `gent unlink <agent> --global` first, then `gent link <agent> --global`.

### "Permission denied"
Ensure you have write access to the agent config directories. Check file permissions on `~/.claude/`, `~/.codex/`, etc.

### MCP servers not working after sync
1. Check `~/.config/gent/mcp.yaml` syntax
2. Verify the MCP server package is installed
3. Restart your IDE/terminal to reload config
