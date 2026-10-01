---
name: prep
description: Pre-class preparation for one course. Deep-reads the lecture slides, readings or problem sets for an upcoming session and writes a structured study note into the course's notes/ folder. Use when the user says "prep ABC1234 week 5", "prep for tomorrow's lecture", "read this paper before class", "帮我预习 ABC1234 W5", "预习一下", "下节课讲什么，帮我先读", or names a course plus a week or topic and asks for a note before the lecture.
---

# Pre-class prep

Turn raw Canvas material into a note the user can actually read on the way to class.

Writing the note is the point of this skill, so it is the one case where you save
a note without asking first. If the user only wanted a quick explanation, answer
inline instead and offer the note in one line.

## 1. Find the material

Pull anything new first: `sync(course="<CODE>")`.

Then locate the target:

- `<Course>/_canvas/modules.md` — the lecturer's own week-by-week spine, with
  `->` pointers to local file paths. **Start here** when the user names a week or
  topic.
- `list_materials(course="<CODE>", week=<n>)` — the synced Files tree, narrowed
  to a week where possible.
- `<Course>/_canvas/pages.json` / `announcements.json` — week instructions,
  reading lists. `pages.json` is only the index: read a page's body with
  `read_page(course, slug_or_title)`. Sync already downloads files linked from
  week pages; if the page links a Canvas file (`/courses/<id>/files/<id>`) that
  isn't in `materials/`, fetch it with `download_file(course, file_id)`.

If the user named a specific file, just use it. If ambiguous (several files match
the week), list what you found and pick the primary lecture deck plus any reading,
saying which you chose. Don't ask unless the choice is genuinely 50/50.

If the week's Canvas page is date-locked or the Files tab is empty, say so rather
than prepping from guesswork.

## 2. Read it properly

Read the **whole** document, not the first pages. For a 60-slide deck, read it in
chunks with `read_material(path, pages="1-15")`, then `"16-30"`, and so on, and
hold the thread — the point of this skill is depth, so a skim is a failed run.
Without `pages`, a long file returns only its first 15 pages, and any result that
hits the size cap ends with the range to ask for next: follow it to the end.

**If `read_material` says poppler is missing**, it can't extract PDFs on this Mac.
Open the PDF with your built-in file reading instead, if available, going in
page ranges, and read it just as thoroughly. Mention once that
`brew install poppler` is optional and makes reading faster — don't stop to
wait for it. If there is no built-in way to read the PDF either, say so and ask
the user to install poppler rather than prepping from the file name.

> **Host note** — Claude Code: the built-in Read tool renders PDF pages, at
> most 20 per call. Codex / ChatGPT: use the app's own file reading if it can
> open PDFs.

`mode="text"` (the default) is the fast path and keeps layout order well enough
for slides. Switch to `mode="images"` when the deck is figure-heavy or
hand-drawn, when text comes back near-empty, or when it comes back scrambled
(some PDFs position each glyph separately — more flags won't fix that, reading
the page visually will).

**Some readings are book scans with no text layer.** Text mode returns nothing on
them — that is not an error, it means go straight to `mode="images"`. Scanned
pages are often rotated 90°; still legible, just slower. Budget for it: a
20-page scanned chapter costs far more than a 60-slide text deck, so read it in
page ranges and don't silently stop halfway. If you cover only part of a long
scan, say which pages you read.

While reading, track:
- the spine of the argument, not the slide order
- definitions and notation introduced (these are what break lectures if missed)
- derivations: which steps are actually load-bearing
- worked examples and what each one is there to demonstrate
- anything the deck asserts without proof — flag it as "check in lecture"

## 3. Write the note

Save with `save_note(course="<CODE>", filename="<week-or-topic>-prep.md", markdown=...)`.
If that file already exists, `save_note` refuses — ask the user before retrying
with `overwrite=True`, or pick a new filename.

**Match the user's own note style.** `list_notes(course="<CODE>")`, then
`read_note` one or two existing notes and follow them, so the output feels like
the user's own work rather than a generic summary. If there are none yet, these
defaults are a reasonable starting shape:

- **Question-framed headings.** `## Why does the Bellman operator converge?`, not
  `## Convergence`. The headings ask; the body answers.
- **Numbered points with bold lead-in labels.** `1. **Computational simplicity:**
  the likelihood is easier to work with...` — one idea per number, labelled.
- **A "Bringing it together" close** on each major section: 2–4 sentences saying
  how the pieces relate. This is the part that makes the note re-readable.
- **An explicit Notation block** wherever symbols are introduced.
- **A stated coverage contract** up front when the material is a problem set or a
  list of algorithms — say what every entry will cover, then hold to it exactly.
- LaTeX for all maths (`$...$` inline, `$$...$$` display). Reconstruct notation
  that came out garbled from extraction rather than pasting it broken.
- Write in the user's language, keeping technical terms as the course uses them.

Structure:

```markdown
# <Course> — <Week / Topic>
Source: <relative paths read>  ·  Prepped: <date>

## What is this session actually about?
<One paragraph. Include why it comes after last week.>

## <Question-framed heading per core concept>
<Plain-language answer first, then the formal statement.>
### Notation
<Symbol table, where relevant.>

## <Question-framed heading for the main derivation>
<Walk the load-bearing steps. Skip algebra that carries no idea.>

### Bringing it together
<How these pieces relate.>

## Worked examples
<Per example: what it demonstrates, and the trick it hinges on.>

## Where does this connect?
<Earlier weeks in this course; other courses the user is taking; and the
 user's own interests where the link is real — not forced.>

## Questions to bring to class
<3–6 specific ones. Real gaps — things the material asserts without support
 or leaves genuinely open. Not "what is X".>

## If you only have 10 minutes
<The 5 bullets that carry the session.>
```

## 4. Report back

Give the note path and paste the "what is this session about" paragraph and the
"if you only have 10 minutes" bullets inline, so the user gets value without
opening the file. Offer a PDF (`export_pdf`) in one line if they want to read it
on their phone.

## Notes

- If a linked reading is a paper, prep it against the *lecture's* framing: what
  does this course want from this paper, not a general paper summary.
- Never invent content for pages you couldn't read. Say a file was unreadable
  (scanned beyond legibility, encrypted, date-locked) and prep the rest.
