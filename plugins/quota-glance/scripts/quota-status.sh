#!/usr/bin/env bash
# Shows quota usage after a response finishes: real session (5h) / weekly
# limits from your account, plus a local token/cost estimate for this
# session -- both on one line, ASCII only.
#
# Account limits: reads the OAuth token Claude Code already stores
# (credentials file or macOS Keychain) and calls Anthropic's own usage
# endpoint -- the same one the `/usage` command and the Claude Code status
# line read from. Never writes, refreshes, or otherwise touches those
# credentials: if the token happens to be expired, this just stays quiet
# on that half until Claude Code refreshes it on its own.
#
# Local estimate: sums the token usage Claude Code already recorded per
# turn in this session's transcript (no re-tokenizing) and prices it with
# a small built-in table -- same idea as the `ccusage` tool, just inline.
# It's an estimate: pricing tables go stale, and cache-token discounts are
# approximated.
#
# Anthropic's edge fingerprints the TLS handshake and rejects some non-curl
# HTTP clients, so the network call goes through `curl` specifically. Any
# failure on either half -- no python3, no curl, signed out, network error,
# rate limited, unreadable transcript -- just drops that half; if both fail,
# the hook exits with no output. A quota readout must never interrupt the turn.

set -u

CACHE_FILE="${TMPDIR:-/tmp}/claude-quota-glance-cache.json"
CACHE_TTL=90 # seconds; avoids one API round-trip per turn on quick back-and-forths

command -v python3 >/dev/null 2>&1 || exit 0

HOOK_INPUT="$(cat)"
TRANSCRIPT_PATH="$(echo "$HOOK_INPUT" | python3 -c '
import json, sys
try:
    print(json.load(sys.stdin).get("transcript_path", ""))
except Exception:
    pass
' 2>/dev/null)"

# ---- Local part: token/cost estimate from this session's transcript ----

LOCAL_PART=""
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
  LOCAL_PART="$(python3 -c '
import json, sys

# USD per million tokens: (input, output, cache_write, cache_read). Rough,
# will drift out of date -- this is meant as a ballpark, not a bill.
PRICING = {
    "opus":   (15.0, 75.0, 18.75, 1.50),
    "sonnet": (3.0, 15.0, 3.75, 0.30),
    "haiku":  (0.80, 4.0, 1.0, 0.08),
}

def rates_for(model):
    model = (model or "").lower()
    for key, rates in PRICING.items():
        if key in model:
            return rates
    return None

path = sys.argv[1]
total_tokens = 0
cost = 0.0
priced_any = False
unpriced_any = False

try:
    with open(path, "r", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                row = json.loads(line)
            except Exception:
                continue
            if row.get("type") != "assistant":
                continue
            msg = row.get("message") or {}
            usage = msg.get("usage") or {}
            if not usage:
                continue
            i = usage.get("input_tokens", 0) or 0
            o = usage.get("output_tokens", 0) or 0
            cw = usage.get("cache_creation_input_tokens", 0) or 0
            cr = usage.get("cache_read_input_tokens", 0) or 0
            total_tokens += i + o + cw + cr
            rates = rates_for(msg.get("model"))
            if rates:
                ri, ro, rcw, rcr = rates
                cost += (i * ri + o * ro + cw * rcw + cr * rcr) / 1_000_000
                priced_any = True
            elif i + o + cw + cr:
                unpriced_any = True
except Exception:
    sys.exit(0)

if total_tokens == 0:
    sys.exit(0)

tok_str = f"{total_tokens/1000:.1f}k tokens" if total_tokens >= 1000 else f"{total_tokens} tokens"
if priced_any:
    tag = " (est., partial)" if unpriced_any else ""
    print(f"This session: {tok_str}, ~${cost:.2f}{tag}")
else:
    print(f"This session: {tok_str}")
' "$TRANSCRIPT_PATH" 2>/dev/null)"
fi

# ---- Remote part: real session (5h) / weekly usage from the account ----

REMOTE_PART=""
if command -v curl >/dev/null 2>&1; then
  CREDS_FILE="$HOME/.claude/.credentials.json"
  if [ -f "$CREDS_FILE" ]; then
    CREDS_JSON="$(cat "$CREDS_FILE" 2>/dev/null)"
  elif [ "$(uname -s)" = "Darwin" ]; then
    CREDS_JSON="$(/usr/bin/security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)"
  else
    CREDS_JSON=""
  fi

  if [ -n "$CREDS_JSON" ]; then
    ACCESS_TOKEN="$(echo "$CREDS_JSON" | python3 -c '
import json, sys, time
try:
    d = json.load(sys.stdin)["claudeAiOauth"]
    if time.time() * 1000 >= d.get("expiresAt", 0) - 60000:
        sys.exit(1)  # expired/about to expire -- let Claude Code refresh it, skip this round
    print(d["accessToken"])
except Exception:
    sys.exit(1)
' 2>/dev/null)"

    if [ -n "$ACCESS_TOKEN" ]; then
      TOKEN_HASH="$(echo -n "$ACCESS_TOKEN" | shasum -a 256 2>/dev/null | cut -c1-16)"

      if [ -f "$CACHE_FILE" ]; then
        REMOTE_PART="$(python3 -c '
import json, sys, time
try:
    d = json.load(open(sys.argv[1]))
    if d.get("token_hash") == sys.argv[2] and time.time() - d.get("ts", 0) < int(sys.argv[3]):
        print(d["line"])
except Exception:
    pass
' "$CACHE_FILE" "$TOKEN_HASH" "$CACHE_TTL" 2>/dev/null)"
      fi

      if [ -z "$REMOTE_PART" ]; then
        RESPONSE="$(curl -s -m 6 -w '\n%{http_code}' "https://api.anthropic.com/api/oauth/usage" \
          -H "Authorization: Bearer $ACCESS_TOKEN" \
          -H "anthropic-beta: oauth-2025-04-20" \
          -H "Content-Type: application/json" 2>/dev/null)"

        if [ -n "$RESPONSE" ]; then
          HTTP_CODE="$(echo "$RESPONSE" | tail -n1)"
          BODY="$(echo "$RESPONSE" | sed '$d')"

          if [ "$HTTP_CODE" = "200" ]; then
            REMOTE_PART="$(echo "$BODY" | python3 -c '
import json, sys

BLUE = "\033[38;2;51;102;255m"  # #36F, readable on dark and light terminals alike
BOLD = "\033[1m"   # filled segment: terminal own fg color (black/white per theme), just bolded
DIM = "\033[2m"    # empty segment: muted/faded, still theme-aware
RESET = "\033[0m"

def color(pct):
    return BLUE

def bar(pct, width=20):
    pct = max(0.0, min(100.0, pct))
    filled = round(pct / 100 * width)
    return f"{BOLD}{chr(0x2501) * filled}{RESET}{DIM}{chr(0x2500) * (width - filled)}{RESET}"

def reset_in(iso):
    if not iso:
        return ""
    from datetime import datetime, timezone
    try:
        t = datetime.fromisoformat(iso.replace("Z", "+00:00"))
    except Exception:
        return ""
    secs = (t - datetime.now(timezone.utc)).total_seconds()
    if secs <= 0:
        return ""
    hours = secs / 3600
    return f"{hours:.1f}h" if hours < 24 else f"{hours/24:.1f}d"

try:
    d = json.load(sys.stdin)
    five = d.get("five_hour") or {}
    week = d.get("seven_day") or {}
    fp, wp = five.get("utilization"), week.get("utilization")
    if fp is None or wp is None:
        sys.exit(1)
    fr, wr = reset_in(five.get("resets_at")), reset_in(week.get("resets_at"))
    seg1 = f"Session {bar(fp)} {color(fp)}{round(fp)}%{RESET} used" + (f", resets in {fr}" if fr else "")
    seg2 = f"Weekly  {bar(wp)} {color(wp)}{round(wp)}%{RESET} used" + (f", resets in {wr}" if wr else "")
    print(f"{seg1}\n{seg2}")
except Exception:
    sys.exit(1)
' 2>/dev/null)"

            if [ -n "$REMOTE_PART" ]; then
              python3 -c '
import json, sys, time
cache = {"token_hash": sys.argv[1], "ts": time.time(), "line": sys.argv[2]}
try:
    json.dump(cache, open(sys.argv[3], "w"))
except Exception:
    pass
' "$TOKEN_HASH" "$REMOTE_PART" "$CACHE_FILE" 2>/dev/null
            fi
          fi
        fi
      fi
    fi
  fi
fi

# ---- Combine whatever succeeded ----

if [ -n "$REMOTE_PART" ] && [ -n "$LOCAL_PART" ]; then
  LINE="$LOCAL_PART
$REMOTE_PART"
elif [ -n "$REMOTE_PART" ]; then
  LINE="$REMOTE_PART"
elif [ -n "$LOCAL_PART" ]; then
  LINE="$LOCAL_PART"
else
  exit 0
fi

python3 -c '
import json, sys
print(json.dumps({"continue": True, "systemMessage": sys.argv[1]}))
' "$LINE"

exit 0
