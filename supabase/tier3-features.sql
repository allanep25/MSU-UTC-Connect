-- Tier 3: security, reports, verification — run once in Supabase SQL Editor
-- Run after tier1-features.sql and tier2-features.sql

-- ============ Helpers ============
create or replace function public.is_utc_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select lower(coalesce(auth.jwt() ->> 'email', '')) in (
    'admin@msu.edu', 'founder@msu.edu', 'realtytrail@gmail.com'
  );
$$;

create or replace function public.is_utc_officer()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.alumni_profiles p
    where lower(p.email) = lower(coalesce(auth.jwt() ->> 'email', ''))
      and (lower(coalesce(p.role, '')) = 'officer' or lower(coalesce(p.title, '')) = 'officer')
  );
$$;

create or replace function public.can_manage_events()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.is_utc_admin() or public.is_utc_officer();
$$;

-- ============ Alumni verification ============
alter table public.alumni_profiles add column if not exists verification_status text default 'approved';

update public.alumni_profiles
set verification_status = 'approved'
where verification_status is null or verification_status = '';

-- ============ Hide reported content ============
alter table public.messages add column if not exists hidden boolean default false;
alter table public.testimonials add column if not exists hidden boolean default false;

-- ============ Content reports ============
create table if not exists public.content_reports (
  id bigint generated always as identity primary key,
  content_type text not null check (content_type in ('message', 'testimonial')),
  content_id bigint not null,
  reporter_email text not null,
  reporter_name text not null,
  reason text,
  status text not null default 'open' check (status in ('open', 'dismissed', 'actioned')),
  created_at timestamptz default now()
);

alter table public.content_reports enable row level security;

drop policy if exists "content_reports_insert" on public.content_reports;
drop policy if exists "content_reports_select_admin" on public.content_reports;
drop policy if exists "content_reports_update_admin" on public.content_reports;

create policy "content_reports_insert" on public.content_reports
  for insert to authenticated
  with check (lower(reporter_email) = lower(auth.jwt() ->> 'email'));

create policy "content_reports_select_admin" on public.content_reports
  for select to authenticated using (public.is_utc_admin());

create policy "content_reports_update_admin" on public.content_reports
  for update to authenticated using (public.is_utc_admin()) with check (public.is_utc_admin());

-- ============ Tighter RLS: alumni profiles ============
drop policy if exists "alumni_profiles_select" on public.alumni_profiles;
create policy "alumni_profiles_select" on public.alumni_profiles
  for select using (
    coalesce(verification_status, 'approved') = 'approved'
    or lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
    or public.is_utc_admin()
  );

drop policy if exists "alumni_profiles_update" on public.alumni_profiles;
create policy "alumni_profiles_update" on public.alumni_profiles
  for update to authenticated
  using (lower(email) = lower(auth.jwt() ->> 'email') or public.is_utc_admin())
  with check (lower(email) = lower(auth.jwt() ->> 'email') or public.is_utc_admin());

-- ============ Messages ============
drop policy if exists "messages_select" on public.messages;
drop policy if exists "messages_insert" on public.messages;
drop policy if exists "messages_update_admin" on public.messages;

create policy "messages_select" on public.messages
  for select using (
    coalesce(hidden, false) = false
    or public.is_utc_admin()
  );

create policy "messages_insert" on public.messages
  for insert to authenticated
  with check (lower(author_email) = lower(auth.jwt() ->> 'email'));

create policy "messages_update_admin" on public.messages
  for update to authenticated
  using (public.is_utc_admin()) with check (public.is_utc_admin());

-- ============ Testimonials ============
drop policy if exists "testimonials_select" on public.testimonials;
drop policy if exists "testimonials_insert" on public.testimonials;
drop policy if exists "testimonials_update" on public.testimonials;
drop policy if exists "testimonials_delete" on public.testimonials;

create policy "testimonials_select" on public.testimonials
  for select using (
    (
      approved = true
      and coalesce(hidden, false) = false
    )
    or lower(author_email) = lower(coalesce(auth.jwt() ->> 'email', ''))
    or public.is_utc_admin()
  );

create policy "testimonials_insert" on public.testimonials
  for insert to authenticated
  with check (lower(author_email) = lower(auth.jwt() ->> 'email'));

create policy "testimonials_update" on public.testimonials
  for update to authenticated
  using (
    public.is_utc_admin()
    or lower(author_email) = lower(auth.jwt() ->> 'email')
  )
  with check (
    public.is_utc_admin()
    or lower(author_email) = lower(auth.jwt() ->> 'email')
  );

create policy "testimonials_delete" on public.testimonials
  for delete to authenticated
  using (
    public.is_utc_admin()
    or lower(author_email) = lower(auth.jwt() ->> 'email')
  );

-- ============ Events (admins + officers only) ============
drop policy if exists "events_insert" on public.events;
drop policy if exists "events_update" on public.events;
drop policy if exists "events_delete" on public.events;

create policy "events_insert" on public.events
  for insert to authenticated with check (public.can_manage_events());

create policy "events_update" on public.events
  for update to authenticated
  using (public.can_manage_events()) with check (public.can_manage_events());

create policy "events_delete" on public.events
  for delete to authenticated using (public.can_manage_events());

-- ============ Invites (own + admins) ============
drop policy if exists "invites_select_admin" on public.invites;
create policy "invites_select_admin" on public.invites
  for select to authenticated using (public.is_utc_admin());

-- Admin can verify profiles
-- (verification_status updates use alumni_profiles_update policy for admin)
