# Google Sheet to Postgres

Moves a Google Sheet that has become your database into Postgres, every hour. Each row is cleaned and checked first: missing or duplicate ids, bad emails, non-numeric amounts and unknown statuses are reported to Slack instead of being loaded.

Background: [Spreadsheet vs database app](https://pushbuild.com/compare/spreadsheet-vs-database-app.html) on pushbuild.com.

## What it does

1. Every hour: runs on a schedule
1. Read sheet: reads the Records tab
1. Validate and clean: one rule per line, easy to change
1. Valid? → Upsert into Postgres: inserts new rows and updates existing ones, matched on external_id
1. Summarize rejects → Slack: lists the rows that were not loaded, with the sheet row number and reason

## What you need

- An n8n instance
- A Postgres database (Supabase, Neon, RDS or your own)
- A Google account for Sheets
- A Slack incoming webhook URL

## Setup

1. Run `schema.sql` in your database.
2. Import `workflow.json` into n8n.
3. Paste your sheet URL into **Read sheet**, add your Google credential, and set the tab name. The sheet needs columns id, name, email, status and amount (or change the mapping in **Validate and clean**).
4. Add your Postgres credential to **Upsert into Postgres** and set the Slack URL in **Config**.
5. Run it once by hand, check the table and the rejects message, then activate.

## Make it yours

- Add your own columns to `schema.sql` and **Validate and clean**.
- Once the database is trusted, build forms or an internal tool on it and make the sheet a read-only export.
- Airtable users can swap the Postgres step for the Airtable node.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` or `REPLACE_WITH_...` must be set before you activate the workflow.
- Test with sample data first. Check each step's output in n8n before you point real traffic at it.

## Want this set up for you?

Pushbuild can set this up for you, connected to your own tools and tested end to end: [pushbuild.com/?need=template-spreadsheet-to-database](https://pushbuild.com/?need=template-spreadsheet-to-database)
