-- Run once in Supabase SQL Editor (after creating the "avatars" bucket in Storage UI)
-- Fixes: profile picture upload fails / nothing appears in Storage

insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do update set public = true;

do $$ begin
  create policy "avatars_public_read" on storage.objects for select using (bucket_id = 'avatars');
exception when duplicate_object then null; end $$;

do $$ begin
  create policy "avatars_auth_insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'avatars');
exception when duplicate_object then null; end $$;

do $$ begin
  create policy "avatars_auth_update" on storage.objects for update to authenticated
  using (bucket_id = 'avatars');
exception when duplicate_object then null; end $$;

do $$ begin
  create policy "avatars_auth_delete" on storage.objects for delete to authenticated
  using (bucket_id = 'avatars');
exception when duplicate_object then null; end $$;
