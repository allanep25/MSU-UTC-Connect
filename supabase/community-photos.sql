-- Community photo slideshow — run once in Supabase SQL Editor
-- Uses the existing public "avatars" Storage bucket (uploads go under gallery/)

create table if not exists public.community_photos (
  id bigint generated always as identity primary key,
  image_url text not null,
  caption text,
  author_name text not null,
  author_email text not null,
  active boolean default true,
  created_at timestamptz default now()
);

alter table public.community_photos enable row level security;

drop policy if exists "community_photos_select" on public.community_photos;
drop policy if exists "community_photos_insert" on public.community_photos;
drop policy if exists "community_photos_delete_own" on public.community_photos;

create policy "community_photos_select" on public.community_photos
  for select using (active = true);

create policy "community_photos_insert" on public.community_photos
  for insert to authenticated with check (true);

create policy "community_photos_delete_own" on public.community_photos
  for delete to authenticated using (author_email = (auth.jwt() ->> 'email'));
