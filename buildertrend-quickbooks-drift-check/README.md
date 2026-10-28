# Buildertrend to QuickBooks drift check for n8n

Bills get entered twice, typed differently, or put on the wrong job, and nobody notices until job costs stop adding up. This workflow compares your Buildertrend bills with the bills in QuickBooks Online every morning and emails you what doesn't match.

Background: [Buildertrend and QuickBooks reconciliation](https://pushbuild.com/guides/buildertrend-quickbooks-reconciliation.html) on pushbuild.com.

## What it does

1. **Latest export**: finds the newest CSV in a Google Drive folder and warns if it is older than `max_export_age_hours`. Buildertrend has no public API, so the bills report you export is the source.
1. **Read it**: parses the CSV (quoted fields, commas in names, amounts like `"1,234.50"`) using the column names you set in Config, and keeps the last `lookback_days`.
1. **QuickBooks**: reads the bills for the same period from the QuickBooks Online API.
1. **Compare**: matches each bill by bill number and vendor, then by vendor, amount and a date within `date_tolerance_days`. It reports:
   - bills **missing in QuickBooks**,
   - bills **missing in Buildertrend** (on the same jobs),
   - **amounts that differ** by more than `amount_tolerance`,
   - bills on a **different job** (the QuickBooks customer or `Customer:Job`),
   - **job totals** that differ by more than `job_total_tolerance`.
1. **Report**: one plain email, only when something needs a look (or every day, with `send_when_clean`). Problems already reported are marked so new ones stand out.
1. **Retries and alerts**: every API and email step retries 3 times; anything that still fails emails the step and the reason.

## What you need

- n8n
- QuickBooks Online and an Intuit developer app (OAuth2)
- A Google Drive folder for the Buildertrend exports
- An SMTP account for the email

## Setup

1. Import `workflow.json` into n8n.
2. Export your Buildertrend bills report as CSV into one Google Drive folder. Each new export is picked up on the next run.
3. Add a **Google Drive OAuth2** credential on **Find latest export** and **Download export**, a **QuickBooks Online OAuth2** credential on **Get QuickBooks bills**, and **SMTP** on the two email steps.
4. In **Config**, set `drive_folder_id`, `realm_id`, `report_to`, `from_email`, and the `field_*` names to match the column headers in your export.
5. Click **Test workflow** to run a sample export and sample QuickBooks bills through the checks and see the report.
6. Activate.

## Notes

- No credentials are included. Every value marked `REPLACE_WITH_...` must be set before you activate the workflow.
- Read-only: nothing is changed in QuickBooks, Buildertrend or Drive.
- The list of problems already reported lives in the workflow's static data, which n8n saves on production runs only.
- Tested on n8n 1.110.1 with the sample data and against mocked Google Drive and QuickBooks APIs.
