---
name: status
description: Weekly full-semester status report across all the user's courses — every remaining deadline in one table, what changed on Canvas this week, what each course needs next week, and a day-by-day plan. Saved as a dated status note in notes/ and exported to PDF. Use on Friday evenings, or when the user says "周报", "写周报", "status update", "weekly report", "帮我更新每个课要做什么", "全部课程状态", or asks for a cross-course picture rather than one course.
---

# Weekly status report

A complete cross-course picture, produced weekly (Friday evening is a good
default). Distinct from the other skills: `week` is a quick "what's due",
`progress` is grades-and-submissions, `prep` is one session's reading. **This one
is the whole semester in a few pages**, regenerated weekly so nothing quietly rots.

Asking for this report is asking for the note and the PDF, so write them.

## 0. Start from last week

**Never assume today's date** — check it first, every time.

`list_notes()` and look for the most recent `status-*.md` in the workspace-level
`notes/`. **Read it first** (`read_note`). It is the baseline: the deadline list and
the known-gaps section are stable and should be carried forward, corrected rather
than re-derived. Your job this week is to find what **changed** and re-cut the
schedule — not to rebuild the whole thing from nothing.

If no previous report exists, build the deadline list from each course's syllabus
(`read_page(course, "syllabus")` for the Canvas Syllabus tab; `list_materials(course=...)`
for a syllabus file, plus the intro/orientation
deck where one exists — lecturers routinely override the Canvas syllabus in class).

## 1. Sync and detect change

1. `sync()` — all courses. Note what it reports as downloaded (it returns
   per-course counts and the first paths; `list_materials` shows the rest).
   It also fetches files linked from inside Canvas pages.
2. `whats_due(days=40)` — every deadline Canvas knows about in the window.
3. Read every announcement posted since the last report: `whats_due(days=<days
   since the last report>)` lists them, each with `title`, `posted` and `text`
   (the message as plain text, clipped to ~600 characters). That is enough to
   tell what changed; if one is clearly cut off mid-instruction, open its `url`
   or ask the user. Canvas returns only a recent window of announcements.

**New files are the other half of the signal.** Open anything newly downloaded that
looks like an instruction sheet, brief, test announcement or rubric and read it
properly with `read_material`. A file named `Test 1 Instructions.pdf` is worth more
than ten slides. For the real requirements of an assignment, `assignment_brief`.

## 2. Read what sync does not save

Two known gaps, both of which have hidden real deadlines before:

- **Canvas page bodies and the Syllabus tab are not synced** — only the page
  index (`_canvas/pages.json`). Assessment weights and weekly instructions often
  live there, so read them with `read_page(course, slug_or_title)`: the
  Syllabus tab is `slug_or_title="syllabus"`, and a weekly page is its `url`
  slug from `pages.json`. A date-locked page comes back with `locked` true and
  no text — note it as not yet open; don't retry or guess.
- **Some courses have an empty Files tab.** The lecturer disabled it and links the
  lecture PDFs, tutorials and assignments from inside each weekly overview page
  instead. The symptom is an empty `materials/` next to a populated
  `_canvas/modules.md`.

`sync` downloads files linked from module pages, the front page and week/overview
pages. If `read_page` shows a Canvas file link (`/courses/<id>/files/<id>`) that
isn't in `materials/` yet, fetch it with `download_file(course, file_id)` and read
it. Anything Canvas refuses (locked, hidden — sync's `errors` and `not_accessible`)
and any page still locked goes in the report's known-gaps line, and the user
checks it in Canvas — never fill the gap by guessing.

## 3. Write the report

Save with `save_note(course="", filename="status-<YYYY-MM-DD>.md", markdown=...)`
— the workspace-level `notes/`, since it spans courses. **Never overwrite a previous
week's file**; each week gets its own dated file, so the series is a record.

**Keep it short.** The weekly report is a *this-week* document, not a semester
reference. Target 4–6 pages. Write it in the user's language; in Chinese the four
sections are 全学期死线总表 · 本周新增 · 各科：下周要准备什么 · 排程建议.

```markdown
# Week N status
As of <weekday date> (end of Week N; Week N+1 starts <date>)

> In one line: <the single most important fact about the coming fortnight>

## All remaining deadlines
<every remaining deadline in date order, with weight. Strike through the completed
 ones — the series should show progress. This table is the point of the report.>

## New this week
<what landed on Canvas since the last report: new files, announcements, released
 briefs. One line each. If a course had nothing, say "nothing".>

## Next week, per course
### <Course>
- Classes: <what each session covers, with room if it changed>
- To do: <pre-class reading, problem sets, sign-ups, things due>
- New material: <only if relevant to the coming week>

## Suggested schedule
<day-by-day for the coming 1–2 weeks, planned around the user's classes.>
```

**Do not restate assessment tables, syllabus outlines or course policies.** Those
belong in a standing document, `notes/reference-assessments.md`. If it exists, read
it for context. When something actually changes (a weight published, a date fixed,
a rule discovered), propose the edit and ask before overwriting it; then say in one
line of the weekly report that the reference was updated and what changed. If it
doesn't exist, offer once to create it.

### What makes this report worth reading

1. **Flag deadline collisions explicitly.** Two 20% items on the same Sunday is the
   single most useful thing the report can surface. Say which one is structurally
   harder to move.
2. **Chase dependencies between deliverables.** If assignment X's reflection must
   cover assignment Y, and Y is due six days before X, say so — that is invisible
   in any per-course view.
3. **Quote the rules that void marks**, verbatim and every week: missing document
   link = 0, late submission not accepted, cheat sheet limits, word caps, file
   naming.
4. **Say what is genuinely unknown.** Unpublished test dates, contradictory syllabus
   entries, deadlines that only exist in a slide. Never invent one to fill a row.
5. **Plan around the real week.** Get the class pattern from `timetable()`: its
   `classes` (weekday, start, end, course, and optionally weeks and label) come
   from Canvas's calendar, or from the timetable the user gave you before. If it
   comes back empty (many universities don't publish class times to Canvas), ask
   the user **once** for their weekly classes — day, start–end time, course, and
   which teaching weeks if not every week. Read the list back, and only after
   they confirm it, save it with `timetable_set(entries=[...])` so next week's
   report doesn't ask again. If they'd rather not, plan from which days they say
   are full or free. A schedule that puts deep work on a day of back-to-back
   classes is not a plan.

## 4. Export the PDF

`export_pdf(note_path="notes/status-<YYYY-MM-DD>.md")` and give the user the PDF
path it returns. If export fails because no renderer is installed, say so and
leave the Markdown note as the deliverable — don't hand-build a substitute.

## 5. Report back inline

Three to six lines in chat, not a summary of the whole file:

- the deadline collisions
- anything newly released this week that carries marks
- the one dependency most likely to bite
- then offer, in one line, to rebuild the todo list from the deadline table

**Do not add, close or delete todos unless told to.** Offer once, wait.

## Notes

- Anything under `materials/` is regenerable; anything under `notes/` is not.
- If a course had no change at all this week, say so in one line rather than
  padding it.
- Canvas is read-only: this report never submits, posts or marks anything.
