#!/bin/bash
# Canvas Companion for Codex / the ChatGPT desktop app — installer.
#
# Paste once into Terminal (no sudo):
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/SamsonChew/canvas-companion-market/main/codex/install.sh)"
#
# What it does (safe to run again — that is also how you update):
#   1. copies the plugin (the same compiled server Claude Code uses, plus the
#      skills) to ~/.canvas-companion/codex/current/
#   2. asks for your Canvas address and workspace folder (kept in
#      ~/.canvas-companion/codex/settings), and your Canvas token and licence
#      key, which go into the macOS Keychain — typed at a hidden prompt, never
#      shown, never written to a file
#   3. adds [mcp_servers.canvas-companion] to ~/.codex/config.toml (backed up
#      first; everything else in it is kept). Codex, the ChatGPT desktop app and
#      the IDE extension all read this file
#   4. copies the skills to ~/.agents/skills/canvas-companion-<name>/
#   5. prints this Mac's device id and, if no licence key is stored yet, opens
#      the licence application page with the device id filled in
#
# Later:
#   ~/.canvas-companion/codex/install.sh --set-license   new / renewed licence key
#   ~/.canvas-companion/codex/install.sh --set-token     new Canvas token
#   ~/.canvas-companion/codex/install.sh --set-domain [canvas.example.edu]
#                                                        change the Canvas address
#   ~/.canvas-companion/codex/install.sh --domain canvas.example.edu --workspace ~/Canvas
#   ~/.canvas-companion/codex/install.sh --device-id     show the device id, open the application page
#   ~/.canvas-companion/codex/uninstall.sh               remove everything but your files
#
# Options: --from DIR (install from a local copy of the plugin instead of
# downloading), --repo OWNER/NAME, --ref BRANCH, --domain D, --workspace DIR,
# --set-license, --set-token, --set-domain [D], --device-id, -h.
#
# The course folder may not be your home folder, / or any folder above your
# home: the assistant reads files in it, and home holds .ssh, .codex and other
# credentials.
set -euo pipefail

REPO="SamsonChew/canvas-companion-market"
REF="main"
ACCOUNT="canvas-companion"
SVC_TOKEN="canvas-companion.canvas-token"
SVC_LICENSE="canvas-companion.license"
CC_HOME="$HOME/.canvas-companion/codex"
CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
CONFIG="$CODEX_DIR/config.toml"
SKILLS_DIR="$HOME/.agents/skills"
BEGIN_MARK="# >>> canvas-companion (managed by ~/.canvas-companion/codex/install.sh) >>>"
END_MARK="# <<< canvas-companion <<<"
DEFAULT_WS="$HOME/课程"   # the folder the guide has students create (step 0.4)
# The student site (licence applications), filled in by the marketplace build
# (render_install.py --platform-url). Unrendered (a dev checkout) = no page to open.
PLATFORM_URL="https://canvas-companion.samsonchew.workers.dev"
PATH="${PATH:+$PATH:}/usr/bin:/bin:/usr/sbin:/sbin"

FROM=""
DOMAIN_ARG=""
WS_ARG=""
ONLY=""

say()  { printf '%s\n' "$*"; }
step() { printf '\n== %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --from) FROM="${2:?--from needs a folder}"; shift ;;
    --repo) REPO="${2:?}"; shift ;;
    --ref) REF="${2:?}"; shift ;;
    --domain) DOMAIN_ARG="${2:?--domain needs a value}"; shift ;;
    --workspace) WS_ARG="${2:?--workspace needs a folder}"; shift ;;
    --set-license) ONLY="license" ;;
    --set-token) ONLY="token" ;;
    --set-domain)
      ONLY="domain"
      if [[ $# -gt 1 && "$2" != -* ]]; then DOMAIN_ARG="$2"; shift; fi ;;
    --device-id) ONLY="device" ;;
    -h|--help) sed -n 2,40p "$0" 2>/dev/null || true; exit 0 ;;
    *) die "unknown option: $1 (try --help)" ;;
  esac
  shift
done

[[ "$(uname -s)" == Darwin ]] || die "Canvas Companion runs on macOS only."
[[ "$(id -u)" != 0 ]] || die "do not run this with sudo — run it as yourself."
command -v security >/dev/null || die "the macOS 'security' tool is missing."

# ------------------------------------------------------------ Keychain
kc_has() { security find-generic-password -a "$ACCOUNT" -s "$1" >/dev/null 2>&1; }

kc_prompt() {  # service, label, explanation
  say ""
  say "$3"
  say "(输入时屏幕上不会显示任何字符，这是正常的 / nothing appears as you type — that is normal)"
  # -w as the LAST option makes `security` prompt for the value itself: it is
  # never in argv, never echoed, never in a file. -U updates an existing item.
  local tries=0
  until security add-generic-password -U -a "$ACCOUNT" -s "$1" -l "$2" -w; do
    tries=$((tries + 1))
    [[ $tries -lt 3 ]] || die "could not save $2 in the Keychain."
    say "两次输入不一致，请重新输入 / the two entries did not match, try again"
  done
  say "✓ $2 已存入钥匙串 / saved in the Keychain"
}

ask_token() {
  kc_prompt "$SVC_TOKEN" "Canvas Companion — Canvas token" \
    "粘贴你的 Canvas 访问令牌（Canvas → 账户 → 设置 → + 新建访问许可证），回车，再粘贴一次。
Paste your Canvas access token (Canvas → Account → Settings → + New Access Token), press Return, then paste it again."
}
ask_license() {
  kc_prompt "$SVC_LICENSE" "Canvas Companion — licence key" \
    "粘贴作者发给你的授权码（CC1-…），回车，再粘贴一次。还没有授权码就直接按两次回车，之后
  双击「Canvas Companion 安装与设置」选 2 补上（或在终端运行 ~/.canvas-companion/codex/install.sh --set-license）。
Paste your licence key (CC1-…), press Return, then paste it again. No key yet? Press Return twice and add it
later: double-click \"Canvas Companion 安装与设置\" and choose 2 (or run the command above in Terminal)."
}

# Canvas address: bare host, lower case; dies on anything else.
clean_domain() {
  local d="$1"
  d="${d#http://}"; d="${d#https://}"; d="${d#HTTP://}"; d="${d#HTTPS://}"; d="${d%%/*}"
  d="$(printf '%s' "$d" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
  [[ "$d" =~ ^[a-z0-9.-]+\.[a-z]{2,}$ ]] || die "'$d' does not look like a Canvas address (e.g. canvas.yourschool.edu). Run the installer again."
  printf '%s' "$d"
}
ask_domain() {
  say "你学校 Canvas 的网址（不要 https://），例如 canvas.yourschool.edu"
  read -r -p "Your university's Canvas address (e.g. canvas.yourschool.edu): " DOMAIN || true
}
write_settings() {  # domain, workspace
  umask 077
  printf 'CANVAS_DOMAIN=%s\nCOMPANION_HOME=%s\n' "$1" "$2" > "$CC_HOME/settings.tmp"
  mv "$CC_HOME/settings.tmp" "$CC_HOME/settings"
  umask 022
}

# One wording everywhere. The server reads the licence/token at launch, so a
# new chat alone is not enough — the app must be restarted. A bare 「授权状态」
# makes Codex answer about its own sandbox; the plugin name routes it to us.
REOPEN_ZH="退出 ChatGPT App（⌘ + Q）再打开，新开一个对话"
REOPEN_EN="quit the ChatGPT app (⌘ + Q), reopen it and start a new chat"
ASK_STATUS_ZH="Canvas Companion 授权状态"
ASK_STATUS_EN="Canvas Companion license status"

# ------------------------------------------------------------ device id
# The same value as companion.license.device_id(): SHA-256 of a fixed salt +
# this Mac's IOPlatformUUID (upper case), first 8 bytes big-endian, 12 Crockford
# base32 digits taken low bits first, as XXXX-XXXX-XXXX. UNKNOWN when ioreg has
# no UUID. Only 60 of the 64 bits are used, so the arithmetic stays positive.
# tests/test_codex.py checks it against license.device_id() for fixed UUIDs.
device_id() {
  local A="0123456789ABCDEFGHJKMNPQRSTVWXYZ" uuid hex hi lo n i s=""
  uuid="$(ioreg -rd1 -c IOPlatformExpertDevice 2>/dev/null \
    | sed -nE 's/.*"IOPlatformUUID"[[:space:]]*=[[:space:]]*"([0-9A-Fa-f-]{16,})".*/\1/p' \
    | head -1 | tr '[:lower:]' '[:upper:]')" || true
  if [[ -z "$uuid" ]]; then printf 'UNKNOWN'; return 0; fi
  hex="$(printf '%s%s' "canvas-companion/device-id/v1" "$uuid" | shasum -a 256 | cut -c1-16)"
  [[ "$hex" =~ ^[0-9a-f]{16}$ ]] || { printf 'UNKNOWN'; return 0; }
  hi=$((16#${hex:0:8})); lo=$((16#${hex:8:8}))
  n=$(( ((hi & 0xFFFFFFF) << 32) | lo ))
  for (( i = 0; i < 12; i++ )); do s+="${A:$((n & 31)):1}"; n=$((n >> 5)); done
  printf '%s-%s-%s' "${s:0:4}" "${s:4:4}" "${s:8:4}"
}

# A real key is stored (not the empty one "press Return twice" leaves). The
# value goes straight into wc: never into a variable, argv or the screen.
has_license() {
  local n
  n="$(security find-generic-password -a "$ACCOUNT" -s "$SVC_LICENSE" -w 2>/dev/null | tr -d '[:space:]' | wc -c)" || n=0
  [[ "${n//[[:space:]]/}" -ge 20 ]]
}

# Print the device id; with `open`, also open the application page with it
# filled in (/apply/?device=…).
show_device() {  # open|print
  local dev url
  dev="$(device_id)"
  say ""
  if [[ "$dev" == UNKNOWN ]]; then
    say "读不到这台 Mac 的设备编号（ioreg 没有返回 IOPlatformUUID）。把这个窗口截图发给作者。"
    say "Could not read this Mac's device id (no IOPlatformUUID from ioreg). Send a screenshot of this window to the author."
    return 0
  fi
  say "这台 Mac 的设备编号 / device id: $dev"
  [[ "$PLATFORM_URL" == https://* ]] || return 0
  url="$PLATFORM_URL/apply/?device=$dev"
  say "申请授权码 / apply for a licence key: $url"
  if [[ "$1" == open ]]; then
    if open "$url" >/dev/null 2>&1; then
      say "已在浏览器里打开申请页，设备编号已经填好 / opened in your browser with the device id filled in."
    else
      say "浏览器没有自动打开：把上面的链接复制到浏览器里 / copy the link above into your browser."
    fi
  fi
}

if [[ "$ONLY" == device ]]; then show_device open; exit 0; fi
if [[ "$ONLY" == domain ]]; then
  [[ -f "$CC_HOME/settings" ]] || die "Canvas Companion is not installed yet — run the installer first."
  DOMAIN="$DOMAIN_ARG"
  [[ -n "$DOMAIN" ]] || ask_domain
  DOMAIN="$(clean_domain "$DOMAIN")" || exit 1
  WS="$(sed -n 's/^COMPANION_HOME=//p' "$CC_HOME/settings" | head -1)"
  write_settings "$DOMAIN" "$WS"
  say "✓ Canvas: $DOMAIN"
  say "${REOPEN_ZH}即可生效 / ${REOPEN_EN} to use it."
  exit 0
fi
if [[ "$ONLY" == license ]]; then ask_license; say "${REOPEN_ZH}即可生效 / ${REOPEN_EN} to use it."; exit 0; fi
if [[ "$ONLY" == token ]]; then ask_token; say "${REOPEN_ZH}即可生效 / ${REOPEN_EN} to use it."; exit 0; fi

[[ "$(uname -m)" == arm64 ]] || die "this build is for Apple silicon Macs (M1 or newer) only."

# ------------------------------------------------------------ 1. plugin files
step "1/4 安装程序文件 / installing the program"
HERE=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
fi
is_tree() { [[ -x "$1/server/companion" && -f "$1/codex/launch" && -d "$1/skills" ]]; }

TMP="$(mktemp -d "${TMPDIR:-/tmp}/canvas-companion.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT
SRC=""
if [[ -n "$FROM" ]]; then
  SRC="$(cd "$FROM" && pwd -P)"
  is_tree "$SRC" || die "$FROM is not a Canvas Companion plugin folder (needs server/companion, codex/launch, skills/)."
elif [[ -n "$HERE" ]] && is_tree "$(dirname "$HERE")" && [[ "$(dirname "$HERE")" != "$CC_HOME/current" ]]; then
  SRC="$(dirname "$HERE")"                              # plugins/canvas-companion/codex/install.sh
elif [[ -n "$HERE" ]] && is_tree "$(dirname "$HERE")/plugins/canvas-companion"; then
  SRC="$(dirname "$HERE")/plugins/canvas-companion"    # <marketplace checkout>/codex/install.sh
else
  [[ "$REPO" != *"{{"* && "$REPO" == */* ]] || die "no plugin to install from: pass --from DIR or --repo OWNER/NAME."
  say "下载 / downloading $REPO ($REF) …"
  curl -fL --progress-bar "https://codeload.github.com/$REPO/tar.gz/refs/heads/$REF" -o "$TMP/src.tgz" \
    || die "download failed — check your internet connection and try again."
  mkdir -p "$TMP/src"
  tar -xzf "$TMP/src.tgz" -C "$TMP/src"
  SRC="$(find "$TMP/src" -mindepth 3 -maxdepth 3 -type d -path '*/plugins/canvas-companion' | head -1)"
  if [[ -z "$SRC" ]] || ! is_tree "$SRC"; then die "the download does not contain plugins/canvas-companion."; fi
fi

mkdir -p "$CC_HOME"
STAGE="$CC_HOME/.staging.$$"
rm -rf "$STAGE"
mkdir -p "$STAGE"
for part in server skills codex .codex-plugin; do
  [[ -e "$SRC/$part" ]] && cp -R "$SRC/$part" "$STAGE/"
done
cp "$SRC/.claude-plugin/plugin.json" "$STAGE/VERSION.json" 2>/dev/null || true
chmod +x "$STAGE/server/companion" "$STAGE/codex/launch" "$STAGE/codex/"*.sh
if [[ -d "$CC_HOME/current" ]]; then
  rm -rf "$CC_HOME/previous"
  mv "$CC_HOME/current" "$CC_HOME/previous"
fi
mv "$STAGE" "$CC_HOME/current"
rm -rf "$CC_HOME/previous"
# Stable paths for the commands in the guide.
cp "$CC_HOME/current/codex/install.sh" "$CC_HOME/install.sh"
cp "$CC_HOME/current/codex/uninstall.sh" "$CC_HOME/uninstall.sh"
chmod +x "$CC_HOME/install.sh" "$CC_HOME/uninstall.sh"
LAUNCH="$CC_HOME/current/codex/launch"
VERSION="$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$CC_HOME/current/VERSION.json" 2>/dev/null | head -1)"
say "✓ Canvas Companion ${VERSION:-?} → $CC_HOME/current"

# ------------------------------------------------------------ 2. settings + secrets
step "2/4 设置 / settings"
DOMAIN=""; WS=""
if [[ -f "$CC_HOME/settings" ]]; then
  DOMAIN="$(sed -n 's/^CANVAS_DOMAIN=//p' "$CC_HOME/settings" | head -1)"
  WS="$(sed -n 's/^COMPANION_HOME=//p' "$CC_HOME/settings" | head -1)"
fi
[[ -n "$DOMAIN_ARG" ]] && DOMAIN="$DOMAIN_ARG"
[[ -n "$WS_ARG" ]] && WS="$WS_ARG"
[[ -n "$DOMAIN" ]] || ask_domain
DOMAIN="$(clean_domain "$DOMAIN")" || exit 1
if [[ -z "$WS" ]]; then
  say "课程文件放在哪个文件夹？直接回车用 $DEFAULT_WS"
  read -r -p "Folder for your course files [$DEFAULT_WS]: " WS || true
  WS="${WS:-$DEFAULT_WS}"
fi
WS="${WS/#\~/$HOME}"
[[ "$WS" == /* ]] || WS="$PWD/$WS"
[[ "$WS" != *$'\n'* ]] || die "the folder name cannot contain a line break."
# Not $HOME, not /, nor anything above $HOME (symlinks resolved): the assistant
# reads the course folder, and home holds .ssh, .codex/auth.json, .env …
mkdir -p "$WS"
WS_REAL="$(cd "$WS" && pwd -P)"
HOME_REAL="$(cd "$HOME" && pwd -P)"
if [[ "$WS_REAL" == / || "$HOME_REAL/" == "$WS_REAL"/* ]]; then
  die "不能把 ${WS} 当作课程文件夹：它是你的用户文件夹（或根目录 /、或在用户文件夹之上），里面有 .ssh、.codex 等存放凭据的隐藏文件夹。请用一个专门的文件夹，例如 ${DEFAULT_WS}：
  install.sh --workspace ${DEFAULT_WS}
${WS} cannot be your course folder: it is your home folder (or /, or above your home), which holds hidden credential folders such as .ssh and .codex. Use a dedicated folder such as ${DEFAULT_WS} (--workspace DIR)."
fi
write_settings "$DOMAIN" "$WS"
say "✓ Canvas: $DOMAIN    课程文件夹 / workspace: $WS"

if kc_has "$SVC_TOKEN"; then say "✓ Canvas token 已在钥匙串中，保留 / already in the Keychain, kept (更换 / change: 双击菜单 3 or --set-token)"; else ask_token; fi
if kc_has "$SVC_LICENSE"; then say "✓ 授权码已在钥匙串中，保留 / licence already in the Keychain, kept (更换 / change: 双击菜单 2 or --set-license)"; else ask_license; fi

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

# ------------------------------------------------------------ 3. ~/.codex/config.toml
step "3/4 Codex 配置 / Codex config"
toml_str() { local s="${1//\\/\\\\}"; s="${s//\"/\\\"}"; printf '"%s"' "$s"; }
mkdir -p "$CODEX_DIR"
BLOCK_IN="$CC_HOME/current/codex/config.toml.in"
[[ -f "$BLOCK_IN" ]] || die "missing $BLOCK_IN — the download is incomplete."
NEW="$CONFIG.canvas-companion.tmp"
if [[ -f "$CONFIG" ]]; then
  BACKUP="$CONFIG.bak-canvas-companion-$(date +%Y%m%d-%H%M%S)"
  cp -p "$CONFIG" "$BACKUP"
  prune_backups
  say "备份 / backup: $BACKUP"
  # Drop our previous block and any hand-made canvas-companion entry (any
  # TOML form); keep every other line as it is.
  strip_ours "$CONFIG" > "$NEW"
  # no trailing blank-line pile-up across re-runs
  sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$NEW" > "$NEW.2" && mv "$NEW.2" "$NEW"
else
  : > "$NEW"
fi
if [[ -s "$NEW" ]]; then printf '\n' >> "$NEW"; fi
{
  printf '%s\n' "$BEGIN_MARK"
  sed "s|@LAUNCH@|$(toml_str "$LAUNCH" | sed 's/[|&\\]/\\&/g')|" "$BLOCK_IN"
  printf '%s\n' "$END_MARK"
} >> "$NEW"
[[ -f "$CONFIG" ]] && chmod "$(stat -f %Lp "$CONFIG")" "$NEW"
mv "$NEW" "$CONFIG"
say "✓ $CONFIG: [mcp_servers.canvas-companion] → $LAUNCH"

# ------------------------------------------------------------ 4. skills
step "4/4 技能 / skills"
mkdir -p "$SKILLS_DIR"
for old in "$SKILLS_DIR"/canvas-companion-*; do
  [[ -d "$old" ]] || continue
  [[ -d "$CC_HOME/current/skills/${old##*/canvas-companion-}" ]] || rm -rf "$old"
done
n=0
for s in "$CC_HOME/current/skills"/*/; do
  s="${s%/}"; name="${s##*/}"
  [[ -f "$s/SKILL.md" ]] || continue
  rm -rf "$SKILLS_DIR/canvas-companion-$name"
  cp -R "$s" "$SKILLS_DIR/canvas-companion-$name"
  # Agent Skills: `name` must match the folder, so the prefixed folder gets a
  # prefixed name (invoked as $canvas-companion-<name>). Only the frontmatter
  # line is touched.
  f="$SKILLS_DIR/canvas-companion-$name/SKILL.md"
  /usr/bin/awk -v n="canvas-companion-$name" '
    NR == 1 && /^---[[:space:]]*$/ { fm = 1; print; next }
    fm && /^---[[:space:]]*$/      { fm = 0; print; next }
    fm && /^name:/                 { print "name: " n; next }
    { print }' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  n=$((n + 1))
done
say "✓ $n 个技能 / skills → $SKILLS_DIR/canvas-companion-*"

say ""
say "完成！${REOPEN_ZH}，问「${ASK_STATUS_ZH}」。"
say "Done. Now ${REOPEN_EN}, and ask \"${ASK_STATUS_EN}\"."
say "课程文件夹 / your course folder: $WS"

# ------------------------------------------------------------ 5. licence application
# No key yet (the first install): open the application page, device id filled
# in, so the student need not ask ChatGPT for it. With a key, just print the id.
if has_license; then
  show_device print
else
  show_device open
  say "提交申请后，按页面提示收藏私人链接；批准后双击安装文件选 2 填入授权码。"
  say "After you apply, bookmark the private link; once approved, double-click the installer and choose 2."
fi
