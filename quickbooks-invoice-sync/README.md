# Job completed to QuickBooks invoice

When a job, order or project is marked complete in your other system, this workflow creates the QuickBooks Online invoice once. It checks for an existing invoice with the same number first, matches the customer by email or name (or creates them), can email the invoice from QuickBooks, and posts every result and every failure to Slack.

Background: [QuickBooks automation](https://pushbuild.com/guides/quickbooks-automation.html) on pushbuild.com.

## What it does

1. **Receive and map**: a webhook (or the built-in sample job) is read using the `field_*` names in **Config**, so any system's payload works without editing code. Jobs with no id, no customer or a bad line are rejected with a reason.
1. **Never invoice twice**: the invoice number is the job id plus an optional prefix. If QuickBooks already has it, nothing is created.
1. **Customer**: matched by email when there is one, otherwise by display name, and created if new.
1. **Invoice**: lines map to your QuickBooks items, the due date follows `due_days`, and `email_invoice` sends it from QuickBooks.
1. **Retries and alerts**: every QuickBooks call retries 3 times. Anything that still fails posts the step, the job and QuickBooks' reason to Slack.

## What you need

- An n8n instance
- A QuickBooks Online company and an Intuit developer app (for the OAuth2 credential)
- A Slack incoming webhook URL

## Setup

1. Import `workflow.json` into n8n.
2. Create a **QuickBooks Online OAuth2 API** credential and select it on the five QuickBooks steps.
3. In **Config**, set `realm_id`, `default_item_id` and the Slack URL. Leave `qbo_base_url` on the sandbox until you have tested.
4. Set the `field_*` names in **Config** to match your system's payload. Dotted paths such as `job.id` work.
5. Click **Test workflow** to send the sample job to your sandbox company and check the invoice.
6. Point your system's webhook at **Job completed (webhook)**, then switch `qbo_base_url` to `https://quickbooks.api.intuit.com`.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` or `REPLACE_WITH_...` must be set before you activate the workflow.
- QuickBooks invoice numbers can be at most 21 characters, so the prefix plus job id must fit.
