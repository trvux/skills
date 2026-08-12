---
name: design-identity
description: Runs a consultative discovery process to find a product's own distinctive design identity ("chất riêng") before any UI gets built — instead of copying the surface look of reference sites like Linear, Framer, Vercel, Stripe, or shadcn/ui. Use this whenever the user names admired reference sites/products and wants their own project to "look like" or "have the vibe of" them, asks how to develop a design language, brand identity, or visual point of view, says a build "doesn't have the chất/gu/feel" of the references even though the tokens and components are technically right, or is about to start a new product/landing page and hasn't yet decided what it should stand for visually. Push to use this skill BEFORE reaching for a component library or copying colors/fonts from a reference — surface-level cloning is exactly the failure mode this skill exists to prevent. The output is a short Design Identity Brief file that downstream UI work (e.g. a `frontend-design` or `shadcn` skill) should build from.
license: Complete terms in LICENSE.txt
---

# Design Identity

Reference sites like Linear, Framer, and shadcn/ui don't look distinctive
because of their color values or font choices — those are just the
downstream artifact of one decision made earlier: a specific point of view
about what the product is and who it's for, held with discipline across
every screen. Copying their hex codes and border-radius gets you a
imitation of the surface, not the discipline that produced it, and the
result reads as generic "AI SaaS template" even when every component is
individually correct.

This skill runs the discovery conversation that comes *before* any of that
— the one that produces an actual point of view, a single signature choice,
and a token system derived from *this* product rather than borrowed from
someone else's. Treat yourself as a design lead doing an intake interview
with a new client, not a template picker.

## When to use this skill

- The user names reference sites/products and wants their own project to
  look like them ("làm giống Linear", "muốn có chất như Framer")
- A build technically uses the right dark-mode-tech tokens and shadcn
  components but still "doesn't have the chất" — the gap is usually a
  missing point of view, not a missing component
- The user asks how to build a design system, brand identity, or visual
  language for a product, team, or company
- A new product/landing page/app is starting and nobody has yet answered
  "what should this feel like and why"

Don't use this for one-off styling tweaks on an existing, already-defined
design system — that's a job for `frontend-design` or `shadcn` directly.
This skill is for the decision that precedes execution.

## Why copying references doesn't transfer

Ask the user (rhetorically, in your own words, don't just paste this) what
Linear, Framer, and shadcn/ui actually have in common visually. The honest
answer is: almost nothing, once you look past "dark, minimal, one accent
color." Linear is optimized for feeling fast to a developer who lives in a
keyboard-driven tool. Framer is optimized for demonstrating motion and
creative range, because the product itself is a design/animation tool.
shadcn/ui is optimized for staying invisible so it doesn't fight whatever
brand gets built on top of it. Three completely different answers to "what
should this feel like," each held with total discipline.

What actually transfers between projects isn't the palette — it's the
*process* that produced the palette. That process is what this skill runs.

## The process

Work through these steps as a conversation, not a form. Ask real questions
and let the answers change your next question. Don't skip to token
choices before step 2 is actually answered — a color palette chosen before
the point of view exists is just aesthetic guessing, which is the exact
failure mode being avoided here.

### 1. Anchor in the real subject and audience

Before anything visual, find out what's actually being sold and to whom.
Ask directly:

- What does this product/company actually do? Who pays for it, and why?
- What does the audience feel *before* they arrive (skeptical? rushed?
  technical? anxious about a big purchase?), and what should they feel by
  the time they leave?
- What does this audience already trust, and what do they need to be
  convinced of that they don't currently believe?

If the user is redesigning something that already exists, look at the
current version (fetch it, read it, or ask for a description) before
proposing anything new — the existing trust signals, tone, and content are
real data, not baggage to discard by default.

### 2. Commit to one point-of-view sentence

Push the conversation toward a single sentence in the shape: "This product
should feel like ___ because ___." The "because" has to trace back to step
1's audience/subject, not to a reference site. Reject anything that's just
a mood board adjective ("modern," "clean," "premium") — those describe
nothing and could apply to any product. A real point of view is specific
enough that it would sound wrong applied to a competitor.

Bad: "Feels modern and professional."
Better: "Feels like a technician is already on the way — calm, specific,
zero hype — because the buyer is anxious about an expensive purchase they
don't understand."

If the user wants to explicitly chase a reference's *category* of feeling
(e.g. "the speed/keyboard-first feeling Linear has, but for us"), that's
legitimate — just make them articulate why that feeling suits *their*
audience, not just that they like how it looks.

### 3. Choose exactly one signature risk

A memorable design spends its boldness in one place and stays disciplined
everywhere else. Ask: "If someone described this site to a friend after
seeing it for five seconds, what's the one thing they'd mention?" That's
the signature. It has to be earned by step 1's subject matter (an
interactive sizing tool for an HVAC company; a live latency counter for an
infra product; a single oversized number for a metrics dashboard) — not a
generic device like a gradient blob or numbered 01/02/03 markers picked
because they look nice.

Explicitly reject additional "special" elements beyond this one. If the
user proposes three signature ideas, ask them to pick the one that most
directly proves the point-of-view sentence and defer or drop the rest —
this is the step where most designs quietly turn generic again by trying
to be memorable in five places at once instead of one.

### 4. Derive the token system from the point of view, not from a reference

Only now pick colors, type, and layout — and derive each choice from the
sentence in step 2, stating the reasoning out loud:

- **Color**: 4-6 named values. If reaching for a dark background + one
  saturated accent because "that's what Linear/Framer do," stop and ask
  whether the point of view actually calls for dark mode, or whether
  that's a reflex. A trust-heavy B2C audience often reads dark-mode/glow
  aesthetics as "tech startup," not "trustworthy local expert" — that's a
  real trade-off to name, not paper over.
- **Type**: a display face and a body face, chosen for how they read given
  the audience (a technical audience tolerates tighter tracking and
  smaller body text than an older or less web-native one).
- **Layout**: one concrete structural idea in a sentence + a rough
  wireframe, not just "hero, features, cta" — what does *this* product's
  layout need to prove that a generic SaaS layout wouldn't?

If `frontend-design` or `shadcn` skills are available for the actual build
afterward, this step should produce inputs for those, not fully replace
them — keep this section to the decisions, not the component-level
execution.

### 5. Plan the visual iteration loop before writing code

The single biggest reason a build "doesn't have the chất" even after
following steps 1-4 is coding blind — reasoning about class names without
ever looking at a rendered screenshot. Taste gets tuned by seeing, not by
describing. Before handing this brief off to implementation:

- Confirm there's a way to actually see rendered output. If a browser
  automation tool is connected, use it. If not and this is a local
  Next.js/web project, `scripts/screenshot.sh` in this skill captures a
  real screenshot via headless Chrome without needing any browser
  extension — use it after every meaningful visual change, look at the
  image, and critique it against the point-of-view sentence before moving
  on.
- Plan for more than one visual pass. The first render is a draft to
  critique, not a deliverable.

## Output: the Design Identity Brief

End the conversation by writing a short Markdown file (ask where — default
to a `design/` folder or the project root if there's no obvious place)
using this shape:

```markdown
# Design Identity Brief — [Product name]

## Point of view
[The one sentence from step 2, plus 2-3 sentences of the reasoning
that produced it.]

## Audience
[Who they are, what they feel arriving, what they need to feel leaving.]

## Signature
[The one memorable element from step 3, and why it's earned by the
subject matter rather than borrowed.]

## Tokens
**Color**: [4-6 named hex/oklch values, each with a one-line reason]
**Type**: [display face + body face, with reasoning]
**Layout**: [the structural idea in a sentence, plus a rough wireframe]

## Explicitly rejected
[Directions considered and dropped, and why — this prevents relitigating
the same ideas later, and is often the most useful part of the brief]

## Reference points (if any)
[What was deliberately borrowed from named references, and — more
importantly — what was deliberately NOT borrowed and why]
```

Hand this file to whatever does the actual build next (a `frontend-design`
or `shadcn` skill, or a human designer) as its starting brief.

## Bundled resources

- `scripts/screenshot.sh` — headless-Chrome screenshot helper for the
  visual iteration loop in step 5. Run
  `scripts/screenshot.sh <url> [output.png] [width] [height]`.
- `references/case-studies.md` — short, original breakdowns of how a few
  well-known products (Linear, Framer, shadcn/ui, Stripe) arrived at their
  point of view, for inspiration on *how to think*, not what to copy. Read
  this if the user wants concrete examples of the process in step 2-3
  worked through for real products.
