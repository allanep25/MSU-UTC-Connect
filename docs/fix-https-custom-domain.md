# Fix “Not secure” on https://utc.marawionline.com

## What’s wrong

Your DNS is correct (`utc` → `allanep25.github.io`), but the site is still using GitHub’s **default** certificate (`*.github.io`), not one for **utc.marawionline.com**. Browsers then show **Not secure** and strike through **https**.

This is fixed in **GitHub Pages settings**, not in `index.html`.

## Automatic fix (from Git)

Every push to `master` runs the **Configure HTTPS** workflow. You can also run **Configure Pages HTTPS** manually from the Actions tab.

**Workflow permissions:** Settings → Actions → General → **Read and write** (you already did this).

**Publish source:** This repo uses the **`master`** branch for Pages (Settings → Pages → Deploy from branch). Pushes to `master` update the live site via GitHub’s **pages build and deployment** workflow.

## Fastest fix right now (your DNS is already green)

1. Open **https://github.com/allanep25/MSU-UTC-Connect/settings/pages**
2. Check **Enforce HTTPS** → **Save**
3. Visit **https://utc.marawionline.com** (not `http://`)

## Manual steps (if Actions cannot enable HTTPS yet)

1. Open: **https://github.com/allanep25/MSU-UTC-Connect/settings/pages**

2. Under **Custom domain**, enter exactly:
   ```
   utc.marawionline.com
   ```
   Click **Save**.

3. Wait until GitHub shows:
   - **DNS check** successful (green)
   - **Certificate** provisioned (green check next to the domain)

4. If the certificate stays on “Certificate: not yet created” for more than an hour:
   - Click **Remove** next to the custom domain
   - Wait 5 minutes
   - Enter `utc.marawionline.com` again and **Save** (this often unblocks provisioning)

5. When the certificate is ready, turn on **Enforce HTTPS**.

6. At your domain registrar (where `marawionline.com` is managed):
   - Keep **one** CNAME: `utc` → `allanep25.github.io`
   - If you use **Cloudflare**, set the `utc` record to **DNS only** (grey cloud), not **Proxied** (orange cloud), until HTTPS works.

7. Hard-refresh: **Ctrl+F5** on https://utc.marawionline.com

## Safe URL while the certificate is pending

Use the default GitHub Pages URL (valid HTTPS):

**https://allanep25.github.io/MSU-UTC-Connect/**

Posters still work at:

**https://utc.marawionline.com/assets/ads/homecoming-2026.png**  
(some browsers may warn until the main site certificate is fixed)

## After it works

You should see a normal padlock on `https://utc.marawionline.com` with no red “Not secure” badge.
