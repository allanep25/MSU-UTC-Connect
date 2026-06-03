-- Run once if overview ads / events still point at .png paths

update public.overview_ads
set image = 'assets/ads/notable-alumni-nominations.jpg', updated_at = now()
where lower(title) like '%notable alumni%';

update public.overview_ads
set image = 'assets/ads/fun-run-2026.jpg', updated_at = now()
where lower(title) like '%fun run%';

update public.events
set photo_urls = 'assets/ads/fun-run-2026.jpg'
where lower(title) like '%fun run%';
