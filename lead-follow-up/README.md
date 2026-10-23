# Lead follow-up: score, reply, CRM, alert

Every new lead from your website form gets a quick reply, goes into HubSpot, and is scored by OpenAI. Leads that score high trigger a Slack alert to your sales team.

Background: [Lead follow-up automation](https://pushbuild.com/guides/lead-follow-up-automation.html) on pushbuild.com.

## What it does

1. Webhook: receives the lead from your form tool (Typeform, Jotform, Webflow, Gravity Forms, or any tool that can POST JSON)
1. Normalize lead: maps your form's field names to name, email, phone, company and message
1. Score lead: asks OpenAI for a 1–10 fit score, a reason, and a one-line summary
1. Reply to lead: sends a short thank-you email with your booking link
1. Upsert contact: creates or updates the contact in HubSpot, matched by email
1. Hot lead?: if the score meets your threshold, posts the lead to Slack

## What you need

- An n8n instance (n8n Cloud or self-hosted)
- An OpenAI API key
- A HubSpot private app token with the CRM contacts scopes
- An SMTP account to send email
- A Slack incoming webhook URL

## Setup

1. In n8n, open **Workflows → Import from file** and choose `workflow.json`.
2. Open **Config** and set your business name, from address, booking link, Slack webhook URL and the hot lead score.
3. Create a **Header Auth** credential named `OpenAI` (name `Authorization`, value `Bearer <your key>`) and select it on **Score lead (OpenAI)**.
4. Create a **Header Auth** credential named `HubSpot` (name `Authorization`, value `Bearer <private app token>`) and select it on **Upsert contact (HubSpot)**.
5. Add your SMTP credential to **Reply to lead**.
6. Copy the production URL from **New lead (webhook)**, point your form's webhook at it, and activate the workflow.
7. Send one test submission and check each step's output.

## Make it yours

- Change the scoring prompt in **Normalize lead** to describe your ideal customer.
- Swap the HubSpot step for Pipedrive, GoHighLevel or Follow Up Boss using their API or n8n node.
- Add a Wait node and a second email to turn the reply into a short follow-up sequence.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` or `REPLACE_WITH_...` must be set before you activate the workflow.
- Test with sample data first. Check each step's output in n8n before you point real traffic at it.

## Want this set up for you?

Pushbuild can set this up for you, connected to your own tools and tested end to end: [pushbuild.com/?need=template-lead-follow-up](https://pushbuild.com/?need=template-lead-follow-up)
