# Godot Pixel Survivor

> Survivor-style game implemented in Godot 4 with GDScript (following Udemy series from Firebelly)

![game](./assets/screenshots/game_screen.png)

## Todo

- Change ability upgrade to use weighting (and min-level)
- Change enemy manager to use enemy weighting via configurable component (vs `WeightedTable`)
  - Consider using `Resources` for enemy type configuration (vs inline resources)
- Create static func/singleton for finding random position within arena
- Refactor menu background to a re-usable scene
- Animate progress bars
- Consider moving pickup sound to game events (ie. player healed, etc)?
- Determine how to link between ability upgrades descriptions and actual behaviour (ie. 10% speed increase is hardcoded)
- Consider allowing rerolling upgrades at cost of player health?
- Implement debug/testing system (console?)
  - Add XP, add level, drop pickup, etc
- Investigate automatically detecting required child Nodes (like Unity's) `GetComponentInChildren`
- Investigate using collision area/shape for detecting potential enemies in range (vs loops for range-based attacks)

### Ideas

- Staff weapon that shoots a projectile traveling in a straight line, damaging all enemies in contact
- Bomb drop that will explode and damage enemies in area

## Known Bugs 🐛

_None reported_

## Caveats

### Pickup System

Currently the pickup system is "handled" by the pickup items themselves detecting collisions with player, rather than player having a pickup system component. This feels a bit odd, but perhaps is the easiest way of supporting the pickup/tweening logic 🤷. The system has been drastically improved from the series (no need for individual classes), although it does use a global enum for determining upgrade type (for string safety).

### Vignette

Since all vignettes share the same shader/material, the underlying shader is modified when animating the player's vignette on damage. This can be worked around by ensuring the vignette runs in `ALWAYS` mode while running the hit animation. However, this feels less than ideal, and maybe could be improved?
