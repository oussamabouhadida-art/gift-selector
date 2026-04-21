# A Little Surprise for Ignacio

Private gift-poll + contribution page. Static HTML, Supabase for storage, Razorpay (hosted link) for contributions. Deploys to Vercel with zero build config.

## Files

```
site/
├── index.html       ← public voting page
├── admin.html       ← PIN-protected dashboard (you only)
├── config.js        ← your keys + admin PIN
├── schema.sql       ← Supabase table + RLS policies
├── .gitignore
└── README.md
```

## Setup — 10 minutes

### 1. Supabase

1. Create a project at https://supabase.com (free tier is fine).
2. In the SQL editor, paste and run the contents of `schema.sql`.
3. Copy your **Project URL** and **anon public key** from Project Settings → API.

### 2. Razorpay payment link

1. In Razorpay Dashboard → Payment Links → **Create payment link**.
2. Description: `Ignacio — collective gift`.
3. Amount: leave flexible or set a suggested amount.
4. Copy the generated link (looks like `https://rzp.io/l/xxxxxx`).

### 3. Fill in `config.js`

```js
window.SUPABASE_URL  = "https://YOUR-PROJECT.supabase.co";
window.SUPABASE_ANON = "YOUR-ANON-KEY";
window.ADMIN_PIN     = "pick-a-strong-pin";   // used to unlock admin.html
```

Then in `index.html`, find the line near the top of the `<script>`:

```js
const CONTRIBUTION_URL = "https://rzp.io/your-razorpay-link-here";
```

Replace with your Razorpay link.

### 4. Deploy on Vercel

**Option A — Claude Code Desktop**
Your Vercel is already connected. Just ask Claude Code to:
> "Push this `site/` folder to a new GitHub repo and deploy it on Vercel as a static site."

**Option B — Manual**
1. Push this folder to a GitHub repo.
2. In Vercel → Add New → Project → Import the repo.
3. Framework preset: **Other** (it's a static site, no build needed).
4. Root Directory: `site`.
5. Deploy. You get a URL like `https://ignacio.vercel.app`.

Your admin page is at `https://ignacio.vercel.app/admin.html`.

## Security notes

- The anon key is safe to commit. Row Level Security (see `schema.sql`) prevents abuse.
- The PIN is **client-side only** — fine for a private poll shared by link, but not bank-grade. Anyone determined could read it by inspecting the source. For a stronger lock, switch to Supabase Auth magic links.
- Razorpay handles all payment data. The site never touches card/bank info.
- No voter authentication = anyone with the link can vote (once per submit). That's intentional for frictionless collegial voting.

## Editing the gift options

`index.html` and `admin.html` both have a `GIFT_OPTIONS` array near the top of their `<script>`. Keep the `id`s in sync between the two files so the admin dashboard labels votes correctly.

## Changing the admin PIN later

Edit `config.js` → commit → Vercel redeploys automatically.

---
*Con cariño.*
