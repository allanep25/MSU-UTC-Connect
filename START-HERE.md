# Start here (simple)

## Use the app

1. Open **https://utc.marawionline.com** (or **https://allanep25.github.io/MSU-UTC-Connect/** if HTTPS is still pending)
2. **Sign In** → **Personalize Profile** → **Save Profile**

## HTTPS / “Not secure” in the browser?

Everything automatic is already in Git. **One click** on GitHub fixes the padlock:

→ Open **HTTPS-SETUP.md** (one checkbox: **Enforce HTTPS**)

## Database (one-time, if not done)

Run in Supabase SQL Editor, in order:

1. `supabase/finish-setup.sql`
2. `supabase/tier1-features.sql`
3. `supabase/tier2-features.sql`
4. `supabase/seed-community-announcements.sql` (optional ads/events)
5. `supabase/seed-homecoming-2026.sql` (homecoming poster)

Turn off **Confirm email** under Authentication → Email for easier sign-in.

## Problems?

| Issue | Fix |
|-------|-----|
| Can't sign in | Turn off **Confirm email** in Supabase |
| Red “Not secure” on the site | **HTTPS-SETUP.md** — check **Enforce HTTPS** |
| No events or posters | Run the SQL files above |
