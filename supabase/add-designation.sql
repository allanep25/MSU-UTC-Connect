-- Run once in Supabase SQL Editor (adds officer designation for Alumni Officers board)
alter table public.alumni_profiles add column if not exists designation text;
