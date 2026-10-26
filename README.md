# Free n8n automation templates

Importable [n8n](https://n8n.io) workflows for jobs most small businesses repeat every week. Each folder has the workflow JSON and a README with setup steps. Published by [Pushbuild](https://pushbuild.com).

| Template | What it does | Guide |
|---|---|---|
| [AI lead qualifier: research, score and route](ai-lead-qualifier/) | An AI agent researches each new lead's company, scores fit and intent, and routes it: a HubSpot deal, three free times from your calendar and a Slack alert for hot leads, a tailored reply for the rest. | [Lead follow-up automation](https://pushbuild.com/guides/lead-follow-up-automation.html) |
| [Lead follow-up: score, reply, CRM, alert](lead-follow-up/) | Every new lead from your website form gets a quick reply, goes into HubSpot, and is scored by OpenAI. | [Lead follow-up automation](https://pushbuild.com/guides/lead-follow-up-automation.html) |
| [Job completed to QuickBooks invoice](quickbooks-invoice-sync/) | When a job or order is marked complete in your other system, this workflow creates the QuickBooks Online invoice. | [QuickBooks automation](https://pushbuild.com/guides/quickbooks-automation.html) |
| [Email attachment to Google Sheet](document-processing/) | Reads PDF invoices and documents that arrive by email, pulls out the fields you choose with OpenAI, checks the totals, and adds a row to a Google Sheet. | [Document processing](https://pushbuild.com/guides/document-processing.html) |
| [Shopify paid order to fulfilment notice](shopify-order-fulfilment/) | When a Shopify order is paid, this workflow checks Shopify's signature, builds a pick list with SKUs, quantities, ship-to address and shipping method, emails it to your warehouse or 3PL, and posts a note to Slack. | [Shopify automation](https://pushbuild.com/guides/shopify-automation.html) |
| [Zapier to n8n migration starter](zapier-to-n8n-starter/) | A starting point for moving Zaps to n8n: a workflow laid out like a typical Zap (Catch Hook, Formatter, Filter, Action), an error alert workflow so failures reach you, and an inventory sheet for listing every Zap before you move any of them. | [Zapier vs Make vs n8n](https://pushbuild.com/compare/zapier-vs-make-vs-n8n.html) |
| [Google Sheet to Postgres](spreadsheet-to-database/) | Moves a Google Sheet that has become your database into Postgres, every hour. | [Spreadsheet vs database app](https://pushbuild.com/compare/spreadsheet-vs-database-app.html) |

## How to use

1. Download the folder you want, or clone this repo.
2. In n8n, open **Workflows → Import from file** and choose the `workflow.json`.
3. Follow that folder's README to add your own credentials and settings.

Import-tested on n8n 1.70; the AI lead qualifier needs n8n 1.110 or later. Older instances may need node versions adjusted.

## Want one set up for you?

Tell us the process and the tools involved: [pushbuild.com](https://pushbuild.com/?need=templates). Each template's README links to a brief for that template.

## License

MIT. Use, change and share them freely.
