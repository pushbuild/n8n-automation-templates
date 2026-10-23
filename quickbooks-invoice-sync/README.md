# Job completed to QuickBooks invoice

When a job or order is marked complete in your other system, this workflow creates the QuickBooks Online invoice. It checks for an existing invoice with the same job number first, so the same job is never invoiced twice, and creates the customer if they are new.

Background: [QuickBooks automation](https://pushbuild.com/guides/quickbooks-automation.html) on pushbuild.com.

## What it does

1. Webhook: receives the completed job (job id, customer, email, lines)
1. Find invoice by job number: queries QuickBooks for an invoice whose DocNumber matches the job id
1. Already invoiced?: if one exists, posts a note to Slack and stops
1. Find customer / Create customer: matches the customer by display name, or creates them
1. Build invoice / Create invoice: posts the invoice with your item, quantity and rate per line
1. Report: posts the new invoice number to Slack

## What you need

- An n8n instance
- A QuickBooks Online company and an Intuit developer app (for the OAuth2 credential)
- A Slack incoming webhook URL

## Setup

1. Import `workflow.json` into n8n.
2. Create a **QuickBooks Online OAuth2 API** credential and select it on the four QuickBooks HTTP steps.
3. In **Config**, set `realm_id` (your company ID), `default_item_id` (the product or service to invoice against) and the Slack URL. Leave `qbo_base_url` on the sandbox until you have tested.
4. Point your job, CRM or order system's webhook at the URL on **Job completed (webhook)**. The expected body is shown in **Normalize job**.
5. Test with a sandbox company, compare the invoices with what your bookkeeper expects, then switch `qbo_base_url` to `https://quickbooks.api.intuit.com`.

## Make it yours

- Map each line to a different QuickBooks item by sending `item_id` per line.
- Add class, location or tax code fields to **Build invoice** if your books use them.
- Swap the webhook for a Schedule trigger that reads completed jobs from a spreadsheet or API.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` or `REPLACE_WITH_...` must be set before you activate the workflow.
- Test with sample data first. Check each step's output in n8n before you point real traffic at it.

## Want this set up for you?

Pushbuild can set this up for you, connected to your own tools and tested end to end: [pushbuild.com/?need=template-quickbooks-invoice-sync](https://pushbuild.com/?need=template-quickbooks-invoice-sync)
