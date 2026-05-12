#!/usr/bin/env python3
"""
tmux-pane-tint hook
Applies a subtle background tint to signal Claude Code state:
  working          → bg=#120020 (very faint lavender tint)
  waiting_for_user → default   (natural colours)

No-op if not running inside tmux.
"""
import json
import os
import subprocess
import sys


def get_tty():
    ppid = os.getppid()
    try:
        result = subprocess.run(
            ["ps", "-p", str(ppid), "-o", "tty="],
            capture_output=True, text=True, timeout=2
        )
        tty = result.stdout.strip()
        if tty and tty not in ("??", "-"):
            if not tty.startswith("/dev/"):
                tty = "/dev/" + tty
            return tty
    except Exception:
        pass
    return None


def find_tmux_pane(tty):
    try:
        result = subprocess.run(
            ["tmux", "list-panes", "-a", "-F", "#{pane_id} #{pane_tty}"],
            capture_output=True, text=True, timeout=2
        )
        for line in result.stdout.splitlines():
            parts = line.split(None, 1)
            if len(parts) == 2 and parts[1] == tty:
                return parts[0]
    except Exception:
        pass
    return None


def set_pane_style(pane_id, working):
    style = "bg=#120020" if working else "default"
    for opt in ("window-style", "window-active-style"):
        try:
            subprocess.run(
                ["tmux", "set", "-p", "-t", pane_id, opt, style],
                timeout=2, capture_output=True
            )
        except Exception:
            pass


def main():
    if not os.environ.get("TMUX"):
        sys.exit(0)
    if os.environ.get("MANAGER_HEADLESS"):
        sys.exit(0)

    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)

    event = data.get("hook_event_name", "")

    working = True
    if event in ("Stop", "SubagentStop", "SessionStart", "SessionEnd"):
        working = False
    elif event == "Notification" and data.get("notification_type") == "idle_prompt":
        working = False
    elif event == "PreToolUse" and data.get("tool_name") in ("AskUserQuestion", "ExitPlanMode"):
        working = False
    elif event == "PermissionRequest":
        working = False
    # UserPromptSubmit, PreToolUse, PostToolUse, PreCompact → working

    tty = get_tty()
    if not tty:
        sys.exit(0)

    pane_id = find_tmux_pane(tty)
    if not pane_id:
        sys.exit(0)

    set_pane_style(pane_id, working)


if __name__ == "__main__":
    main()
