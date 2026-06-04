-- Round 2: batch channels, UTC memories, message batch_name
-- Run once in Supabase SQL Editor (after private-inbox.sql)

-- ---------- Batch channel on messages ----------
alter table public.messages add column if not exists batch_name text;

create or replace function public.auth_user_batch_name()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select batch_name from public.alumni_profiles
  where lower(email) = lower(auth.jwt() ->> 'email')
  limit 1;
$$;

create or replace function public.batch_names_equivalent(a text, b text)
returns boolean
language sql
immutable
as $$
  select lower(trim(coalesce(a, ''))) = lower(trim(coalesce(b, '')))
     or (
       lower(trim(coalesce(a, ''))) in ('2013 eminent', '2013 emminent')
       and lower(trim(coalesce(b, ''))) in ('2013 eminent', '2013 emminent')
     );
$$;

drop policy if exists "messages_select" on public.messages;
drop policy if exists "messages_insert" on public.messages;

create policy "messages_select" on public.messages
  for select to authenticated
  using (
    public.is_utc_admin()
    or (
      coalesce(hidden, false) = false
      and (
        (
          recipient_email is not null
          and (
            lower(author_email) = lower(auth.jwt() ->> 'email')
            or lower(recipient_email) = lower(auth.jwt() ->> 'email')
          )
        )
        or (
          recipient_email is null
          and batch_name is null
        )
        or (
          recipient_email is null
          and batch_name is not null
          and public.batch_names_equivalent(batch_name, public.auth_user_batch_name())
        )
      )
    )
  );

create policy "messages_insert" on public.messages
  for insert to authenticated
  with check (
    lower(author_email) = lower(auth.jwt() ->> 'email')
    and (
      (
        recipient_email is not null
        and lower(recipient_email) <> lower(auth.jwt() ->> 'email')
      )
      or (
        recipient_email is null
        and batch_name is null
      )
      or (
        recipient_email is null
        and batch_name is not null
        and (
          public.is_utc_admin()
          or public.batch_names_equivalent(batch_name, public.auth_user_batch_name())
        )
      )
    )
  );

-- ---------- UTC Memory / throwback ----------
create table if not exists public.utc_memories (
  id bigint generated always as identity primary key,
  image_url text not null,
  caption text,
  story text,
  active boolean default true,
  pinned boolean default false,
  author_name text not null,
  author_email text not null,
  created_at timestamptz default now()
);

alter table public.utc_memories enable row level security;

drop policy if exists "utc_memories_select" on public.utc_memories;
drop policy if exists "utc_memories_insert" on public.utc_memories;
drop policy if exists "utc_memories_update" on public.utc_memories;
drop policy if exists "utc_memories_delete" on public.utc_memories;

create policy "utc_memories_select" on public.utc_memories
  for select using (active = true);

create policy "utc_memories_insert" on public.utc_memories
  for insert to authenticated
  with check (public.is_utc_admin() or public.is_utc_officer());

create policy "utc_memories_update" on public.utc_memories
  for update to authenticated
  using (public.is_utc_admin() or public.is_utc_officer())
  with check (public.is_utc_admin() or public.is_utc_officer());

create policy "utc_memories_delete" on public.utc_memories
  for delete to authenticated
  using (public.is_utc_admin());
