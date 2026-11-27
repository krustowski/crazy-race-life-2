# Rampage Missions

A timed, pickup-triggered shootout minigame: a player who touches a rampage start pickup is thrown into a 5-minute firefight against up to 16 NPCs armed with random weapons, with health/weapon pickups and a countdown HUD. An admin-only in-game editor places each mission's pickup, NPC, weapon and health-pack coordinates.

**Source:** `src/modules/rampage.pwn` (~1020 lines)

## Overview

Missions are identified by a `missionid` (the `rampages.id` row) and located in one of three cities via `RMType` (`RM_LV`/`RM_SF`/`RM_LS`). Per-mission state is held in fixed-size arrays sized by `MAX_RAMPAGE_MISSION_COUNT` (16), `MAX_RAMPAGE_NPC_COUNT` (16), `MAX_RAMPAGE_WEAPON_COUNT` (16) and `MAX_RAMPAGE_HEALTH_POINTS_COUNT` (16): `gRampageNPCs`, `gRampageWeapons`, `gRampageHealthPoints`, `gRampagePickups`, plus one `gRampageMission[playerid]` per-player run and one `gRampageEdit[playerid]` per-player editor session.

Flow: `InitRampagePickups()` (called at startup, after `InitRampageSlots()` has set every slot to its `INVALID_*` sentinel, and again after every successful save; it replaces the pickups and labels it created before and skips ids beyond `MAX_RAMPAGE_MISSION_COUNT`) creates one world pickup per row of `rampage_coords` type 1 (`RMPT_START`) with a floating 3D name label. Touching it (`CheckRampagePickup`, invoked from the pickup callback) calls `SetRampageMission(playerid)`, which reads `rampage_coords` rows for that mission (type 4 = weapons, type 5 = health, type 2 = NPCs), spawns the corresponding pickups/NPCs, sets `gRampageMission[playerid][TimeElapsed] = 300000` (5 minutes) and starts a 1s countdown timer (`UpdateRampageMissionInfoText`) that updates a textdraw and calls `AbortRampageMission` once time hits zero. NPCs are spawned via raw `NPC_*` natives (not through `modules/npcs.pwn`) and armed by `ArmRampageNPC`: random skin (`random(300)`), a random weapon in the `random(13) + 22` range, infinite ammo, `RAMPAGE_NPC_HEALTH` (50) and `RAMPAGE_NPC_ACCURACY` (0.15) set for that weapon in the same call, because accuracy is stored per weapon. They jog toward a secondary coordinate while `RampageNPCEngage` runs the component's aim loop on a target: half open on the player, the rest on another live NPC of the **same mission** chosen by `GetRampageNPCTarget` (the player when there is none yet). There are no scripted `NPC_Shoot` calls any more; with `isHit = true` those were guaranteed hits that bypassed accuracy. NPCs outside the mission (drivers, customers) are never targeted and never told to shoot. When a mission NPC is killed, `main.pwn`'s `OnNPCDeath` finds its owner with `FindRampageNPC` and recreates it in place after a delay that depends on **who** killed it. The killer is never respawned:

| killed by | respawn delay |
|---|---|
| the player running the mission | **60 s** (`RAMPAGE_RECREATE_DELAY_OWNER_KILL`) — slow enough that clearing the area feels like progress |
| anyone else: another NPC (crossfire), another player, or no killer at all | 250 ms (`RAMPAGE_RECREATE_DELAY_CROSSFIRE`) — effectively immediate |

A non-mission NPC killed by an NPC is respawned as it was (`NPC_Respawn`) and left alone; killed by a player it is destroyed, as before. `OnNPCRespawn` re-arms a mission NPC through `ArmRampageNPC`, so a fresh weapon never fires at the component's default accuracy. NPC slots hold `INVALID_NPC_ID` when empty (`InitRampageSlots` at startup, and again on abort), since 0 is a real NPC id.

`gRampageMission[killerid][KilledCount]` is incremented separately, in `OnPlayerDeath` (`src/main.pwn:526`), since NPCs are player slots and their deaths surface through both callbacks. Pickups: `RMPT_HEALTH` fully heals + armours the player, `RMPT_WEAPON` gives the configured (or random) weapon; both are one-shot and destroyed after use.

The **Rampage Editor** is reached only through the admin `/edit` command (`GameEditorListDialog`) and walks an admin through `RMEditType` steps (`RMET_PICKUP_COORDS` → `RMET_NPC_COORDS_PRIMARY`/`SECONDARY` → `RMET_WEAPON_COORDS` → `RMET_HEALTH_COORDS`). Each step's coordinates are captured by clicking the map, handled in `modules/player.pwn`'s map-click handler, which writes into `gRampageEdit[playerid]`. `SaveRampageMission` then persists the mission, its start pickup, and every recorded health/weapon/NPC coordinate pair as rows in `rampages`/`rampage_coords`, and calls `InitRampagePickups()` again to (re)spawn the start pickup. Opening the editor from that list first runs `ResetRampageEditor`, which wipes the player's cached fields and every slot recorded under the prospective mission id, so an abandoned session no longer leaks into the next one; the same reset runs after a successful save, on disconnect, and from the "Discard Recordings" entry of the main dialog. Each recording site stops at the 16-slot array limit. The weapon dialog parses the typed id (`strval`), keeps it only if `IsValidRampageWeapon` accepts it (1–46, minus the unused 19–21) and stores it on the slot claimed when the position was recorded; `SaveRampageMission` writes it to `rampage_coords.weapon_id`, and `SetRampageMission` gives the pickup that weapon, or a random gun when the stored id is 0 or invalid, and spawns it with the matching object model from `GetWeaponModel` (`support/helpers.pwn`). The main dialog picks the recording slot (highest `rampages.id` + 1) only when a session starts and keeps it afterwards, and refuses to open once that slot would reach `MAX_RAMPAGE_MISSION_COUNT`. `SaveRampageMission` refuses to run without a name or a start pickup position, inserts the `rampages` row, reads the real id back with `last_insert_rowid()` (AUTOINCREMENT never reuses a deleted id, so the guessed slot can be lower than the assigned id), writes every recorded slot under that id, tells the player how each step went (`RampageSaveFailed` on an error, a summary line with the counts on success), reruns `InitRampagePickups` so the mission is live immediately, and resets the session. A failed save keeps the recordings and reopens the menu for another try.

## Scoring

`AbortRampageMission` — which every exit path runs, whether the 5-minute timer expired, the player died, or they disconnected — calls `SaveRampageMissionScore` before tearing the mission down. A run with a zero `KilledCount` is not written.

| Column | Value |
|---|---|
| `type` | `7` (`TYPE_MISSION_RAMPAGE` in `high_scores_types`) |
| `spec_id` | `gRampageMission[playerid][ID]` — the `rampages.id`, so scores are per-mission |
| `value` | `KilledCount` |
| `user_id` | `gPlayers[playerid][OrmID]` |
| `time` | `TimeElapsed` (ms remaining on the countdown) |

Because `spec_id` carries a real mission id, `ShowHighScoresRampageDialog` joins `rampages` on it to show each entry's mission **name** rather than a bare number; both of its lists (top runs, best run per player) are ranked by kill count across all missions, with the countdown left as the tie-break — see [Player UI & Interaction](../support/player-ui.md).

## Key Functions

| Function | Description |
|---|---|
| `public UpdateRampageMissionInfoText(playerid)` (`src/modules/rampage.pwn:137`) | 1s countdown timer; updates the mission HUD textdraw and auto-aborts when time runs out. |
| `stock ArmRampageNPC(npcid)` (`src/modules/rampage.pwn:166`) | Sets health, skin, a random weapon and that weapon's accuracy in one place. |
| `stock FindRampageNPC(npcid, &missionid, &npcindex)` (`src/modules/rampage.pwn:181`) | Returns the owning player of a mission NPC (or `INVALID_PLAYER_ID`) and its mission/slot. |
| `stock GetRampageNPCTarget(playerid, missionid, selfid)` (`src/modules/rampage.pwn:215`) | Random other live NPC of the same mission, else the player. Never an outside NPC. |
| `stock RampageNPCEngage(npcid, targetid)` (`src/modules/rampage.pwn:245`) | Starts the aim loop on a target at the configured accuracy; no scripted forced-hit shot. |
| `public RecreateRampageNPC(playerid, missionid, npcindex)` (`src/modules/rampage.pwn:252`) | Recreates a killed mission NPC in place (destroying the old id only if still valid), arms it, aims it at a mission mate or the player, and points the other survivors back at the player. |
| `stock bool: CheckRampagePickup(playerid, pickupid)` (`src/modules/rampage.pwn:315`) | Pickup callback entry point: starts a mission, heals, or grants a weapon depending on pickup type. A start pickup is ignored while the player is on a rampage or in another minigame (taking its id would switch the running rampage over), and refused with a message while someone else runs that rampage. A used weapon or health pickup's id is forgotten: the server hands it to the next pickup made. |
| `stock InitRampageSlots()` (`src/modules/rampage.pwn:393`) | Startup reset of every NPC, pickup and label slot to its `INVALID_*` sentinel. |
| `stock InitRampagePickups()` (`src/modules/rampage.pwn:415`) | Loads `rampages`/`rampage_coords` (type 1) and spawns/refreshes every mission's start pickup. |
| `stock AbortRampageMission(playerid)` (`src/modules/rampage.pwn:477`) | The single exit path: saves the score, destroys the mission's NPCs and every weapon/health pickup slot the run filled, clears state, respawns the player. |
| `stock SetRampageMission(playerid)` (`src/modules/rampage.pwn:535`) | Loads weapon/health/NPC coordinates for the chosen mission and spawns them; starts the 5-minute timer. Refuses a rampage someone already runs: its gunmen and pickups are one set per rampage, and a second run would overwrite the first one's and leave them behind. |
| `stock SetRampageNPC(playerid, missionid, npcarrayid)` (`src/modules/rampage.pwn:704`) | Allocates an NPC bot slot and spawns it (used both live and by the editor preview). |
| `stock SaveRampageMissionScore(playerid)` (`src/modules/rampage.pwn:748`) | Writes the finished run to `high_scores` as type 7. No-op on a zero kill count. |
| `stock bool: IsValidRampageWeapon(weaponid)` (`src/modules/rampage.pwn:781`) | True for a real weapon id (1–46 minus 19–21); 0 or anything else means a random gun each run. |
| `stock bool: IsRampageMissionRunning(missionid)` (`src/modules/rampage.pwn:786`) | Whether any player currently has an active run of that mission. |
| `stock ResetRampageEditor(playerid)` (`src/modules/rampage.pwn:803`) | Clears the player's editor session and the `Set` slots under its prospective mission id (skipped if a live run uses that id). |
| `stock RampageSaveFailed(playerid, const what[], const query[])` (`src/modules/rampage.pwn:845`) | Logs a failed save step with its query, tells the editing player which step failed, returns 0. |
| `stock SaveRampageMission(playerid)` (`src/modules/rampage.pwn:859`) | Persists an editor session: validates name and start pickup, inserts the `rampages` row, reads the real id back, writes every recorded slot, reports to the player, reruns `InitRampagePickups` and resets the session. Unrelated to scoring despite the similar name. |

## Commands

No dedicated `/rampage` command exists. The mission is entirely pickup-driven (`CheckRampagePickup`, called from the world pickup callback in `main.pwn`). The editor is reached via the admin-only `/edit` command (RCON or admin level 4+), which opens a shared "Game Editors" list with a "Rampage Editor" entry. See [Commands Reference](../commands.md) for full details.

## Data & Integration

Reads/writes `gPlayers[playerid][InMinigame]` (blocks/marks minigame overlap) and `gPlayers[playerid][EditingMode]` (editor session flag). Touches the `rampages` and `rampage_coords` tables (coordinate `type` values: 1 = start pickup, 2 = NPC primary/secondary, 4 = weapon, 5 = health), and writes one `high_scores` row per scored run (type 7). Integrates with `support/dialogs.pwn` and `support/response.pwn` for the editor dialogs, `modules/player.pwn` for map-click coordinate capture during editing, and `main.pwn` for the pickup callback, NPC-kill bookkeeping (`OnNPCDeath`/`OnNPCRespawn`) and the startup call to `InitRampageSlots`. See [player.md](player.md) for the `gPlayers` enum, [npcs.md](npcs.md) for the generic NPC lifecycle (rampage NPCs are spawned independently of it, directly via `NPC_*` natives), and [../database.md](../database.md) for schema details.

## Notes

- Listed as **experimental** in the project README ("5-minute long clashes with NPCs on the street").
- Rampage NPCs use raw `NPC_*` natives directly rather than the ambient driver-NPC plumbing in `modules/npcs.pwn`.
- Several `SendClientMessage` lines are commented out (e.g. mission-start message in `SetRampageMission`), suggesting the UX is unfinished.
