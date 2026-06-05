-- Push notifications, email prefs, event check-in — run once after features-round2.sql

-- Web Push subscriptions (one row per device/browser)
create table if not exists public.push_subscriptions (
  id bigint generated always as identity primary key,
  user_email text not null,
  endpoint text not null,
  p256dh text not null,
  auth_key text not null,
  user_agent text,
  created_at timestamptz default now(),
  unique (endpoint)
);

alter table public.push_subscriptions enable row level security;

drop policy if exists "push_subscriptions_select_own" on public.push_subscriptions;
drop policy if exists "push_subscriptions_upsert_own" on public.push_subscriptions;
drop policy if exists "push_subscriptions_delete_own" on public.push_subscriptions;

create policy "push_subscriptions_select_own" on public.push_subscriptions
  for select to authenticated
  using (lower(user_email) = lower(auth.jwt() ->> 'email') or public.is_utc_admin());

create policy "push_subscriptions_upsert_own" on public.push_subscriptions
  for insert to authenticated
  with check (lower(user_email) = lower(auth.jwt() ->> 'email'));

create policy "push_subscriptions_update_own" on public.push_subscriptions
  for update to authenticated
  using (lower(user_email) = lower(auth.jwt() ->> 'email'))
  with check (lower(user_email) = lower(auth.jwt() ->> 'email'));

create policy "push_subscriptions_delete_own" on public.push_subscriptions
  for delete to authenticated
  using (lower(user_email) = lower(auth.jwt() ->> 'email'));

-- Homecoming / event check-in (QR opens site with ?checkin=EVENT_ID)
create table if not exists public.event_checkins (
  event_id bigint not null references public.events(id) on delete cascade,
  user_email text not null,
  user_name text,
  checked_at timestamptz default now(),
  primary key (event_id, user_email)
);

alter table public.event_checkins enable row level security;

drop policy if exists "event_checkins_select" on public.event_checkins;
drop policy if exists "event_checkins_insert" on public.event_checkins;

create policy "event_checkins_select" on public.event_checkins
  for select to authenticated using (true);

create policy "event_checkins_insert" on public.event_checkins
  for insert to authenticated
  with check (lower(user_email) = lower(auth.jwt() ->> 'email'));

-- Optional email notification preference on profile
alter table public.alumni_profiles add column if not exists email_notify boolean default true;
