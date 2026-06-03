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
| Can't sign in | Confirm email OFF in Supabase Auth |
| Photo won't save | Sign in first, then Personalize Profile → Save |
| Registration error | Run `finish-setup.sql` |

---

## Optional later

- Storage bucket `avatars` + `storage-avatars.sql` (not required for photos now)
- GitHub Pages to put the site online
