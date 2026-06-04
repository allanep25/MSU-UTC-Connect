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
6. `supabase/community-photos.sql` (photo slideshow + alumni uploads)
7. `supabase/tier3-features.sql` (security, reports, verification, PWA tables)
8. `supabase/open-registration.sql` (only if tier 3 left alumni as pending — approves everyone)
9. `supabase/private-inbox.sql` (private inbox + public community board)
10. `supabase/message-likes.sql` (Like button on inbox & community messages)
11. `supabase/features-round2.sql` (batch channel, UTC memory, admin tools in app)

Turn off **Confirm email** under Authentication → Email for easier sign-in.

## Problems?

| Issue | Fix |
|-------|-----|
| Can't sign in | Turn off **Confirm email** in Supabase |
| Red “Not secure” on the site | **HTTPS-SETUP.md** — check **Enforce HTTPS** |
| No events or posters | Run the SQL files above |
| Report button or verification admin empty | Run `tier3-features.sql` |
| Install app on phone | Browser menu → Add to Home screen (after tier 3 deploy) |
| Private message not working | Run `private-inbox.sql`; message from Directory → profile → Message |
| Batch group chat empty / can’t post | Run `features-round2.sql`; set batch in Personalize Profile |
| UTC Memory or admin edit member missing | Run `features-round2.sql` |
| Fix old batch typo (e.g. EMMINENT) | Run `fix-2013-eminent.sql` or Admin → Edit member profile |
