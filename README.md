# Roblox Maps

Our Roblox maps — built in Roblox Studio, versioned on GitHub, checked by CI, published from `main`.

## Quick start (once per computer)

1. Install **Roblox Studio**, **GitHub Desktop**, and **VS Code** (optional, for scripts).
2. GitHub Desktop → *File → Clone repository* → this repo.
3. In the repo folder, open PowerShell and run:
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\setup.ps1
   ```
   This installs Rojo, StyLua, Selene, Lune (versions pinned in `rokit.toml`), the Rojo Studio
   plugin, VS Code extensions and the git hooks.

Then read **[CONTRIBUTING.md](CONTRIBUTING.md)** (the rules, 3 minutes) and
**[docs/MAP-WORKFLOW.md](docs/MAP-WORKFLOW.md)** (how to build a map, step by step).

## Layout

```
maps/
  _template/            copied for every new map
  <map-name>/
    map.json            name, owner, status, Roblox universe/place IDs
    Map.rbxmx           the geometry — Workspace.Map saved from Studio
    scripts/            scripts for this map only
    default.project.json  Rojo: shared code + scripts + Map.rbxmx -> a place
src/
  shared/               pure Luau shared by every map (tested in CI)
  server/               server scripts every map gets (checkpoints, leaderstats)
tests/                  Lune tests for src/shared
scripts/                setup, new-map, build, check, validate-maps
.github/                CI, publish workflow, templates, CODEOWNERS
```

## Everyday commands (PowerShell, repo root)

| Do | Command |
|---|---|
| New map + branch | `powershell -ExecutionPolicy Bypass -File scripts\new-map.ps1 lava-run` |
| Build a map into a place | `rojo build maps\lava-run -o build\lava-run.rbxl` |
| Live-sync scripts into Studio | `rojo serve maps\lava-run` + Rojo plugin → Connect |
| Run every check CI runs | `powershell -ExecutionPolicy Bypass -File scripts\check.ps1` |
| Fix formatting | `stylua src maps tests scripts` |

## The rules in one line

`main` is protected: **nobody pushes to it** — every change is a branch → pull request → green
`CI passed` → one approval from the other person → squash-merge.
