#!/usr/bin/env bash
# Install the Uboros Meta Ads plugin: Claude Code marketplace + Claude Desktop config.
# Usage: curl -fsSL https://raw.githubusercontent.com/workeronai/uboros-claude-plugins/main/install.sh | bash
set -euo pipefail

REPO='workeronai/uboros-claude-plugins'
MARKETPLACE='uboros'
PLUGIN='meta-ads'
MCP_URL='https://mcp.facebook.com/ads'

desktop_config_path() {
  case "$(uname -s)" in
    Darwin) printf '%s\n' "${HOME}/Library/Application Support/Claude/claude_desktop_config.json" ;;
    Linux) printf '%s\n' "${HOME}/.config/Claude/claude_desktop_config.json" ;;
    MINGW* | MSYS* | CYGWIN*) printf '%s\n' "${APPDATA:-}/Claude/claude_desktop_config.json" ;;
    *) printf '%s\n' "${HOME}/Library/Application Support/Claude/claude_desktop_config.json" ;;
  esac
}

merge_desktop_config() {
  local path="$1"
  if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 not found — skip Claude Desktop config. Add a custom connector at ${MCP_URL}."
    return 0
  fi
  mkdir -p "$(dirname "$path")"
  python3 - "$path" "$MCP_URL" <<'PY'
import json, os, sys, tempfile

path, url = sys.argv[1], sys.argv[2]
data = {}
if os.path.isfile(path):
    with open(path, encoding="utf-8") as handle:
        raw = handle.read().strip()
        if raw:
            data = json.loads(raw)
if not isinstance(data, dict):
    raise SystemExit(f"{path} is not a JSON object")

servers = data.setdefault("mcpServers", {})
if not isinstance(servers, dict):
    raise SystemExit("mcpServers must be an object")
servers["meta-ads"] = {"type": "http", "url": url}

directory = os.path.dirname(path) or "."
fd, tmp = tempfile.mkstemp(prefix="claude-desktop-", suffix=".json", dir=directory)
try:
    with os.fdopen(fd, "w", encoding="utf-8") as handle:
        json.dump(data, handle, indent=2)
        handle.write("\n")
    os.replace(tmp, path)
except Exception:
    os.unlink(tmp)
    raise
print(f"Wrote Meta Ads connector into {path}")
PY
}

install_claude_code_plugin() {
  if ! command -v claude >/dev/null 2>&1; then
    echo "Claude Code CLI not on PATH — skip plugin install. Desktop config is enough for Claude Desktop."
    return 0
  fi
  echo "Adding marketplace ${REPO}…"
  claude plugin marketplace add --scope user "${REPO}"
  echo "Installing ${PLUGIN}@${MARKETPLACE}…"
  claude plugin install --scope user -y "${PLUGIN}@${MARKETPLACE}"
}

echo "Uboros Meta Ads plugin"
merge_desktop_config "$(desktop_config_path)"
install_claude_code_plugin
echo
echo "Next:"
echo "  1. Quit and reopen Claude Desktop (config loads at startup)."
echo "  2. Connect Meta Ads / Authenticate. Leave OAuth client id blank."
echo "  3. Claude Code: /mcp → Authenticate if the server is not yet signed in."
echo "Campaigns this plugin creates stay paused until you activate them in Ads Manager."
