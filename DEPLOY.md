# Deploy to Vercel

This project is configured for instant deployment to Vercel.

## Option 1: Deploy via GitHub (Recommended)

1. Push this folder to a GitHub repository:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: SilentCapure download page"
   git remote add origin https://github.com/YOUR_USERNAME/silentcapure.git
   git branch -M main
   git push -u origin main
   ```

2. Go to [Vercel Dashboard](https://vercel.com/dashboard)

3. Click **"Add New Project"** → **"Import Project"**

4. Paste your GitHub repo URL and click **Import**

5. Vercel auto-detects it's a static site. Click **Deploy** — done!

6. Your site is live. Share the URL and users can click "Save ScreenRecord.ps1" to download.

## Option 2: Deploy via Vercel CLI

1. Install the Vercel CLI:
   ```powershell
   npm i -g vercel
   ```

2. From this folder, run:
   ```powershell
   vercel
   ```

3. Follow the prompts:
   - Link to a new Vercel project (or existing)
   - Confirm the project name and settings
   - Deploy

4. Vercel provides your live URL instantly.

## Option 3: Deploy via Vercel UI (Drag & Drop)

1. Go to [Vercel Dashboard](https://vercel.com/dashboard)
2. Drag this folder into the dashboard, or use **Add New Project** → **File Upload**
3. Click **Deploy**

---

## Files in this project

- **index.html** — The download page UI (static)
- **ScreenRecord.ps1** — The PowerShell script (served as a downloadable file)
- **vercel.json** — Vercel configuration (handles routing, headers, and file serving)
- **package.json** — Project metadata (minimal, only for Vercel context)
- **README.md** — This file

---

## How it works

1. User opens your Vercel domain (e.g., `silentcapure.vercel.app`)
2. Sees the download page with a "Save ScreenRecord.ps1" button
3. Clicks the button → browser downloads `ScreenRecord.ps1`
4. If browser blocks the download, a direct link is shown as fallback

---

## Customization (Optional)

Edit the project name in **vercel.json** and **package.json** if desired, but it's not required for deployment.

---

**That's it!** Once deployed, share your Vercel URL with anyone who needs the script. One click saves the file.
