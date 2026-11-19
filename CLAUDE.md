# Roblox Maps — instructions for Claude

Two humans + an AI map team. Read CONTRIBUTING.md for the human rules; this file is the AI rules.

## Commands (the command center)
| Command | What |
|---|---|
| `/new-map <name> "<idea>"` | full pipeline → new map on `map/<name>` → pull request |
| `/improve-map <name> "<change>"` | change or review an existing map |
| `/maps` | status board of every map, PR and CI |

## The team (`.claude/agents/`)
| Agent | Model | Writes |
|---|---|---|
| idea-generator | Fable 5.2 → fallback Opus 5.5 | `maps/<m>/DESIGN.md` |
| level-designer | Fable 5.2 → fallback Opus 5.5 | `maps/<m>/LAYOUT.md` |
| map-builder | Sonnet 5.5 | `maps/<m>/build.luau` (structure) → generates `Map.rbxmx` |
| gameplay-scripter | Sonnet 5.5 | `maps/<m>/scripts/`, `src/`, `tests/` |
| polish | Sonnet 5.5 | `THEME` + decoration in `build.luau`, `Lighting` in `default.project.json` |
| checker | Fable 5.2 → fallback Opus 5.5 | nothing — read-only verdict |

Fallback: if a Fable agent fails because the model is unavailable, re-run it with `model: "opus"`.

## File ownership — one owner per file, so parallel agents never collide
Listed above. `Map.rbxmx` of a map that has `build.luau` is **generated** (`lune run scripts/build-maps <m>`)
and never edited by hand; CI fails if it's out of date. `.github/`, `scripts/`, `tools/`, CI and docs
are human-owned — agents only change them when the human asks.

## Hard rules
- Never commit to, push to, or merge into `main`. Never publish to Roblox. Humans approve PRs and publish.
- Never put scripts inside a map model. Never use `require(<assetId>)`, `loadstring`, `getfenv`.
- Before saying anything is done: `bash scripts/check.sh` → "All checks passed."
- Tools: `~/.rokit/bin` (rojo, lune, stylua, selene). Format: `stylua src maps tests scripts tools`.

## Map conventions (MapKit, validator and shared scripts all rely on them)
- Root `Model` named `Map`; one `SpawnLocation`.
- `Map/Course/P001, P002, …` — the path in visiting order; CI checks every jump with `src/shared/Jump.luau`
  (limits: `lune run scripts/jump-table`).
- `Map/Checkpoints/Stage1..N` — leaderstats + respawn (shared). `Map/Hazards/*` — kill on touch (shared).
- `Map/Decoration/*` — never on the jump path.
- Commits: `<map>: <imperative summary>`, e.g. `lava-run: add stages 5-8`.
