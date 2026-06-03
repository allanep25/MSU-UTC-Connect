-- Paste ALL of this in Supabase → SQL Editor → Run (one time)
-- Adds officer designation + message recipient fields

alter table public.alumni_profiles add column if not exists designation text;

alter table public.messages add column if not exists recipient_name text;
alter table public.messages add column if not exists recipient_email text;

-- Overview advertisement board — or run supabase/overview-ads.sql for policies + seed

-- Tier 1 features (feedback, social links, event edit, RSVP counts) — run supabase/tier1-features.sql
