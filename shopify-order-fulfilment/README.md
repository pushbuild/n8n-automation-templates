# Shopify paid order to warehouse pick list

When a Shopify order is paid, this workflow checks Shopify's signature, builds a pick list from the lines that need shipping, emails it to your warehouse or 3PL once per order, and posts to Slack. Skipped orders and failures are posted to Slack too.

Background: [Shopify automation](https://pushbuild.com/guides/shopify-automation.html) on pushbuild.com.

## What it does

1. **Receive and verify**: the webhook (or the built-in sample order) is checked against Shopify's HMAC signature; anything unsigned goes to the alert.
1. **Map**: **Config** sets the SKU field, the text for lines with no SKU, whether line properties (gift wrap, engraving) are included, and how shipping methods are renamed for the warehouse.
1. **Dedupe**: order ids already sent are remembered, so a webhook Shopify delivers twice never sends a second pick list.
1. **Filter**: orders with a skip tag (for example `wholesale`) or nothing to ship are skipped, and Slack says why.
1. **Send with retries**: the email retries 3 times. The order is only marked sent after it succeeds, so a re-run sends anything that failed.

## What you need

- An n8n instance with `NODE_FUNCTION_ALLOW_BUILTIN=crypto`
- Shopify store admin, an SMTP account and a Slack incoming webhook URL

## Setup

1. Set `NODE_FUNCTION_ALLOW_BUILTIN=crypto` on n8n and restart it.
2. Import `workflow.json` and fill in **Config**: the webhook signing secret, addresses, Slack URL and mapping options.
3. Add your SMTP credential to **Email pick list**.
4. Click **Test workflow** to run the sample order.
5. In Shopify admin, go to **Settings → Notifications → Webhooks**, create an **Order payment** (JSON) webhook pointing at the production URL of **Order paid (Shopify)**, and activate the workflow.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` or `REPLACE_WITH_...` must be set before you activate the workflow.
- Sent order ids are kept in the workflow's static data, which n8n saves on production (active) runs only.
