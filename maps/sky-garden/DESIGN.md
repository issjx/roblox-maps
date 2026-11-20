# Sky Garden — design

## 1. Pitch
Bounce on giant mushrooms and swing on vines across floating garden islands high above the clouds!

## 2. Audience & difficulty
- Ages 8–13, players who have finished at least one easy obby.
- Difficulty: **medium**. 8 stages, ~3.5 min for a first clear (~25 s per stage + a few falls), ~2 min for a good run.

## 3. Core loop
Every ~10 s: read the next island → time a jump, a mushroom hop or a vine-seat swing → land → reach a
flower checkpoint (stage counter +1). Falling into the cloud sea respawns you at the last checkpoint.
Fun because each stage adds one twist, and bouncy mushrooms tempt you up to **optional bonus ledges**
(shortcuts, viewpoints) high above the normal path — risk vs. reward, never required.

## 4. Theme & mood
- Setting: small grassy islands with roots hanging underneath, floating in a bright sky. Path climbs
  gently from ~Y 50 at spawn to ~Y 110 at the summit; a white cloud sea fills everything below.
- Colours: sky `#8FD3FF`, grass `#6CC24A`, mushroom cap `#E8475A`, cap spots / cream `#FFF6E9`,
  vine `#2E8B57`, petal pink `#FFB7D5`.
- Materials: Grass (island tops), Ground/Slate (undersides), SmoothPlastic (mushroom caps),
  Neon (checkpoint flowers, sparingly), Wood (bridges, vine seats), Fabric (leaves).
- Lighting: late morning (ClockTime 10), soft sun, light haze, slightly warm. No dark areas.
- Music mood: light, bouncy, plucked strings + flute, ~110 BPM, happy but not childish.

## 5. Stages
**Required path rule:** Spawn → P001 → P002 → … must pass the existing fair-jump check
(`src/shared/Jump.luau`: max rise 6.1 studs, max gap ~8.4 on the flat). Design target for every
Course jump: gap ≤ 7, rise ≤ 4. Mushroom caps on the path are ordinary Course platforms (they just
bounce you). Bonus ledges live in `Map/Bonus`, never in `Map/Course`. Checkpoints are flower pads ≥ 10×10.

| # | Name | Course parts / obstacles | Mechanic taught | Bonus (optional) | Diff |
|---|---|---|---|---|---|
| 1 | Seedling Steps | 6 grass islands (8×8), gaps 4–5 | basic jumps, cloud sea = death | — | 1 |
| 2 | Mushroom Meadow | 3 islands + 2 small mushroom caps on the path | **bounce mushroom** (path still fair) | 1 ledge with a view | 2 |
| 3 | Drifting Petals | 7 petals (5×5 → 4×4), gaps 5–7 | narrow landings | climb vine to a shortcut skipping 2 petals | 4 |
| 4 | Willow Swing | 3 islands + 2 **swinging vine seats** | timing jumps onto/off a moving seat | — | 5 |
| 5 | Tea-Garden Rest | 4 wide islands (10×10), 1 small cap, bench | breather | 1 ledge | 2 |
| 6 | Mushroom Spiral | 6 caps (4 small, 2 big) spiralling up in ≤ 4-stud steps + 2 bramble patches | bouncing while steering, avoid thorns | big cap → high ledge cutting the spiral | 7 |
| 7 | Cloud Bridge | 6 plank islands, gentle rise | breather, rhythm | climb vine to a viewpoint | 3 |
| 8 | Sunflower Summit | 2 swing seats, 3 caps, 4 petals, 2 bramble patches, finish pad | everything combined | big cap → shortcut to the last petal | 8 |

Totals: ~46 Course parts, checkpoints `Stage1`–`Stage8`, ~6 Bonus parts. Finish = giant sunflower pad.

## 6. Mechanics
- **[shared]** Checkpoints `Map/Checkpoints/Stage1..8` (glowing flower pads); kill parts `Map/Hazards/*`; fair-jump check of `Map/Course`.
- **[engine, no script]** Climbing vines — `TrussPart`s coloured `#2E8B57`, 12–16 tall, under
  `Map/Bonus` only; they lead to optional ledges, never required.
- **[new] Bounce Mushroom** — any part (in `Course` or `Bonus`) with attribute `BouncePower` (studs/s).
  - Trigger: `Touched` by a character part while the root's vertical velocity ≤ 5 (landing/standing, not side hits).
  - Effect: root `AssemblyLinearVelocity.Y = BouncePower`; X/Z kept so players steer. Small = 75
    (≈ 14 studs high), big = 100 (≈ 25 studs). The next Course part is always a fair normal jump
    away anyway; the extra height only helps or reaches a Bonus ledge.
  - Feedback: cap squashes (Size.Y × 0.7), springs back over 0.2 s; "boing" sound.
  - Reset: per-character debounce 0.4 s; no other state.
- **[new] Swinging Vine Seat** — wooden leaf seat (6×1×6) on a vine, swinging as a pendulum. It is a Course part.
  - Attributes: `SwingLength` 16, `SwingAngle` 25°, `SwingPeriod` 4 s, `SwingPhase` 0–1.
  - Effect: server moves the anchored seat each Heartbeat along the arc (±6.8 studs at the bottom)
    and sets its `AssemblyLinearVelocity` to the arc velocity so standing players are carried.
  - The **rest position (bottom of swing) is the one in `build.luau`** and must be a fair jump from
    both neighbours, so the jump is always possible as the seat passes the middle.
  - Reset: none — continuous, server-driven, same for everyone.

## 7. Hazards
- **Cloud sea**: one huge thin kill part at Y 20 under the map, CanCollide off, under opaque cloud
  Decoration. Visible the whole time; falling anywhere = respawn.
- **Bramble patches** (stages 6 and 8, 4 total): dark `#5B2A4E` thorny clumps with red tips, 4×2×4,
  beside landing spots — never on the only landing spot, never hidden under a bounce arc.
- Nothing else kills. No moving hazards. Missing a Bonus ledge just drops you back to the path or the cloud sea.

## 8. Store page
- Title: **Sky Garden Obby** (15 chars)
- Description:
  Bounce on giant mushrooms and swing on vines!
  8 floating garden islands above the clouds.
  Reach the Sunflower Summit!
- Thumbnail: a player mid-air above a giant red-and-cream mushroom, a vine seat swinging behind,
  green islands climbing to a huge sunflower, white cloud sea below, bright blue sky.
- Tags: `obby`, `parkour`, `sky`, `garden`, `bounce`

## 9. Out of scope (v1)
- Coins, shop, skins, trails, gamepasses, timers/leaderboards beyond the shared stage counter.
- Rope physics (seats follow a scripted arc); grabbing vines mid-air.
- Moving or falling islands, wind, weather, day/night cycle.
- Finish effects, badges, rewards for Bonus ledges.

## 10. Risks
- **Bounce feels pointless if the path is all normal jumps**: Mitigation: Bonus ledges and shortcuts
  give a reason to aim bounces; stage 6 spiral makes steering on bouncy caps the challenge.
- **Bonus parts confuse the jump check or the path**: they live only in `Map/Bonus`, never `Course`; shortcuts land back on a Course part.
- **Swing seats feel unfair**: seat 6×6, ±6.8 studs only, slow 4 s period, rest position fair both sides.
- **Bounce overshoot on the path**: caps on the path use small power in low-ceiling spots only where
  a 14-stud hop can't throw you off; landing islands after caps ≥ 8×8.
- **Too hard at the end**: checkpoint at start of stage 8; no single jump harder than one in stages 4 or 6.

## 11. Proposal for humans (needs validator change)
The full version uses bounces and climbs as *required* steps (14–25 stud rises). Today
`scripts/validate-maps.luau` (human-owned) rejects any rise > 6.1. Suggested rule: when the
*from* part of a jump has attribute `BouncePower = v`, allow rise ≤ `v²/(2·196.2)·0.85`; when it is a
`TrussPart` (or tagged `Climb`), allow rise up to the truss top + 6.1. The helper can live in
`src/shared/Jump.luau` (scripter-owned); the validator hook-up needs human approval. Once merged,
the Bonus ledges in stages 6 and 8 can be promoted into the Course for a taller v2.
