# MSU-UTC Connect

Single-page alumni social platform (`index.html`) with Tailwind UI, Supabase auth/data, and GitHub Pages deployment.

## Quick start (local)

1. Set up Supabase (see below).
2. Open `index.html` in a browser (or use Live Server).
3. **Create Account** → verify email if required → **Sign In**.
4. Post a testimonial; sign in as an admin email to approve it and add events.

## Supabase setup

1. Open [Supabase](https://supabase.com) and use the project whose URL/key match `index.html` (or update those constants).
2. In **SQL Editor**, paste and run [`supabase/schema.sql`](supabase/schema.sql).
3. In **Authentication → Providers → Email**, turn off **Confirm email** for easier local testing (optional).
4. In **Storage**, create a public bucket named `avatars`.
5. In **Database → Replication**, confirm `messages` is enabled for realtime (the schema adds it to `supabase_realtime`).

### Tables

`alumni_profiles`, `connections`, `events`, `event_rsvps`, `messages`, `invites`, `testimonials`

### Admin accounts

Use these emails when registering (or in Auth) to unlock the **Admin & Moderation** panel:

- `admin@msu.edu`
- `founder@msu.edu`
- `realtytrail@gmail.com`

## Deployment (GitHub Pages)

1. Push to the `master` branch.
2. `.github/workflows/deploy.yml` publishes to `gh-pages`.
3. In GitHub: **Settings → Pages** → source branch `gh-pages`.
4. Live URL: `https://<username>.github.io/MSU-UTC-Connect/` (see `CNAME` if you use a custom domain).

## Security notes

- The Supabase **publishable/anon** key in `index.html` is expected to be public; do not put service-role keys in the client.
- RLS in `schema.sql` is a starting point; tighten policies before a production launch.
- Replace CDN Tailwind with a build step when you harden for production.

## Logo

Place your official logo in the project as:

- **`assets/logo.png`** (recommended, square or transparent PNG), or
- Replace **`assets/logo.svg`** with your own SVG.

The app shows `logo.png` first and falls back to `logo.svg` if the PNG is missing.

## Files

| File | Purpose |
|------|---------|
| `assets/logo.png` | Your official logo (add this file) |
| `assets/logo.svg` | Default placeholder until PNG is added |
| `index.html` | Full app UI and logic |
| `supabase/schema.sql` | Database tables, seed events, RLS, realtime |
| `.github/workflows/deploy.yml` | GitHub Pages deploy |
