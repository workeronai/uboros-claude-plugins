# Uboros Claude plugins

Two plugins. Both land campaigns **paused**.

| Plugin | Connects | Use it when |
| --- | --- | --- |
| **`uboros`** | Uboros **and** [Meta ads MCP](https://mcp.facebook.com/ads) | You have an Uboros account. This is the one you want. |
| `meta-ads` | Meta ads MCP only | You want Meta's connector on its own. |

`uboros` is a superset of `meta-ads` — install one or the other, not both.

Uboros does **not** create a Meta developer app. Claude is already enrolled as the OAuth client. You sign in as yourself.

## `uboros` — the full loop

```
/plugin marketplace add workeronai/uboros-claude-plugins
/plugin install uboros@uboros
```

Claude signs you in itself: it opens an Uboros consent screen where you pick which brand the connection may read. **There is no token to paste anywhere.**

Earlier versions asked for one at install. The MCP server does OAuth now, so the plugin holds no credential and there is no field to fill in.

Then just ask: *"post my next approved creative."* The `publish-approved-creative` skill reads what Uboros has approved, builds the campaign from Uboros's own plan, creates it paused in Meta, and records it back so Uboros knows the campaign exists.

### What it ships

- MCP server `uboros` (HTTP, authenticated with your token)
- MCP server `meta-ads` — `https://mcp.facebook.com/ads`, Meta's own sign-in
- Skill `publish-approved-creative`

### Generated, not hand-written

`plugins/uboros/**` is emitted from [`workeronai/studio`](https://github.com/workeronai/studio) by `pnpm --filter @app/uboros plugin:emit`. Edit it there, not here — the MCP path and the publishing rules are defined alongside the server they point at, so a hand-edit here becomes a copy that drifts.

---

## `meta-ads` — Meta's connector alone

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

## What `meta-ads` ships

- Remote MCP server `https://mcp.facebook.com/ads` (HTTP)
- Skill `paused-publish`: campaign → ad set → creative → ad, all paused

## Layout

```
.claude-plugin/marketplace.json
plugins/meta-ads/.claude-plugin/plugin.json
plugins/meta-ads/.mcp.json
plugins/meta-ads/skills/paused-publish/SKILL.md
plugins/uboros/.claude-plugin/plugin.json          # generated — see above
plugins/uboros/.mcp.json                           # generated
plugins/uboros/skills/publish-approved-creative/SKILL.md   # generated
install.sh
```
