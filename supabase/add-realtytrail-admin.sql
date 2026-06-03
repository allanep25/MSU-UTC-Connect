-- Optional: run once in Supabase SQL Editor so admin can see all invites in the dashboard
-- (App admin UI already works for testimonials; this updates database invite access)

drop policy if exists "invites_select_admin" on public.invites;

create policy "invites_select_admin" on public.invites for select to authenticated
  using ((auth.jwt() ->> 'email') in (
    'admin@msu.edu',
    'founder@msu.edu',
    'realtytrail@gmail.com'
  ));
