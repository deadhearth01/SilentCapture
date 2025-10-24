# SilentCapure — Simple static download page

This is a small static site that lets you download `ScreenRecord.ps1` with one click.

Files added:

- `index.html` — Web UI with a single "Save" button that triggers download of `ScreenRecord.ps1`.
- `ScreenRecord.ps1` — (already present in this folder) the PowerShell script that will be downloaded.

Quick notes on usage and deployment

1) Local preview

 - You can open `index.html` in your browser directly (double-click). For best results serve the folder with a local static server so the download attribute works reliably.

2) Deploy to Vercel (recommended)

 - Option A — GitHub
   1. Commit this folder to a GitHub repository.
   2. In Vercel, "Import Project" → pick the repo → Deploy.

 - Option B — Vercel CLI
   1. Install the Vercel CLI: `npm i -g vercel`
   2. Run `vercel` in this folder and follow prompts.

After deployment, open the site root. Click the "Save ScreenRecord.ps1" button — the browser should start saving `ScreenRecord.ps1` to your Downloads folder.

Troubleshooting

- If the download does not start automatically, use the direct link shown on the page ("Direct download: ScreenRecord.ps1").
- Some browsers may block downloads triggered by scripts depending on security settings. In that case right-click the direct link and choose "Save link as...".

Privacy & security

 - This page is a static download only; no server-side code is required.
