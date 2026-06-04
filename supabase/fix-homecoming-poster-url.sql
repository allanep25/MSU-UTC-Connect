-- Run once so the Homecoming event always has the live poster URL

update public.events
set photo_urls = 'https://utc.marawionline.com/assets/ads/homecoming-2026.png'
where lower(title) like '%homecoming%'
  and lower(title) not like '%fun run%';

update public.events
set photo_urls = 'https://utc.marawionline.com/assets/ads/fun-run-2026.jpg'
where lower(title) like '%fun run%';
