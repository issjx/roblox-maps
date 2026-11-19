# How we work

Two people, many maps. These rules exist so we almost never edit the same file — because a Roblox
map **cannot be merged**: if both of us change the same `Map.rbxmx`, one person's work is lost.

## Ownership

| Area | Owner | Reviewer |
|---|---|---|
| `maps/<name>/` | the `owner` in that map's `map.json` | the other person |
| `src/` (shared by every map) | both | the other person — think about **every** map |
| `.github/`, `scripts/`, docs | lead (@issjx) | @Abo6le |

**One map, one owner at a time.** Want to change someone else's map? Ask first, they push what
they have, then you take it (change `owner` in `map.json` in your PR).

## Branches

- `main` is protected by a GitHub ruleset: pull request, **one approval**, a green **`CI passed`**,
  branch up to date with `main`; force-pushes and deletion blocked; **bypass list empty** — applies
  to the repo owner too. The pre-commit hook also refuses commits on `main` locally.
- Branch from an up-to-date `main`, named `<area>/<short-description>`:
  `map/lava-run`, `map/lava-run-checkpoints`, `code/kill-bricks`, `infra/ci-cache`, `docs/publishing`.
- Keep branches short: open a PR within a couple of days, even as a **draft**.
- Before asking for review: GitHub Desktop → *Branch → Update from main*.

## Before you push

`scripts\setup.ps1` installs git hooks (`core.hooksPath = .githooks`). They run the same checks CI
runs, just earlier:

| When | What runs |
|---|---|
| On commit | blocks commits on `main`, blocks `.rbxl`/`.env` files, StyLua + Selene on staged Luau |
| On push | `scripts/check.sh` — format, lint, tests, map validation, Rojo build of every map |

Skipping hooks only delays the bad news — **CI is the gate**, and the rule on `main` makes it one.

## What CI checks (`.github/workflows/ci.yml`)

| Job | Fails when |
|---|---|
| Lint | Luau isn't StyLua-formatted, or Selene finds a problem |
| Tests | a Lune test in `tests/` fails (rules in `src/shared`) |
| Maps | a map is missing files, `map.json` is incomplete, `Map.rbxmx` doesn't load, there's no SpawnLocation, checkpoints skip a number, it's over budget, or **a script is hidden inside the map** (free-model backdoors) — then every map must build with Rojo |
| **CI passed** | any job above failed. This is the only check the ruleset requires |

Every PR's CI run uploads the built places (**Artifacts → places**) — the reviewer downloads the
`.rbxl`, opens it in Studio, and playtests without checking out the branch.

## Commits

Short, imperative, area first:

```
lava-run: add stages 5-8 and the final tower
shared: stop players skipping checkpoints
infra: cache rokit tools in CI
```

## Pull requests

1. Fill in the template — **which map**, **how you tested it**, a screenshot.
2. One map per PR. Touching `src/` too? Say why — it changes every map.
3. CI green before review.
4. Reviewer: download the place from the CI artifacts, play it, read the scripts.
5. **Squash-merge**, delete the branch.

## Publishing

Only from `main`, via **Actions → Publish map** — see [docs/PUBLISHING.md](docs/PUBLISHING.md).
Nobody publishes from Studio straight to the live game, so what's live is always what's in `main`.

## Secrets

- Never commit API keys, cookies (`.ROBLOSECURITY`!) or `.env` files. The Open Cloud key lives only in
  **Settings → Secrets → Actions** as `ROBLOX_API_KEY`.
- If a key is committed by mistake: revoke it on create.roblox.com immediately — deleting it from
  history is not enough.

## Definition of done

- The map's issue "done when" list is ticked
- Playtested by the other person
- CI green, PR merged, `map.json` status updated (`wip` → `testing` → `published`)

## Setting up the GitHub repository (lead, once)

1. ✅ Repository created and `main` pushed.
2. **Settings → Collaborators** → invite your friend. When they accept, add their handle to
   `.github/CODEOWNERS` (in a PR).
3. ✅ **Settings → Rules → Rulesets → `main`**: active, default branch, bypass list empty —
   require PR (1 approval, dismiss stale approvals), require status check **`CI passed`**, branches
   up to date, block force-push and deletion.
4. **Settings → Environments → New** `roblox-production` → required reviewers: both of you.
5. **Settings → Secrets → Actions** → `ROBLOX_API_KEY` (docs/PUBLISHING.md).
