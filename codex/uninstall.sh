#!/bin/bash
# Canvas Companion for Codex / the ChatGPT desktop app — uninstaller.
#
#   ~/.canvas-companion/codex/uninstall.sh [--keep-secrets]
#
# Removes: the [mcp_servers.canvas-companion] entry from ~/.codex/config.toml
# (backed up first; everything else is kept), ~/.agents/skills/canvas-companion-*,
# ~/.canvas-companion/codex/, and — unless --keep-secrets — the Canvas token and
# licence key from the macOS Keychain.
# Never touches your course folder (materials, notes, todos stay where they are).
set -euo pipefail

ACCOUNT="canvas-companion"
CC_HOME="$HOME/.canvas-companion/codex"
CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
CONFIG="$CODEX_DIR/config.toml"
SKILLS_DIR="$HOME/.agents/skills"
BEGIN_MARK="# >>> canvas-companion (managed by ~/.canvas-companion/codex/install.sh) >>>"
END_MARK="# <<< canvas-companion <<<"
PATH="${PATH:+$PATH:}/usr/bin:/bin:/usr/sbin:/sbin"
KEEP=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --keep-secrets) KEEP=1 ;;
    -h|--help) sed -n 2,11p "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done
[[ "$(id -u)" != 0 ]] || { echo "do not run this with sudo" >&2; exit 1; }

# Copy config.toml without anything of ours: the managed block, any
# [mcp_servers.canvas-companion…] table, an inline `canvas-companion = {…}`
# under [mcp_servers], and dotted keys (`canvas-companion.command = …` under
# [mcp_servers], `mcp_servers.canvas-companion… = …` at the top level). A value
# whose brackets span lines is followed to its close. Identical in install.sh
# and uninstall.sh (a test checks).
strip_ours() {
  /usr/bin/awk -v b="$BEGIN_MARK" -v e="$END_MARK" -v q="'" '
    function norm(s) { gsub("[[:space:]\"" q "]", "", s); return s }
    function depth(s,   o, c) {
      gsub(/"([^"\\]|\\.)*"/, "", s); gsub(q "[^" q "]*" q, "", s); sub(/#.*/, "", s)
      o = gsub(/[[{]/, "", s); c = gsub(/[]}]/, "", s)
      return o - c
    }
    function ours(k) {
      if (table == "mcp_servers")
        return k == "canvas-companion" || index(k, "canvas-companion.") == 1
      if (table == "")
        return k == "mcp_servers.canvas-companion" || index(k, "mcp_servers.canvas-companion.") == 1
      return 0
    }
    $0 == b { inblock = 1; next }
    inblock { if ($0 == e) inblock = 0; next }
    cont > 0 { cont += depth($0); if (!drop && !skip) print; next }
    /^[[:space:]]*\[/ {
      h = $0; sub(/#.*/, "", h); table = norm(h)
      gsub(/^\[+|\]+$/, "", table)
      skip = (table == "mcp_servers.canvas-companion" || index(table, "mcp_servers.canvas-companion.") == 1)
      drop = 0
      if (!skip) print
      next
    }
    /^[[:space:]]*[^#[:space:]=][^=]*=/ {
      k = $0; sub(/=.*/, "", k); k = norm(k)
      v = $0; sub(/^[^=]*=/, "", v)
      drop = ours(k); cont = depth(v); if (cont < 0) cont = 0
      if (!drop && !skip) print
      next
    }
    !skip { print }
  ' "$1"
}
# Keep the 3 newest config.toml.bak-canvas-companion-* (names sort by time).
prune_backups() {
  local all=( "$CONFIG".bak-canvas-companion-* ) i
  [[ -e "${all[0]}" ]] || return 0
  for (( i = 0; i < ${#all[@]} - 3; i++ )); do rm -f "${all[i]}"; done
}

WS=""
[[ -f "$CC_HOME/settings" ]] && WS="$(sed -n 's/^COMPANION_HOME=//p' "$CC_HOME/settings" | head -1)"

if [[ -f "$CONFIG" ]]; then
  BACKUP="$CONFIG.bak-canvas-companion-$(date +%Y%m%d-%H%M%S)"
  cp -p "$CONFIG" "$BACKUP"
  prune_backups
  NEW="$CONFIG.canvas-companion.tmp"
  strip_ours "$CONFIG" > "$NEW"
  sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$NEW" > "$NEW.2" && mv "$NEW.2" "$NEW"
  chmod "$(stat -f %Lp "$CONFIG")" "$NEW"
  mv "$NEW" "$CONFIG"
  echo "✓ removed canvas-companion from $CONFIG (backup: $BACKUP)"
fi

for d in "$SKILLS_DIR"/canvas-companion-*; do
  [[ -d "$d" ]] && rm -rf "$d"
done
echo "✓ removed skills $SKILLS_DIR/canvas-companion-*"

if [[ $KEEP == 0 ]]; then
  for svc in canvas-companion.canvas-token canvas-companion.license; do
    security delete-generic-password -a "$ACCOUNT" -s "$svc" >/dev/null 2>&1 || true
  done
  echo "✓ removed the Canvas token and licence key from the Keychain"
else
  echo "  kept the Canvas token and licence key in the Keychain (--keep-secrets)"
fi

# Last: this script may itself live in $CC_HOME.
rm -rf "$CC_HOME"
rmdir "$HOME/.canvas-companion" 2>/dev/null || true
echo "✓ removed $CC_HOME"
[[ -n "$WS" ]] && echo "你的课程文件夹没有动 / your course folder was left as it is: $WS"
echo "重新打开 ChatGPT / Codex 后生效 / reopen ChatGPT / Codex to finish."
