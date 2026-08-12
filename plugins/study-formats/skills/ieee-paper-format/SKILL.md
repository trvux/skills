---
name: ieee-paper-format
description: Write any explanation, tutorial, or answer as a formal academic paper in IEEE conference format (Abstract, Index Terms, numbered Roman-numeral sections, figures/tables, references). Use whenever the user asks for "academic paper style", "IEEE format", "two column format", "research paper style", or wants a topic explained the way a conference paper would present it. Also trigger when the user says things like "make this into a paper" or "give me the academic version" of an explanation. Defaults to a Markdown deliverable (no toolchain required); produces a compiled two-column PDF only when the user explicitly asks for "PDF" or "compiled".
license: Complete terms in LICENSE.txt
---

# IEEE Two-Column Paper Format

Turn any topic, question, or explanation into a properly structured
academic paper: Abstract, Index Terms, numbered sections (Introduction,
body sections, Discussion, Conclusion), figures/tables/code listings, and
a References section, in the style of an IEEE conference paper.

## Two output modes — Markdown is the default

- **Default: Markdown file.** Write a single `.md` file with the IEEE
  structure (see below) rendered in plain Markdown — headings, tables,
  fenced code blocks. No toolchain, no dependencies, opens anywhere,
  diffable in git. Use this unless the user says otherwise.
- **Opt-in: compiled PDF.** Only go this route when the user's own words
  say "PDF", "compile", "compiled", or similar (e.g. "IEEE PDF", "compile
  it to a paper"). This requires a working `pdflatex`/`xelatex` toolchain
  on the machine — see "PDF mode" below. If the toolchain isn't
  installed, say so and ask before spending time installing it; don't
  silently fall back to Markdown without telling the user why.

If unsure which the user wants, default to Markdown — it's the
lower-cost, lower-friction deliverable and is what most requests for
"IEEE format" / "paper style" actually need (a well-structured document
they can read and edit immediately, not necessarily a print-ready PDF).

## When to use this skill

Trigger this skill whenever the user asks for:
- "academic paper style", "IEEE format", "IEEE two column format"
- "research paper style", "paper format"
- "make this into a paper" / "give me the academic version"
- Any request to explain a topic the way a conference paper would

If the user only wants academic *tone* in chat (no file), skip this
skill and just write in that register directly.

## Language

Always write the paper in the same language the user is writing in —
do not default to English. Detect the language from the user's request
and write the title, abstract, index terms, section headers, and body
text in that language throughout. Code and code comments inside
listings may stay in English regardless of the paper's language,
following normal programming convention, unless the user explicitly
asks for translated code comments.

## Content guidelines (both modes)

- **Abstract**: 150-250 words, self-contained summary (problem, approach,
  finding).
- **Index Terms / Từ khóa**: 4-7 keywords, italic, right after the
  abstract.
- **Sections**: Roman numerals (I, II, III...). Subsections: A, B, C...
- **Code listings**: fenced code blocks with the correct language tag,
  numbered/captioned as "Listing N."
- **Tables**: Markdown tables (Markdown mode) or `\begin{table}` (PDF
  mode). IEEE convention: caption ABOVE tables, BELOW figures.
- **References**: only include citations for facts you can verify (via
  web search if needed). Never invent citations, DOIs, or page numbers.
  If the paper doesn't need external sources (e.g. explaining a
  programming concept from first principles), a single reference to
  official documentation is enough — don't pad with fake sources.
- Keep the tone formal and third-person/passive where natural
  ("We examine...", "This paper demonstrates..."), matching real
  conference paper register.

## Markdown mode (default)

Write directly to a `.md` file — do not paste the full paper into the
chat as well; present the file and give a short summary of what's in it.

Structure:

```markdown
# [Title]
**[Author]** — [affiliation/date line]

### Abstract
[150-250 word abstract.]

*Index Terms*—keyword1, keyword2, keyword3, keyword4.

## I. Introduction
[Body text.]

## II. [Section name]

### A. [Subsection name]
[Body text.]

**Listing 1.** [Caption.]
```go
// code
```

## III. [Next section]

**Table 1.** [Caption above, IEEE convention.]

| Aspect | A | B |
|---|---|---|
| Row | value | value |

## IV. Conclusion
[Closing summary.]

## References
[1] Author, "Title," Source, Year.
```

Two-column layout doesn't exist in plain Markdown — don't try to fake it
with HTML/CSS hacks unless the user's renderer is known to support it.
The IEEE-ness of the Markdown deliverable comes from structure and
section numbering, not from column layout.

## PDF mode (only when explicitly requested)

1. **Check the toolchain first**: confirm `pdflatex` or `xelatex` is on
   PATH (`which xelatex pdflatex`). If neither is present, tell the user
   PDF generation needs a LaTeX distribution (e.g. BasicTeX via
   Homebrew) and confirm before installing anything — this is a
   multi-hundred-MB install that typically needs `sudo`, which you may
   not be able to supply yourself; the user may need to run the install
   command themselves.
2. **Check `IEEEtran.cls`** (`kpsewhich IEEEtran.cls`). It's frequently
   unavailable in sandboxed/offline environments. This skill does NOT
   depend on it — use the bundled hand-built template instead, which
   visually reproduces IEEE conference styling with `article` +
   `geometry` + two-column, with no external downloads.
3. **Use the template.** Copy `assets/template_en.tex` (English/Latin-only
   content) or `assets/template_unicode.tex` (any language needing full
   Unicode, e.g. Vietnamese) into the working directory and fill in the
   placeholders.
4. **Pick fonts that actually exist on the machine.** Don't assume
   `DejaVu Serif`/`DejaVu Sans` are installed — check with `fc-list`
   first. On macOS, `Times New Roman` (serif), `Helvetica Neue` (sans),
   and `Menlo` (mono) are reliable built-in fallbacks that cover
   Vietnamese and most Latin-extended diacritics. Swap the
   `\setmainfont`/`\setsansfont`/`\setmonofont` values in the template to
   whatever `fc-list` confirms is present.
5. **Avoid packages that aren't installed.** Prefer LaTeX built into
   `article`/`geometry`/`titlesec` over extras like `authblk` unless you
   confirm the package is available (`kpsewhich <pkg>.sty`) — installing
   a missing package also needs `sudo tlmgr install`, another
   possible-friction point. A plain `\author{Name \\ \normalsize\itshape
   affiliation}` block avoids the dependency entirely.
6. **Compile.**
   - English/Latin content → `pdflatex` (run twice for cross-refs): see
     `references/compile.md`.
   - Unicode/non-Latin content (Vietnamese, etc.) → `xelatex` with
     `fontspec` (run twice). See `references/compile.md`.
7. **Verify visually.** Render page 1 to PNG (`pdf2image` if available,
   otherwise macOS `sips -s format png file.pdf --out page1.png`) and
   view it before presenting — confirms the two-column layout, font
   rendering, and that no text overflows the column width. This is not
   optional: LaTeX errors often compile "successfully" while silently
   dropping content or misrendering diacritics.
8. **Present the file** via your file-presentation tool. Do not paste
   the paper's content into the chat as well — the PDF is the
   deliverable.

### Non-English / Unicode text (PDF mode)

`pdflatex` with the standard `times`/`fontenc` setup CANNOT render
Vietnamese (or most non-Latin) diacritics — it throws
`Unicode character ... not set up` errors for characters like ế, ợ, ầ.

**Fix: use `xelatex` + `fontspec` + a Unicode-complete font that is
actually installed** (see step 4 above — verify with `fc-list` rather
than assuming DejaVu/Noto are present).

```latex
\usepackage{fontspec}
\setmainfont{Times New Roman}  % or whatever fc-list confirms
\setsansfont{Helvetica Neue}
\setmonofont{Menlo}
```

Do NOT use `\usepackage[utf8]{inputenc}` with `xelatex` — xelatex is
UTF-8 native and inputenc will conflict or no-op. Drop it entirely from
the Unicode template.

Compile with `xelatex file.tex` (not `pdflatex`) — twice, for cross-refs.

See `references/compile.md` for the full compile checklist and common
error patterns.

## Common pitfalls

- **Don't** default to PDF mode — Markdown is the default deliverable
  unless the user's request contains "PDF"/"compile"/"compiled".
- **Don't** assume any specific font or LaTeX package is installed in
  PDF mode — verify with `fc-list` / `kpsewhich` before writing the
  template, rather than discovering the failure at compile time.
- **Don't** silently install multi-hundred-MB toolchains — confirm with
  the user first, since it likely needs `sudo` they'll have to supply.
- **Don't** skip the visual verification step in PDF mode — always
  render and view page 1 before presenting.
- **Don't** paste the full paper text into the chat response in either
  mode — present the file and give a short summary of what's in it
  instead.
