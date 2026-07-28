# Police Bribes

Implements pickup-based "police bribe" stars that a wanted player can collect to reduce their wanted level by one, plus an in-game admin editing mode for placing/removing bribe pickup locations. It is a small, self-contained minigame with no dedicated `/command`.

**Source:** `src/modules/bribe.pwn` (~165 lines)

## Overview

Bribe pickups are backed by the `police_bribe_coords` table and tracked in `gPoliceBribeStars[MAX_BRIBE_COUNT][BribePickup]` (`MAX_BRIBE_COUNT = 128`), each entry storing the DB `OrmID`, the live `PickupID`, and a `HiddenTimer` used to respawn the star after it's collected. `InitPoliceBribePickups` loads all rows at startup and spawns a `PICKUP_STAR` (model `19`) at each location, tracking the highest ORM id seen in `gPoliceBribeStarLastOrmID`.

`CheckPoliceBribePickup` is the collection handler: it matches the touched `pickupid` against `gPoliceBribeStars`, requires the player to have `gPlayers[playerid][WantedLevel] > 0` (otherwise it silently breaks out), then hides/destroys the pickup, decrements the player's wanted level by 1 via `SetPlayerWantedLevel`, and schedules `HidePoliceBribeTimer` to respawn the star after 60 seconds.

Separately, an admin "bribe edit mode" is supported via the `gBribeEdit[MAX_PLAYERS][BribeEdit]` per-player struct and the `BreditType` enum (`BREDIT_NONE`, `BREDIT_NEW`, `BREDIT_DELETE`). When an admin is in `BREDIT_NEW` mode and clicks a world position (handled in `player.pwn`/`response.pwn`), the picked coordinates and a note are captured into `gBribeEdit[playerid]` and `SaveNewPoliceBribePickup` persists a new row to `police_bribe_coords`, spawns the pickup immediately, and clears the player's `EditingMode`/`BreditType`.

## Key Functions

| Function | Description |
|---|---|
| `public HidePoliceBribeTimer(bribeid)` (`src/modules/bribe.pwn:44`) | One-shot timer callback that re-creates a previously collected bribe pickup at its stored coordinates. |
| `stock InitPoliceBribePickups()` (`src/modules/bribe.pwn:75`) | Loads all bribe pickup coordinates from the database and spawns their pickups at startup. |
| `stock SaveNewPoliceBribePickup(playerid)` (`src/modules/bribe.pwn:107`) | Persists a newly placed bribe location (from admin edit mode) to the database and spawns it. |
| `stock CheckPoliceBribePickup(playerid, pickupid)` (`src/modules/bribe.pwn:140`) | Handles a player touching a bribe pickup: reduces wanted level by 1 and hides the pickup temporarily. |

## Commands

This module has no directly associated `/command` — it is triggered entirely by world pickups (`OnPlayerPickUpPickup`, dispatched from `main.pwn` via `CheckPoliceBribePickup`). The admin placement/deletion flow (`BREDIT_NEW`/`BREDIT_DELETE`) is driven through dialogs in `src/support/dialogs.pwn` and `src/support/response.pwn`, gated by the player's `EditingMode` flag rather than a dedicated dcmd handler.

## Data & Integration

- **gPlayers[] fields:** `WantedLevel` (read and decremented on bribe collection), `EditingMode` (cleared when a new bribe pickup is saved; set/read elsewhere to enter edit mode — see `src/support/response.pwn` and `src/modules/player.pwn`).
- **Database:** the `police_bribe_coords` table (`SELECT` for coordinates, `INSERT` for new bribe locations). See [../database.md](../database.md).
- **Integration:** `InitPoliceBribePickups` is called once from `main.pwn` at startup; `CheckPoliceBribePickup` is called from `main.pwn`'s pickup-touch dispatcher. The admin edit workflow's coordinate capture and dialog prompts live in `src/modules/player.pwn` (checks `gBribeEdit[playerid][Type] != BREDIT_NONE`) and `src/support/response.pwn` (dialog input handling, including the note-text dialog that calls `SaveNewPoliceBribePickup`). Uses `EnsurePickupCreated` (support/pickups.pwn) to spawn pickups.

## Notes

- `SaveNewPoliceBribePickup` indexes into `gPoliceBribeStars` using `++gPoliceBribeStarCount` (pre-increment) for the pickup write but `gPoliceBribeStarCount` (post-increment, unincremented at that point) for the `OrmID` write two lines later — these two writes land on different array slots if not careful; worth double-checking against `gPoliceBribeStarLastOrmID` sequencing if bugs appear in newly-added bribes.
- No player-facing deletion of bribes appears in this file itself (`BREDIT_DELETE` is defined but its DB-delete logic isn't in `bribe.pwn` — check `response.pwn`/`player.pwn` for where the delete path is actually completed).
