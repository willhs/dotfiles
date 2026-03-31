#!/usr/bin/env python3
import json, sys, os
from datetime import datetime, timezone

data = json.load(sys.stdin)

# --- Model ---
model = data["model"]["display_name"]

# --- Folder + git branch ---
cwd = os.path.basename(os.getcwd())
branch = ""
git_dir = os.path.join(os.getcwd(), ".git")
if os.path.isdir(git_dir):
    try:
        ref = open(os.path.join(git_dir, "HEAD")).read().strip()
        if ref.startswith("ref: refs/heads/"):
            branch = ref[16:]
    except Exception:
        pass

# --- Context window ---
ctx = data.get("context_window", {})
ctx_size = ctx.get("context_window_size", 1)
cur = ctx.get("current_usage", {})
tokens = sum(
    cur.get(k, 0)
    for k in (
        "input_tokens",
        "output_tokens",
        "cache_creation_input_tokens",
        "cache_read_input_tokens",
    )
)
ctx_pct = int(tokens / ctx_size * 100) if ctx_size > 0 else 0

# --- Usage quotas from cache ---
usage_5h = usage_7d = reset_5h = reset_7d = ""
cache = "/tmp/.claude_usage_cache"
if os.path.isfile(cache):
    try:
        lines = open(cache).read().strip().split("\n")
        if len(lines) >= 4:
            usage_5h, usage_7d, reset_5h, reset_7d = lines[:4]
    except Exception:
        pass


def time_delta(iso_str):
    if not iso_str:
        return ""
    try:
        clean = iso_str.replace("Z", "+00:00")
        if "." in clean:
            base, rest = clean.split(".", 1)
            tz = ""
            for i, c in enumerate(rest):
                if c in "+-":
                    tz = rest[i:]
                    break
            clean = base + tz
        dt = datetime.fromisoformat(clean)
        diff = int((dt - datetime.now(timezone.utc)).total_seconds())
        if diff <= 0:
            return "now"
        d, rem = divmod(diff, 86400)
        h, rem = divmod(rem, 3600)
        m = rem // 60
        if d > 0:
            return f"{d}d {h}h"
        if h > 0:
            return f"{h}h {m}m"
        return f"{m}m"
    except Exception:
        return ""


# --- ANSI colors (claude-watch palette) ---
O = "\033[38;5;208m\033[1m"  # orange bold - model
T = "\033[1m\033[38;2;76;208;222m"  # teal bold - folder
P = "\033[1m\033[38;2;192;103;222m"  # purple bold - branch
G = "\033[90m"  # gray - separators
M = "\033[38;2;156;162;175m"  # muted - stats
D = "\033[2m\033[38;2;156;162;175m"  # dim muted - reset timers
R = "\033[0m"  # reset

SEP = f"{G} | {R}"
DOT = f"{G} \u2022 {R}"

# --- Assemble ---
# Opus 4.6 | my-project • main | ctx 35% | 5h:54% 2h15m • 7d:33% 4d23h
parts = [f"{O}{model}{R}"]

loc = f"{T}{cwd}{R}"
if branch:
    loc += f"{DOT}{P}{branch}{R}"
parts.append(loc)

parts.append(f"{M}ctx {ctx_pct}%{R}")

if usage_5h and usage_7d:
    def fmt_quota(pct, reset):
        d = time_delta(reset)
        return f"{pct}%{f' {D}{d}{R}{M}' if d else ''}"
    u = f"{M}5h:{fmt_quota(usage_5h, reset_5h)} {G}\u2022{R} {M}7d:{fmt_quota(usage_7d, reset_7d)}{R}"
    parts.append(u)

print(SEP.join(parts))
