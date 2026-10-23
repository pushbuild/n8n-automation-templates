-- Run once in your Postgres database (Supabase, Neon, RDS or your own server).
create table if not exists records (
  external_id text primary key,
  name        text,
  email       text,
  status      text not null default 'active' check (status in ('active', 'paused', 'closed')),
  amount      numeric(12, 2),
  updated_at  timestamptz not null default now()
);
