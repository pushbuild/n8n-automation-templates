# Google Sheet to Postgres sync

Keeps a Postgres table in step with a Google Sheet that has become your database, every hour. Each row is cleaned and checked first. Only new and changed rows are written, rows removed from the sheet are marked deleted rather than dropped, and every run is logged. Rows that fail a check are posted to Slack with their sheet row number instead of being loaded.

Background: [Spreadsheet vs database app](https://pushbuild.com/compare/spreadsheet-vs-database-app.html) on pushbuild.com.

## What it does

1. **Every hour** (or **Test with sample data**, which uses six built-in rows instead of your sheet)
1. **Read sheet**: reads the `Records` tab
1. **Validate and clean**: trims and normalises names, emails, statuses and amounts, and rejects missing or duplicate ids, bad emails, unknown statuses and amounts that are not numbers
1. **Read current table** and **Plan changes**: compares a hash of each row with what is in Postgres, so only new, changed and restored rows are written
1. **Upsert into Postgres**: inserts or updates by `external_id`
1. **Mark missing rows deleted**: sets `deleted_at` on rows no longer in the sheet. If more than `max_delete_share` of the table would be marked (a cleared or renamed tab, say), nothing is marked and you are told instead
1. **Log the run**: one row in `sync_runs` with the counts
1. **Post report (Slack)**: rejected rows and blocked deletes, with the reason for each
1. **Failure alert (Slack)**: any Sheets or Postgres step that still fails after 3 tries names the step and the reason

## What you need

- An n8n instance (tested on 1.110)
- A Postgres database (Supabase, Neon, RDS or your own)
- A Google account for Sheets
- A Slack workspace where you can add the n8n Slack app

## Setup

1. Run `schema.sql` in your database.
2. Import `workflow.json` into n8n.
3. Add a Postgres credential to the four Postgres steps, a Google Sheets credential to **Read sheet**, and a Slack credential to the two Slack steps.
4. Paste your sheet URL into **Read sheet** and set the tab name. The sheet needs columns `id`, `name`, `email`, `status` and `amount` (or change the mapping in **Validate and clean**).
5. Set the Slack channel and options in **Config**.
6. Click **Test workflow**: two sample rows load and four are reported. Run it again and nothing is rewritten. Then delete the sample rows (`delete from records; delete from sync_runs;`) and activate.

## Config

| Setting | What it does |
|---|---|
| `slack_channel` | Where reports and failures go |
| `allowed_statuses` | Comma-separated statuses a row may have |
| `soft_delete_missing` | `false` to never mark rows deleted |
| `max_delete_share` | Largest share of the table one run may mark deleted (0.2 = 20%) |
| `report_when_clean` | `true` to post a summary even when nothing was rejected |

## Make it yours

- Add your own columns to `schema.sql` and **Validate and clean**; add them to the hash in the same node so a change to them is picked up.
- Once the database is trusted, build forms or an internal tool on it and make the sheet a read-only export.
- Query `sync_runs` to chart how often the sheet changes or how many rows are rejected.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` must be set before you activate the workflow.
- Rows rejected by a check are never marked deleted, so a typo in the sheet does not remove a row from the table.
- Test with sample data first. Check each step's output in n8n before you point real traffic at it.

## Want this set up for you?

Pushbuild can set this up for you, connected to your own tools and tested end to end: [pushbuild.com/?need=template-spreadsheet-to-database](https://pushbuild.com/?need=template-spreadsheet-to-database)
