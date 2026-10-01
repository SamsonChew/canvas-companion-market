---
name: progress
description: Semester progress report across the user's courses — grades so far, what's submitted vs missing, module completion, and how much prep has been done. Use when the user asks "how am I doing", "semester summary", "what have I fallen behind on", "am I on track", "我的进度怎么样", "进度", "成绩怎么样", "我落下了什么", or wants a status check across all courses.
---

# Progress across the semester

## 1. Gather

Call `progress()` (or `progress(course="<CODE>")` for one course).

Per course this gives: `grades` (Canvas's running score), `graded` / `pending` /
`missing` assignments, `modules` (completion state of the lecturer's module tree),
`local_materials` (files synced), `prep_notes` (notes written by the `prep` skill).

Also check `last_sync` — if it's more than a few days old, call `sync()` first so
the picture is current.

## 2. Read the numbers honestly

- `current_score` is a percentage of **graded work only** — it is not a projected
  final grade. Say so if you quote it; a 95% over 8% of the course weight means
  little. Use `points_earned / points_graded_out_of` to show how much has actually
  been assessed.
- `missing` = past due with nothing submitted. This is the section that matters.
- Module completion is only meaningful if the lecturer set completion requirements.
  If every module shows 0 completed items, don't report it as "0% done" — say the
  course has no tracking and fall back to materials + notes coverage.

## 3. Present

```
# Progress as of <date>

## Needs attention
<missing submissions, courses with no prep, anything overdue. Empty is fine —
 say "nothing outstanding".>

## Per course
### <Course>
- Assessed: <earned>/<possible> pts (<n> of <total> items graded) · Canvas score: <x>%
- Submitted, awaiting grade: <n>
- Missing: <list, or "none">
- Prep notes: <n> · Materials synced: <n>
- <one line of read: on track / behind on X / heavy stretch coming>

## The semester shape
<Where the remaining weight sits. Which course will demand the most next.>
```

Write it in the user's language.

## 4. Judgement, not just numbers

The value of this skill is the read, not the table. Say the true thing:
- If a course is quietly falling behind (materials piling up, no notes, no
  submissions), name it.
- If the workload is front-loaded in one course for the next fortnight, say it.
- If everything is fine, say that in one sentence and stop. Don't manufacture
  concern.

Be factual about weak spots — the user asked for a status check, not
encouragement. Equally, don't editorialise about study habits beyond what the
data shows.

This is an inline answer. Don't save it as a note unless the user asks.
