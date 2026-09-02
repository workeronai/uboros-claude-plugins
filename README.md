# Uboros Claude plugins

Plug-and-play marketplace for [Meta’s official ads MCP](https://mcp.facebook.com/ads).

Uboros does **not** create a Meta developer app. Claude is already enrolled as the OAuth client. You sign in as yourself. Campaigns land **paused**.

## 1. One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/workeronai/uboros-claude-plugins/main/install.sh | bash
```

That installs the Claude Code plugin if `claude` is on PATH, copies `https://mcp.facebook.com/ads`, and opens [Claude Connectors](https://claude.ai/settings/connectors).

Claude Desktop does **not** read a remote HTTP MCP from `claude_desktop_config.json` — that file only launches local stdio servers. Add a custom connector:

- Name: `Meta Ads`
- URL: `https://mcp.facebook.com/ads`
- Leave OAuth client id blank

Quit and reopen Claude Desktop, then Connect **Meta Ads**.

## 2. Local zip

1. Download [the marketplace zip](https://github.com/workeronai/uboros-claude-plugins/archive/refs/heads/main.zip) and unzip.
2. In Claude Code, from the unzipped folder:

```
/plugin marketplace add ./uboros-claude-plugins-main
/plugin install meta-ads@uboros
```

Or from a terminal in that folder:

```bash
claude plugin marketplace add --scope user .
claude plugin install --scope user -y meta-ads@uboros
```

## 3. From git (marketplace)

Inside Claude Code:

```
/plugin marketplace add workeronai/uboros-claude-plugins
/plugin install meta-ads@uboros
```

From a terminal:

```bash
claude plugin marketplace add --scope user workeronai/uboros-claude-plugins
claude plugin install --scope user -y meta-ads@uboros
```

## Phone

Connect once on a computer (one-liner or Claude Desktop → Settings → Connectors → Add custom connector, URL `https://mcp.facebook.com/ads`). Open the Claude app on your phone with the same account. Turn **Meta Ads** on for the chat.

## What the plugin ships

- Remote MCP server `https://mcp.facebook.com/ads` (HTTP)
- Skill `paused-publish`: campaign → ad set → creative → ad, all paused

## Layout

```
.claude-plugin/marketplace.json
plugins/meta-ads/.claude-plugin/plugin.json
plugins/meta-ads/.mcp.json
plugins/meta-ads/skills/paused-publish/SKILL.md
install.sh
```
