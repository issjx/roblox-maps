# Building a map, step by step

Studio is where you build; the repo is where the map lives. Rojo connects the two.

## 1. Start

```powershell
powershell -ExecutionPolicy Bypass -File scripts\new-map.ps1 lava-run "Lava Run"
```
Creates `maps/lava-run/` from the template and switches to branch `map/lava-run`.
(Working on an existing map instead? GitHub Desktop → *Current branch → New branch* from `main`,
named `map/<name>-<what>`.)

## 2. Open it in Studio

```powershell
rojo build maps\lava-run -o build\lava-run.rbxl
start build\lava-run.rbxl
```
Optional live-sync of scripts: `rojo serve maps\lava-run`, then Studio → Plugins → **Rojo → Connect**.
Edits to `.luau` files in VS Code then appear in Studio instantly.

## 3. Build

- All geometry goes **inside `Workspace.Map`** (the Model). Anything outside it is not saved.
- Checkpoints: parts named `Stage1`, `Stage2`, ... inside `Map/Checkpoints` — the shared server
  script handles leaderstats and respawning automatically.
- Need a script? Create it as a file in `maps/lava-run/scripts/` (or `src/` if every map should
  get it) — **never inside the Map**. CI rejects maps that contain scripts.
- Toolbox / free models: check them for hidden scripts before using — that's the classic backdoor.

## 4. Save the map back to the repo

In Studio **Explorer → right-click `Workspace.Map` → Save to File… →**
`Documents\GitHub\roblox-maps\maps\lava-run\Map.rbxmx` (overwrite; keep the **.rbxmx** type).

Don't save the whole place (`.rbxl`) into the repo — `build/` and `.rbxl` files are ignored on purpose.

## 5. Commit and push (GitHub Desktop)

1. Check the changed files: `Map.rbxmx` and anything in `scripts/`.
2. Summary like `lava-run: stages 1-4`, **Commit to map/lava-run**.
3. **Push origin** — the pre-push hook runs every check first (~10 s).
4. **Create Pull Request** → fill in the template → the other person reviews.

Commit often (every working session). A pushed branch is your backup.

## 6. Review and merge

The reviewer opens the PR → **Checks → CI → Artifacts → places**, downloads the `.rbxl`, plays it.
Approve → **Squash and merge** → delete branch. Then everyone: GitHub Desktop → switch to `main` →
**Fetch / Pull**.

## Why not just share the place file?

Two people editing one place file means the last save wins. Here, each map has one owner, every
change is reviewable, CI catches broken maps, and any old version can be restored from history.
