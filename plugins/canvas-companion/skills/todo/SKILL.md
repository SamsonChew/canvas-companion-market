---
name: todo
description: The user's tracked todo list — show what's outstanding, add an item when the user says so, mark done, reopen, edit, or delete. Use when the user asks "what's left", "what's on my list", "add this to my todos", "mark 2 done", "change the deadline", "还有什么没做", "记一下这个 todo", "把这个加进去", "第 2 个做完了", "改一下 deadline", "删掉那条", or refers to a todo by its number.
---

# Todo list

The list lives in the workspace and is driven by the `todo_*` tools.

**Refer to items by their position — 1, 2, 3 — never by an internal id.** Any id
in a tool result is plumbing; it must not appear in your replies. Positions come
from `todo_list`, so they only mean anything against a *fresh* read.

## The list is the truth. Your memory is not.

**Never state or assume the status of a todo from conversation history.** Earlier
in the same chat you may have said something was done — it may since have been
reopened, edited, or deleted, in this chat or in another session.

So, every single time:

1. **Call `todo_list` before answering anything about the list.** Not "I recall
   that one was done" — read it. This also re-derives the numbering.
2. **Call the tool.** Saying "already marked done" without calling `todo_done` is
   the failure mode this rule exists for: the user sees the item still open next
   time and stops trusting the whole thing.
3. **Read back after writing.** After `todo_done` / `todo_add` / `todo_edit` /
   `todo_delete`, the tool returns the resulting item — quote that, not your
   intention.

If `todo_done` reports an item was already closed, say exactly that ("that one was
already done" / "那条之前就标掉了") — that's a real read, not a recollection.

## The rule that matters

**Nothing enters or leaves this list unless the user says so.**

Summarising what's outstanding is free and expected. *Adding* is a separate,
explicit instruction — "add this", "记一下", "加进去". Never add an item because
it looked important, because Canvas surfaced it, or because a sync ran. Same for
done / edit / delete: they happen when told, not when inferred.

If something looks worth tracking, say so in one line and stop:

> 3 things on Canvas aren't on your list yet — want me to add them?

## The three moves

### 1. "What's left" / 「还有什么没做」 — summarise

- `todo_list()` — open items, soonest first. `todo_list(all=True)` includes done
  ones; `course="<CODE>"` narrows.
- `todo_candidates()` — Canvas items **not yet** on the list (next 21 days by
  default; `days=` to widen).

Show the tracked list first — that's the answer to the question. Then, if
`todo_candidates` returned anything, mention it briefly as *available to add*, not
as part of the list. Keep them visually separate; conflating "what I'm tracking"
with "what exists on Canvas" is the main way this gets confusing.

Flag overdue items first. If the list is empty, say so in one line — don't pad.

### 2. "Add this" / 「记一下这个」 — add

`todo_add(text="...", due="2026-08-20 23:59", course="<CODE>", note="...", source="canvas:12345")`
— everything but `text` is optional.

- `due` takes `YYYY-MM-DD` (defaults to 23:59) or `YYYY-MM-DD HH:MM`.
- When adding something that came from `todo_candidates`, pass its `source`
  through. That's what stops it reappearing as an untracked candidate next time.
- Write the text as the user said it. Don't formalise their wording.
- Put the real instruction (what to do, where, by when) in `note` rather than
  cramming it into the text. Lists clip notes; the full note is kept.
- If a due date is genuinely unclear, add it undated rather than guessing —
  a wrong deadline is worse than none.

### 3. "That's done" / 「这个做完了」 — close, change, remove

- `todo_done(positions=[2, 3])` — positions, as shown by `todo_list`.
- `todo_undone(positions=["x1"])` — reopen, if they closed it wrongly. Call
  `todo_list(all=True)` first: done items are numbered x1, x2 … there (most
  recently finished first), and those x-numbers are what `todo_undone` takes —
  not the open-list numbers.
- `todo_edit(position=2, due="2026-09-01", text="...", note="...")` — `due=""`
  clears the due date.
- `todo_delete(positions=[2])` — remove outright.
- A **done** item can be edited or deleted too: pass its x-number from
  `todo_list(all=True)`, e.g. `todo_edit(position="x2", ...)` or
  `todo_delete(positions=["x1"])`. A bare number always means the open list.

Positions are resolved against the open list **at the moment the tool runs**, and
all positions in one call are resolved before anything changes — so
`todo_done(positions=[1, 2])` closes the first two items you were shown, not item 1
and then whatever slid into position 2. Still: list first, act second. A number
quoted from earlier in the conversation may point somewhere else now.

Prefer done over delete — done items stay visible under `todo_list(all=True)` and
record when they were finished. Only delete when the user says delete/remove, or
when the item turned out to be wrong rather than completed.

## Resolving which item

The user will usually give a number. If they describe it instead ("the survey",
「那个 survey」), match against a fresh `todo_list` and **name what you matched**
before acting:

> Marked done: "<Course> Background Survey".

If two items plausibly match, ask which — don't guess. Closing the wrong todo is
silent and easy to miss.

After any change, end with the one-line current state (e.g. "4 open, next due
Thu") so what the user sees in chat matches the list.
