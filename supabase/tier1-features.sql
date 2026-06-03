-- Tier 1 features — run once in Supabase SQL Editor

-- Profile social links
alter table public.alumni_profiles add column if not exists linkedin text;
alter table public.alumni_profiles add column if not exists facebook text;
alter table public.alumni_profiles add column if not exists phone text;

-- Site feedback (separate from public Messages)
create table if not exists public.site_feedback (
  id bigint generated always as identity primary key,
  author_name text not null,
  author_email text not null,
  message text not null,
  created_at timestamptz default now()
);

alter table public.site_feedback enable row level security;

drop policy if exists "site_feedback_insert" on public.site_feedback;
drop policy if exists "site_feedback_select_admin" on public.site_feedback;

create policy "site_feedback_insert" on public.site_feedback for insert to authenticated
  with check ((auth.jwt() ->> 'email') is not null);

create policy "site_feedback_select_admin" on public.site_feedback for select to authenticated
  using ((auth.jwt() ->> 'email') in ('admin@msu.edu', 'founder@msu.edu', 'realtytrail@gmail.com'));

-- Event RSVP counts visible to signed-in alumni
drop policy if exists "event_rsvps_select" on public.event_rsvps;
create policy "event_rsvps_select" on public.event_rsvps for select to authenticated using (true);

-- Officers/admins can edit and delete events
drop policy if exists "events_update" on public.events;
drop policy if exists "events_delete" on public.events;
create policy "events_update" on public.events for update to authenticated using (true) with check (true);
create policy "events_delete" on public.events for delete to authenticated using (true);
