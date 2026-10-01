---
name: setup
description: Connect Canvas from the chat, or renew the Canvas access token — find the school's Canvas address by name, open the page where the student makes a token, then read the copied token from the clipboard, check it and save it. Use when the user says "set up Canvas", "connect my Canvas", "my token expired", "Canvas rejected my token", "设置 Canvas", "连接 Canvas", "令牌过期了", "换 Canvas 令牌", or when a tool reports that no Canvas token is set or that Canvas rejected it.
---

# Set up Canvas

The student never pastes the token into the chat. They copy it in their
browser; `setup_canvas_token` reads it from the clipboard, checks it with their
school's Canvas and saves it on this computer. You never see it, and you must
not ask for it, print it, or try to read it any other way.

## 1. Find the school

Ask for the school's name if you don't have it, then call
`setup_canvas(school_name="<name>")`. Full names match better than
abbreviations ("National University of Singapore", not "NUS").

- One match: confirm it with the user ("Is this your school: <name>,
  <domain>?").
- Several: list them (name and domain) and ask which one; then call
  `setup_canvas(domain="<chosen domain>")`.
- None: ask for another spelling, or for the Canvas address in their browser's
  address bar after logging in, and call `setup_canvas(domain="<address>")`.
  If that address is refused as not in the directory, pass on the error's own
  instructions; don't try other ways around it.

If the directory can't be reached, the error asks for the address instead; do
the same.

## 2. Make the token

Show `steps_zh` or `steps_en` (the user's language) with the `token_page`
link. Say plainly: the token appears once, copy it, don't send it here.

## 3. Save it

When the user says they copied it, call `setup_canvas_token(domain="<domain>")`.

- Success: tell them who Canvas says they are (`canvas_user`) and when the
  token expires (`token_expires_at`, `token_days_left`); suggest a phone
  reminder a few days before. It works right away, no restart. The token is
  still on their clipboard; they may copy something else over it.
- "The clipboard does not hold a Canvas token": they copied something else, or
  only part of it. Ask them to copy it again (or generate a new one) and retry.
- "did not accept this token": made on another school's Canvas, revoked, or
  incomplete. Back to step 2.
- Could not be saved: pass on the error's alternative (the plugin's settings).

## 4. Then

If courses aren't set up yet (`list_courses` shows no folders), offer
`setup_courses` next. Don't run it unasked.

> **Host note** — Codex / ChatGPT desktop app: the saved token is also the one
> the app reads on its next start; nothing else to change. Claude Code: a token
> saved here takes priority over an old one in the plugin's settings until the
> user changes that setting again.
