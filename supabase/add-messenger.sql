-- Messenger link on alumni profiles — run once in Supabase SQL Editor
alter table public.alumni_profiles add column if not exists messenger text;
