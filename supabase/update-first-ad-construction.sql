-- Run once in Supabase SQL Editor to set the first (lowest sort_order) ad to the construction notice

update public.overview_ads
set
  title = 'This Site Is Still Under Construction',
  body = 'We are actively improving MSU-UTC Connect. Please leave your comments and suggestions in Messages so we can make the platform better for every batch.',
  tag = 'Notice',
  accent = 'construction',
  link = null,
  link_label = 'Share feedback',
  panel = 'messages',
  active = true,
  sort_order = 0,
  updated_at = now()
where id = (
  select id from public.overview_ads
  order by sort_order asc, id asc
  limit 1
);
