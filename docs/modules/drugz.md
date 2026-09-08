# Drugz (Drug Economy & Drug Mission)

Defines the data model and world-init logic for CRL2's drug economy — drug types/prices, the colored drug pickups scattered around the map, the "druggery point" black-market entry pickups — **and** the timed Drug Mission minigame that dealers run with `/drug`. The remaining dealer-side gameplay (peer-to-peer deals, black-market offers, the market ratio) still lives in [`player.pwn`](player.md); see Data & Integration below.

**Source:** `src/modules/drugz.pwn` (~435 lines)

## Overview

`drugz.pwn` declares the drug-related enums and global arrays, provides the init/interaction functions that run at `OnGameModeInit` (or on pickup) time, and owns the Drug Mission:

- **Drug catalog** (`gDrugz[MAX_DRUG_TYPES]`) — name, ini-name, and price per drug, loaded from the `drug_prices` table by `InitDrugValues()`.
- **World drug pickups** (`gDrugPickups[MAX_DRUG_PICKUPS]`) — per-type colored pickups (green/white/yellow/blue/red/orange for zaza/cocaine/heroin/meth/fent/pcp) placed from the `drug_coords` table by `InitDrugPickups()`, each respawning every 30 seconds (`PICKUP_TYPE_RESPAWN_30_SECONDS`).
- **Druggery points** (`gDruggeryPoints[MAX_DRUGGERY_POINTS]`) — skull pickups loaded from `druggery_points` that open the black-market dialog when touched.
- **Drug Mission** (`gDrugMission[MAX_PLAYERS]`) — the timed drug-collection minigame for `TEAM_DEALERS` players, including its HUD textdraw, elapsed-time timer, and high-score persistence.
- **Black market** — `gBlackMarketItems[MAX_MARKET_ITEMS]` (listed offers) and a floating `gBlackMarketRatio` price multiplier that mean-reverts toward `MARKET_RATIO_EQULIBRIUM` (1.0) each update, clamped to `[MARKET_RATIO_MIN, MARKET_RATIO_MAX]` (0.01–100.0) with a `MARKET_REVERSION_RATE` of 0.005 and a symmetric random step of up to `MARKET_STEP_PERCENT` (20%). The ratio itself is recomputed by `UpdateBlackMarketRatio()`, still defined in `player.pwn`.

Two drug-type enumerations coexist and are **not interchangeable without an offset**: a plain 0-based constant list (`ZAZA=0 … PCP=9`, used to index `Player[Drugs][MAX_DRUG_TYPES]` and `gDrugz[]`), and a tagged `DrugType` enum (`TYPE_NONE=0, TYPE_ZAZA=1 … TYPE_PCP=10`, used by `gDrugPickups[Type]` and `gBlackMarketItems[Type]`). Code that bridges the two subtracts 1 (see `CheckDrugzPickup` here and `ProcessNewBlackMarketOffer` in `player.pwn`).

## Drug Mission

`/drug` toggles the mission for a `TEAM_DEALERS` player who isn't already in another minigame. While active, every world drug pickup the player touches adds its amount to `gDrugMission[playerid][Count]` (`CheckDrugzPickup`), and a 1-second repeating timer updates the on-screen counter and elapsed clock (`UpdateDrugMissionInfoText`).

The mission ends via `AbortPlayerDrugMission` — from a second `/drug`, or from `OnPlayerDisconnect` in `main.pwn`. It follows the same shape as the taxi mission's `AbortPlayerTaxiMission`: kill the timer, persist the score, clear the state, hide the HUD. `ToggleDrugMission` is now just the start path plus a delegation to the abort path.

`SaveDrugMissionScore` writes one `high_scores` row per completed mission:

| Column | Value |
|---|---|
| `type` | `8` (`TYPE_MISSION_DRUG` in `high_scores_types`) |
| `spec_id` | `1` — a fixed filler; drug missions have no sub-type the way taxi missions have areas |
| `value` | `gDrugMission[playerid][Count]` (drugs collected) |
| `user_id` | `gPlayers[playerid][OrmID]` |
| `time` | `gDrugMission[playerid][TimeElapsed]` (ms) |

A mission with a zero count is not written. The results are read back by `ShowHighScoresMissionDrugDialog` in `src/support/dialogs.pwn`.

## Key Functions

| Function | Description |
|---|---|
| `stock InitDrugValues()` (`src/modules/drugz.pwn:109`) | Loads `drug_prices` (name, alt name, price) into `gDrugz[]`, index 0 seeded from the first row then the rest via `DB_SelectNextRow`. |
| `stock InitDrugPickups()` (`src/modules/drugz.pwn:158`) | Loads `drug_coords` and spawns a color-coded 30s-respawn pickup per drug type into `gDrugPickups[]`. |
| `stock InitDruggeryPoints()` (`src/modules/drugz.pwn:225`) | Loads `druggery_points` and spawns a `PICKUP_SKULL` pickup per row into `gDruggeryPoints[]` — these are the black-market entry points. |
| `stock CheckDruggeryPointPickup(playerid, pickupid)` (`src/modules/drugz.pwn:268`) | Matches a touched pickup against `gDruggeryPoints[]` and opens `ShowBlackMarketMainDialog` if the player has no dialog already open. |
| `public UpdateDrugMissionInfoText(playerid)` (`src/modules/drugz.pwn:293`) | 1s repeating timer callback; accrues `TimeElapsed` and redraws the mission HUD textdraw. |
| `stock CheckDrugzPickup(playerid, pickupid)` (`src/modules/drugz.pwn:311`) | Awards a random amount of the matching drug type on pickup, and adds it to the mission count when a mission is active. |
| `stock SaveDrugMissionScore(playerid)` (`src/modules/drugz.pwn:340`) | Inserts the finished mission into `high_scores` as type 8. No-ops on a zero count. |
| `stock AbortPlayerDrugMission(playerid)` (`src/modules/drugz.pwn:371`) | Ends an active mission: kills the timer, saves the score, clears state, hides the HUD. |
| `stock ToggleDrugMission(playerid)` (`src/modules/drugz.pwn:401`) | Starts the mission (dealers only, not already in a minigame) or delegates to `AbortPlayerDrugMission`; backs `/drug`. |

## Commands

No `dcmd_*` handler lives in this file. The drug/deal features are surfaced through `/drug` (toggles the Drug Mission, dealers only), `/drugz` (opens the player's pocket drug inventory dialog), and `/deal` (dealer-to-player drug sale dialog, dealers only) — all three are implemented as `dcmd_drug`, `dcmd_drugz`, `dcmd_deal` in `src/support/dcmd.pwn`. `/drug` now calls straight into this file's `ToggleDrugMission`; the other two still call into `player.pwn` (`ShowPlayerPocketDrugzDialog`, `ShowDealMainDialog`). See [Commands Reference](../commands.md) for full details.

## Data & Integration

- **Reads/writes `gPlayers[]`:** the Drug Mission functions read `Locale`, `InMinigame`, `TeamID`, `OrmID` and mutate `Drugs[]` and `InMinigame`. The `Drugs[MAX_DRUG_TYPES]` field itself is declared on the `Player` enum in `player.pwn` (see [Player Data Model](player.md#player-data-model)) and is also mutated by `player.pwn`'s `ProcessDealOffer`, `ProcessBlackMarketOffer`, and `ProcessNewBlackMarketOffer`.
- **Database tables:** `drug_prices` (catalog), `drug_coords` (world pickups), `druggery_points` (black-market pickups), `high_scores` (mission results, type 8). The player-owned drug inventory (`drugz` table) and black-market listings (`black_market_items` table) are read/written from `player.pwn`. See [Database Schema](../database.md).
- **Calls into:** `support/pickups.pwn` (`EnsurePickupCreated`) and `support/helpers.pwn`.
- **Called from:** `main.pwn`'s `OnPlayerDisconnect` (`AbortPlayerDrugMission`), `support/dcmd.pwn` (`/drug`), `support/texts.pwn` (creates the mission textdraw), and the init calls in `OnGameModeInit`.

## Include position

`player.pwn` includes this file **after** declaring `gPlayers[]` (`src/modules/player.pwn:113`), not before it as it once did. The Drug Mission code reads `gPlayers[]`, and pawncc cannot forward-reference a global variable, so the include has to come after the declaration.

That left one symbol needing to exist earlier — `MAX_DRUG_TYPES`, which sizes the `Drugs[]` field on the `Player` enum. It now lives in `src/support/includes.pwn:14` alongside `MAX_PLAYERS`/`MAX_VEHICLES`. The `DrugType` tag did **not** need moving: Pawn creates a tag on first use, so `DrugType: SelectedDrugID` compiles fine before the enum is declared.

!!! warning "Do not try to split this module across two includes"
    The project builds with `-Z+`, under which pawncc treats `#include` as **include-once** — a second `#include` of the same file is a silent no-op, not a re-read. A two-phase include guard compiles cleanly and produces nothing. `includes.pwn` used to carry a redundant `#include "modules/drugz.pwn"` for exactly this reason; it never did anything and has been removed.

## Notes

- The plain-constant vs. `DrugType:`-tagged offset-by-one indexing (noted above) is an easy-to-miss trap if extending drug types.
- `UpdateBlackMarketRatio` is still defined in `player.pwn` even though it operates purely on this module's globals — it sits directly below the `drugz.pwn` include there, so moving it across is a small, self-contained follow-up.
- The commented-out `//SendClientMessageLocalized(playerid, I18N_DRUG_MISS_ABORTED);`-style lines around the mission start/stop paths are leftovers from when those messages were chat messages rather than gametext.
