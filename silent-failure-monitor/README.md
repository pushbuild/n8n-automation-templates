# Silent failure monitor for n8n

Some failures never turn a run red: a filter drops every item, an API returns an empty page, a schedule stops firing, someone switches a workflow off. This workflow watches the workflows you list and tells you when they **succeeded but did nothing**.

Background: [How to catch n8n workflows that succeed but do nothing](https://pushbuild.com/guides/n8n-silent-failures.html) on pushbuild.com.

## What it does

1. **Fetch**: every 15 minutes, for each workflow in `checks_json`, it reads the workflow (is it still active?) and its last 50 runs with their data from the n8n API, plus an optional record-check URL.
1. **Judge**: it flags
   - **empty runs**: fewer items than `min_items` out of the step you name (or the step never ran),
   - **missed schedules**: no run within `max_gap_minutes`,
   - **missing records**: your record-check URL returns fewer than `record_min` rows,
   - **switched-off workflows**,
   - **failed runs**, if you turn on `alert_on_errors`.
1. **Report once**: each problem has a key (the run id, the date or the hour), so it is reported a single time.
1. **Tell someone**: one Slack message and one email per round, with a link to each run, and a row per finding in a Google Sheet.
1. **Daily summary**: at 8am Slack gets the number of checks and problems in the last 24 hours, which also proves the monitor is running.
1. **Retries and alerts**: every API, Slack, email and sheet step retries 3 times; anything that still fails posts the step and the reason to Slack.

## What you need

- n8n with the public API turned on, and an n8n API key
- A Slack incoming webhook URL
- An SMTP account for the email alerts
- A Google Sheet with a tab named `Silent failures`

## Setup

1. Import `workflow.json` into n8n.
2. In n8n, open **Settings → n8n API** and create a key. Add a **Header Auth** credential with name `X-N8N-API-KEY` and the key as its value, and select it on **Get workflow** and **Get recent runs**.
3. In **Config**, set `n8n_base_url`, the Slack URL, the alert email and `checks_json`.
4. Add your SMTP credential to **Alert (email)** and Google Sheets to **Log to sheet**.
5. Click **Test workflow** to run three sample workflows with problems through the checks.
6. Activate.

## checks_json

```json
[{"workflow_id": "12", "name": "Nightly order sync", "max_gap_minutes": 1500, "count_node": "Upsert orders", "min_items": 1,
  "record_check_url": "", "record_min": 1, "alert_on_errors": true}]
```

- `max_gap_minutes`: 0 turns the schedule check off. Use 1500 for a nightly job, 90 for an hourly one.
- `count_node`: blank means the last step that ran.
- `record_check_url`: any URL that returns today's records as JSON: a list, or an object with `count`, `total`, `data`, `results` or `items`.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` or `REPLACE_WITH_...` must be set before you activate the workflow.
- The watched workflows must save successful runs (workflow settings), or there is no run data to count.
- The list of problems already reported lives in the workflow's static data, which n8n saves on production runs only.
- Tested on n8n 1.110.1 against sample runs and a mocked n8n API.
