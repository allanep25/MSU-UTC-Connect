-- Optional: run if anyone registered with the old misspelling
update public.alumni_profiles
set batch_name = '2013 EMINENT'
where batch_name = '2013 EMMINENT';
