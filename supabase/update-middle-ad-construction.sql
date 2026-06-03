-- Center / Community ad (middle box in the 3-column board) — Supabase SQL Editor → Run

update public.overview_ads
set
  title = 'This Site Is Still Under Construction',
  body = 'This site is still under construction. Leave your comments in Messages for more improvements — we appreciate your feedback!',
  tag = 'Community',
  accent = 'construction',
  link = null,
  link_label = 'Leave a comment',
  panel = 'messages',
  active = true,
  sort_order = 2,
  updated_at = now()
where id = (
  select id from (
    select id, row_number() over (order by sort_order asc, id asc) as rn
    from public.overview_ads
  ) ranked
  where rn = 2
);
