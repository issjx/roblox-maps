---
name: maps
description: Studio status board — every map with its status, owner, open PR and CI state, plus what to do next. Usage /maps
disable-model-invocation: true
---

# /maps — status board

Collect, then print ONE table and at most 3 "next step" lines. Don't change anything.

1. For each `maps/*/map.json` (skip `_template`): name, folder, owner, status, published place?
2. `gh pr list --state open --json number,title,headRefName,author,reviewDecision,statusCheckRollup`
   → match PRs to maps by branch `map/<folder>…`.
3. `git branch -r --list "origin/map/*"` → branches with no PR = stale work.

Table columns: Map · Owner · Status · PR · CI · Review.
Next steps examples: "PR #4 lava-run is green and waiting for <other person>'s review",
"sky-tower has been `wip` with no branch activity — pick it up or archive it".
