---
name: week
description: Live sweep of Canvas across all the user's courses for what is due and what is new — assignments due soon, Canvas's own todo items, recent announcements, and a suggested order to tackle them. Use when the user asks "what's due this week", "what's due", "any new assignments", "check my canvas", "what did I miss", "这周要交什么", "本周要做什么", "最近有什么 deadline", "有什么新公告", or wants a current picture of deadlines across courses.
---

# This week across Canvas

## 1. Pull live state

Call `whats_due(days=7)`. Use `days=14` for a fortnight view, `course="<CODE>"` to
narrow to one course.

This hits Canvas live — never answer from cached files or from an earlier call in
this conversation. If the user is asking again, call it again.

When new assignments appear, also call `sync()` so their attachments land locally,
and mention what got downloaded.

## 2. Triage, don't dump

The result has `courses` (assignments per course), `todo` (Canvas's own list), and
`announcements` (each with `text`, the message as plain text, clipped to ~600
characters — say in one line what each one changes). Merge them — Canvas's todo
and the assignment list overlap, so deduplicate by name before presenting.

Order by **what should be started first**, not by due date alone. A 20-point
project due in 10 days outranks a 2-point quiz due tomorrow on some days; use
`points` and `days_left` together and say why when the order is non-obvious.

## 3. Present

```
## Due this week

**⚠ Overdue**
- <Course> — <name> · was due <when> · <points>pt

**Next 48h**
- <Course> — <name> · <when> · <points>pt · <submitted? / not started>

**Rest of week**
- ...

## New since last time
<announcements, new assignments, newly posted materials>

## Suggested order
1. <item> — <one line on why first>
```

Rules:
- Mark anything with `submitted: true` as done and drop it from the action list —
  mention it in one line at the end instead.
- `⚠` only for genuinely overdue or <24h items. Don't decorate everything.
- If a course has nothing due, one line: "<Course> — nothing due." Not a blank
  section.
- If the whole week is empty, say so plainly in a sentence. Don't pad.
- Headings and prose in the user's language.

## 4. Offer the next step

End by offering to prep the most imminent item (the `prep` skill) or to open the
assignment brief. One line, not a menu.

Do **not** add anything to the todo list from this sweep. If the user wants these
tracked, they will say so (the `todo` skill).

## Notes

- **Read-only.** This skill reports what's due. It never submits, never marks
  anything complete, never posts. If the user says "just submit it for me",
  decline and point them at the assignment's Canvas link to do it themselves.
- What an assignment actually requires lives in `assignment_brief(ref="<id or name>")`
  — fetch it when the user asks.
- A 401 means the Canvas token expired or was revoked; tell the user to create a
  new one in Canvas (Account > Settings) and update it in the plugin's settings.
