# Drugz (Drug Economy Data)

Defines the data model and world-init logic for CRL2's drug economy: drug types/prices, the colored drug pickups scattered around the map, the "druggery point" black-market entry pickups, and the dealer-side drug/black-market/deal minigame state. Most of the *gameplay logic* that acts on this data (drug missions, peer-to-peer deals, black-market offers) is actually implemented in [`player.pwn`](player.md), which includes this file early in its own compilation — see Data & Integration below.

**Source:** `src/modules/drugz.pwn` (~285 lines)

## Overview

`drugz.pwn` declares the drug-related enums and global arrays and provides four `stock` init/interaction functions that run at `OnGameModeInit` (or on pickup) time:

- **Drug catalog** (`gDrugz[MAX_DRUG_TYPES]`) — name, ini-name, and price per drug, loaded from the `drug_prices` table by `InitDrugValues()`.
- **World drug pickups** (`gDrugPickups[MAX_DRUG_PICKUPS]`) — per-type colored pickups (green/white/yellow/blue/red/orange for zaza/cocaine/heroin/meth/fent/pcp) placed from the `drug_coords` table by `InitDrugPickups()`, each respawning every 30 seconds (`PICKUP_TYPE_RESPAWN_30_SECONDS`).
- **Druggery points** (`gDruggeryPoints[MAX_DRUGGERY_POINTS]`) — skull pickups loaded from `druggery_points` that open the black-market dialog when touched.
- **Black market** — `gBlackMarketItems[MAX_MARKET_ITEMS]` (listed offers) and a floating `gBlackMarketRatio` price multiplier that mean-reverts toward `MARKET_RATIO_EQULIBRIUM` (1.0) each update, clamped to `[MARKET_RATIO_MIN, MARKET_RATIO_MAX]` (0.01–100.0) with a `MARKET_REVERSION_RATE` of 0.005 and a symmetric random step of up to `MARKET_STEP_PERCENT` (20%). The ratio itself is recomputed by `UpdateBlackMarketRatio()`, defined in `player.pwn`.

Two drug-type enumerations coexist and are **not interchangeable without an offset**: a plain 0-based constant list (`ZAZA=0 … PCP=9`, used to index `Player[Drugs][MAX_DRUG_TYPES]` and `gDrugz[]`), and a tagged `DrugType` enum (`TYPE_NONE=0, TYPE_ZAZA=1 … TYPE_PCP=10`, used by `gDrugPickups[Type]` and `gBlackMarketItems[Type]`). Code that bridges the two subtracts 1 (see `CheckDrugzPickup` and `ProcessNewBlackMarketOffer` in `player.pwn`).

## Key Functions

| Function | Description |
|---|---|
| `stock InitDrugValues()` (`src/modules/drugz.pwn:109`) | Loads `drug_prices` (name, alt name, price) into `gDrugz[]`, index 0 seeded from the first row then the rest via `DB_SelectNextRow`. |
| `stock InitDrugPickups()` (`src/modules/drugz.pwn:158`) | Loads `drug_coords` and spawns a color-coded 30s-respawn pickup per drug type into `gDrugPickups[]`. |
| `stock InitDruggeryPoints()` (`src/modules/drugz.pwn:225`) | Loads `druggery_points` and spawns a `PICKUP_SKULL` pickup per row into `gDruggeryPoints[]` — these are the black-market entry points. |
| `stock CheckDruggeryPointPickup(playerid, pickupid)` (`src/modules/drugz.pwn:268`) | Matches a touched pickup against `gDruggeryPoints[]` and opens `ShowBlackMarketMainDialog` if the player has no dialog already open. |

## Commands

No `dcmd_*` handler lives in this file. The drug/deal features are surfaced through `/drug` (toggles the timed drug-collection minigame, dealers only), `/drugz` (opens the player's pocket drug inventory dialog), and `/deal` (dealer-to-player drug sale dialog, dealers only) — all three are implemented as `dcmd_drug`, `dcmd_drugz`, `dcmd_deal` in `src/support/dcmd.pwn` and call into logic that lives in `player.pwn` (`ToggleDrugMission`, `ShowPlayerPocketDrugzDialog`, `ShowDealMainDialog`). See [Commands Reference](../commands.md) for full details.

## Data & Integration

- **Reads/writes `gPlayers[]`:** none directly in this file — `Drugs[MAX_DRUG_TYPES]` (per-player drug inventory) is a field on the `Player` enum defined in `player.pwn` (see [Player Data Model](player.md#player-data-model)), and is mutated by `player.pwn`'s `CheckDrugzPickup`, `ProcessDealOffer`, `ProcessBlackMarketOffer`, and `ProcessNewBlackMarketOffer`.
- **Database tables:** `drug_prices` (catalog), `drug_coords` (world pickups), `druggery_points` (black-market pickups). The player-owned drug inventory (`drugz` table) and black-market listings (`black_market_items` table) are read/written from `player.pwn`, not from this file. See [Database Schema](../database.md).
- **Calls into:** `support/pickups.pwn` (`EnsurePickupCreated`) and `support/helpers.pwn`, both `#include`d directly by this file.
- **Called from / depended on by:** `player.pwn` includes `drugz.pwn` before defining the `Player` enum (so `MAX_DRUG_TYPES` is available for the `Drugs[]` field), and re-implements the actual drug-mission/deal/market gameplay logic itself (`ToggleDrugMission`, `UpdateDrugMissionInfoText`, `UpdateBlackMarketRatio`, `ProcessDealOffer`, `CleanDealCounterparts`, `ProcessBlackMarketOffer`, `ProcessNewBlackMarketOffer`) rather than in `drugz.pwn`.

## Notes

- The split between "data/init lives in `drugz.pwn`" and "gameplay logic lives in `player.pwn`" is a structural quirk of the include order (`includes.pwn` pulls in `modules/race.pwn`/`modules/deathmatch.pwn` before `modules/player.pwn`, and `player.pwn` itself `#include`s `drugz.pwn` before declaring its own drug-mission functions) rather than a deliberate module boundary — when tracing drug-related behavior, check both files.
- The plain-constant vs. `DrugType:`-tagged offset-by-one indexing (noted above) is a easy-to-miss off-by-one trap if extending drug types.
