---
name: socratic-dialogue
description: Explain a concept as a Socratic dialogue between a curious learner (Q) and an expert (A), where the learner keeps pushing with "but why" until the expert's underlying tacit reasoning surfaces -- rather than presenting the conclusion directly. Use whenever the user asks for "Socratic method", "Q&A style", "dialogue format", or wants to see the reasoning process behind a conclusion rather than just the conclusion itself. Especially effective for surfacing the tacit, hard-to-articulate judgment that experts use but rarely write down explicitly.
license: Complete terms in LICENSE.txt
---

# Socratic Dialogue / Q&A Format

Present understanding as it's actually extracted from an expert under
questioning — not as a clean, pre-organized lecture. The mechanism: tacit
knowledge (the "feel" for when/why to do something) tends to surface when
someone is pressed with successive "but why" questions, not when they sit
down to write a tutorial from scratch. This format simulates that
pressure.

## When to use this skill

- User asks for "Socratic method", "Q&A style", "dialogue format"
- User wants to see the reasoning PROCESS, not just the conclusion
- The topic has non-obvious "why" behind it that a direct explanation
  tends to state as given fact rather than earn through reasoning
  (design principles, architectural decisions, "best practices" that
  sound like arbitrary rules until justified)

## Language

Always respond in the same language the user is writing in — do not
default to English. Detect the language from the user's most recent
message and write both the Q and A turns entirely in that language,
including the redirection phrases described under Tone below (translate
their intent, not their literal wording). If the user switches languages
mid-conversation, switch with them on the next response. Code and code
comments may stay in English regardless of the surrounding language,
following normal programming convention.

## Structure

- Alternating **Q:** and **A:** turns, formatted as a real back-and-forth,
  not a FAQ list.
- Q starts from a naive, concrete situation the learner is actually
  facing (a piece of code they wrote, an error they hit) — not an
  abstract "what is X?" opener.
- Each Q must genuinely follow from A's previous answer — often by
  asking "why" about something A just said, or by proposing the obvious
  next wrong idea and asking A to evaluate it.
- A never dumps the full explanation in one turn. Each A turn advances
  the reasoning by ONE step and stops — the payoff is watching the
  concept assemble turn by turn, not reading a lecture split into
  quotation marks.
- The dialogue should end with Q successfully articulating the deepest
  insight THEMSELVES (with A confirming), not with A delivering the
  punchline. This is the core mechanic — if A says the key insight, the
  format has failed; Q should say it, prompted by A's questions.

## Turn-by-turn pattern to follow

1. Q presents a concrete situation/question (not abstract)
2. A answers directly but incompletely, or answers with a clarifying
   question back
3. Q either: (a) asks "why" about something A said, (b) proposes a
   plausible-but-wrong next step, or (c) reports trying A's suggestion
   and hitting a new wall
4. Repeat, each cycle advancing one concept
5. Near the end, A asks a question that requires Q to synthesize
   everything discussed — Q answers correctly, using their own words,
   arriving at the real principle/pattern name
6. A confirms and optionally names the formal term (e.g. "that's called
   the Dependency Inversion Principle") as the final beat, AFTER Q has
   already demonstrated understanding the *mechanism* in their own words

## Tone

- Keep A's voice natural, not lecture-y — short answers, real
  back-and-forth rhythm, occasional Socratic redirection (e.g. the
  English equivalents of "let's dig into that —" or "close, but —"
  rather than always answering the literal question asked). Write these
  redirections in the user's language, per the Language section above —
  do not use English filler phrases in a non-English dialogue.
- Q's voice should sound like genuine realization happening in real
  time (e.g. "oh, I see now—", "...I'd guess it's because...") not like
  a scripted straight-man feeding lines. Again, write this in the user's
  language, not English.
- Match the register the user is writing in — casual if they're casual,
  more formal if they're formal — independent of which language it is.

## What NOT to do

- Don't let A explain the full concept in one turn — this collapses the
  format into a lecture with fake quotation marks around it.
- Don't have A state the key insight — Q must arrive at it, with A only
  asking the question that leads there.
- Don't open with an abstract definitional question ("What is dependency
  injection?") — open from a concrete situation the learner is actually
  in.
- Don't make Q's wrong guesses strawmen — they should be genuinely
  plausible things someone would try, so the correction actually
  teaches something.
