# AI lead qualifier: research, score and route to HubSpot, Google Calendar and Slack

An AI agent reads every new lead, researches the company's website, checks HubSpot for history, and scores fit, intent and authority. Your own rules then decide what happens: hot leads get a deal, three real free times from your calendar and a tailored reply; warm leads get a reply with your booking link; nurture leads get a polite reply; spam is dropped. Sales hears about every hot and warm lead in Slack, with the reasons.

Background: [Lead follow-up automation](https://pushbuild.com/guides/lead-follow-up-automation.html) on pushbuild.com.

## What it does

1. **Capture**: the built-in n8n form, your own site's form through a webhook, or the sample lead for testing. Field names are mapped in **Config**.
1. **Clean up**: names and emails are normalized, personal and throwaway addresses are flagged, sales-pitch spam is spotted, and the same person submitting twice within `dedupe_hours` is handled once.
1. **CRM check**: HubSpot is searched by email. Existing customers skip qualification and go straight to Slack for their owner.
1. **AI agent with tools**: an AI Agent node with three tools (read the company's website, look the company up in HubSpot, think) returns a structured result: score, size band, industry, company summary, reasons, red flags, next step and a reply draft.
1. **Your rules decide**: the tier comes from the score and your thresholds, not from the model's own label. A personal email address caps a lead at warm unless the score is 90 or more. The owner is picked by company size from `owners_json`, and leads that arrive after hours are flagged.
1. **CRM write**: the contact is upserted with the lead status for its tier and owner, and the AI's reasoning is logged as a HubSpot note.
1. **Hot leads**: the workflow reads your calendar's free/busy, picks one free time on each of the next three working days inside business hours, opens a deal, holds the first time as a tentative event, emails the lead the three times plus your booking link, and alerts Slack.
1. **Warm and nurture leads**: the tailored reply goes out (with the booking link for warm leads), and Slack is told about warm ones.
1. **Retries and alerts**: every HubSpot, calendar, email and AI step retries 3 times. Anything that still fails posts the step, the lead and the reason to Slack.

## What you need

- n8n 1.110 or later (AI Agent node 2.2)
- An OpenAI API key
- A HubSpot private app token with read and write scopes for contacts, companies and deals
- Google Calendar (OAuth2)
- An SMTP account for the replies
- A Slack incoming webhook URL

## Setup

1. Import `workflow.json` into n8n.
2. Add credentials: OpenAI on **OpenAI chat model**; HubSpot App Token on the four HubSpot steps and the **Look up company in HubSpot** tool; Google Calendar OAuth2 on **Check calendar** and **Hold first time**; SMTP on the three reply steps.
3. In **Config**, describe what you sell and your ideal customer (the agent scores against these), then set the thresholds, owners, HubSpot portal id, calendar, booking link, signature and Slack URL.
4. Click **Test workflow** to run the sample lead through every step.
5. Share the **Lead form** URL, or point your site's form at **Website form (webhook)** and set the `field_*` names to match its payload. Activate.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` or `REPLACE_WITH_...` must be set before you activate the workflow.
- The agent is told to use only facts from the lead, its tools and your Config, and never to quote prices or meeting times; the times come from your calendar.
- The duplicate check keeps its list in the workflow's static data, which n8n saves on production runs only, so repeated test runs are not blocked.
- Tested end to end on n8n 1.110.1 with sample hot, warm and spam leads.
