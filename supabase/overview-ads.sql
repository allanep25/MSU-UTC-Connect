-- Overview advertisement board (Admin panel in app)
-- Run in Supabase → SQL Editor after main schema

create table if not exists public.overview_ads (
  id bigint generated always as identity primary key,
  title text not null,
  body text not null,
  image text,
  link text,
  link_label text,
  tag text,
  accent text default 'from-[#800020] to-red-900',
  panel text,
  active boolean default true,
  sort_order int default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.overview_ads enable row level security;

drop policy if exists "overview_ads_select" on public.overview_ads;
drop policy if exists "overview_ads_insert" on public.overview_ads;
drop policy if exists "overview_ads_update" on public.overview_ads;
drop policy if exists "overview_ads_delete" on public.overview_ads;

create policy "overview_ads_select" on public.overview_ads for select using (
  active = true
  or (auth.jwt() ->> 'email') in ('admin@msu.edu', 'founder@msu.edu', 'realtytrail@gmail.com')
);

create policy "overview_ads_insert" on public.overview_ads for insert to authenticated
  with check ((auth.jwt() ->> 'email') in ('admin@msu.edu', 'founder@msu.edu', 'realtytrail@gmail.com'));

create policy "overview_ads_update" on public.overview_ads for update to authenticated
  using ((auth.jwt() ->> 'email') in ('admin@msu.edu', 'founder@msu.edu', 'realtytrail@gmail.com'))
  with check ((auth.jwt() ->> 'email') in ('admin@msu.edu', 'founder@msu.edu', 'realtytrail@gmail.com'));

create policy "overview_ads_delete" on public.overview_ads for delete to authenticated
  using ((auth.jwt() ->> 'email') in ('admin@msu.edu', 'founder@msu.edu', 'realtytrail@gmail.com'));

-- Optional starter ads (skip if you already have rows)
insert into public.overview_ads (title, body, tag, accent, link_label, panel, sort_order)
select * from (values
  ('UTC Alumni Homecoming', 'Reconnect with your batch, meet national officers, and celebrate MSU-UTC pride together.', 'Event', 'from-[#800020] to-red-900', 'View events', 'events', 1),
  ('This Site Is Still Under Construction', 'This site is still under construction. Leave your comments in Messages for more improvements — we appreciate your feedback!', 'Community', 'construction', 'Leave a comment', 'messages', 2),
  ('Partner With MSU-UTC Connect', 'Businesses and alumni groups can sponsor this board. Contact the alumni officers to post an announcement.', 'Sponsor', 'from-slate-700 to-slate-900', 'Inquire', null, 3)
) as v(title, body, tag, accent, link_label, panel, sort_order)
where not exists (select 1 from public.overview_ads limit 1);
