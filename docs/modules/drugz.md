# Drugz (Drug Economy & Drug Mission)

Defines the data model and world-init logic for CRL2's drug economy — drug types/prices, the colored drug pickups scattered around the map, the "druggery point" black-market entry pickups, the black market ratio and its daily boom — **and** the timed Drug Mission minigame that dealers run with `/drug`. The server's own drug buyer, the [Fence](fence.md), is a separate module included at the end of this file. The remaining dealer-side gameplay (peer-to-peer deals, black-market offers) still lives in [`player.pwn`](player.md); see Data & Integration below.

**Source:** `src/modules/drugz.pwn` (~650 lines)

## Overview

`drugz.pwn` declares the drug-related enums and global arrays, provides the init/interaction functions that run at `OnGameModeInit` (or on pickup) time, and owns the Drug Mission:

- **Drug catalog** (`gDrugz[MAX_DRUG_TYPES]`) — name, ini-name, and price per drug, loaded from the `drug_prices` table by `InitDrugValues()`.
- **World drug pickups** (`gDrugPickups[MAX_DRUG_PICKUPS]`) — per-type colored pickups (green/white/yellow/blue/red/orange for zaza/cocaine/heroin/meth/fent/pcp) placed from the `drug_coords` table by `InitDrugPickups()`, each respawning every 30 seconds (`PICKUP_TYPE_RESPAWN_30_SECONDS`).
- **Druggery points** (`gDruggeryPoints[MAX_DRUGGERY_POINTS]`, `gDruggeryPointCount` of them loaded) — skull pickups loaded from `druggery_points` that open the black-market dialog when touched. Theirs is the only black-market menu with the third entry, "Sell to the fence"; `IsPlayerAtDruggeryPoint` is the range check the fence uses at the sale.
- **Drug Mission** (`gDrugMission[MAX_PLAYERS]`) — the timed drug-collection minigame for `TEAM_DEALERS` players, including its HUD textdraw, elapsed-time timer, and high-score persistence.
- **Black market** — `gBlackMarketItems[MAX_MARKET_ITEMS]` (listed offers) and the floating `gBlackMarketRatio` price multiplier, recomputed every 3 minutes by `UpdateBlackMarketRatio()`. See [Market ratio](#market-ratio).

Two drug-type enumerations coexist and are **not interchangeable without an offset**: a plain 0-based constant list (`ZAZA=0 … PCP=9`, used to index `Player[Drugs][MAX_DRUG_TYPES]` and `gDrugz[]`), and a tagged `DrugType` enum (`TYPE_NONE=0, TYPE_ZAZA=1 … TYPE_PCP=10`, used by `gDrugPickups[Type]` and `gBlackMarketItems[Type]`). Code that bridges the two subtracts 1 (see `CheckDrugzPickup` here and `ProcessNewBlackMarketOffer` in `player.pwn`).

## Market ratio

`gBlackMarketRatio` multiplies `drug_prices.price` into the "Market price" column of the black market and deal dialogs, and into what the [Fence](fence.md) pays. `UpdateBlackMarketRatio` runs every 3 minutes (`TIMER_UPDATE_BLACK_MARKET_RATIO` in `support/timers.pwn`) and tells every online Dealerz member the new value.

The ratio moves in **log10 space**: the clamps `MARKET_RATIO_MIN`..`MARKET_RATIO_MAX` (0.01–100) are −2..+2 around the equilibrium of 1.0 (level 0), so a step up is as likely as the same step down. `SetBlackMarketRatioLevel` converts a level back and clamps it. A level at or past a bound sets the ratio to exactly that bound, so the boom peaks at exactly 100.0. Each tick is one of three phases:

| Phase | What a tick does |
|---|---|
| `BOOM_NONE` (normal) | A random step of up to `MARKET_STEP_LOG` (0.08, ×1.2 either way), plus a pull of `MARKET_REVERSION_RATE` (8%) of the distance back to equilibrium (half-life about 8 ticks, 25 min). On `MARKET_SHOCK_CHANCE` (5%) of ticks, an extra shock of up to `MARKET_SHOCK_LOG` (0.6, ×4 either way): these are the faster swings. |
| `BOOM_RISING` | +`MARKET_BOOM_STEP_LOG` (0.4, ×2.5) per tick, so 5 ticks from equilibrium to the max and 10 from the very bottom. Fence sales on the way up slow the climb. On tick `MARKET_BOOM_MAX_TICKS` (12) the ratio is set to the max anyway, so the boom always peaks. |
| `BOOM_PEAK` | No drift for `MARKET_BOOM_HOLD_TICKS` (3) ticks; only fence sales move the ratio. On the peaking tick, Dealerz also get `I18N_FENCE_RATIO_PEAK_FMT`. Then back to normal: reversion brings it below 3 in about 17 ticks (50 min). |

Without a boom, a 2-million-tick simulation of these numbers gives a median of 1.00, p10 0.54, p90 1.85 and p99 4.0. The median tick moves the ratio ×1.09, and the 99th-percentile tick ×3.1.

**One boom per game day.** World time follows the real clock (`support/clock.pwn`), so a game day is a real day. `UpdateMarketBoomSchedule` runs at the start of every tick. On the first tick of a new day (`getdate()`'s day of the year changed), it picks the boom's start at random between now and `MARKET_BOOM_LATEST_S` (23:00), so the boom peaks the same day. A server started after 23:00 gets no boom until the next day. A restart re-schedules for the rest of the day, so a day with restarts can see more than one boom. Never fewer, as long as the server is up from the scheduled time to the peak.

**Fence sales push the ratio down.** `PushBlackMarketRatioDown(baseValue)` lowers the level by `MARKET_SALE_IMPACT_LOG` (0.005) per $1000 of list-price value sold (units × `drug_prices.price`, not ratio-adjusted). The change is immediate: the next dialog anyone opens shows it. Player-to-player deals and black market offers don't move the ratio.

The tests in `tests/test_drugz.pwn` pin the boom schedule (`FreezeMarketBoomSchedule`) and check the bounds, the boom from the very bottom, the boom under heavy selling, the schedule, and the sale push-down.

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
| `stock InitDrugValues()` (`src/modules/drugz.pwn:144`) | Loads `drug_prices` (name, alt name, price) into `gDrugz[]`, index 0 seeded from the first row then the rest via `DB_SelectNextRow`. |
| `stock InitDrugPickups()` (`src/modules/drugz.pwn:193`) | Loads `drug_coords` and spawns a color-coded 30s-respawn pickup per drug type into `gDrugPickups[]`. |
| `stock InitDruggeryPoints()` (`src/modules/drugz.pwn:260`) | Loads `druggery_points` and spawns a `PICKUP_SKULL` pickup per row into `gDruggeryPoints[]` (up to `MAX_DRUGGERY_POINTS`), setting `gDruggeryPointCount` — these are the black-market entry points. |
| `stock CheckDruggeryPointPickup(playerid, pickupid)` (`src/modules/drugz.pwn:305`) | Matches a touched pickup against the loaded `gDruggeryPoints[]` and opens `ShowBlackMarketMainDialog(playerid, true)` (with the fence entry) if the player has no dialog already open. |
| `stock bool: IsPlayerAtDruggeryPoint(playerid)` (`src/modules/drugz.pwn:326`) | Whether the player is within `DRUGGERY_POINT_RANGE` (5.0) of any druggery point. The fence checks it at the sale. |
| `stock SetBlackMarketRatioLevel(Float: level)` (`src/modules/drugz.pwn:350`) | Sets `gBlackMarketRatio` from a log10 level, exactly to a bound when the level reaches one. |
| `stock PushBlackMarketRatioDown(baseValue)` (`src/modules/drugz.pwn:368`) | Lowers the ratio for a fence sale of `baseValue` dollars of list-price value. |
| `stock PickMarketBoomTime(now)` (`src/modules/drugz.pwn:375`) | A random boom start between `now` and `MARKET_BOOM_LATEST_S` (seconds since midnight), or -1 when it is too late today. |
| `stock UpdateMarketBoomSchedule()` (`src/modules/drugz.pwn:387`) | Schedules a boom for each new day and starts it when its time has come. |
| `public UpdateBlackMarketRatio()` (`src/modules/drugz.pwn:420`) | 3-minute timer callback: advances the ratio by the current phase and broadcasts it to Dealerz. |
| `public UpdateDrugMissionInfoText(playerid)` (`src/modules/drugz.pwn:503`) | 1s repeating timer callback; accrues `TimeElapsed` and redraws the mission HUD textdraw. |
| `stock CheckDrugzPickup(playerid, pickupid)` (`src/modules/drugz.pwn:521`) | Awards a random amount of the matching drug type on pickup, and adds it to the mission count when a mission is active. |
| `stock SaveDrugMissionScore(playerid)` (`src/modules/drugz.pwn:550`) | Inserts the finished mission into `high_scores` as type 8. No-ops on a zero count. |
| `stock AbortPlayerDrugMission(playerid)` (`src/modules/drugz.pwn:583`) | Ends an active mission: kills the timer, saves the score, clears state, hides the HUD. |
| `stock ToggleDrugMission(playerid)` (`src/modules/drugz.pwn:617`) | Starts the mission (dealers only, not already in a minigame) or delegates to `AbortPlayerDrugMission`; backs `/drug`. |

## Commands

No `dcmd_*` handler lives in this file. The drug/deal features are surfaced through `/drug` (toggles the Drug Mission, dealers only), `/drugz` (opens the player's pocket drug inventory dialog), and `/deal` (dealer-to-player drug sale dialog, dealers only) — all three are implemented as `dcmd_drug`, `dcmd_drugz`, `dcmd_deal` in `src/support/dcmd.pwn`. `/drug` now calls straight into this file's `ToggleDrugMission`; the other two still call into `player.pwn` (`ShowPlayerPocketDrugzDialog`, `ShowDealMainDialog`). See [Commands Reference](../commands.md) for full details.

## Data & Integration

- **Reads/writes `gPlayers[]`:** the Drug Mission functions read `Locale`, `InMinigame`, `TeamID`, `OrmID` and mutate `Drugs[]` and `InMinigame`. The `Drugs[MAX_DRUG_TYPES]` field itself is declared on the `Player` enum in `player.pwn` (see [Player Data Model](player.md#player-data-model)) and is also mutated by `player.pwn`'s `ProcessDealOffer`, `ProcessBlackMarketOffer`, and `ProcessNewBlackMarketOffer`.
- **Database tables:** `drug_prices` (catalog), `drug_coords` (world pickups; `000025` added a zaza pickup south of San Fierro at −1604.23, −1302.11, 56.17), `druggery_points` (black-market pickups), `high_scores` (mission results, type 8). The fence's `fence_sales` log belongs to [`fence.pwn`](fence.md). The player-owned drug inventory (`drugz` table) and black-market listings (`black_market_items` table) are read/written from `player.pwn`. See [Database Schema](../database.md).
- **Calls into:** `support/pickups.pwn` (`EnsurePickupCreated`) and `support/helpers.pwn`.
- **Called from:** `main.pwn`'s `OnPlayerDisconnect` (`AbortPlayerDrugMission`), `support/dcmd.pwn` (`/drug`), `support/texts.pwn` (creates the mission textdraw), `support/timers.pwn` (`UpdateBlackMarketRatio`), [`fence.pwn`](fence.md) (`IsPlayerAtDruggeryPoint`, `PushBlackMarketRatioDown`), and the init calls in `OnGameModeInit`.

## Include position

`player.pwn` includes this file **after** declaring `gPlayers[]` (`src/modules/player.pwn:113`), not before it as it once did. The Drug Mission code reads `gPlayers[]`, and pawncc cannot forward-reference a global variable, so the include has to come after the declaration.

That left one symbol needing to exist earlier — `MAX_DRUG_TYPES`, which sizes the `Drugs[]` field on the `Player` enum. It now lives in `src/support/includes.pwn:14` alongside `MAX_PLAYERS`/`MAX_VEHICLES`. The `DrugType` tag did **not** need moving: Pawn creates a tag on first use, so `DrugType: SelectedDrugID` compiles fine before the enum is declared.

!!! warning "Do not try to split this module across two includes"
    A second `#include` of this file is a no-op: pawncc reads it again, and its `_CRL2_DRUGZ` guard ends it at once. Getting a second phase out of it would mean working around the guard; keep the module in one place instead. `includes.pwn` used to carry a redundant `#include "modules/drugz.pwn"`; it never did anything and has been removed.

## Notes

- The plain-constant vs. `DrugType:`-tagged offset-by-one indexing (noted above) is an easy-to-miss trap if extending drug types.
- `UpdateBlackMarketRatio` used to be defined in `player.pwn`. It moved here with the log-space rewrite, as it only touches this module's globals.
- The `MARKET_*` defines replaced `MARKET_STEP_PERCENT` (20) and the old `MARKET_REVERSION_RATE` (0.005). That ratio took a flat ±0.20 step per tick despite its comment, sat pinned near 0.01 or wandered around 2–4 for hours at a time (half-life about 7 h), and never got anywhere near 100.
- The commented-out `//SendClientMessageLocalized(playerid, I18N_DRUG_MISS_ABORTED);`-style lines around the mission start/stop paths are leftovers from when those messages were chat messages rather than gametext.
