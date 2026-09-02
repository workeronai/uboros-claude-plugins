---
name: paused-publish
description: Create a Meta ads campaign, ad set, creative, and ad through the official ads MCP. Always leave every object PAUSED. Never activate.
---

# Paused Meta ad publish

Use the Meta Ads MCP server at `https://mcp.facebook.com/ads`.

Sequence, in order:

1. `ads_create_campaign`
2. `ads_create_ad_set`
3. `ads_create_creative`
4. `ads_create_ad`

Rules that do not bend:

- Every object is created **PAUSED**.
- Never call `ads_activate_entity`. The operator turns spend on in Ads Manager.
- Creatives take a public `image_url` Meta can fetch. Do not send a local file path.
- If the operator is not authenticated, tell them to Connect the Meta Ads connector (Claude Desktop) or run `/mcp` → Authenticate (Claude Code). Leave OAuth client id blank — Meta already enrolled Claude.

Ask for anything missing (ad account, page, destination URL, image URL) before creating.
