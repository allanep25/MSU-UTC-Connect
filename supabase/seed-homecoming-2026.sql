-- 6th Alumni Homecoming (July 11–13, 2026) — run once in Supabase SQL Editor

insert into public.events (title, date, time, location, description, photo_urls)
select
  '6th Alumni Homecoming',
  '2026-07-11',
  null,
  'MSU-UTC (PHS, UHS) Alumni Association',
  'Brotherhood for World Peace

July 11, 12, and 13, 2026

The MSU-UTC (PHS, UHS) Alumni Association welcomes all batches for the 6th Alumni Homecoming. Full schedule and venue details will be posted here as they are confirmed.

Contact: msuutc.alumni@gmail.com',
  'assets/ads/homecoming-2026.png'
where not exists (
  select 1 from public.events
  where lower(title) like '%homecoming%'
    and lower(title) not like '%fun run%'
);
