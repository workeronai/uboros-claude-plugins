---
name: publish-approved-creative
description: Publish an approved Uboros creative to Meta Ads as a paused campaign, and record it back to Uboros. Use when asked to publish, post, launch or ship an ad, creative or campaign, or to see what Uboros has approved and ready.
---

# Publish an approved Uboros creative

You have two connectors: **uboros** holds the brief — the approved creative,
the copy, the brand's market and its daily cap — and **Meta Ads** holds the
ad account. Neither does this job alone, and Uboros cannot reach Meta on its own: that sign-in
is the operator’s, inside this session.

## The loop

  1. Call uboros's uboros_list_ready_creatives and show me what is approved.
  2. For the creative I pick (or the newest if I do not say), call uboros_get_publish_plan.
  3. Create the campaign, ad set, creative and ad in Meta Ads using exactly that plan:
     the same objective, budget, targeting and copy. Do not substitute your own.
  4. Call uboros_record_publish with the ids Meta gave you, so Uboros knows it exists.

Rules: every object must be created PAUSED. Never call activate. If the plan tool refuses,
tell me why instead of working around it. The refusal is deliberate.

## Why the plan is not a suggestion to improve on

`uboros_get_publish_plan` runs the forbidden-phrase check and the risk assessment before it
answers, so a refusal is a guard firing rather than a gap to route around. Report the refusal
and stop. Substituting your own objective, budget or targeting silently discards a decision a
human made about their own money.

The plan is advice in one direction only: the operator may ask for something different, and
then `uboros_record_publish` records what was actually created rather than what was planned.
Without that call Uboros never learns the campaign exists — nothing on the Publishing
screen, no deploy record — so it is the last step every time, even when the operator
deviated from the plan, and especially then.
