-- Optional: run in Supabase SQL Editor if you still see old sample events
-- (from an earlier version of the setup script)

delete from public.events
where title in (
  'End of Term Party',
  'Career Networking Breakfast',
  'Virtual Mentoring Session'
);
