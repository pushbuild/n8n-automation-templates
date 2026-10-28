# Weekly numbers dashboard for n8n: HubSpot, QuickBooks and Stripe in Google Sheets

Every Monday this reads last week's numbers from the tools you already use, adds one row to a Google Sheets tab, and emails you a short summary with the change on the week before. The sheet becomes your dashboard: chart it, share it, or add your own columns.

Background: [Weekly business dashboard in Google Sheets](https://pushbuild.com/guides/weekly-business-dashboard.html) on pushbuild.com.

## What it does

1. **Last week**: works out Monday to Monday in your timezone.
1. **HubSpot**: new deals and their value, deals won and their value, and the open pipeline. Results are paged, so large accounts are counted in full.
1. **QuickBooks Online**: invoiced, payments received, unpaid invoices and the overdue part of them.
1. **Stripe**: card payments net of refunds, refunds and failed payments, in your currency. Paged as well.
1. **Sheet**: one row per week in the `Weekly KPIs` tab. Re-running a week updates its row instead of adding another.
1. **Email**: every number with its change on the previous week.
1. **Partial data is still useful**: each source is optional (`use_*` in Config). A source that fails after 3 retries is named in the email, and the other numbers still go out.

## What you need

- n8n
- Any of: a HubSpot private app token (deals read scope), QuickBooks Online with an Intuit developer app (OAuth2), a Stripe secret key (restricted, read-only is enough)
- A Google Sheet
- An SMTP account for the email

## Setup

1. Import `workflow.json` into n8n.
2. Create a Google Sheet with a tab named `Weekly KPIs` and this header row:
   `week, deals_created, deals_created_value, deals_won, deals_won_value, open_pipeline, invoiced, payments_received, unpaid, overdue, card_payments, refunds, failed_payments`
3. Add credentials: HubSpot App Token on the three deal steps, QuickBooks Online OAuth2 on the three QuickBooks steps, Stripe on **Stripe charges**, Google Sheets on the two sheet steps, SMTP on the two email steps.
4. In **Config**, set `use_*` to `false` for any source you don't use, then set `realm_id`, `timezone`, `currency` and the emails.
5. Click **Test workflow** to see the row and the email with sample data. Activate.

## Notes

- No credentials are included. Every value marked `REPLACE_WITH_...` must be set before you activate the workflow.
- Read-only: nothing is changed in HubSpot, QuickBooks or Stripe.
- Tested on n8n 1.110.1 with the sample data and against mocked HubSpot, QuickBooks and Stripe APIs, including paged results and a failing source.
