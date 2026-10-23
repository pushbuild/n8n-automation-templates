# Email attachment to Google Sheet

Reads PDF invoices and documents that arrive by email, pulls out the fields you choose with OpenAI, checks the totals, and adds a row to a Google Sheet. Rows it is unsure about are marked CHECK for a person to review.

Background: [Document processing](https://pushbuild.com/guides/document-processing.html) on pushbuild.com.

## What it does

1. Email trigger (IMAP): watches a mailbox, such as invoices@, and downloads attachments
1. Has PDF?: skips emails without a PDF in the first attachment
1. Extract PDF text: turns the PDF into text
1. Extract fields: asks OpenAI for supplier, invoice number, dates, subtotal, tax, total and currency
1. Check and flag: marks the row CHECK when confidence is low or subtotal plus tax does not equal the total
1. Append to sheet: adds the row to the Documents tab

## What you need

- An n8n instance
- An IMAP mailbox the documents arrive in
- An OpenAI API key
- A Google account for Sheets

## Setup

1. Import `workflow.json` into n8n.
2. Add your IMAP credential to **New email (IMAP)**.
3. Create a **Header Auth** credential for OpenAI (name `Authorization`, value `Bearer <your key>`) and select it on **Extract fields (OpenAI)**.
4. Create a Google Sheet with a tab named `Documents` and headers: received, from, subject, file, supplier, invoice_number, invoice_date, due_date, subtotal, tax, total, currency, review.
5. Paste the sheet URL into **Append to sheet** and add your Google credential.
6. Send a test email with a PDF invoice attached, then activate.

## Make it yours

- Change the field list in **Build extraction request** for orders, applications or statements.
- Scanned documents need an OCR step before extraction.
- Send rows marked CHECK to Slack or email for review, or post approved rows to QuickBooks or Xero.

## Notes

- No credentials are included. Every value marked `REPLACE_ME` or `REPLACE_WITH_...` must be set before you activate the workflow.
- Test with sample data first. Check each step's output in n8n before you point real traffic at it.

## Want this set up for you?

Pushbuild can set this up for you, connected to your own tools and tested end to end: [pushbuild.com/?need=template-document-processing](https://pushbuild.com/?need=template-document-processing)
