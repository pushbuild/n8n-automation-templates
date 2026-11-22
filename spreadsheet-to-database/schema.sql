-- Run once in your Postgres database (Supabase, Neon, RDS or your own server).
create table if not exists records (
  external_id text primary key,
  name        text,
  email       text,
  status      text not null default 'active' check (status in ('active', 'paused', 'closed')),
  amount      numeric(12, 2),
  row_hash    text,                 -- hash of the loaded values, so unchanged rows are skipped
  updated_at  timestamptz not null default now(),
  deleted_at  timestamptz           -- set when the row disappears from the sheet; cleared if it comes back
);

-- One row per run: what was loaded, skipped, rejected and marked deleted.
create table if not exists sync_runs (
  id             bigserial primary key,
  run_at         timestamptz not null default now(),
  sheet_rows     int,
  new_rows       int,
  changed_rows   int,
  restored_rows  int,
  unchanged_rows int,
  rejected_rows  int,
  deleted_rows   int,
  delete_blocked boolean
);

-- Already ran the first version of this template? Add the new columns instead:
-- alter table records add column if not exists row_hash text;
-- alter table records add column if not exists deleted_at timestamptz;
