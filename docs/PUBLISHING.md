# Publishing a map to Roblox

What's live on Roblox is always what's in `main`: publishing happens from GitHub Actions, never
from someone's Studio.

## Once per map

1. Create the experience: Studio → *File → Publish to Roblox* **once** (creates the experience/place),
   or create it on [create.roblox.com](https://create.roblox.com).
2. Copy the IDs from create.roblox.com → your experience → the `⋯` menu → *Copy Universe ID*, and the
   start place → *Copy Place ID*.
3. Put them in `maps/<name>/map.json` (`universeId`, `placeId`) in a PR.
4. If the experience is owned by a **group**, both of you can own it there — recommended so the game
   doesn't belong to one account.

## Once per repository

1. [create.roblox.com → Open Cloud → API Keys](https://create.roblox.com/dashboard/credentials) →
   **Create API Key**:
   - Access permissions → **universe-places** → add each experience → **write**
   - Accepted IP addresses: `0.0.0.0/0` (GitHub runners have no fixed IP)
   - Set an expiry and a calendar reminder to rotate it.
2. GitHub → **Settings → Secrets and variables → Actions → New repository secret**
   `ROBLOX_API_KEY` = the key.
3. GitHub → **Settings → Environments → New environment** `roblox-production` →
   **Required reviewers**: both of you. Every publish then waits for a click.

## Publish

GitHub → **Actions → Publish map → Run workflow** (branch `main`) → map name → Run.
It validates, builds `build/<map>.rbxl` with Rojo, waits for approval, and uploads it as a new
published version. Then set `"status": "published"` in `map.json`.

Rolling back: create.roblox.com → the place → *Version History* → restore, then fix forward in a PR.
