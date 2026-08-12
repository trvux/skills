---
name: feynman-eli5
description: Explain a concept, theorem, or piece of code using the Feynman Technique — a layered explanation that starts with a plain-language everyday analogy (no jargon), then adds technical precision in successive layers, ends with the real motivating "why does this matter" reasoning, and closes with a self-test question the user must answer in their own words. Use whenever the user asks to explain something "like I'm 5", "ELI5", "Feynman style", "simply", "in plain English", or wants to build intuition for a concept rather than just read a definition. Trigger this proactively whenever a concept is genuinely hard to build intuition for (recursion, gradient descent, dependency injection, statistical concepts, etc.) even if the user just asks "explain X" without naming the technique.
license: Complete terms in LICENSE.txt
---

# Feynman Technique / ELI5 Layered Explanation

Explain a concept the way Richard Feynman recommended teaching: force
genuine simplicity first, then rebuild precision layer by layer. The
core mechanic is that writing the ELI5 version exposes exactly which
parts of your own understanding are fuzzy — so the layering is not just
a presentation style, it's a comprehension check.

## When to use this skill

- User says "ELI5", "explain like I'm 5", "Feynman style", "explain
  simply", "in plain English", "dumb it down"
- User is clearly struggling with a concept after a more technical
  explanation didn't land
- Proactively for concepts that are notoriously hard to build intuition
  for even among practitioners: recursion, closures, gradient descent,
  Bayesian inference, dependency injection, monads, CAP theorem,
  eigenvectors, etc. — even if the user just asked "explain X"

## Language

Always respond in the same language the user is writing in — do not
default to English. Detect the language from the user's most recent
message and write the entire explanation (headers, analogies, self-test
question, everything) in that language. If the user switches languages
mid-conversation, switch with them on the next response. Code and code
comments may stay in English regardless of the surrounding language,
following normal programming convention, unless the user explicitly
asks for translated code comments.

## Structure (always four layers, in this order)

### Layer 1 — Explain like a child
- Use a physical, everyday analogy. No jargon, no technical terms at
  all. If you catch yourself writing a term from the domain, replace it
  with the analogy's vocabulary instead.
- 2-4 sentences. This layer must stand alone and make sense to someone
  with zero background.
- Good analogies come from: household objects, cooking, games, physical
  spaces, animals, everyday social situations. Pick one that maps
  cleanly onto the actual structure of the concept — don't force a cute
  analogy that breaks down under scrutiny.

### Layer 2 — Add real terminology
- Reintroduce the actual technical vocabulary, explicitly mapping each
  term back to the Layer 1 analogy ("in code, the 'slot' from Layer 1 is
  called an interface").
- Include one small, concrete code example or worked mini-example if the
  topic is technical.

### Layer 3 — The "why does this matter" layer
- This is the layer most explanations skip, and it's the one that
  actually builds tacit knowledge. Answer: what breaks or becomes
  painful WITHOUT this concept? Show the failure mode concretely (a
  bad-code example, a wrong intuition, a real consequence) before
  showing how the concept fixes it.
- This layer should contain the most "aha" — it's where surface
  knowledge turns into judgment about when/why to use the thing.

### Layer 4 — The subtlety that trips people up
- Name ONE specific misconception or edge case that people coming from
  a different background (a different language, a different field, a
  naive first read) commonly get wrong. Be concrete about who gets
  confused and why — this is often the most valuable layer for someone
  who already has partial knowledge.

### Close — self-test
- End with exactly one question that requires the user to reconstruct
  the core reasoning in their own words — not a recall question ("what
  is X called") but a reasoning question ("why should Y not do Z
  itself, but instead receive it from outside").
- Include a one-line hint about what a correct answer must reference,
  so the user can self-check without being handed the answer outright.
- Do not answer this question yourself. End the response here.

## Formatting

- Use `## Layer 1: ...` style headers, translated into the user's
  language per the Language section above (e.g. "Lớp 1" in Vietnamese,
  "Capa 1" in Spanish).
- Keep code blocks minimal and focused — one small example per layer
  max, not a full program.
- Total length: proportional to concept complexity, but default to
  concise. This is meant to be read in one sitting, not skimmed.

## What NOT to do

- Don't skip straight to Layer 2 vocabulary in Layer 1 "for clarity" —
  the whole point is forcing a jargon-free pass first.
- Don't answer the self-test question in the same response.
- Don't pad Layer 4 with a generic "it depends" — name a specific,
  real misconception.
- If the user pushes back that a layer is "too simple", that's the
  technique working as intended, not a flaw to fix — explain briefly why
  the simple layer exists rather than cutting it.
