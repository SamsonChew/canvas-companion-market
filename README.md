# Canvas Companion — plugin marketplace

Compiled build 0.3.5 for Apple silicon Macs (M1 or newer), macOS 15 or later.
A license key is required: request or renew one at https://canvas-companion.samsonchew.workers.dev

In Terminal:

    claude plugin marketplace add SamsonChew/canvas-companion-market
    claude plugin install canvas-companion@canvas-companion-market

Codex / ChatGPT desktop app: download codex/CanvasCompanion-ChatGPT-安装.zip, open it and
double-click "Canvas Companion 安装与设置.command" (install, update, change the licence
key / Canvas token / address, uninstall). Or paste once into Terminal (run it again to update):

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/SamsonChew/canvas-companion-market/main/codex/install.sh)"

Full guide (中文): INSTALL.zh.md (Claude), INSTALL-chatgpt.zh.md (ChatGPT / Codex). Terms: TERMS.zh.md. Privacy: PRIVACY.zh.md. Licence: LICENSE.

This repository must stay public and keep this name: the plugin checks
revocations.json once a day (the platform first, this repository's copy as the
fallback), and stops working 14 days after it last could. The copy here is kept
current by .github/workflows/sync-revocations.yml (hourly, verified signature,
seq only goes up) — leave GitHub Actions enabled for this repository.
