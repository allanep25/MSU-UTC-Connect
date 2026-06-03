-- Run once in Supabase SQL Editor (adds officer designation for Batch Officers board)
alter table public.alumni_profiles add column if not exists designation text;
