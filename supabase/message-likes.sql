-- Message likes — run once in Supabase SQL Editor

create table if not exists public.message_likes (
  message_id bigint not null references public.messages(id) on delete cascade,
  user_email text not null,
  created_at timestamptz default now(),
  primary key (message_id, user_email)
);

alter table public.message_likes enable row level security;

drop policy if exists "message_likes_select" on public.message_likes;
drop policy if exists "message_likes_insert" on public.message_likes;
drop policy if exists "message_likes_delete" on public.message_likes;

create policy "message_likes_select" on public.message_likes
  for select to authenticated using (true);

create policy "message_likes_insert" on public.message_likes
  for insert to authenticated
  with check (lower(user_email) = lower(auth.jwt() ->> 'email'));

create policy "message_likes_delete" on public.message_likes
  for delete to authenticated
  using (lower(user_email) = lower(auth.jwt() ->> 'email'));
