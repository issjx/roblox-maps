---
name: improve-map
description: Change an existing map with the AI team — "make stage 3 harder", "add a lava moving bridge", or just run the checker. Usage /improve-map <map-name> "<what to change>"
argument-hint: <map-name> "<change request, or 'review'>"
disable-model-invocation: true
---

# /improve-map

Arguments: `$ARGUMENTS` → map folder + request. Same model-fallback rule as `/new-map`
(Fable agent unavailable → same agent, `model: "opus"`).

1. Branch: `git switch main && git pull && git switch -c map/<map>-<short-slug>`.
   Check `maps/<map>/map.json` "owner" — if it isn't the current git user, warn the human that the
   owner must agree (CONTRIBUTING.md "One map, one owner").
2. Request is `review` → run only `checker` and report. Done.
3. Otherwise decide who's needed:
   - design change (new stage, new mechanic) → `idea-generator` updates DESIGN.md → **human approves**
     → `level-designer` updates LAYOUT.md
   - layout/geometry → `level-designer` (LAYOUT.md) then `map-builder`
   - behaviour → `gameplay-scripter`
   - looks only → `polish`
4. `checker` → fix loop (max 3) exactly as in /new-map step 4.
5. `bash scripts/check.sh`, push, `gh pr create`, hand-off in ≤ 6 lines.

Never push to main, merge, or publish.
