# NextHome People First — Agent Portal

A simple, hosted portal for your agents: shared training videos, documents, a
team message board, quick tools, and a private closing/GCI tracker for each agent.

## What's in this folder
- **index.html** — the whole portal (the screen your agents see).
- **config.js** — where your two Supabase connection values go.
- **supabase-setup.sql** — the database setup (run once, by copy-paste).
- **README.md** — this file.

## How it works (plain English)
- Agents **sign in** with an email + password.
- **Videos, documents, and the message board** are the SAME for everyone.
- Each agent's **closings and GCI goal** are PRIVATE to them.
- **You (admin)** can add videos/documents and pin announcements. Agents can't.

---

## Setup checklist (we do these together, one at a time)

### ✅ Step 1 — Build the portal  *(done)*

### ⬜ Step 2 — Create a Supabase project
1. Go to https://supabase.com and sign in.
2. Click **New project**. Name it `nexthome-portal`. Pick a region near Las Vegas
   (e.g. **West US**). Set a database password (save it somewhere).
3. When it finishes, open **Project Settings → API** and copy these two values:
   - **Project URL**
   - **anon public** key
4. Paste them into `config.js`.

### ⬜ Step 3 — Set up the database
1. In Supabase, open the **SQL Editor** → **New query**.
2. Open `supabase-setup.sql`, copy ALL of it, paste it in, click **Run**.

### ⬜ Step 4 — Create your login + make yourself admin
1. In Supabase, go to **Authentication → Users → Add user**.
2. Enter your email + a password. (Check "Auto Confirm User".)
3. Re-run the last few lines of `supabase-setup.sql` (the "MAKE YOURSELF AN ADMIN"
   part) so your account becomes an admin.
4. Add each agent the same way (Add user). They sign in with that email/password.

### ⬜ Step 5 — Put it online (Vercel)
We'll do this last so your agents can reach it from any device.

---

## Running it on your computer (to test)
Open a terminal in this folder and run:

    npx serve .

Then open the address it prints (usually http://localhost:3000).
> Tip: just double-clicking index.html won't fully work because of the login —
> use the command above so it runs like a real website.
