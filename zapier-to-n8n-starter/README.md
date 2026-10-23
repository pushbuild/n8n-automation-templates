# Zapier to n8n migration starter

A starting point for moving Zaps to n8n: a workflow laid out like a typical Zap (Catch Hook, Formatter, Filter, Action), an error alert workflow so failures reach you, and an inventory sheet for listing every Zap before you move any of them.

Background: [Zapier vs Make vs n8n](https://pushbuild.com/compare/zapier-vs-make-vs-n8n.html) on pushbuild.com.

## What it does

1. `zap-inventory.csv`: one row per Zap with its trigger, steps, apps, monthly runs, owner, and a keep, move or retire decision
1. `workflow.json`: Catch hook (Webhooks by Zapier) → Formatter (Code) → Filter (IF) → Action (HTTP Request)
1. `error-alert.json`: an Error Trigger workflow that posts any failure to Slack

## What you need

- An n8n instance
- Access to your Zapier account to list your Zaps
- A Slack incoming webhook URL for alerts

## Setup

1. Fill in `zap-inventory.csv` from your Zapier dashboard. Sort by runs per month; the busiest and most fragile Zaps are the ones worth moving first.
2. Import `error-alert.json`, set the Slack URL, and activate it.
3. Import `workflow.json`. In its settings, choose the error alert workflow as the **Error workflow**.
4. Rebuild one Zap: replace the Formatter code and Filter rule, and point the Action at the app's n8n node or API.
5. Run the Zap and the n8n workflow side by side for a few days, compare the results, then turn the Zap off.

## Make it yours

- Zapier step → n8n: Catch Hook → Webhook · Formatter → Code or Set · Filter → IF · Paths → Switch · Delay → Wait · Looping → Loop Over Items · Storage → a database or Data Table · Code by Zapier → Code.
- Keep simple Zaps where they are if they run fine; moving everything is rarely worth it.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` or `REPLACE_WITH_...` must be set before you activate the workflow.
- Test with sample data first. Check each step's output in n8n before you point real traffic at it.

## Want this set up for you?

Pushbuild can set this up for you, connected to your own tools and tested end to end: [pushbuild.com/?need=template-zapier-to-n8n-starter](https://pushbuild.com/?need=template-zapier-to-n8n-starter)
