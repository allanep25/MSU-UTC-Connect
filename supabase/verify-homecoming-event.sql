-- Check events on the board (run in Supabase SQL Editor)

select id, title, date, time, location, photo_urls
from public.events
order by date asc;
