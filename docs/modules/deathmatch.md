# Deathmatch

A timed free-for-all deathmatch minigame confined to a gang zone in Los Santos: players register, wait for a 45-second pre-start countdown, then fight for 4 minutes with a live scoreboard, health/armour pickups, and a top-score save to the database at the end.

**Source:** `src/modules/deathmatch.pwn` (~419 lines)

## Overview

Session state is split across three structures: `gDeathmatch[MAX_PLAYERS][Deathmatch]` (per-player `InGame`, `IsRegistered`, `Score`), `gDeathmatchTimers[DeathmatchTimers]` (global `Start`/`Game`/`Elapsed` timer handles plus `TimeElapsed` countdown in ms), and `gDeathmatchPickups[MAX_DEATHMATCH_PICKUPS][DeathmatchPickup]` (up to 10 health/armour pickups placed from the hardcoded `deathmatchPickups[6][3]` coordinate table). Match duration is `DEATHMATCH_TIME_SECONDS = 240` (4 minutes).

`RegisterToDeathmatch(playerid)` is the join entry point: it refuses if a match is already running (`IsValidTimer(gDeathmatchTimers[Game])`) or if the player is in another minigame (`gPlayers[playerid][InMinigame]`), otherwise marks them registered, freezes them at the arena spawn, and — if this is the first registrant — starts a 45-second `StartDeathmatch` pre-game timer and broadcasts a "get ready" message to everyone online. `StartDeathmatch` (fired when that timer elapses) promotes every registered player to `InGame`, creates a per-player gang zone (`CreatePlayerGangZone` over the arena bounds, shown in gold and checked with `UsePlayerGangZoneCheck`), resets their weapons/position via `ResetPlayerDeathmatchState`, and — if at least one player actually joined — starts the 240-second `EndDeathmatch` timer and a 1-second `UpdateDeathmatchScoreboard` ticker, and spawns the health/armour pickups. If nobody joined, it aborts immediately.

`UpdateDeathmatchScoreboard` runs every second, computing the current top scorer and pushing a localized textdraw update (`gDeathmatchText[playerid]`) to every in-game player with player count, leader name/score, and remaining time; if the last participant leaves mid-match it kills both running timers on the spot. `EndDeathmatch` (on timeout or forced) calls `SaveScores` (writes the single top score to `high_scores`, type `2`), then force-`LeaveDeathmatch`s every registered/in-game player and destroys the pickups. `LeaveDeathmatch` is the per-player exit path (used both for early quitting and end-of-match cleanup): hides/destroys the player's gang zone and scoreboard textdraw, clears their `InGame`/`IsRegistered`/`InMinigame` flags, and respawns them.

## Key Functions

| Function | Description |
|---|---|
| `public StartDeathmatch()` (`src/modules/deathmatch.pwn:61`) | Fires after the 45s pre-game timer; promotes registered players to active combatants and starts the match timers. |
| `stock SetDeathmatchPickups()` (`src/modules/deathmatch.pwn:122`) | Spawns the fixed set of health/armour pickups around the arena. |
| `stock CheckDeathmatchPickups(playerid, pickupid)` (`src/modules/deathmatch.pwn:139`) | Applies full health or armour when a player touches a deathmatch pickup. |
| `public EndDeathmatch()` (`src/modules/deathmatch.pwn:166`) | Saves the winning score, removes all remaining participants, destroys pickups, and kills timers. |
| `public UpdateDeathmatchScoreboard()` (`src/modules/deathmatch.pwn:200`) | Per-second tick: recomputes the leaderboard and updates the on-screen textdraw for all in-game players. |
| `stock SaveScores()` (`src/modules/deathmatch.pwn:275`) | Persists the top scorer's score to `high_scores` (skips if score is 0). |
| `stock ResetPlayerDeathmatchState(playerid)` (`src/modules/deathmatch.pwn:324`) | Resets weapons/position and issues starting weapons (`30`, `34`) for a match participant. |
| `stock RegisterToDeathmatch(playerid)` (`src/modules/deathmatch.pwn:335`) | Entry point: registers a player for the next match and starts the pre-game timer if needed. |
| `stock LeaveDeathmatch(playerid)` (`src/modules/deathmatch.pwn:379`) | Removes a player from an in-progress or pending match and cleans up their gang zone/textdraw. |

## Commands

The `/deathmatch` command (`dcmd_deathmatch`, `src/support/dcmd.pwn:271`) is available to all players and simply opens `ShowDeathmatchOptionsDialog`, whose dialog responses call `RegisterToDeathmatch`/`LeaveDeathmatch` (`src/support/response.pwn`). See [Commands Reference](../commands.md) for full details.

## Data & Integration

- **gPlayers[] fields:** `InMinigame` (read to block registration while in another minigame; set/cleared on join/leave), `OrmID` (read in `SaveScores` for the winning player's DB id).
- **Database:** `high_scores` (write only, `type = 2`, `spec_id = 1`). See [../database.md](../database.md).
- **Integration:** `RegisterToDeathmatch`/`LeaveDeathmatch` are called from `src/support/response.pwn` in response to the deathmatch options dialog. `CheckDeathmatchPickups` is called from `main.pwn`'s pickup-touch dispatcher. `gDeathmatchText` textdraws are created/styled in `src/support/texts.pwn`. Uses `CreatePlayerGangZone`/`PlayerGangZoneShow`/`UsePlayerGangZoneCheck` gang zone natives and `EnsurePickupCreated` from `src/support/pickups.pwn`. Localized strings via `I18N_DEATHMATCH_*` keys, see [../localization.md](../localization.md).

## Notes

- `LeaveDeathmatch` builds a "player left" broadcast string (`I18N_DEATHMATCH_PLAYER_LEFT`) inside a loop over all connected players but never actually calls `SendClientMessage` with it — the formatted message is discarded, so the "player left" notification currently doesn't reach anyone. Worth flagging to whoever touches this file next.
- Match capacity/geometry (`deathmatchPickups[6][3]`, the gang zone corners `-1433,-2373,-1293,-2229`, and the fixed spawn `-1365.1, -2307.0, 39.1`) are all hardcoded in this file rather than database-driven, unlike `combat.pwn`'s mission layouts.
