# Racing

Implements CRL2's player-vs-clock racing minigame: race definitions and checkpoints loaded from SQLite, registration/entry-fee handling, per-race checkpoint progression with a live HUD timer, prize payout and high-score recording on finish, and an in-game race editor for admins to author new tracks.

![Racing](../assets/img/crl2_racing_start.jpg)

**Source:** `src/modules/race.pwn` (~645 lines)

## Overview

Races are rows in the `races`/`race_coords` tables (see [Database Schema](../database.md)), loaded into `gRaces[MAX_RACE_COUNT]` (`MAX_RACE_COUNT` = 64) by `InitRaces()`. Each `Race` has a `Type` (1 = ground vehicle, 2 = air/aircraft — selects `CP_TYPE_GROUND_*` vs `CP_TYPE_AIR_*` checkpoint types), a `CostDollars` entry fee, a `PrizeDollars` payout, and a `Start` coordinate; `InitRaces()` also drops a pickup and a 3D text label at each race's start.

A player's registration/progress in a race is tracked purely through `gPlayerRace[playerid][raceId]`: `0` means not registered, and any positive value is `1 + <checkpoints already passed>` (also used directly as the next checkpoint index). `CheckPlayerRaceState(playerid)` scans this array and returns the single race a player is currently in (the code enforces — via comments and flow, not an assertion — that a player can only be registered to one race at a time). `SetPlayerRaceState()` validates the join (not already in a minigame, in a vehicle, not already joined, race exists, enough cash), deducts the cost, sets `InMinigame`, and calls `SetPlayerRace()` to fetch that race's `race_coords` and place the first checkpoint via `SetPlayerRaceSingle()`.

`OnPlayerEnterRaceCheckpoint` (`src/main.pwn:830`) — a dedicated open.mp callback for *race* checkpoints, separate from the ordinary `OnPlayerEnterCheckpoint` — calls `CheckRaceCheckpoint(playerid)` first (falling through to tow/trucking checkpoint checks if it returns 0). On the first checkpoint it starts a 1-second repeating timer (`gPlayerRaceTimer`) driving `UpdateRaceInfoText()`, which redraws a per-player textdraw (`gRaceInfoText`) showing checkpoint progress and elapsed `mm:ss`. Reaching the final checkpoint calls `ResetPlayerRaceState(playerid, raceId, true)`, which pays out `PrizeDollars`, broadcasts a finish message, and calls `SaveNewScore()` to insert a `high_scores` row and refresh the cached top-3 leaderboard (`gHighScores`, via `InitHighScores()`). Leaving a race early (death, disconnect, admin abort) instead calls `ResetPlayerRaceState(playerid, raceId, false)`.

The race editor (admin-only, reached through dialogs such as `ShowRaceEditorListDialog`/`ShowRaceEditorOptionsDialog` rather than a dedicated command) records a new race's start position and up to `MAX_RACE_CP` (99) track checkpoints into `gPlayerRaceEdit[playerid]`/`gPlayerRaceEditTrackCoords[playerid][]` as the admin walks/drives the track (coordinate capture itself happens in `player.pwn`'s `HandlePlayerKeyStateChange` under `KEY_NO`), then `SaveRaceData()` bulk-inserts the new `races` + `race_coords` rows and reloads `InitRaces()`.

## Key Functions

| Function | Description |
|---|---|
| `public InitRaces()` (`src/modules/race.pwn:69`) | Loads all rows from `races` into `gRaces[]`, creating a start pickup + 3D text label per race. |
| `stock SetPlayerRaceSingle(playerid, raceId, coords[][], len)` (`src/modules/race.pwn:122`) | Computes and sets the next race checkpoint (normal or finish, ground or air) from the player's current progress. |
| `stock SetPlayerRace(playerid, raceId)` (`src/modules/race.pwn:190`) | Loads `race_coords` for a race from the DB and delegates to `SetPlayerRaceSingle`. |
| `stock SetPlayerRaceState(playerid, raceId)` (`src/modules/race.pwn:240`) | Validates and registers a player for a race, charging `CostDollars` and setting `InMinigame`. |
| `stock ResetPlayerRaceState(playerid, raceId, finishedSuccessfully)` (`src/modules/race.pwn:296`) | Ends a race for a player — pays the prize and records a score on success, or shows an "ended prematurely" message; always clears race/timer/HUD state. |
| `stock CheckPlayerRaceState(playerid)` (`src/modules/race.pwn:366`) | Returns the raceId a player is currently registered to, or `0`. |
| `stock SetPlayerRaceStartPos(playerid)` (`src/modules/race.pwn:381`) | Warps the player's vehicle back to the race start line (only before the first checkpoint is passed). |
| `public UpdateRaceInfoText(playerid)` (`src/modules/race.pwn:409`) | Per-second timer callback that redraws the race HUD textdraw (checkpoint count + elapsed time). |
| `public CheckRaceCheckpoint(playerid)` (`src/modules/race.pwn:436`) | Entry point from `OnPlayerEnterRaceCheckpoint`; starts the race timer on first entry, advances progress, and re-arms the next checkpoint. |
| `stock InitHighScores()` (`src/modules/race.pwn:480`) | Loads the top-3 times per race (`high_scores` joined to `users`) into `gHighScores[]`. |
| `stock SaveNewScore(raceId, playerid, time, vehicleModel)` (`src/modules/race.pwn:537`) | Inserts a new `high_scores` row and refreshes `gHighScores` via `InitHighScores()`. |
| `stock SaveRaceData(playerid)` (`src/modules/race.pwn:571`) | Admin race editor: bulk-inserts the edited race's `races` + `race_coords` rows and reloads `InitRaces()`. |

## Commands

`/race` (`dcmd_race`, `src/support/dcmd.pwn:658`) opens the race list dialog if the player isn't currently racing, or the in-race options dialog (which exposes warping to the start via `SetPlayerRaceStartPos` and quitting via `ResetPlayerRaceState`) if they are. `/scores` (`dcmd_scores`) opens the high-scores dialog backed by `gHighScores`. The race editor has no dedicated `/command` — it's reached through admin dialog menus. See [Commands Reference](../commands.md) for full details and admin-level gating.

## Data & Integration

- **`gPlayers[]` fields:** `InMinigame` (set while racing, blocks other minigames), `NewRaceID` (holds the race id being edited, set from dialogs), `RacesHSOffset` (pagination offset for the high-scores dialog). Cash is debited/credited via `GivePlayerMoney`, not a direct `gPlayers[][Cash]` write.
- **Database tables:** `races`, `race_coords` (read/write), `high_scores` (read/insert), implicitly `race_types`/`high_scores_types` as FK lookups and `users` for score nicknames. See [Database Schema](../database.md).
- **Calls into:** `player.pwn` (`gPlayers[][InMinigame]`), `support/dialogs.pwn` (`ShowRaceListDialog`, `ShowRaceOptionsDialog`, `ShowRaceEditorOptionsDialog`, `ShowHighScoresOptionsDialog`), `support/pickups.pwn` (`EnsurePickupCreated`), localization (`I18N_RACE_*` keys — see [Localization](../localization.md)).
- **Called from:** `src/main.pwn`'s `OnPlayerEnterRaceCheckpoint` and `OnPlayerDeath` (which calls `ResetPlayerRaceState(..., false)` if the dying player was mid-race). The demo race-driver NPCs seen on the same tracks are separate plumbing in [npcs.md](npcs.md) (`NPC_TRACK_RACE_*` playback files), not driven by this file.

## Notes

- `CheckPlayerRaceState`'s single-active-race invariant relies entirely on call-site discipline (registration always resets all other slots); there's no guard preventing a bug elsewhere from setting two `gPlayerRace[playerid][x]` entries simultaneously.
- `MAX_RACE_COORD` (3) is defined but not referenced anywhere in this file — likely a vestige of an earlier fixed-size coordinate layout before `race_coords` became a variable-length DB-backed list.
