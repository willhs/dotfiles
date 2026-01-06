---
name: gent
description: This skill should be used when the user asks about managing AI agent configuration, syncing rules/MCP/skills across Claude Code, Codex, or Windsurf, or needs help with the gent CLI tool. Triggers on questions about centralized agent config, cross-tool sync, or gent commands.
---

# Gent - Centralized AI Agent Configuration

Gent is a CLI tool for managing AI agent configuration across multiple tools (Claude Code, Codex, Windsurf) from a single source of truth.

## Core Concepts

### Local vs Global Mode
- **Local** (`.gent/`): Project-specific config, affects agents in that project only
- **Global** (`~/.config/gent/`): User-level config, affects all projects

Most users work with global mode (`--global` flag).

### What Gent Manages
1. **Rules** - Agent instructions (CLAUDE.md, AGENTS.md, etc.)
2. **MCP Servers** - Model Context Protocol server definitions
3. **Skills** - Shared skill directories for Claude and Codex

## Common Workflows

### Initial Setup (Global)
```bash
gent init --global
```
Links all supported agents to central config at `~/.config/gent/`.

### Link Specific Agent
```bash
gent link claude --global
gent link codex --global
gent link windsurf --global
```

### Check Status
```bash
gent list --global
```
Shows which agents are linked and their config locations.

### Resync After Changes
```bash
gent sync --global
```
Updates symlinks if paths changed, resyncs MCP configs.

### Unlink Agent
```bash
gent unlink claude --global
```
Restores original agent config from backup.

## Config Locations

| Item | Global Location |
|------|-----------------|
| Central rules | `~/.config/gent/rules.md` |
| Agent-specific rules | `~/.config/gent/rules.claude.md`, `rules.codex.md` |
| MCP config | `~/.config/gent/mcp.yaml` |
| Skills | `~/.config/gent/skills/` |
| Backups | `~/.config/gent/original_configs/` |

## How It Works

Gent creates symlinks from each agent's config location to the central gent config:
- `~/.claude/CLAUDE.md` → `~/.config/gent/rules.md` (or `rules.claude.md`)
- `~/.codex/AGENTS.md` → `~/.config/gent/rules.md` (or `rules.codex.md`)
- `~/.claude/skills/` → `~/.config/gent/skills/`

Edit `~/.config/gent/rules.md` once, all linked agents use those rules.

## Troubleshooting

### "File exists and is not a symlink"
The agent config already exists. Gent backs up existing configs before linking. Run `gent link <agent> --global` and it will handle the backup.

### MCP servers not syncing
Check `~/.config/gent/mcp.yaml` for the central MCP config. Gent converts between formats (JSON for Claude, TOML for Codex).

### Skills not appearing
Ensure skills are in `~/.config/gent/skills/` with proper SKILL.md files. Run `gent sync --global` to update symlinks.

## Reference

For detailed CLI reference and config file formats, see `references/commands.md`.
