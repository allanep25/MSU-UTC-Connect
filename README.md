# MSU-UTC Connect

This project is a single-page alumni social platform built as a standalone HTML file.

## Files
- `index.html` — the complete app, including Tailwind UI, Supabase authentication, testimonial feed, and profile personalization.

## How to use
1. Open `index.html` in a browser.
2. Use the auth overlay to register or sign in.
3. Invite classmates, post a testimonial, and personalize the profile.

## Notes
- The app uses Tailwind CSS and Supabase via CDN.
- It currently expects a Supabase backend with a `testimonials` table.
- The page is ready for local use; for production, move dependencies off CDN and secure Supabase keys.
