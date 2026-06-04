-- Run once if alumni were stuck as "pending" after tier3-features.sql
-- Opens the directory to everyone (free registration, no approval gate)

update public.alumni_profiles
set verification_status = 'approved'
where coalesce(verification_status, 'pending') <> 'approved';

drop policy if exists "alumni_profiles_select" on public.alumni_profiles;
create policy "alumni_profiles_select" on public.alumni_profiles
  for select using (true);
