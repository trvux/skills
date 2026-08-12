---
name: ieee-paper-format
description: Write any explanation, tutorial, or answer as a formal academic paper compiled to PDF in IEEE two-column conference format (Abstract, Index Terms, numbered Roman-numeral sections, figures/tables, references). Use whenever the user asks for "academic paper style", "IEEE format", "two column format", "research paper style", "paper format PDF", or wants a topic explained the way a conference paper would present it. Also trigger when the user says things like "make this into a paper" or "give me the academic version" of an explanation. Produces a real compiled PDF, not just markdown that looks like a paper.
license: Complete terms in LICENSE.txt
---

# IEEE Two-Column Paper Format

Turn any topic, question, or explanation into a properly typeset academic
paper: Abstract, Index Terms, numbered sections (Introduction, body
sections, Discussion, Conclusion), figures/tables/code listings, and a
References section — compiled to a real PDF in IEEE conference two-column
layout.

## When to use this skill

Trigger this skill whenever the user asks for:
- "academic paper style", "IEEE format", "IEEE two column format"
- "research paper style", "paper format PDF"
- "make this into a paper" / "give me the academic version"
- Any request to explain a topic the way a conference paper would

This skill produces a **compiled PDF**, not markdown. If the user only
wants academic *tone* in chat (no file), skip this skill and just write in
that register directly.

## Language

Always write the paper in the same language the user is writing in —
do not default to English. Detect the language from the user's request
and write the title, abstract, index terms, section headers, and body
text in that language throughout. Code and code comments inside
listings may stay in English regardless of the paper's language,
following normal programming convention, unless the user explicitly
asks for translated code comments. This determines which LaTeX engine
and template to use — see "Non-English / Unicode text" below.

## Important environment note

`IEEEtran.cls` is frequently unavailable in sandboxed environments with no
network access to CTAN. This skill does NOT depend on it. Instead it uses
a hand-built LaTeX class (`article` + `geometry` + two-column) that
visually reproduces IEEE conference styling: centered Roman-numeral
section headers, two-column body, title/author block, boxed abstract,
italic index terms. This works everywhere `pdflatex`/`xelatex` +
`texlive-latex-extra` are installed, with no external downloads.

## Workflow

1. **Gather the content.** If the user gave you a topic but not full
   content, write the paper content yourself: a real Abstract (150-250
   words), an Introduction motivating the topic, 2-4 body sections with
   real technical depth (code listings if the topic is technical), a
   Discussion or comparison section if relevant, a Conclusion, and a
   References section (only cite real, verifiable sources — never
   fabricate citations).

2. **Choose the language.** If the user's request or conversation is in a
   non-English language (e.g. Vietnamese), write the paper in that
   language. See "Non-English / Unicode text" below — this changes which
   LaTeX engine and fonts to use.

3. **Use the template.** Copy `assets/template_en.tex` (English/Latin-only
   content) or `assets/template_unicode.tex` (any language needing full
   Unicode, e.g. Vietnamese, and reads more broadly compatible even for
   English) into the working directory and fill in the placeholders.

4. **Compile.**
   - English/Latin content → `pdflatex` (run twice for references/TOC to
     resolve): see `references/compile.md`.
   - Unicode/non-Latin content (Vietnamese, etc.) → `xelatex` with
     `fontspec` (run twice). See `references/compile.md`.

5. **Verify visually.** Render page 1 to PNG with `pdf2image` and `view`
   it before presenting — confirms the two-column layout, font rendering,
   and that no text overflows the column width. This is not optional:
   LaTeX errors often compile "successfully" while silently dropping
   content or misrendering diacritics.

6. **Present the file** via your file-presentation tool. Do not paste the
   paper's content into the chat as well — the PDF is the deliverable.

## Non-English / Unicode text

`pdflatex` with the standard `times`/`fontenc` setup CANNOT render
Vietnamese (or most non-Latin) diacritics — it throws
`Unicode character ... not set up` errors for characters like ế, ợ, ầ.

**Fix: use `xelatex` + `fontspec` + a Unicode-complete font.**
`DejaVu Serif` (or `Noto Serif`) is reliably preinstalled and covers
Vietnamese, Central European, and most Latin-extended ranges.

```latex
\usepackage{fontspec}
\setmainfont{DejaVu Serif}
\setsansfont{DejaVu Sans}
\setmonofont{DejaVu Sans Mono}
```

Do NOT use `\usepackage[utf8]{inputenc}` with `xelatex` — xelatex is
UTF-8 native and inputenc will conflict or no-op. Drop it entirely from
the Unicode template.

Compile with `xelatex file.tex` (not `pdflatex`) — twice, for cross-refs.

See `references/compile.md` for the full compile checklist and common
error patterns.

## Content guidelines

- **Abstract**: 150-250 words, self-contained summary (problem, approach,
  finding).
- **Index Terms / Từ khóa**: 4-7 keywords, italic, after the abstract.
- **Sections**: Roman numerals (I, II, III...), centered, small caps or
  bold per template. Subsections: A, B, C..., italic.
- **Code listings**: use the `listings` package with language-appropriate
  keyword highlighting (see template — Go is pre-configured as an
  example; adjust `\lstdefinelanguage` keywords for other languages).
- **Tables**: use `\begin{table}[htbp]` with `\caption` above... actually
  IEEE convention is caption ABOVE tables, BELOW figures. Follow this.
- **References**: only include citations for facts you can verify (via
  web search if needed). Never invent citations, DOIs, or page numbers.
  If the paper doesn't need external sources (e.g. explaining a
  programming concept from first principles), a single reference to
  official documentation is enough — don't pad with fake sources.
- Keep the tone formal and third-person/passive where natural
  ("We examine...", "This paper demonstrates..."), matching real
  conference paper register.

## Common pitfalls

- **Don't** assume `IEEEtran.cls` is installed — check first
  (`find / -iname "IEEEtran*"`), and fall back to the bundled template
  if absent. Most sandboxed environments will NOT have it.
- **Don't** use `pdflatex` for any non-ASCII content — it will fail
  hard on diacritics. Use `xelatex` + `fontspec` instead (see above).
- **Don't** skip the visual verification step — always render and view
  page 1 before presenting.
- **Don't** paste the full paper text into the chat response — present
  the file and give a short summary of what's in it instead.
