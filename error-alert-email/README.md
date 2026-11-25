# Error alert email

Emails you the moment any n8n workflow fails: which workflow, the step that failed, the error message, and a link to the failed run.

Two nodes: an **Error Trigger** and a **Gmail** node. Watch it set up and catch a real failure: [YouTube walkthrough](https://youtu.be/WoPtnK-IGz4).

## Setup

1. Import `workflow.json` (**Workflows → Import from file**).
2. Open the Gmail node, connect your Gmail account, and change `you@yourbusiness.com` to the address that should get alerts. Save.
3. Open each workflow you want watched → **Settings → Error workflow** → pick **Error alert**. Save, and make sure that workflow is active.

The next time a watched workflow fails, the email arrives within seconds.

## What it does not catch

A workflow that stops running at all, or runs but does nothing, never errors. For those, use the [silent failure monitor](../silent-failure-monitor/).

More: [free error alert page](https://pushbuild.com/free/scripts/n8n-error-alert-email/?utm_source=github&utm_medium=repo&utm_campaign=n8n-automation-templates) · [why n8n workflows fail silently](https://pushbuild.com/guides/n8n-silent-failures.html?utm_source=github&utm_medium=repo&utm_campaign=n8n-automation-templates)
