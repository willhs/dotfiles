#!/usr/bin/env python3
"""Fetch Claude API usage quotas and write to /tmp/.claude_usage_cache.
Meant to run in background via hooks. No output on success."""
import json, os, sys, time, subprocess

CACHE = "/tmp/.claude_usage_cache"
TOKEN_CACHE = "/tmp/.claude_token_cache"
CREDS = os.path.expanduser("~/.claude/.credentials.json")
KEYCHAIN_SERVICE = "Claude Code-credentials"
TOKEN_TTL = 900

# --- Get token (cached 15 min) ---
token = ""
if os.path.isfile(TOKEN_CACHE):
    if time.time() - os.path.getmtime(TOKEN_CACHE) < TOKEN_TTL:
        token = open(TOKEN_CACHE).read().strip()

if not token:
    if os.path.isfile(CREDS):
        token = json.load(open(CREDS)).get("claudeAiOauth", {}).get("accessToken", "")
    if not token:
        try:
            raw = subprocess.check_output(
                ["security", "find-generic-password", "-s", KEYCHAIN_SERVICE, "-w"],
                stderr=subprocess.DEVNULL,
                text=True,
            ).strip()
            creds = json.loads(raw)
            oauth = creds.get("claudeAiOauth", creds)
            token = oauth.get("accessToken", "")
        except Exception:
            pass
    if not token:
        sys.exit(0)
    with open(TOKEN_CACHE, "w") as f:
        f.write(token)

# --- Fetch usage via curl (avoids Python SSL cert issues on macOS) ---
try:
    raw = subprocess.check_output(
        [
            "curl", "-s", "-m", "3",
            "-H", "accept: application/json",
            "-H", "anthropic-beta: oauth-2025-04-20",
            "-H", f"authorization: Bearer {token}",
            "-H", "user-agent: claude-code/2.1.11",
            "https://api.anthropic.com/oauth/usage",
        ],
        stderr=subprocess.DEVNULL,
        text=True,
    )
    data = json.loads(raw)
except Exception:
    sys.exit(0)

five = data.get("five_hour", {})
seven = data.get("seven_day", {})
u5 = five.get("utilization")
u7 = seven.get("utilization")

if u5 is not None and u7 is not None:
    with open(CACHE, "w") as f:
        f.write(
            f"{round(u5)}\n{round(u7)}\n"
            f"{five.get('resets_at', '')}\n{seven.get('resets_at', '')}\n"
        )
