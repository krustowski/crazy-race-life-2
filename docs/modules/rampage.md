# Rampage Missions

A timed, pickup-triggered shootout minigame: a player who touches a rampage start pickup is thrown into a 5-minute firefight against up to 16 NPCs armed with random weapons, with health/weapon pickups and a countdown HUD. An admin-only in-game editor places each mission's pickup, NPC, weapon and health-pack coordinates.

**Source:** `src/modules/rampage.pwn` (~751 lines)

## Overview

Missions are identified by a `missionid` (the `rampages.id` row) and located in one of three cities via `RMType` (`RM_LV`/`RM_SF`/`RM_LS`). Per-mission state is held in fixed-size arrays sized by `MAX_RAMPAGE_MISSION_COUNT` (16), `MAX_RAMPAGE_NPC_COUNT` (16), `MAX_RAMPAGE_WEAPON_COUNT` (16) and `MAX_RAMPAGE_HEALTH_POINTS_COUNT` (16): `gRampageNPCs`, `gRampageWeapons`, `gRampageHealthPoints`, `gRampagePickups`, plus one `gRampageMission[playerid]` per-player run and one `gRampageEdit[playerid]` per-player editor session.

Flow: `InitRampagePickups()` (called once at startup) creates one world pickup per row of `rampage_coords` type 1 (`RMPT_START`) with a floating 3D name label. Touching it (`CheckRampagePickup`, invoked from the pickup callback) calls `SetRampageMission(playerid)`, which reads `rampage_coords` rows for that mission (type 4 = weapons, type 5 = health, type 2 = NPCs), spawns the corresponding pickups/NPCs, sets `gRampageMission[playerid][TimeElapsed] = 300000` (5 minutes) and starts a 1s countdown timer (`UpdateRampageMissionInfoText`) that updates a textdraw and calls `AbortRampageMission` once time hits zero. NPCs are spawned via raw `NPC_*` natives (not through `modules/npcs.pwn`), given a random skin (`random(300)`), a random weapon in the `random(13) + 22` range, infinite ammo, 0.15 accuracy, 50 HP, and are ordered to jog toward a secondary coordinate while shooting at the player or another nearby NPC. When an NPC in a mission is killed, `main.pwn` increments `gRampageMission[killerid][KilledCount]` and schedules `RecreateRampageNPC` ~250ms later, which respawns that NPC slot in place. Pickups: `RMPT_HEALTH` fully heals + armours the player, `RMPT_WEAPON` gives the configured (or random) weapon; both are one-shot and destroyed after use.

The **Rampage Editor** is reached only through the admin `/edit` command (`GameEditorListDialog`) and walks an admin through `RMEditType` steps (`RMET_PICKUP_COORDS` → `RMET_NPC_COORDS_PRIMARY`/`SECONDARY` → `RMET_WEAPON_COORDS` → `RMET_HEALTH_COORDS`). Each step's coordinates are captured by clicking the map, handled in `modules/player.pwn`'s map-click handler, which writes into `gRampageEdit[playerid]`. `SaveRampageMission` then persists the mission, its start pickup, and every recorded health/weapon/NPC coordinate pair as rows in `rampages`/`rampage_coords`, and calls `InitRampagePickups()` again to (re)spawn the start pickup.

## Key Functions

| Function | Description |
|---|---|
| `public UpdateRampageMissionInfoText(playerid)` (`src/modules/rampage.pwn:127`) | 1s countdown timer; updates the mission HUD textdraw and auto-aborts when time runs out. |
| `public RecreateRampageNPC(playerid, missionid, npcindex)` (`src/modules/rampage.pwn:152`) | Respawns a killed mission NPC in place and re-aims all surviving NPCs. |
| `stock CheckRampagePickup(playerid, pickupid)` (`src/modules/rampage.pwn:231`) | Pickup callback entry point: starts a mission, heals, or grants a weapon depending on pickup type. |
| `stock InitRampagePickups()` (`src/modules/rampage.pwn:279`) | Loads `rampages`/`rampage_coords` (type 1) and spawns/refreshes every mission's start pickup. |
| `stock AbortRampageMission(playerid)` (`src/modules/rampage.pwn:335`) | Destroys the mission's NPCs and pickups, clears state, respawns the player. |
| `stock SetRampageMission(playerid)` (`src/modules/rampage.pwn:382`) | Loads weapon/health/NPC coordinates for the chosen mission and spawns them; starts the 5-minute timer. |
| `stock SetRampageNPC(playerid, missionid, npcarrayid)` (`src/modules/rampage.pwn:583`) | Allocates an NPC bot slot and spawns it (used both live and by the editor preview). |
| `stock SaveRampageMission(playerid)` (`src/modules/rampage.pwn:629`) | Persists an editor session (pickup, health, weapon and NPC coordinates) to the database. |

## Commands

No dedicated `/rampage` command exists. The mission is entirely pickup-driven (`CheckRampagePickup`, called from the world pickup callback in `main.pwn`). The editor is reached via the admin-only `/edit` command (RCON or admin level 4+), which opens a shared "Game Editors" list with a "Rampage Editor" entry. See [Commands Reference](../commands.md) for full details.

## Data & Integration

Reads/writes `gPlayers[playerid][InMinigame]` (blocks/marks minigame overlap) and `gPlayers[playerid][EditingMode]` (editor session flag). Touches the `rampages` and `rampage_coords` tables (coordinate `type` values: 1 = start pickup, 2 = NPC primary/secondary, 4 = weapon, 5 = health). Integrates with `support/dialogs.pwn` and `support/response.pwn` for the editor dialogs, `modules/player.pwn` for map-click coordinate capture during editing, and `main.pwn` for the pickup callback and NPC-kill bookkeeping. See [player.md](player.md) for the `gPlayers` enum, [npcs.md](npcs.md) for the generic NPC lifecycle (rampage NPCs are spawned independently of it, directly via `NPC_*` natives), and [../database.md](../database.md) for schema details.

## Notes

- Listed as **experimental** in the project README ("5-minute long clashes with NPCs on the street").
- Unlike taxi/tow/trucking, there is no `high_scores` write for a finished rampage — `KilledCount` is tracked only in memory for the HUD and is lost on abort.
- Rampage NPCs use raw `NPC_*` natives directly rather than the ambient driver-NPC plumbing in `modules/npcs.pwn`.
- Several `SendClientMessage` lines are commented out (e.g. mission-start message in `SetRampageMission`), suggesting the UX is unfinished.
