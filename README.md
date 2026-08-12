# trvux-skills

A Claude Code plugin marketplace with study/explanation-format skills, a
small usage-tracking hook, and a design-identity discovery process.

## Install

Run this once, inside Claude Code:

```
/plugin marketplace add trvux/skills
/plugin install study-formats@trvux-skills
/plugin install quota-glance@trvux-skills
/plugin install design-identity@trvux-skills
```

You can install any plugin on its own — they don't depend on each other.

## What's included

### study-formats

Six skills that reformat any explanation. Trigger them two ways:

- **By name**, explicitly: `/cornell-notes explain recursion to me`
- **By asking naturally** — Claude picks the matching skill on its own when
  your wording matches, e.g. "explain this like I'm 5" auto-triggers
  `feynman-eli5`.

| Skill | What it does | Say things like |
|---|---|---|
| `cornell-notes` | Cue/notes columns + self-test recall questions | "give me study notes", "Cornell notes on X" |
| `feynman-eli5` | Plain-language analogy → precision → why it matters | "explain like I'm 5", "ELI5", "explain simply" |
| `ieee-paper-format` | Formats the answer as a two-column IEEE-style paper (Markdown by default, PDF on request) | "academic paper style", "IEEE format" |
| `socratic-dialogue` | Q&A dialogue that surfaces the reasoning behind a conclusion | "Socratic method", "Q&A style" |
| `worked-example` | One continuous case-study walkthrough, naive attempt → fix → payoff | "worked example", "walk me through it" |
| `zettelkasten-notes` | Atomic, cross-linked notes with a link map instead of one linear doc | "zettelkasten", "linked notes" |

Each skill just changes the *shape* of the answer — ask your real question,
optionally naming the format you want.

### quota-glance

No commands to learn — it's fully passive. Once installed, it runs
automatically after **every** response and prints a line showing your
Claude usage:

```
This session: 8.4k tokens, ~$4.24
Session ██████████░░░░░░░░░░ 50% used, resets in 1.5h
Weekly  ██░░░░░░░░░░░░░░░░░░ 12% used, resets in 5.3d
```

- **session/weekly bars** — pulled from your account's real usage limits
  (same data as `/usage`), only shown if you're signed in with a Claude.ai
  account (Pro/Max/Team).
- **token/cost line** — a local estimate from this session's own transcript,
  no extra API calls.

Nothing to configure, no sign-in beyond your existing Claude Code login.
Full details: [`plugins/quota-glance/README.md`](plugins/quota-glance/README.md).

### design-identity

One skill, `design-identity` — a consultative discovery process to run
*before* building any UI. Instead of copying colors/fonts off a reference
site (Linear, Framer, shadcn/ui, ...), it interviews you to find your own
product's point of view, one signature element, and a token system derived
from that — then writes it all out as a Design Identity Brief file you
hand to the actual build step.

Say things like:

- "muốn có chất riêng như Linear/Framer, không phải copy y chang"
- "help me define a design identity for this product before we build it"
- "bản build đúng token/component rồi mà vẫn không ra chất"

It bundles `scripts/screenshot.sh` — a headless-Chrome screenshot helper
for actually looking at rendered output during iteration, no browser
extension required — and `references/case-studies.md`, short breakdowns of
how Linear/Framer/shadcn/Stripe each arrived at their point of view.

## Uninstall

```
/plugin uninstall study-formats
/plugin uninstall quota-glance
/plugin uninstall design-identity
```

## License

MIT — see `plugins/study-formats/LICENSE`, `plugins/quota-glance/LICENSE`,
and `plugins/design-identity/LICENSE`.
