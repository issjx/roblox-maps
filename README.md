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

## AI map studio (Claude Code)

Open Claude Code in this folder and type:

| Command | What happens |
|---|---|
| `/new-map lava-run "lava obby with moving bridges"` | idea → **you approve** → layout → build + scripts → polish → checker → pull request |
| `/improve-map lava-run "make stage 3 harder"` | the right agents change it, checker reviews, PR |
| `/maps` | status board: every map, owner, PR, CI |

Team (in `.claude/agents/`): **idea-generator**, **level-designer**, **checker** on Fable 5.2 (auto-fallback
to Opus 5.5); **map-builder**, **gameplay-scripter**, **polish** on Sonnet 5.5. Maps are built *by code*
(`maps/<name>/build.luau` + `tools/MapKit.luau`) and CI checks every jump is physically possible.
Agents never touch `main` or publish — you approve the PR and publish. Details: [CLAUDE.md](CLAUDE.md).

## The rules in one line

`main` is protected: **nobody pushes to it** — every change is a branch → pull request → green
`CI passed` → one approval from the other person → squash-merge.
