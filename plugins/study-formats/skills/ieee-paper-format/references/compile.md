# Compiling the paper

## Decision: which engine?

| Content language | Engine | Template |
|---|---|---|
| English / Latin-only, no diacritics | `pdflatex` | `assets/template_en.tex` |
| Any language with diacritics/non-Latin (Vietnamese, etc.) | `xelatex` | `assets/template_unicode.tex` |

If unsure, default to `xelatex` + `template_unicode.tex` — it works for
English too and avoids the diacritics failure mode entirely.

## Compile commands

Always compile **twice** — the first pass resolves labels/references,
the second pass renders them correctly (table/figure numbers, etc.).

```bash
# English/Latin (pdflatex)
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex

# Unicode / non-Latin (xelatex)
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex
```

Check the exit code and grep the log for real errors (warnings about
"Overfull \hbox" are usually harmless spacing issues, not failures):

```bash
grep -i "! " main.log | head -30
```

## Verify before presenting — mandatory

LaTeX can "succeed" (exit 0, PDF produced) while silently mangling
content — most commonly:
- A table or code listing overflowing the column width
- Diacritics rendering as boxes or missing-glyph warnings (if
  `pdflatex` was wrongly used for non-Latin content)
- Content pushed off the page by an oversized table

Render page 1 (and any page containing a table/listing) to PNG and
visually inspect it:

```python
from pdf2image import convert_from_path
imgs = convert_from_path('main.pdf', dpi=100)
imgs[0].save('page1.png')
```
Then use the `view` tool on `page1.png`. Confirm:
- Two columns are visible and balanced
- Title/abstract/index terms render correctly
- No text runs past the column edge
- (Unicode case) diacritics render as real glyphs, not boxes or `?`

## Common errors and fixes

**`! LaTeX Error: File 'IEEEtran.cls' not found.`**
Expected in sandboxed environments — this skill's templates don't use
IEEEtran.cls, so this error means you accidentally used a different
template. Use `assets/template_en.tex` or `assets/template_unicode.tex`
instead.

**`! LaTeX Error: Unicode character X (U+....)`**
You used `pdflatex` on non-Latin content. Switch to `xelatex` +
`assets/template_unicode.tex`.

**Table/listing overflows the column**
Two-column IEEE layout is narrow (~3.3in per column at 10pt). Long
table cells need `p{Ncm}` fixed-width columns (see template) rather
than `l`/`c`/`r`. Code listings should use a small font
(`\fontsize{7}{8}\ttfamily` in the template) and `breaklines=true`.

**pip / package install needed for verification**
```bash
pip install pdf2image --break-system-packages -q
```
(poppler-utils, needed by pdf2image, is normally already present in the
sandbox; if `convert_from_path` fails with a poppler error, install
`poppler-utils` via apt if network access allows, otherwise fall back
to `pdftoppm` directly.)

## Output

Copy the final PDF to the outputs directory and present it — do not also
paste the paper's full text into the chat response.
