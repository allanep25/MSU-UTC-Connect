-- MSU-UTC Connect — run in Supabase SQL Editor (project must match index.html URL/key)
-- After running: Storage → create public bucket named "avatars" (or run storage section below)

-- ============ TABLES ============

create table if not exists public.alumni_profiles (
  id bigint generated always as identity primary key,
  email text not null unique,
  name text,
  avatar text,
  title text,
  company text,
  summary text,
  role text,
  grad_year text,
  batch_name text,
  skills text,
  badges text,
  status text,
  updated_at timestamptz default now()
);

create table if not exists public.connections (
  id bigint generated always as identity primary key,
  owner_email text not null,
  batchmate_id bigint not null references public.alumni_profiles(id) on delete cascade,
  connected_at timestamptz default now(),
  unique (owner_email, batchmate_id)
);

create table if not exists public.events (
  id bigint generated always as identity primary key,
  title text not null,
  date text not null,
  time text,
  location text,
  description text
);

create table if not exists public.event_rsvps (
  id bigint generated always as identity primary key,
  event_id bigint not null references public.events(id) on delete cascade,
  user_email text not null,
  response text not null check (response in ('yes', 'maybe', 'no')),
  updated_at timestamptz default now(),
  unique (event_id, user_email)
);

create table if not exists public.messages (
  id bigint generated always as identity primary key,
  author_name text not null,
  author_email text not null,
  content text not null,
  created_at timestamptz default now()
);

create table if not exists public.invites (
  id bigint generated always as identity primary key,
  email text not null,
  invited_by text not null,
  invite_link text,
  status text default 'sent',
  invited_at timestamptz default now()
);

create table if not exists public.testimonials (
  id bigint generated always as identity primary key,
  author_name text not null,
  author_email text not null,
  message_content text not null,
  category text default 'professional',
  likes int default 0,
  approved boolean default false,
  featured boolean default false,
  created_at timestamptz default now()
);

-- ============ REALTIME (message board) ============

alter publication supabase_realtime add table public.messages;

-- ============ ROW LEVEL SECURITY ============

alter table public.alumni_profiles enable row level security;
alter table public.connections enable row level security;
alter table public.events enable row level security;
alter table public.event_rsvps enable row level security;
alter table public.messages enable row level security;
alter table public.invites enable row level security;
alter table public.testimonials enable row level security;

-- Profiles: directory is public read; signed-in users manage their own row
create policy "alumni_profiles_select" on public.alumni_profiles for select using (true);
create policy "alumni_profiles_insert" on public.alumni_profiles for insert to authenticated, anon with check (true);
create policy "alumni_profiles_update" on public.alumni_profiles for update to authenticated
  using ((auth.jwt() ->> 'email') = email)
  with check ((auth.jwt() ->> 'email') = email);

-- Connections: only your own network list
create policy "connections_select" on public.connections for select to authenticated
  using ((auth.jwt() ->> 'email') = owner_email);
create policy "connections_insert" on public.connections for insert to authenticated
  with check ((auth.jwt() ->> 'email') = owner_email);
create policy "connections_delete" on public.connections for delete to authenticated
  using ((auth.jwt() ->> 'email') = owner_email);

-- Events: public read; authenticated can add (admin UI in app)
create policy "events_select" on public.events for select using (true);
create policy "events_insert" on public.events for insert to authenticated with check (true);

-- RSVPs: your own responses
create policy "event_rsvps_select" on public.event_rsvps for select to authenticated
  using ((auth.jwt() ->> 'email') = user_email);
create policy "event_rsvps_upsert" on public.event_rsvps for insert to authenticated
  with check ((auth.jwt() ->> 'email') = user_email);
create policy "event_rsvps_update" on public.event_rsvps for update to authenticated
  using ((auth.jwt() ->> 'email') = user_email);

-- Messages: public read; signed-in post
create policy "messages_select" on public.messages for select using (true);
create policy "messages_insert" on public.messages for insert to authenticated with check (true);

-- Invites
create policy "invites_select_own" on public.invites for select to authenticated
  using ((auth.jwt() ->> 'email') = invited_by);
create policy "invites_select_admin" on public.invites for select to authenticated
  using ((auth.jwt() ->> 'email') in ('admin@msu.edu', 'founder@msu.edu'));
create policy "invites_insert" on public.invites for insert to authenticated with check (true);

-- Testimonials: public sees approved; authors and admins see pending via app
create policy "testimonials_select" on public.testimonials for select using (approved = true or auth.role() = 'authenticated');
create policy "testimonials_insert" on public.testimonials for insert to authenticated with check (true);
create policy "testimonials_update" on public.testimonials for update to authenticated using (true);
create policy "testimonials_delete" on public.testimonials for delete to authenticated using (true);

-- ============ STORAGE (avatars bucket) ============
-- In Dashboard: Storage → New bucket → name "avatars" → Public bucket
-- Or run policies after creating the bucket:

-- insert into storage.buckets (id, name, public) values ('avatars', 'avatars', true) on conflict do nothing;

-- create policy "avatars_public_read" on storage.objects for select using (bucket_id = 'avatars');
-- create policy "avatars_auth_upload" on storage.objects for insert to authenticated
--   with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = (auth.jwt() ->> 'email'));
