-- Run once in Supabase SQL Editor (direct messages on the community board)
alter table public.messages add column if not exists recipient_name text;
alter table public.messages add column if not exists recipient_email text;
