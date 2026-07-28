# Combat Missions

A briefcase-collection combat minigame: the player is dropped into a mission interior populated with armed NPCs, briefcases to loot, and an NPC "briefcase man" to hand them in to for cash, then exits via a helicopter/exit marker. Mission layouts are data-driven from the database rather than hardcoded per mission.

**Source:** `src/modules/combat.pwn` (~495 lines)

## Overview

Mission geometry is stored in the `combat_coords` table, tagged per-row with a `type` matching the anonymous `COMBAT_COORD_*` enum (`BRIEFCASE`, `NPC`, `HEALTH`, `HELI`, `EXIT`, `ROOF`, `CP`, `NPC_MAN`, `DOOR`, `SPAWN`). `PrepareCombatInterior(playerid, missionid)` queries all rows for a `mission_id` and, per type, spawns the corresponding pickup (`gCombatPickups[MAX_COMBAT_PICKUPS]`, up to 20), NPC (`gCombatNPC[MAX_COMBAT_NPCS]`, up to 25, armed with weapon `29` at `COMBAT_ACCURACY = 0.15` accuracy and infinite ammo), or vehicle (`gCombatVehicles[MAX_COMBAT_VEHICLES]`, up to 5 — currently only a model-487 helicopter).

`SetCombatMission(playerid, missionid)` is the entry point: it aborts any existing mission first, blocks if `gPlayers[playerid][InMinigame]` is already set, otherwise calls `PrepareCombatInterior`, flips `gPlayers[playerid][InMinigame]` and `gCombatMission[playerid][Active]` on, resets the player's weapons and gives weapon `26`(200 ammo)/`31`(500 ammo), creates an on-screen info textdraw, and starts a per-second `UpdateCombatMissionInfoText` timer. Only `missionid` 1 and 2 currently have hardcoded post-teleport positions in the `switch`.

Progress is tracked per-player in `gCombatMission[MAX_PLAYERS][CombatMission]`: `BriefcaseCount` increments on each briefcase pickup (`CheckCombatPickup`, `TYPE_BRIEFCASE`); reaching the "briefcase man" NPC within 4.0 units (`CheckBriefcaseManProximity`, polled every 2 seconds via `TimerBriefcaseMan`) pays out `BriefcaseCount * COMPAT_BRIEFCASE_DOLLARS` (50,000 per briefcase) and ends the mission successfully. `TYPE_HEALTH` pickups heal to full; `TYPE_EXIT` teleports the player out of the interior and arms the race-checkpoint system toward any `TYPE_CP` point (helicopter finish). `AbortCombatMission(playerid, success)` is the unified teardown: destroys all pickups/NPCs, disables the checkpoint, kills both timers, hides the info textdraw, shows a finish/abort gametext, saves a high score on success, clears `InMinigame`/`Active`/state, and respawns the player (unless they died mid-mission, tracked via `gCombatMission[playerid][Dead]`).

## Key Functions

| Function | Description |
|---|---|
| `public CheckBriefcaseManProximity(playerid, npcid)` (`src/modules/combat.pwn:71`) | Polling timer that detects the player reaching the payout NPC and finishes the mission with a cash reward. |
| `public UpdateCombatMissionInfoText(playerid)` (`src/modules/combat.pwn:104`) | Per-second timer updating the on-screen briefcase count / elapsed time textdraw. |
| `stock CheckCombatCheckpoint(playerid)` (`src/modules/combat.pwn:124`) | Disables the race checkpoint and shows a "follow marker" hint while a mission is active. |
| `stock CheckCombatPickup(playerid, pickupid)` (`src/modules/combat.pwn:138`) | Dispatches on pickup type (briefcase/health/exit) for a touched combat pickup. |
| `stock PrepareCombatInterior(playerid, missionid)` (`src/modules/combat.pwn:197`) | Loads `combat_coords` for the given mission and spawns all pickups/NPCs/vehicles. |
| `stock SetCombatMission(playerid, missionid)` (`src/modules/combat.pwn:351`) | Entry point: starts (or restarts) a combat mission for a player. |
| `stock SaveCombatMissionScore(playerid)` (`src/modules/combat.pwn:408`) | Writes the player's briefcase count to `high_scores` on mission success. |
| `stock AbortCombatMission(playerid, bool: success)` (`src/modules/combat.pwn:439`) | Tears down an active mission (pickups, NPCs, timers, textdraw) and respawns the player. |

## Commands

The `/combat` command (`dcmd_combat`, `src/support/dcmd.pwn:1119`) requires admin level 3 or higher (`!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < 3`). If a mission is already active for the caller it aborts it; otherwise it opens `ShowCombatListDialog`, whose dialog response calls `SetCombatMission(playerid, listitem + 1)`. See [Commands Reference](../commands.md) for full details.

## Data & Integration

- **gPlayers[] fields:** `InMinigame` (read/write — blocks starting a mission while another minigame is active, and is cleared on abort), `OrmID` (read, for the high-score insert).
- **Database:** `combat_coords` (mission layout, read by `mission_id`), `high_scores` (write, `type = 5`, `spec_id` = mission id, `value` = briefcase count). See [../database.md](../database.md).
- **Integration:** `SetCombatMission` is invoked from `src/support/response.pwn` (combat list dialog selection). `AbortCombatMission` is called from `main.pwn` on player disconnect/spawn-reset paths and on player death (`gCombatMission[playerid][Dead]` is set before aborting so the player isn't force-respawned twice). `CheckCombatCheckpoint`/`CheckCombatPickup` are called from `main.pwn`'s checkpoint/pickup dispatch handlers. Uses `NPC_*` natives (NPC_Create/Spawn/SetPos/SetWeapon/AimAtPlayer/Shoot) and `EnsurePickupCreated` from `src/support/pickups.pwn`. Localized strings via `I18N_COMBAT_*` keys, see [../localization.md](../localization.md).

## Notes

- `SetCombatMission`'s teleport `switch (missionid)` only handles cases `1` and `2` explicitly — any other `missionid` loaded from `ShowCombatListDialog` would spawn the interior/NPCs but leave the player at their prior position, likely outside the mission interior. Worth checking `ShowCombatListDialog` to see how many missions are actually offered.
- The constant `COMPAT_BRIEFCASE_DOLLARS` is a likely typo of `COMBAT_BRIEFCASE_DOLLARS` (missing "b"), harmless but worth knowing when grepping.
