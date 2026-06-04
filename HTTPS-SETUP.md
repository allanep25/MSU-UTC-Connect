# HTTPS setup — almost everything is automatic

## What is already done for you (in Git)

- Site files on **master** → GitHub publishes automatically
- Custom domain **utc.marawionline.com** in the repo (`CNAME` file)
- Workflow **Deploy to GitHub Pages** runs on every push and tries to turn on **Enforce HTTPS**
- Posters, events, and app code are on GitHub

You already set **Workflow permissions → Read and write**. Good.

## One step only you can do (about 10 seconds)

GitHub will not let a robot click your **Enforce HTTPS** checkbox. You must be signed in as **allanep25**.

1. Open: **https://github.com/allanep25/MSU-UTC-Connect/settings/pages**
2. Turn on **Enforce HTTPS** (checkbox under your domain).
3. Click **Save** if there is a Save button.
4. Open: **https://utc.marawionline.com** (must start with `https://`).

That removes the red **Not secure** badge.

## If the checkbox is grayed out

Wait 1–24 hours (certificate still generating). DNS is already green on your screenshot.

Then try again, or run **Actions** → **Deploy to GitHub Pages** → **Run workflow**.

## Safe link until then

**https://allanep25.github.io/MSU-UTC-Connect/** — always secure.

## You can ignore

- Old failed Action runs (red X) — they used the wrong API; new runs use `github-script`
- The `gh-pages` branch — your live site uses **master**, not `gh-pages`
