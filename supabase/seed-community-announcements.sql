-- Association posters + Fun Run event (run once in Supabase SQL Editor)
-- Add image files to assets/ads/ in the repo, or use full image URLs in the image column.

insert into public.overview_ads (title, body, image, link, link_label, tag, accent, panel, sort_order, active)
select
  'Call for Nominations: Notable Alumni',
  'Honor outstanding MSU-UTC alumni. Submit a 100–150 word bionote and one high-quality photo on or before July 1, 2026.',
  'assets/ads/notable-alumni-nominations.jpg',
  'mailto:abdulhamidgunda@gmail.com?cc=gabrielmohammadomar3@gmail.com,m2angni@gmail.com&subject=Notable%20Alumni%20Nomination',
  'Email nominations',
  'Association',
  'from-[#800020] to-red-900',
  null,
  -2,
  true
where not exists (
  select 1 from public.overview_ads where lower(title) like '%notable alumni%'
);

insert into public.overview_ads (title, body, image, link, link_label, tag, accent, panel, sort_order, active)
select
  '6th Alumni Homecoming Fun Run',
  'July 12, 2026 · 5:30 AM · MSU-Main · Run for World Peace. 3K & 5K — ₱500 includes finisher shirt, medal, and food.',
  'assets/ads/fun-run-2026.jpg',
  null,
  'View event details',
  'Event',
  'from-emerald-800 to-emerald-950',
  'events',
  -1,
  true
where not exists (
  select 1 from public.overview_ads where lower(title) like '%fun run%'
);

insert into public.events (title, date, time, location, description, photo_urls)
select
  '6th Alumni Homecoming Fun Run',
  '2026-07-12',
  '5:30 AM',
  'MSU-Main',
  'MSU-UTC (PHS, UHS) Alumni Association — Run for World Peace.

Distances: 3 KM and 5 KM
Registration: ₱500 (finisher shirt, medal, food & drinks)

Contact: msuutc.alumni@gmail.com
Facebook: MSU-UTC (PHS, UHS) Alumni Association',
  'assets/ads/fun-run-2026.jpg'
where not exists (
  select 1 from public.events where lower(title) like '%fun run%'
);
