---
name: cornell-notes
description: Present an explanation as Cornell-style study notes -- a cue-question column paired with a notes/evidence column, followed by a fill-in-yourself summary prompt and self-test recall questions. Use whenever the user asks for "Cornell notes", "study notes", "notes format", or wants material formatted for spaced-repetition style review and active recall rather than a linear explanation. Especially good for exam prep, onboarding docs, or any material the user will need to review more than once.
license: Complete terms in LICENSE.txt
---

# Cornell Notes / Question-Evidence-Conclusion

Produce study notes in the classic Cornell format: a left column of
recall-cue questions, a right column of the actual notes/evidence that
answers them, and a summary section the user must complete themselves.
The format's power comes from retrieval practice — the reader is meant
to cover the right column and try to answer from the cue alone.

## When to use this skill

- User asks for "Cornell notes", "study notes", "notes format"
- Material will be reviewed more than once (exam prep, onboarding docs,
  certification study, spaced repetition)
- User wants something more scannable/reviewable than prose, but more
  structured than a bare bullet list

## Language

Always respond in the same language the user is writing in — do not
default to English. Detect the language from the user's most recent
message and write all column headers, cues, notes, and self-test
questions in that language. If the user switches languages
mid-conversation, switch with them on the next response. Code snippets
and code comments may stay in English regardless of the surrounding
language, following normal programming convention.

## Structure

```markdown
# [Topic]
**Date:** [today's date]

| Câu hỏi (Cues) | Ghi chú / Bằng chứng (Notes) |
|---|---|
| [recall-style question 1] | [the actual content that answers it, including any code/formula/example] |
| [recall-style question 2] | [...] |
| ... 8-14 rows depending on topic depth ... |

## Tóm tắt (tự viết lại bằng lời của bạn — đừng copy)
> ________________________________________________
> ________________________________________________

**Câu hỏi tự kiểm tra (che bảng trên, trả lời trước khi xem lại):**
1. [a question that requires synthesizing 2+ rows, not looked up directly]
2. [a second synthesis question]
```

(The structure above is shown with Vietnamese labels as one worked
example; translate every label — "Cues", "Notes", "Summary", "Self-test
questions", the write-your-own-summary instruction — into whatever
language the user is actually writing in, per the Language section
above.)

## Writing the cue-question column

This is the part that actually makes Cornell notes work, and the part
most tempting to phone in. Rules:

- Every cue must be phrased as a genuine question, not a topic label.
  Bad: "Interfaces". Good: "Why doesn't Go need an `implements`
  keyword?"
- Cover the material progressively: start with "what is X / what problem
  does X solve", move through "how do you do X", end with "why does X
  matter / what's the tradeoff". The cue column read top-to-bottom
  should tell a coherent story on its own.
- Include at least one cue that asks "why" about a design decision, not
  just "what" about a fact — why-questions are what force real
  understanding rather than definition memorization.
- One cue, one clear answer in the paired Notes cell — don't let a
  single row try to answer two different questions.

## Writing the Notes column

- Include real content: code snippets, exact syntax, the actual
  mechanism — not just a restated version of the cue.
- Keep each cell focused — a paragraph or a short code block, not
  multiple paragraphs. If a topic needs more space, split it into two
  cue/note rows instead of writing a long cell.
- Code snippets inside table cells: use inline code formatting or a
  fenced block depending on what the target renderer supports; for
  Markdown tables being read as plain text or in a terminal, prefer
  short inline `code` and keep longer code blocks OUTSIDE the table,
  referenced from the cue row (e.g. "See Listing 1 below").

## The self-test section — non-negotiable

Never omit the closing self-test questions, and never answer them in the
same response. They must require connecting multiple rows (synthesis),
not just quoting one row back. This is the actual retrieval-practice
moment — skipping it turns the skill into a glorified FAQ, which is a
much weaker artifact.

## What NOT to do

- Don't write cue questions that are just the note content with a
  question mark appended ("What is a struct? A struct is...") — that's
  not a real recall cue, it's a rhetorical question.
- Don't fill in the summary section yourself — leave it blank with the
  instruction for the user to write it.
- Don't make the table so dense it needs horizontal scrolling in a
  terminal — if content is code-heavy, keep code blocks separate from
  the table and reference them by listing number.
