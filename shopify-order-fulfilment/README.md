# Shopify paid order to fulfilment notice

When a Shopify order is paid, this workflow checks Shopify's signature, builds a pick list with SKUs, quantities, ship-to address and shipping method, emails it to your warehouse or 3PL, and posts a note to Slack.

Background: [Shopify automation](https://pushbuild.com/guides/shopify-automation.html) on pushbuild.com.

## What it does

1. Webhook: receives Shopify's Order payment webhook
1. Verify and build pick list: checks the HMAC signature and builds the pick list
1. Signature valid?: drops anything that did not come from your store
1. Email fulfilment team: sends the pick list
1. Post to Slack: posts the order number and line count

## What you need

- An n8n instance where you can set `NODE_FUNCTION_ALLOW_BUILTIN=crypto`
- A Shopify store (admin access)
- An SMTP account
- A Slack incoming webhook URL

## Setup

1. Import `workflow.json` into n8n.
2. Set the environment variable `NODE_FUNCTION_ALLOW_BUILTIN=crypto` on your n8n instance and restart it.
3. In Shopify admin, go to **Settings → Notifications → Webhooks**, create an **Order payment** webhook in JSON format, and paste the production URL from **Order paid (Shopify webhook)**.
4. Copy the signing secret shown under the webhooks list into the settings block at the top of **Verify and build pick list**, with your fulfilment and from addresses and Slack URL.
5. Add your SMTP credential to **Email fulfilment team**, activate, and send a test notification from Shopify.

## Make it yours

- Route orders to different warehouses by country or SKU with an IF or Switch node.
- Post the order to your 3PL's API or ShipStation instead of email.
- Add a second workflow on Shopify's fulfilment webhook to send tracking numbers to Klaviyo.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` or `REPLACE_WITH_...` must be set before you activate the workflow.
- Test with sample data first. Check each step's output in n8n before you point real traffic at it.

## Want this set up for you?

Pushbuild can set this up for you, connected to your own tools and tested end to end: [pushbuild.com/?need=template-shopify-order-fulfilment](https://pushbuild.com/?need=template-shopify-order-fulfilment)
