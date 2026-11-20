# Sky Garden — layout

Source: `DESIGN.md` (approved). Units: studs. `y` = centre of a part; **top** = y + height/2.
"gap" = horizontal edge-to-edge (`Jump.measure`, rotation ignored), "rise" = top-to-top,
"limit" = `Jump.maxGap(rise)` (`lune run scripts/jump-table`: max rise 6.1; rise 0 → 8.4, 1 → 8.1,
3 → 7.5, 4 → 7.1, −8 → 10.0, −12 → 10.7). Every number below was computed with the formula in
`src/shared/Jump.luau`.

## 1. Coordinate frame
- **SpawnLocation**: centre `0, 50, 0`, size `12×1×12` (top 50.5). The course runs toward **+z**.
- Stages 1–5 run up +z near x = 0. Stage 6 is a spiral around `x 0, z 438.4` (radius 18).
  Stages 7–8 run +z again on the line **x = −29.2** (the spiral's exit side).
- Height: spawn top 50.5 → finish top 107. Cloud-sea kill plane at y 20.
- **All Course parts are axis-aligned Blocks with no rotation** (the CI jump check ignores rotation and
  MapKit cylinders lie along x — see Deviations). Round looks come from Decoration.

| Kind | Height | Default look (Polish may change) |
|---|---|---|
| checkpoint pad (island) | 2 | Grass `#6CC24A` |
| grass island | 2 | Grass `#6CC24A` |
| plank island | 1 | Wood |
| petal | 1 | SmoothPlastic `#FFB7D5` |
| small / big cap | 1.5 | SmoothPlastic `#E8475A`, attribute `BouncePower` |
| vine seat | 1 | Wood, attributes `Swing*` |
| sunflower pad (finish) | 2 | SmoothPlastic yellow |

## 2. Course (`Map/Course`, visiting order)
`kit.platform(map, i, {...})`. Position = centre. Size = x×y×z. % = gap / limit.
P001's gap/rise is measured from the SpawnLocation.

| Part | Stage | Kind | Position (x, y, z) | Size | Top | Gap | Rise | Limit | % | Attributes |
|---|---|---|---|---|---|---|---|---|---|---|
| P001 | 1 | checkpoint pad (island) | 0, 50.5, 15 | 10×2×10 | 51.5 | 4.00 | +1.00 | 8.10 | 49% |  |
| P002 | 1 | grass island | 2, 51, 28 | 8×2×8 | 52 | 4.00 | +0.50 | 8.24 | 49% |  |
| P003 | 1 | grass island | -2, 52, 40.5 | 8×2×8 | 53 | 4.50 | +1.00 | 8.10 | 56% |  |
| P004 | 1 | grass island | 2, 52.5, 52.5 | 8×2×8 | 53.5 | 4.00 | +0.50 | 8.24 | 49% |  |
| P005 | 1 | grass island | -2, 53.5, 65.5 | 8×2×8 | 54.5 | 5.00 | +1.00 | 8.10 | 62% |  |
| P006 | 1 | grass island | 2, 54, 78 | 8×2×8 | 55 | 4.50 | +0.50 | 8.24 | 55% |  |
| P007 | 1 | grass island | 0, 55, 91 | 8×2×8 | 56 | 5.00 | +1.00 | 8.10 | 62% |  |
| P008 | 2 | checkpoint pad (island) | 0, 56, 104.5 | 10×2×10 | 57 | 4.50 | +1.00 | 8.10 | 56% |  |
| P009 | 2 | grass island | 0, 57, 118.5 | 8×2×8 | 58 | 5.00 | +1.00 | 8.10 | 62% |  |
| P010 | 2 | small cap | 0, 58.25, 130.5 | 6×1.5×6 | 59 | 5.00 | +1.00 | 8.10 | 62% | BouncePower 75 |
| P011 | 2 | grass island | 0, 58.5, 142.5 | 8×2×8 | 59.5 | 5.00 | +0.50 | 8.24 | 61% |  |
| P012 | 2 | small cap | 0, 59.75, 154.5 | 6×1.5×6 | 60.5 | 5.00 | +1.00 | 8.10 | 62% | BouncePower 75 |
| P013 | 2 | grass island | 0, 60, 166.5 | 8×2×8 | 61 | 5.00 | +0.50 | 8.24 | 61% |  |
| P014 | 3 | checkpoint pad (island) | 0, 61, 180.5 | 10×2×10 | 62 | 5.00 | +1.00 | 8.10 | 62% |  |
| P015 | 3 | petal | 1.5, 62, 193 | 5×1×5 | 62.5 | 5.00 | +0.50 | 8.24 | 61% |  |
| P016 | 3 | petal | -1.5, 62.5, 203.5 | 5×1×5 | 63 | 5.50 | +0.50 | 8.24 | 67% |  |
| P017 | 3 | petal | 1.5, 62.5, 214.5 | 5×1×5 | 63 | 6.00 | +0.00 | 8.37 | 72% |  |
| P018 | 3 | petal | -1.5, 63, 225.25 | 4.5×1×4.5 | 63.5 | 6.00 | +0.50 | 8.24 | 73% |  |
| P019 | 3 | petal | 1.5, 63, 236.25 | 4.5×1×4.5 | 63.5 | 6.50 | +0.00 | 8.37 | 78% |  |
| P020 | 3 | petal | -1.5, 63.5, 247 | 4×1×4 | 64 | 6.50 | +0.50 | 8.24 | 79% |  |
| P021 | 3 | petal | 0, 63.5, 258 | 4×1×4 | 64 | 7.00 | +0.00 | 8.37 | 84% |  |
| P022 | 4 | checkpoint pad (island) | 0, 63.5, 270 | 10×2×10 | 64.5 | 5.00 | +0.50 | 8.24 | 61% |  |
| P023 | 4 | grass island | 0, 64.5, 283.5 | 10×2×8 | 65.5 | 4.50 | +1.00 | 8.10 | 56% |  |
| P024 | 4 | vine seat (rest) | 0, 65, 294.5 | 6×1×6 | 65.5 | 4.00 | +0.00 | 8.37 | 48% | Swing* |
| P025 | 4 | grass island | 0, 65, 305.5 | 10×2×8 | 66 | 4.00 | +0.50 | 8.24 | 49% |  |
| P026 | 4 | vine seat (rest) | 0, 65.5, 316.5 | 6×1×6 | 66 | 4.00 | +0.00 | 8.37 | 48% | Swing* |
| P027 | 4 | grass island | 0, 65.5, 328 | 10×2×8 | 66.5 | 4.50 | +0.50 | 8.24 | 55% |  |
| P028 | 5 | checkpoint pad (island) | 0, 66.5, 341.5 | 10×2×10 | 67.5 | 4.50 | +1.00 | 8.10 | 56% |  |
| P029 | 5 | grass island | -2, 67.5, 356 | 10×2×10 | 68.5 | 4.50 | +1.00 | 8.10 | 56% |  |
| P030 | 5 | small cap | 0, 68.25, 368.5 | 6×1.5×6 | 69 | 4.50 | +0.50 | 8.24 | 55% | BouncePower 75 |
| P031 | 5 | grass island | 2, 68.5, 381 | 10×2×10 | 69.5 | 4.50 | +0.50 | 8.24 | 55% |  |
| P032 | 5 | grass island | 0, 69.5, 395.5 | 10×2×10 | 70.5 | 4.50 | +1.00 | 8.10 | 56% |  |
| P033 | 6 | checkpoint pad (island) | 0, 70.5, 410 | 10×2×10 | 71.5 | 4.50 | +1.00 | 8.10 | 56% |  |
| P034 | 6 | small cap | 9, 74.25, 422.8 | 5×1.5×5 | 75 | 5.51 | +3.50 | 7.33 | 75% | BouncePower 75 |
| P035 | 6 | small cap | 17, 77.75, 432.5 | 5×1.5×5 | 78.5 | 5.58 | +3.50 | 7.33 | 76% | BouncePower 75 |
| P036 | 6 | big cap | 16.9, 81.25, 444.6 | 8×1.5×8 | 82 | 5.60 | +3.50 | 7.33 | 76% | BouncePower 100 |
| P037 | 6 | small cap | 6.2, 84.75, 455.3 | 5×1.5×5 | 85.5 | 5.94 | +3.50 | 7.33 | 81% | BouncePower 75 |
| P038 | 6 | small cap | -4.3, 88.25, 455.9 | 5×1.5×5 | 89 | 5.50 | +3.50 | 7.33 | 75% | BouncePower 75 |
| P039 | 6 | big cap | -15.7, 91.75, 447.1 | 8×1.5×8 | 92.5 | 5.41 | +3.50 | 7.33 | 74% | BouncePower 100 |
| P040 | 7 | checkpoint pad (island) | -29.2, 92, 454.6 | 10×2×10 | 93 | 4.50 | +0.50 | 8.24 | 55% |  |
| P041 | 7 | plank island | -29.2, 93.5, 468.1 | 6×1×8 | 94 | 4.50 | +1.00 | 8.10 | 56% |  |
| P042 | 7 | plank island | -29.2, 94.5, 481.1 | 6×1×8 | 95 | 5.00 | +1.00 | 8.10 | 62% |  |
| P043 | 7 | plank island | -29.2, 95.5, 494.1 | 6×1×8 | 96 | 5.00 | +1.00 | 8.10 | 62% |  |
| P044 | 7 | plank island | -29.2, 96.5, 507.1 | 6×1×8 | 97 | 5.00 | +1.00 | 8.10 | 62% |  |
| P045 | 7 | plank island | -29.2, 97.5, 520.1 | 6×1×8 | 98 | 5.00 | +1.00 | 8.10 | 62% |  |
| P046 | 7 | plank island | -29.2, 98.5, 533.1 | 6×1×8 | 99 | 5.00 | +1.00 | 8.10 | 62% |  |
| P047 | 8 | checkpoint pad (island) | -29.2, 99, 546.6 | 10×2×10 | 100 | 4.50 | +1.00 | 8.10 | 56% |  |
| P048 | 8 | vine seat (rest) | -29.2, 99.5, 558.6 | 6×1×6 | 100 | 4.00 | +0.00 | 8.37 | 48% | Swing* |
| P049 | 8 | petal | -30.7, 100, 568.1 | 4×1×4 | 100.5 | 4.50 | +0.50 | 8.24 | 55% |  |
| P050 | 8 | petal | -27.7, 101, 578.1 | 4×1×4 | 101.5 | 6.00 | +1.00 | 8.10 | 74% |  |
| P051 | 8 | vine seat (rest) | -29.2, 101, 587.6 | 6×1×6 | 101.5 | 4.50 | +0.00 | 8.37 | 54% | Swing* |
| P052 | 8 | petal | -30.7, 101.5, 597.1 | 4×1×4 | 102 | 4.50 | +0.50 | 8.24 | 55% |  |
| P053 | 8 | petal | -27.7, 102.5, 607.1 | 4×1×4 | 103 | 6.00 | +1.00 | 8.10 | 74% |  |
| P054 | 8 | big cap | -29.2, 103.25, 619.1 | 10×1.5×10 | 104 | 5.00 | +1.00 | 8.10 | 62% | BouncePower 100 |
| P055 | 8 | small cap | -29.2, 104.25, 632.6 | 8×1.5×8 | 105 | 4.50 | +1.00 | 8.10 | 56% | BouncePower 75 |
| P056 | 8 | small cap | -29.2, 105.25, 645.1 | 8×1.5×8 | 106 | 4.50 | +1.00 | 8.10 | 56% | BouncePower 75 |
| P057 | 8 | sunflower pad (finish) | -29.2, 106, 660.6 | 14×2×14 | 107 | 4.50 | +1.00 | 8.10 | 56% |  |

Formulas (they reproduce the table; the table wins on any rounding question):
- Straight runs: `z_i = z_{i-1} + sz_{i-1}/2 + gap_i + sz_i/2`, `top_i = top_{i-1} + rise_i`, `y_i = top_i − h_i/2`.
- Stage 6 spiral caps: `x = 18·sin(a)`, `z = 438.4 + 18·cos(a)`, rounded to 0.1, at a = 150°, 109°, 70°, 20°, −14°, −61°;
  each cap +3.5 above the previous. P040 sits 4.5 further out along a = −61°.
- Stages 7–8 on x = −29.2; stage 8 petals alternate x = −30.7 / −27.7.

Stage summary: S1 pad + 6 islands · S2 pad + 3 islands + 2 small caps · S3 pad + 7 petals (5×5 → 4×4, gaps 5–7) ·
S4 pad + 3 islands + 2 seats · S5 pad + 3 wide islands + 1 small cap · S6 pad + 6 caps (4 small, 2 big) spiralling up
3.5 per step · S7 pad + 6 planks · S8 pad + 2 seats + 4 petals + 3 caps + finish.

**Hardest jumps**: P021 (S3) gap 7.00 at rise 0 vs 8.37 (84 %) — the 7-stud gap DESIGN asks for; P037 (S6) gap 5.94
at rise +3.5 vs 7.33 (81 %). Stage 8 peaks at 74 % (DESIGN §10). All rises ≤ 3.5, all gaps ≤ 7 (design target).
Every platform that follows a path cap is ≥ 8×8, except inside the stage 6 spiral (caps-to-caps by design).

## 3. Checkpoints (`Map/Checkpoints`)
Flower pads on each stage's first island: size `10×0.2×10`, pad x/z, **y = pad top + 0.1**.

| Checkpoint | On | Position |
|---|---|---|
| Stage1 | P001 | 0, 51.6, 15 |
| Stage2 | P008 | 0, 57.1, 104.5 |
| Stage3 | P014 | 0, 62.1, 180.5 |
| Stage4 | P022 | 0, 64.6, 270 |
| Stage5 | P028 | 0, 67.6, 341.5 |
| Stage6 | P033 | 0, 71.6, 410 |
| Stage7 | P040 | -29.2, 93.1, 454.6 |
| Stage8 | P047 | -29.2, 100.1, 546.6 |

The finish is the sunflower pad P057 (no 9th checkpoint; DESIGN has 8 stages).

## 4. Hazards (`Map/Hazards`)
| Name | Position | Size | Notes |
|---|---|---|---|
| CloudSea | -10, 20, 335 | 120×1×730 | `canCollide = false`, transparency 1 (CloudDeck is what you see). Covers x −70…50, z −30…700: every fall, Bonus included. |
| Bramble1 | 8.6, 86, 461.8 | 4×2×4 | `#5B2A4E`; 2 studs radially outside P037, off the P036→P037→P038 line |
| Bramble2 | -5.9, 89.5, 462.4 | 4×2×4 | 2 studs radially outside P038, same rule |
| Bramble3 | -21.7, 102, 578.1 | 4×2×4 | 2 studs east of petal P050; 4.5 studs (z) clear of seat P051's sweep |
| Bramble4 | -21.7, 103.5, 607.1 | 4×2×4 | 2 studs east of petal P053; outside P054's footprint |

Bramble centre = landing top + 0.5. None is on the only landing spot, none is under a cap.

## 5. Bonus (`Map/Bonus`, optional, never in Course)
`kit.part(kit.folder(map, "Bonus"), name, props)`. Blocks, no rotation. Leaf steps: Fabric `#2E8B57`;
ledges/branches: Wood or Grass.

| Name | Position | Size | Top |
|---|---|---|---|
| S2Ledge | 8, 70, 154.5 | 6×1×6 | 70.5 |
| S3Leaf1 | 9, 64.5, 181 | 4×1×4 | 65 |
| S3Leaf2 | 9, 67.5, 187 | 4×1×4 | 68 |
| S3Leaf3 | 9, 70.5, 193 | 4×1×4 | 71 |
| S3Branch | 9, 70.5, 202 | 4×1×14 | 71 |
| S5Ledge | -8, 78.5, 368.5 | 6×1×6 | 79 |
| S6Branch | 0.6, 99.5, 444.6 | 18.6×1×4 | 100 |
| S7Leaf1 | -37.2, 98.5, 494.1 | 4×1×4 | 99 |
| S7Leaf2 | -37.2, 101.5, 500.1 | 4×1×4 | 102 |
| S7Leaf3 | -37.2, 104.5, 506.1 | 4×1×4 | 105 |
| S7View | -39.2, 107.5, 514.1 | 8×1×8 | 108 |
| S8Branch | -19.7, 121.5, 633 | 3×1×34 | 122 |

Routes (bounce heights: small 75 → 14.3, big 100 → 25.5):
| Route | Gap | Rise | Limit |
|---|---|---|---|
| P012 (small cap) → S2Ledge (viewpoint) | 2.00 | +10.0 | bounce |
| S2Ledge → P013 | 5.10 | −9.5 | 10.30 |
| P014 → S3Leaf1 → S3Leaf2 → S3Leaf3 | 2.00 each | +3 each | 7.50 |
| S3Leaf3 → S3Branch | 0 (joined) | 0 | — |
| S3Branch → **P017** (skips P015, P016) | 4.24 | −8.0 | 10.04 |
| P030 (small cap) → S5Ledge | 2.00 | +10.0 | bounce |
| S5Ledge → P031 | 4.92 | −9.5 | 10.30 |
| P036 (big cap) → S6Branch | 3.00 | +18.0 | bounce |
| S6Branch → **P039** (skips P037, P038) | 3.00 | −7.5 | 9.95 |
| P043 → S7Leaf1 → S7Leaf2 → S7Leaf3 → S7View | 3 / 2 / 2 / 2 | +3 each | 7.50 |
| S7View → P045 | 3.00 | −10.0 | 10.38 |
| P054 (big cap) → S8Branch | 3.00 | +18.0 | bounce |
| S8Branch → **P057** finish (skips P055, P056) | 3.74 | −15.0 | 11.15 |

Each Bonus part is ≥ 3 studs (horizontally) outside every cap footprint except the ledge that cap is meant to reach
(S2Ledge / S5Ledge are 2 studs beside their cap), so no path bounce hits a ceiling. No Bonus part overlaps any Course
part in plan view.

## 6. Decoration (`Map/Decoration`, all `canCollide = false` unless noted, none on a jump line)
| Name | Position / rule | Size | Notes |
|---|---|---|---|
| CloudDeck | -10, 24, 335 | 140×2×750 | white, opaque, above CloudSea |
| Roots_Pxxx | under every pad / island / plank / finish: same x, z; y = part bottom − 2 | (sx−2)×4×(sz−2) | Slate/Ground undersides (30 parts) |
| Stem_Pxxx | under every cap: same x, z; y = cap bottom − 3 | Cylinder 6×1.5×1.5 (big caps 6×2.5×2.5), rotation 0, 0, 90 | cream `#FFF6E9` (12 parts) |
| Rope_P024 / P026 / P048 / P051 | seat centre + (0, 8.25, 0) at rest | 0.6×15.5×0.6 | vine `#2E8B57`; moved with the seat (§7) |
| SwingBranch_P024 / P026 / P048 / P051 | seat x, seat y + 16.75, seat z | 1.5×1.5×10 | Wood, static pivot branch along z |
| S3Vine | 11.5, 66.5, 187 | 0.6×10×0.6 | hangs beside S3Leaf1–3 |
| S7Vine | -39.7, 102.5, 500 | 0.6×10×0.6 | hangs beside S7Leaf1–3 |
| Bench | 3.75, 71.25, 395.5 (on P032) | 1.5×1.5×4 | Wood, off the x = 0 line; collidable allowed |
| SunflowerHead | -29.2, 104.5, 660.6 | Cylinder 1×20×20, rotation 0, 0, 90 | yellow disc just under the finish pad |
| SunflowerStem | -29.2, 84, 660.6 | Cylinder 40×3×3, rotation 0, 0, 90 | green |

Polish may add more (cap spots, leaves, cloud puffs) but keeps it off every jump line, out of the seat sweeps, and
out of the column above any cap (bounce height + 6 studs).

## 7. Moving / scripted elements
**Bounce Mushroom** — attribute `BouncePower` (number) set on the part `kit.platform` returns
(`part:SetAttribute("BouncePower", 75)`).
- Small 75: P010, P012, P030, P034, P035, P037, P038, P055, P056. Big 100: P036, P039, P054.

**Swinging Vine Seat** — Course parts **P024, P026 (stage 4), P048, P051 (stage 8)**, 6×1×6.
- Attributes: `SwingLength` 16, `SwingAngle` 25, `SwingPeriod` 4, `SwingPhase` P024 0, P026 0.5, P048 0.25, P051 0.75.
- The built CFrame is the **rest** (bottom) position. Pivot = rest centre + (0, 16, 0).
- Swing plane **x–y** (sideways across the path, never toward a neighbour):
  `θ(t) = SwingAngle·sin(2π(t/SwingPeriod + SwingPhase))`, centre = pivot + (16·sinθ, −16·cosθ, 0), seat stays level.
  Extremes: x ± 6.76, top + 1.52.
- `Rope_<seat>` follows: centre = pivot + (8.25·sinθ, −8.25·cosθ, 0), rotated θ around z.
- Swing extremes are still landable (seat at x ± 6.76, top + 1.52, worst side):

| Seat | Jump onto | Jump off |
|---|---|---|
| P024 | gap 4.00, rise +1.50 vs 7.96 | gap 4.00, rise −1.00 vs 8.62 |
| P026 | gap 4.00, rise +1.50 vs 7.96 | gap 4.50, rise −1.00 vs 8.62 |
| P048 | gap 4.00, rise +1.50 vs 7.96 | gap 5.56, rise −1.00 vs 8.62 |
| P051 | gap 5.56, rise +1.50 vs 7.96 | gap 5.56, rise −1.00 vs 8.62 |

The sweep (x ± 9.8 around the seat, at the seat's z ± 3) is empty of all other parts.

## 8. Budget
| Group | Parts |
|---|---|
| SpawnLocation | 1 |
| Course P001–P057 | 57 |
| Checkpoints Stage1–8 | 8 |
| Hazards (CloudSea + 4 brambles) | 5 |
| Bonus | 12 |
| Decoration listed above (1 + 30 + 12 + 4 + 4 + 2 + 1 + 2) | 56 |
| **Total (structure)** | **139** |
| Polish allowance | ≤ 300 |
| **Ceiling** | **< 450** (target < 2,000; hard limit 30,000) |

## 9. Deviations from DESIGN.md
1. **Climbing vines (TrussPart) → leaf steps.** `tools/MapKit.luau` only makes `Part` (Block/Ball/Cylinder) and
   `WedgePart`; there is no TrussPart. The stage 3 and 7 "climb a vine" bonuses are 3 leaf steps each (rise 3, gap 2)
   beside a non-collide decorative vine, so Bonus has 12 parts instead of ~6. If a human adds a truss helper to MapKit,
   S3Leaf1–3 / S7Leaf1–3 can become one 2×12×2 truss each.
2. **No attribute helper in MapKit.** The builder sets `BouncePower` / `Swing*` with `:SetAttribute` on the part
   `kit.platform` returns (works in Lune; checked).
3. **Square caps.** Course caps are Blocks: MapKit's Cylinder lies along x and `Jump.measure` ignores rotation, so a
   rotated cylinder would be measured with the wrong height. Roundness is decoration only.
4. **Checkpoint pads are extra islands.** Each stage starts with a 10×10 pad (DESIGN: flower pads ≥ 10×10), so Course
   has 57 parts instead of ~46.
5. **Stage 8 order and shortcut.** DESIGN §10 wants the platform after a path cap to be ≥ 8×8 (a cap bounce carries you
   12–16 studs forward). With 4 petals and 2 seats, the 3 caps have to be the last run before the finish, so the big-cap
   shortcut lands on the **finish pad** (skipping the last 2 caps) instead of the last petal.
6. Finish top is 107 (DESIGN "~110").
