# Tier 3 — implemented

## Run in Supabase (once)

`supabase/tier3-features.sql`

## Features

| # | Feature | Status |
|---|---------|--------|
| 16 | Tighter RLS (messages, testimonials, events, directory) | SQL + app |
| 17 | Alumni verification (pending / approved) | SQL + app |
| 18 | Report & hide content | SQL + app |
| 19 | PWA (install on phone) | `manifest.webmanifest` + `sw.js` |
| 20 | Split codebase | Deferred — see below |

## Verification (currently off)

In `index.html`, `ALUMNI_VERIFICATION_ENABLED` is **`false`** — everyone can register and appear in the directory.

To turn verification on later: set that flag to `true` and run tier3 RLS as written.

If anyone was left as **pending**, run once: **`supabase/open-registration.sql`**

## Reports

- **Report** on Messages and Testimonials (signed in).
- **Admin → Content reports** — Hide post or Dismiss report.

## PWA

On mobile Chrome/Safari: browser menu → **Add to Home screen** / **Install app**.

## Code split (item 20)

`index.html` remains the main app file. Future split options:

- `js/auth.js`, `js/dashboard.js`, `js/admin.js` loaded as ES modules
- Or a small build step (Vite) when the file grows further
