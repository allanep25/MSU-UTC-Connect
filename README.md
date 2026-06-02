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

## Deployment
This project can be deployed as a static site using GitHub Pages.

1. Commit and push your changes to the `master` branch.
2. The workflow in `.github/workflows/deploy.yml` will publish the repository contents to the `gh-pages` branch automatically.
3. In GitHub, enable Pages in `Settings > Pages` and choose the `gh-pages` branch as the source.
4. Your live site URL will typically be `https://<your-username>.github.io/MSU-UTC-Connect/`.

> Note: Because this app uses a public Supabase anon key in client-side code, it is fine for frontend access but not for secrets. For a production-ready release, consider moving Supabase operations to a server or proxy.
