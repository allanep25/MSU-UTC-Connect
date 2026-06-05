# Push notifications & email setup

The app can send **Web Push** (phone alerts when the app is closed) and **email** (Resend) after you deploy one Edge Function.

## 1. Run SQL

In Supabase SQL Editor, run:

`supabase/push-email-homecoming.sql`

## 2. Generate VAPID keys (push)

On your computer (Node.js installed):

```bash
npx web-push generate-vapid-keys
```

Copy the **public** and **private** keys.

## 3. Deploy Edge Function

Install [Supabase CLI](https://supabase.com/docs/guides/cli), link your project, then:

```bash
cd "path/to/MSU-UTC Connect"
supabase functions deploy notify-alumni --no-verify-jwt
```

In Supabase Dashboard → **Edge Functions** → **notify-alumni** → **Secrets**, add:

| Secret | Value |
|--------|--------|
| `VAPID_PUBLIC_KEY` | From step 2 |
| `VAPID_PRIVATE_KEY` | From step 2 |
| `RESEND_API_KEY` | From [resend.com](https://resend.com) (optional, for email) |
| `RESEND_FROM` | e.g. `MSU-UTC Connect <notify@yourdomain.com>` (must be verified in Resend) |

`SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` are usually set automatically.

## 4. Paste public VAPID key in the app

Open `index.html` and set:

```javascript
const VAPID_PUBLIC_KEY = 'YOUR_PUBLIC_KEY_HERE';
```

Commit and push so the live site can subscribe devices.

## 5. Test

1. Sign in on your phone (or Chrome).
2. Tap **🔔** → **Enable push & alerts**.
3. Send yourself a DM from another account — you should get a push and/or email.

## What sends automatically

| Event | Push | Email |
|-------|------|-------|
| New private DM | Yes (if subscribed) | Yes (if Resend configured) |
| Batch group chat | Yes (batchmates subscribed) | No |
| Officer “Email RSVPs” button | No | Yes (joined alumni) |

Without secrets, the app still works; only push/email are skipped.
