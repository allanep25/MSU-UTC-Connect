-- Tier 2 community features — run once in Supabase SQL Editor

-- Profile: location + privacy
alter table public.alumni_profiles add column if not exists city text;
alter table public.alumni_profiles add column if not exists country text;
alter table public.alumni_profiles add column if not exists hide_contact boolean default false;

-- Events: photo gallery (comma-separated image URLs)
alter table public.events add column if not exists photo_urls text;

-- Batch-specific announcements
create table if not exists public.batch_announcements (
  id bigint generated always as identity primary key,
  batch_name text not null,
  title text not null,
  body text not null,
  author_name text not null,
  author_email text not null,
  created_at timestamptz default now()
);

-- Jobs & opportunities
create table if not exists public.job_posts (
  id bigint generated always as identity primary key,
  title text not null,
  body text not null,
  category text default 'other',
  batch_name text,
  author_name text not null,
  author_email text not null,
  active boolean default true,
  created_at timestamptz default now()
);

alter table public.batch_announcements enable row level security;
alter table public.job_posts enable row level security;

drop policy if exists "batch_announcements_select" on public.batch_announcements;
drop policy if exists "batch_announcements_insert" on public.batch_announcements;
drop policy if exists "batch_announcements_delete" on public.batch_announcements;

create policy "batch_announcements_select" on public.batch_announcements for select to authenticated using (true);
create policy "batch_announcements_insert" on public.batch_announcements for insert to authenticated with check (true);
create policy "batch_announcements_delete" on public.batch_announcements for delete to authenticated using (true);

drop policy if exists "job_posts_select" on public.job_posts;
drop policy if exists "job_posts_insert" on public.job_posts;
drop policy if exists "job_posts_update" on public.job_posts;
drop policy if exists "job_posts_delete" on public.job_posts;

create policy "job_posts_select" on public.job_posts for select using (active = true or auth.role() = 'authenticated');
create policy "job_posts_insert" on public.job_posts for insert to authenticated with check (true);
create policy "job_posts_update" on public.job_posts for update to authenticated using (true);
create policy "job_posts_delete" on public.job_posts for delete to authenticated using (true);
