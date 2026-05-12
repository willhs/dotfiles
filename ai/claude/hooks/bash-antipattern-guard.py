#!/usr/bin/env python3
"""
bash-antipattern-guard — PreToolUse hook

Blocks Bash calls whose first command is a shell equivalent of a native
Claude Code tool. Raw Bash output dumps into context and stays there for
every subsequent turn; native tools produce structured, truncatable output.

Antipatterns → native replacement:
  cat/head/tail → Read
  grep/rg       → Grep
  find          → Glob
  ls            → Glob (or LS)
  sed/awk       → Edit
"""
import json
import re
import sys

NATIVE_TOOL_MAP = {
    "cat":  "Read",
    "head": "Read (with limit:)",
    "tail": "Read (with offset: + limit:)",
    "grep": "Grep",
    "rg":   "Grep",
    "find": "Glob",
    "ls":   "Glob",
    "sed":  "Edit",
    "awk":  "Edit",
}


def first_command(shell: str) -> str:
    """Return the bare command name from the start of a shell string."""
    token = re.split(r"[\s|&;<>()\[\]]", shell.lstrip())[0]
    # Strip env-var assignments like FOO=bar command → command
    while "=" in token and not token.startswith("-"):
        parts = shell.lstrip().split(None, len(token.split("=")[0]) + 2)
        if len(parts) < 2:
            return token
        shell = shell.lstrip()[len(token):].lstrip()
        token = re.split(r"[\s|&;<>()\[\]]", shell)[0]
        if not token:
            return ""
    return token


def main():
    try:
        data = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        sys.exit(0)

    if data.get("hook_event_name") != "PreToolUse":
        sys.exit(0)
    if data.get("tool_name") != "Bash":
        sys.exit(0)

    command = data.get("tool_input", {}).get("command", "")
    if not command:
        sys.exit(0)

    cmd = first_command(command)
    if cmd not in NATIVE_TOOL_MAP:
        sys.exit(0)

    native = NATIVE_TOOL_MAP[cmd]
    print(json.dumps({
        "decision": "block",
        "reason": (
            f"`{cmd}` via Bash is an antipattern — use the {native} tool instead. "
            "Bash output enters context raw and persists; native tools are "
            "structured and summarisable by the harness."
        ),
    }))
    sys.exit(0)


if __name__ == "__main__":
    main()
