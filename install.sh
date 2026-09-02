#!/usr/bin/env bash
# Install the Uboros Meta Ads plugin for Claude Code, and open Desktop Connectors.
# Usage: curl -fsSL https://raw.githubusercontent.com/workeronai/uboros-claude-plugins/main/install.sh | bash
#
# Claude Desktop's claude_desktop_config.json only launches local stdio servers. Writing
# `type: "http"` into it is a no-op (or a silent strip). Meta enrolled Claude as the ads-MCP
# OAuth client, so Desktop must Add a custom connector. This script does not fake that.
set -euo pipefail

REPO='workeronai/uboros-claude-plugins'
MARKETPLACE='uboros'
PLUGIN='meta-ads'
MCP_URL='https://mcp.facebook.com/ads'
CONNECTORS_URL='https://claude.ai/settings/connectors'
CONNECTOR_NAME='Meta Ads'

copy_url() {
  if command -v pbcopy >/dev/null 2>&1; then
    printf '%s' "${MCP_URL}" | pbcopy
    echo "Copied ${MCP_URL} to the clipboard."
    return 0
  fi
  if command -v xclip >/dev/null 2>&1; then
    printf '%s' "${MCP_URL}" | xclip -selection clipboard
    echo "Copied ${MCP_URL} to the clipboard."
    return 0
  fi
  if command -v clip.exe >/dev/null 2>&1; then
    printf '%s' "${MCP_URL}" | clip.exe
    echo "Copied ${MCP_URL} to the clipboard."
    return 0
  fi
  return 1
}

open_connectors() {
  if command -v open >/dev/null 2>&1; then
    open "${CONNECTORS_URL}"
    return 0
  fi
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "${CONNECTORS_URL}" >/dev/null 2>&1 || true
    return 0
  fi
  return 1
}

install_claude_code_plugin() {
  if ! command -v claude >/dev/null 2>&1; then
    echo "Claude Code CLI not on PATH — skip plugin install. Desktop still uses Add custom connector."
    return 0
  fi
  echo "Adding marketplace ${REPO}…"
  claude plugin marketplace add --scope user "${REPO}"
  echo "Installing ${PLUGIN}@${MARKETPLACE}…"
  claude plugin install --scope user -y "${PLUGIN}@${MARKETPLACE}"
}

echo "Uboros Meta Ads plugin"
install_claude_code_plugin
copy_url || true
open_connectors || true
echo
echo "Next:"
echo "  Claude Desktop: Settings → Connectors → Add custom connector"
echo "    Name: ${CONNECTOR_NAME}"
echo "    URL:  ${MCP_URL}"
echo "    Leave OAuth client id blank. Quit and reopen Desktop if it was already running."
echo "  Claude Code: /mcp → Authenticate if the server is not yet signed in."
echo "Campaigns this plugin creates stay paused until you activate them in Ads Manager."
