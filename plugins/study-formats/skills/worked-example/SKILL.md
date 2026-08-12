---
name: worked-example
description: Teach a concept by walking through one realistic, continuous scenario from a naive first attempt through the wrong turns, the moment the real problem is discovered, the fix, and a payoff that proves the fix was worth it -- ending with a generalized heuristic. Use whenever the user asks for a "worked example", "case study", "walk me through it", "show me step by step with a real example", or is trying to understand WHY a pattern/technique exists rather than just what it is. Especially good for design patterns, refactoring techniques, debugging methodology, and any "best practice" that sounds arbitrary until you've hit the problem it solves yourself.
license: Complete terms in LICENSE.txt
---

# Case-based / Worked Example

Teach through apprenticeship, not lecture. Instead of stating a
principle and then illustrating it, follow one continuous, realistic
scenario in which the principle is *discovered* — including the wrong
turns — so the reader experiences why the principle exists rather than
being told that it does.

## When to use this skill

- User asks for a "worked example", "case study", "walk me through it"
- User is trying to understand WHY a practice/pattern exists, not just
  what it is or how to write it
- The topic is a "best practice" that sounds arbitrary or like arbitrary
  ceremony until you've personally hit the problem it solves (design
  patterns, refactoring rules, testing practices, architecture
  principles, SOLID-type guidelines, debugging methodology)

## Language

Always respond in the same language the user is writing in — do not
default to English. Detect the language from the user's most recent
message and write the entire narrative, headers, and closing heuristic
in that language. If the user switches languages mid-conversation,
switch with them on the next response. Code and code comments may stay
in English regardless of the surrounding language, following normal
programming convention.

## Structure (always these five beats, in order)

### 1. Bối cảnh (Setup)
A realistic, specific task with a real constraint (a deadline, an
existing codebase, a vague requirement) — not an abstract "let's say we
have a class Foo". Make it concrete enough that the reader recognizes
the situation from their own experience.

### 2. Naive first attempt
Write the straightforward, uninformed solution — the thing a reasonable
person would write without foreseeing the problem. This must be
genuinely reasonable, not a strawman. Show real code/steps. It should
"work" at first glance.

### 3. The wrong turns
This is the step most explanations skip and the one that does the real
teaching. Show 2-3 tempting-but-wrong fixes the person might reach for
first when the problem surfaces, and explain concretely why each is a
dead end (not just "this is bad practice" — show the actual failure:
what breaks, what test fails, what becomes impossible). This section is
what separates a worked example from a tutorial — it's where the reader
builds the judgment to recognize dead ends themselves next time.

### 4. The real fix
Show the moment of reframing — the question that leads to the actual
solution ("the right question isn't X, it's Y") — then the fix itself
with real code/steps. Explain what changed conceptually, not just what
changed syntactically.

### 5. Payoff
A second scenario, later in the story (a new requirement, a code
review, a production incident) that the fix now handles cleanly —
proving the investment was worth it. This should require touching
ZERO or minimal code from the original fix, to make the payoff visible
and concrete.

### Close: heuristic
End with ONE extracted, generalizable heuristic — stated as a rule of
thumb the reader can apply to a DIFFERENT situation, not a restatement
of what just happened. Explicitly frame it as "not always do X, but do
X when you see signal Y" — worked examples that end in "always use
interfaces" or similar absolutist advice have failed to extract the real
lesson, which is almost always conditional.

## Formatting

- Use `## Step N: ...` style headers for beats 2-5 (translated into the
  user's language per the Language section above — e.g. "Bước N" in
  Vietnamese); beat 1 can be a short intro paragraph.
- Real code throughout — this format lives and dies on concreteness.
  Pseudocode is a last resort only if the user hasn't specified a
  language.
- Keep narrative connective tissue conversational ("you commit, go to
  lunch", "a few weeks later, product asks for...") — the story quality
  is doing real pedagogical work, not just decoration.

## What NOT to do

- Don't make the naive first attempt a strawman that's obviously bad —
  if experienced practitioners wouldn't plausibly write it, the "wrong
  turns" section loses its teaching power.
- Don't skip straight from problem to fix — the wrong-turns section is
  mandatory and is usually the most valuable part.
- Don't end with a universal rule ("always do X") — the heuristic must
  be conditional and specific about when it applies.
- Don't use a toy/abstract scenario (Foo/Bar/Baz) — specificity is what
  makes this format work.
