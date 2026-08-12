---
name: zettelkasten-notes
description: Break an explanation into small, independently-readable, cross-linked notes (a Zettelkasten-style knowledge graph) instead of one linear document -- each note has an ID, a single focused idea, and explicit links to related notes, plus a link map showing the overall network. Use whenever the user asks for "zettelkasten", "linked notes", "note graph", "progressive disclosure", or wants a non-linear reference they can browse by following connections rather than reading top to bottom. Also offer this format when explaining a topic with many interrelated sub-concepts where a single linear document would force an arbitrary reading order.
license: Complete terms in LICENSE.txt
---

# Progressive Disclosure / Zettelkasten-style Notes

Represent knowledge as a network of small, atomic notes rather than a
linear document. The premise: experts don't store knowledge as a
top-to-bottom narrative, they store it as richly cross-linked concepts
they can enter from any point — so notes structured this way mirror how
the knowledge will actually be recalled and used later, rather than how
it was first explained.

## When to use this skill

- User asks for "zettelkasten", "linked notes", "note graph",
  "progressive disclosure"
- Topic has many interrelated sub-concepts where a single linear reading
  order would be somewhat arbitrary (any concept where "it depends which
  part you already know" is true)
- User wants something they'll come back to and browse repeatedly, not
  read once start-to-finish

## Language

Always respond in the same language the user is writing in — do not
default to English. Detect the language from the user's most recent
message and write every note's title and body, the link labels, and the
closing usage instructions in that language. If the user switches
languages mid-conversation, switch with them on the next response. Note
IDs stay in the `PREFIX-NNN` Latin-numeral format regardless of language
(see Structure below) for stable cross-referencing. Code and code
comments may stay in English regardless of the surrounding language,
following normal programming convention.

## Structure

Each note:

```markdown
### 🔖 `PREFIX-NNN` — [short, specific title]

[2-5 sentences OR one focused code block. One idea only.]

→ Liên quan: `PREFIX-XXX` (why it's related, in a few words), `PREFIX-YYY` (...)
```

(The "Liên quan" label above is one worked example, meaning "Related" in
Vietnamese; translate it — and every other label in the note — into
whatever language the user is actually writing in, per the Language
section above. Keep the `🔖` marker and `PREFIX-NNN` ID format regardless
of language.)

Rules for individual notes:
- **One idea per note.** If explaining the note requires a "and also..."
  digression, that digression is a separate note with its own link.
- **Self-contained but not redundant.** A note should make sense read in
  isolation (don't assume the reader just read the previous note) but
  shouldn't re-explain concepts that have their own note — link instead.
- **IDs are stable and sequential** within a topic prefix (e.g. `DI-001`,
  `DI-002`...) so links remain valid as the set grows.
- **Every note has at least one link**, usually 2-3. A note with zero
  links is a sign it should be merged into a related note or the link
  was missed.
- Links are asymmetric-friendly: note A can link to note B without B
  necessarily linking back, if the relationship only matters in one
  direction (e.g. a specific example linking to the general principle it
  illustrates, without the principle needing to link every example).

## Required closing section: link map

After all individual notes, include an ASCII or simple text diagram
showing the overall connection structure — not just a repeat of each
note's own links, but a bird's-eye view of clusters and the main paths
through the material:

```
DI-001 (problem) ──→ DI-002 (solution) ──→ DI-003 (mechanism)
     │                     │                      │
     ↓                     ↓                      ↓
  ...                   ...                    ...
```

End with an explicit instruction for how to use the notes actively: pick
a note at random, try to recall its content before opening it, and only
follow a link when genuinely stuck — not "read top to bottom a second
time." This instruction is part of the deliverable, not optional
boilerplate — it's what makes the format function as retrieval practice
rather than just a differently-formatted document.

## When generating for a CLI/terminal context

If this skill is invoked via CLI where the eventual consumption is an
interactive tool (not raw markdown), mention to the user that the note
set can also be rendered as an actual clickable graph (e.g. via a small
HTML/JS artifact or a note-taking tool import) — but always produce the
complete markdown note set as the primary deliverable regardless, since
that's portable to any tool.

## What NOT to do

- Don't write notes that are actually sequential steps in disguise (note
  2 only makes sense after note 1) — that's a linear document wearing a
  Zettelkasten costume. If the content is genuinely sequential, this is
  the wrong format; suggest `worked-example` instead.
- Don't over-link — every note linking to every other note defeats the
  purpose of showing meaningful structure.
- Don't skip the link map — individual notes without the bird's-eye view
  lose the "network" property that's the whole point of the format.
- Don't make notes so short they lose standalone meaning (a title alone
  is not a note) or so long they stop being atomic (if it needs
  subheadings, split it into multiple linked notes).
