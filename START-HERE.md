# Start here (simple)

## Use the app (you are ready if you already ran the database script)

1. Double-click **`index.html`**
2. **Sign In** with your email and password
3. **Personalize Profile** → pick a photo → **Save Profile**

**Profile photos** save automatically in your profile (no Storage bucket or extra SQL required).

The `avatars` Storage bucket in Supabase is **optional** (only for larger teams later).

---

## If you have not run the database yet (one-time)

1. Go to [supabase.com](https://supabase.com) → your project → **SQL Editor**
2. Copy all of **`supabase/finish-setup.sql`** → paste → **Run** → Success
3. **Authentication** → **Providers** → **Email** → turn **Confirm email** OFF → Save

---

## Problems?

| Issue | Fix |
|-------|-----|
| Can't sign in / registration seems to fail | **Authentication** → **Providers** → **Email** → turn **Confirm email** **OFF** → Save, then register or sign in again |
| Email already registered | Use **Sign In** instead of Create Account |
| Photo won't save | Sign in first, then Personalize Profile → Save |
| Registration error | Run `finish-setup.sql` |
| Officer designation or Message fails | Run **`supabase/run-pending-migrations.sql`** once in SQL Editor (copies both fixes) |
| Feedback, social links, event edit | Run **`supabase/tier1-features.sql`** once in SQL Editor |
| Batch news, jobs board, locations, privacy | Run **`supabase/tier2-features.sql`** once in SQL Editor (after tier 1) |

---

## Live site shows “Not secure” (red badge, https crossed out)?

The site is still using GitHub’s **\*.github.io** certificate instead of one for **utc.marawionline.com**. Fix it in GitHub (not in code):

1. Open **https://github.com/allanep25/MSU-UTC-Connect/settings/pages**
2. Set custom domain to `utc.marawionline.com` → **Save**
3. Wait for **DNS** and **certificate** green checks, then enable **Enforce HTTPS**
4. If stuck: **Remove** the domain, wait 5 minutes, add it again

Full steps: **`docs/fix-https-custom-domain.md`**

**Temporary safe link:** https://allanep25.github.io/MSU-UTC-Connect/

Do **not** open `index.html` from File Explorer — that always shows “Not secure” (`file://`).

---

## Optional later

- Storage bucket `avatars` + `storage-avatars.sql` (not required for photos now)
