-- Private inbox — run once in Supabase SQL Editor (after tier3-features.sql)
-- Public board: recipient_email IS NULL (everyone signed in can read)
-- Private inbox: only sender, recipient, or admin can read

drop policy if exists "messages_select" on public.messages;
drop policy if exists "messages_insert" on public.messages;

create policy "messages_select" on public.messages
  for select to authenticated
  using (
    public.is_utc_admin()
    or (
      coalesce(hidden, false) = false
      and (
        recipient_email is null
        or lower(author_email) = lower(auth.jwt() ->> 'email')
        or lower(recipient_email) = lower(auth.jwt() ->> 'email')
      )
    )
  );

create policy "messages_insert" on public.messages
  for insert to authenticated
  with check (
    lower(author_email) = lower(auth.jwt() ->> 'email')
    and (
      recipient_email is null
      or (
        recipient_email is not null
        and lower(recipient_email) <> lower(auth.jwt() ->> 'email')
      )
    )
  );
