# Quota Glance

A tiny Claude Code plugin: after every response, it shows how much of your
**session (5-hour)** and **weekly** usage limit you've used, plus a rough
**token/cost estimate** for this session — no config.

```
This session: 8.4k tokens, ~$4.24
Session ⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶ 50% used, resets in 1.5h
Weekly  ⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶ 12% used, resets in 5.3d
```

(the bar is 10 fully-lit braille cells; only the color changes at the
usage boundary — filled cells blue, `#2A78D6`, unfilled cells pale blue,
`#CDE2FB`, both switching to red, `#C34743`, once a limit is fully used —
so it renders as one solid two-tone bar in a terminal, even though it's
the same dot glyph the whole way across in plain text like this.)

- **`This session: 8.4k tokens, ~$4.24`** — rough token count and cost for
  *this session only*, estimated from the local transcript (see below).
- **`Session ... 50% used, resets in 1.5h`** — how much of your rolling
  **5-hour** usage window you've used, and when it resets.
- **`Weekly ... 12% used, resets in 5.3d`** — same, for the rolling
  **7-day** window.

## How it works

This is a single `Stop` hook (fires right after Claude finishes replying),
not a conversational skill — there's nothing to invoke by name. Two
independent parts, shown together when both succeed:

- **Account limits** (`Session ... | Weekly ...`): calls Anthropic's own
  usage endpoint (`/api/oauth/usage`), the same one the `/usage` command and
  the Claude Code status line read from, using the OAuth token Claude Code
  already has stored (`~/.claude/.credentials.json`, or the macOS Keychain
  if you're signed in that way).
- **Local token/cost estimate** (`8.4k tok ~$4.24`): sums the token counts
  Claude Code already recorded per turn in this session's transcript (no
  re-tokenizing, no extra API calls) and prices it with a small built-in
  table — the same idea as the `ccusage` tool, just inline. It's a ballpark:
  pricing tables go stale and cache-token discounts are approximated. A
  trailing `+` means part of the session used a model this plugin doesn't
  have pricing for, so the total is a floor, not the full number.

If only one half succeeds, you get just that half. If both fail, the hook
stays silent — see below.

- **No new sign-in, no API key, no extra config.** It reuses your existing
  Claude Code session and its own local transcript file.
- **Read-only.** It never writes to or refreshes your stored credentials —
  if your token happens to be expired at that instant, the account-limit
  half just stays quiet until Claude Code refreshes it on its own.
- **Fails silently.** No `curl`/`python3`, not signed in, offline, rate
  limited, unreadable transcript — each half drops out on its own rather
  than showing an error after your response.
- **Account limits are cached for ~90s** so quick back-and-forth turns
  don't add a network round-trip to every single reply. The local estimate
  is recomputed each time (it's just a file read, no network).

## Requirements

- `python3` on your `PATH` (ships by default on macOS and virtually every
  Linux dev box) — used for both halves.
- `curl`, for the account-limits half specifically (Anthropic's edge blocks
  some non-curl HTTP clients by TLS fingerprint). Without it you still get
  the local token/cost estimate.
- A Claude Code session signed in with a Claude.ai account (Pro/Max/Team)
  for the account-limits half — usage limits don't apply to API-key
  billing, so there's nothing to show there in that case (the local
  estimate still works).

## Install

Add the marketplace and install the plugin:

```
/plugin marketplace add trvux/skills
/plugin install quota-glance@trvux-skills
```

## Uninstall

```
/plugin uninstall quota-glance
```
