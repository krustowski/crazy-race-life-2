# Quests

An event-driven onboarding and achievement checklist. Twenty-three quests are defined in the database rather than in code; gameplay modules announce what a player just did by calling `FireQuestEvent` (or report a level they reached with `FireQuestLevelEvent`), and the quest module matches that event against every incomplete quest, advances progress, pays the reward on completion, and upserts the result to SQLite.

**Source:** `src/modules/quest.pwn` (~316 lines)

Quests replace the former `modules/tutorial.pwn` stub and its `tutorials` table, both removed in `000010_quests.sql`. The old `/tut` command survives as an alias for `/quest`.

## Overview

Three tables describe the quest catalogue and one holds per-player progress:

| Table | Role |
|---|---|
| `quest_events` | Mirrors the `QuestEvent` enum. Ids must agree with the Pawn enum — the migration says so in a comment, and nothing enforces it. |
| `quest_types` | One row per quest: which `event` advances it, the `target` count, the cash `reward`, a `seq_no`, and an `active` flag. |
| `quest_labels` | Localized `label` + `desc` per `(quest_type, locale)`. One row per quest per locale (EN, CZ, BS). |
| `quests` | Per-player progress: `(user_id, quest_type)` unique, plus `progress` and a nullable `completed_at`. |

In memory the catalogue lives in `gQuests[MAX_QUESTS]` (64 slots) with `gQuestLabels` / `gQuestDesc` alongside it, and progress in `gPlayerQuests[MAX_PLAYERS][MAX_QUESTS]`.

!!! note "The arrays are keyed by `quest_types.id`, not by a dense index"
    `InitQuests` writes `gQuests[id]` directly from the database id, so slot 0 is permanently empty and the array is sparse wherever an id is missing or inactive. Every loop over quests therefore starts at `1`, not `0` — `FireQuestEvent` and `ShowPlayerQuestListDialog` both do. `gQuestCount` counts distinct quests loaded, **not** the highest id, so it is not a valid loop bound; see [Notes](#notes).

## Lifecycle

```text
OnGameModeInit  → InitQuests()          loads the catalogue once, server-wide
login           → LoadPlayerQuests()    fills gPlayerQuests[] for one player
gameplay        → FireQuestEvent()      called by the module that owns the event
                  FireQuestLevelEvent() same, for level events (also once at login)
  └─ UpdateQuestProgress()
       ├─ progress < target → SaveQuestProgress()  upsert progress
       └─ progress ≥ target → CompleteQuest()      upsert progress + completed_at, pay reward, announce it
```

`InitQuests` (`src/main.pwn:60`) joins `quest_types` to `quest_labels` filtered on `active = 1`, so one row comes back per quest **per locale** — the `if (!gQuests[id][ID])` guard is what keeps `gQuestCount` counting quests rather than rows. A row whose quest id is outside `1 .. MAX_QUESTS - 1` or whose locale has no `PlayerLocale` slot is skipped and logged, rather than indexing out of bounds, which would abort `OnGameModeInit` and every `Init*` after it.

`LoadPlayerQuests` runs from `SetPlayerAccountLogin` (`src/modules/auth.pwn:53`) only. The registration path deliberately skips it: a brand-new account has no `quests` rows to read. Right after it, the login path reports the player's current commercial share (see [Level events](#level-events)), so commercial properties rented before the quest existed count without another rent.

## Events

`FireQuestEvent(playerid, event, amount = 1)` is the entry point gameplay modules use for everything they count; the one [level event](#level-events) has its own. It walks every quest, skips those whose event doesn't match or that are already complete, adds `amount` to progress (capped at the quest's `target`, so a large `amount` cannot list a quest as `60 / 1`), and hands the new progress to `UpdateQuestProgress`, which routes to completion or a progress save. All nineteen non-sentinel events are wired:

| Event | Fired from | Quest |
|---|---|---|
| `QUEST_EVT_PROPERTY_RENTED` | `real.pwn:1309` | Rent a property |
| `QUEST_EVT_PROPERTY_BOUGHT` | `real.pwn:1424` | Buy a property |
| `QUEST_EVT_RACE_FINISHED` | `race.pwn:888` | Finish a race |
| `QUEST_EVT_TEAM_JOINED` | `player.pwn:1982` | Join a team |
| `QUEST_EVT_PM_SENT` | `player.pwn:499` | Send a private message |
| `QUEST_EVT_BANK_DEPOSIT` | `player.pwn:927` | Deposit money in the bank |
| `QUEST_EVT_DEATHMATCH_PLAYED` | `deathmatch.pwn:391` | Play a deathmatch round |
| `QUEST_EVT_DEATHMATCH_WON` | `deathmatch.pwn:320` | Win a deathmatch round |
| `QUEST_EVT_TRUCKING_DONE` | `trucking.pwn:170` | Complete 3 trucking runs |
| `QUEST_EVT_TAXI_DONE` | `taxi.pwn:246` | Complete 3 taxi fares |
| `QUEST_EVT_TOW_DONE` | `tow.pwn:313` | Tow 3 vehicles |
| `QUEST_EVT_COMBAT_DONE` | `combat.pwn:632` | Complete a combat mission |
| `QUEST_EVT_RAMPAGE_DONE` | `rampage.pwn:486` | Survive a rampage |
| `QUEST_EVT_DRUG_DONE` | `drugz.pwn:594` | Complete a drug run |
| `QUEST_EVT_PROPERTY_ROBBED` | `rob.pwn` (`StopRobbery`) | Rob 5 / 50 / 500 properties |
| `QUEST_EVT_TAXI_STOP_REACHED` | `taxistop.pwn` (`CheckTaxiStopCheckpoint`) | Call a taxi |
| `QUEST_EVT_TAXI_RIDE_STOP` | `taxistop.pwn` (`UpdateTaxiRide`) | Ride a taxi / Ride through 10 taxi stops |
| `QUEST_EVT_FUEL_BOUGHT` | `fuel.pwn` (`BuyFuel`) | Fill up at a petrol station / Buy 1000 litres of fuel |
| `QUEST_EVT_COMMERCIAL_SHARE` | `real.pwn` (`RentProperty`), `auth.pwn` (`SetPlayerAccountLogin`) | Rent 100% of commercial properties |

`QUEST_EVT_NONE` is a sentinel and has no quest.

Where an event fires decides what a `target` above 1 means. `QUEST_EVT_TOW_DONE` fires inside `CheckTowMissionCheckpoint`, once **per delivered vehicle**, so a target of 3 counts deliveries — the same shape as the taxi and trucking quests. The other mission events fire once per completed run (and only when the run produced something: rampage requires a non-zero kill count, drug a non-zero collection count, combat a success), so their targets are 1. `QUEST_EVT_PROPERTY_ROBBED` fires once **per robbery** that paid anything, so its three quests (targets 5, 50 and 500) count robbed properties, not Rob missions.

The [taxi stop](taxistop.md) events fire per step of a ride. `QUEST_EVT_TAXI_STOP_REACHED` fires when the player walks into the checkpoint the phone's "Call Taxi" set, whether or not a cab is standing there. `QUEST_EVT_TAXI_RIDE_STOP` fires once **per stop** the passenger's NPC cab pulls up at, so the target of 10 counts stops, not rides. `QUEST_EVT_FUEL_BOUGHT` is the one event fired with an `amount`: [`/fuel`](fuel.md) passes the litres it sold. A target of 1 is therefore met by any purchase, and the target of 1000 counts litres.

### Level events

`QUEST_EVT_COMMERCIAL_SHARE` is not a count, so it goes through `FireQuestLevelEvent(playerid, event, level)` instead. Progress becomes the highest `level` reported so far rather than a running sum, and a level at or below the stored progress writes nothing. The level is `GetPlayerCommercialShare` (`real.pwn`), the share of all commercial properties the player rents right now, in percent rounded down. Rounding down means 100 is reached only when the player rents every single one, so the target of 100 stays right however many commercial properties the admins add. A player outrented later keeps their best share, as on every other quest progress never goes down.

The share is reported after every successful `RentProperty` and once at login. An outrented player's share is not re-reported, since it can only drop.

## Persistence

Both write paths are a single SQLite UPSERT against the `UNIQUE(user_id, quest_type)` constraint that `000010` declares:

```sql
INSERT INTO quests (user_id, quest_type, progress) VALUES (?, ?, ?)
ON CONFLICT(user_id, quest_type) DO UPDATE SET progress = excluded.progress
```

`CompleteQuest` adds `completed_at = gettime()` to both the insert and the update clause. A plain `UPDATE` would not work here: the first time a player progresses a quest there is no row yet, and `DB_ExecuteQuery` returns a valid result for an `UPDATE` that matched nothing, so the `if (!result)` guard would not catch the silent loss.

`completed_at` is the only completion marker that survives a restart — `LoadPlayerQuests` derives the in-memory `Completed` flag from `completed_at > 0`.

## Dialogs

`/quest` (and `/tut`) opens `DIALOG_QUEST_LIST` (`0xF0`), a four-column `DIALOG_STYLE_TABLIST_HEADERS` list — the maximum a SA-MP tablist supports:

```text
Quest ID and Name           Reward   Progress   Target
Join a team                 5000     1          1          (green = completed)
Complete 3 taxi fares       15000    2          3
Tow 3 vehicles              15000    0          3
```

Completed rows are coloured green (`0x00FF00`) via an embedded `{%06x}` prefix, incomplete ones white. The list is built in a 2048-character buffer; the 23 quests take about 1220. Selecting a row opens `DIALOG_QUEST_DESC`, a plain message box showing the label and the localized description; its only button returns to the list.

Both dialog functions live in `support/dialogs.pwn` (`:2562`, `:2594`) with every other `Show*Dialog`, not in `quest.pwn` — see [Include position](#data-integration).

## Key Functions

| Function | Description |
|---|---|
| `stock InitQuests()` (`src/modules/quest.pwn:65`) | Loads the active catalogue and all locale strings into `gQuests[]` / `gQuestLabels[]` / `gQuestDesc[]`. Called once from `OnGameModeInit`. |
| `stock LoadPlayerQuests(playerid)` (`src/modules/quest.pwn:132`) | Reads one player's `quests` rows into `gPlayerQuests[]`. Called from the login path only. |
| `stock FireQuestEvent(playerid, QuestEvent:event, amount = 1)` (`src/modules/quest.pwn:250`) | The public API: advances every incomplete quest matching `event`. |
| `stock FireQuestLevelEvent(playerid, QuestEvent:event, level)` (`src/modules/quest.pwn:274`) | The API for [level events](#level-events): raises every incomplete quest matching `event` to `level` if that is higher than its progress. |
| `stock UpdateQuestProgress(playerid, questid, progress)` (`src/modules/quest.pwn:299`) | Sets progress, capped at the target, then calls `CompleteQuest` or `SaveQuestProgress`. Shared by both `Fire*` functions. |
| `stock CompleteQuest(playerid, questid)` (`src/modules/quest.pwn:179`) | Upserts progress + `completed_at`, sets the in-memory flag, pays `gQuests[questid][Reward]`, then tells the player: a chat line with the localized label and reward (`I18N_QUEST_COMPLETED_FMT`) and a style 0 "mission passed" game text with the reward (`I18N_QUEST_COMPLETED_GAMETEXT_FMT`). No mission uses style 0, so a mission's own end text cannot overwrite it. A failed database write returns before any of this, so the player is neither paid nor told. |
| `stock SaveQuestProgress(playerid, questid)` (`src/modules/quest.pwn:223`) | Upserts progress for a quest that is not finished yet. |
| `stock ShowPlayerQuestListDialog(playerid)` (`src/support/dialogs.pwn:2561`) | The four-column quest list. |
| `stock ShowPlayerQuestDescDialog(playerid, questid)` (`src/support/dialogs.pwn:2593`) | Label + description message box for one quest. |

## Commands

`/quest` (`dcmd_quest`, `src/support/dcmd.pwn:735`) and `/tut` (`dcmd_tut`, `src/support/dcmd.pwn:919`) both call `ShowPlayerQuestListDialog`. Neither is gated. See [Commands Reference](../commands.md).

## Data & Integration

- **Database tables:** `quest_events`, `quest_types`, `quest_labels`, `quests` — all introduced in `000010_quests.sql`, with five more mission quests added by `000011_quest_mission_types.sql`, the three rob quests by `000014_rob_quests.sql`, the taxi stop and fuel quests by `000022_taxistop_fuel_quests.sql`, and the commercial share quest by `000023_commercial_share_quest.sql`. See [Database Schema](../database.md).
- **Reads `gPlayers[]`:** `OrmID` (the `users.id` foreign key for every quest row) and `Locale` (which label/description to show). Writes nothing back to `gPlayers[]`; the reward goes out through `GivePlayerMoney`.
- **Called from:** twelve gameplay modules, via `FireQuestEvent` or `FireQuestLevelEvent`, plus the login path in `auth.pwn` (see the [Events](#events) table). `support/response.pwn:2137` handles both dialogs; `support/dcmd.pwn` binds the two commands.
- **Include position:** first included from `modules/drugz.pwn:583` (`drugz.pwn` itself comes in from `modules/player.pwn:128`), so the `QUEST_EVT_*` constants exist before `drugz.pwn:596` and `player.pwn:499` use them. The later includes at `modules/player.pwn:446`, `modules/race.pwn:825`, `modules/player.pwn:1949` and `src/support/includes.pwn:118` are no-ops: no build passes `-Z+`, so pawncc reads the file again each time, and its `_CRL2_QUEST` guard ends each later read at once — see [Architecture](../architecture.md#include-order-srcsupportincludespwn).

!!! warning "Why the dialogs are not in `quest.pwn`"
    `quest.pwn` is compiled from inside `player.pwn` at line 446 — well before `support/dialogs.pwn` and its `DIALOG_*` constants exist. Defining the quest dialogs in `quest.pwn` requires `#include "support/dialogs.pwn"` there, which drags `dialogs.pwn` (and, through it, `taxi.pwn`) in ahead of the `bool:`-tagged `IsPlayerInTeam` at `player.pwn:1143`, producing a *"function with tag result used before definition, forcing reparse"* warning. Keeping the two `Show*` functions in `dialogs.pwn` avoids the cycle entirely.

## Notes

- **`ShowPlayerQuestDescDialog(playerid, listitem + 1)`** (`support/response.pwn:2144`) maps a dialog row back to a quest id by adding 1. That is only correct while active quest ids are contiguous from 1. Deactivate any quest (`quest_types.active = 0`) and `InitQuests` skips it, the list skips it, and every row *after* the gap opens the wrong description. A lookup array built alongside the list — the same pattern `gPlayers[][OnlinePlayerList]` uses for player lists — would make this robust.
- **`seq_no` is selected but unused.** `InitQuests` requests `t.seq_no` and the assignment is commented out (`quest.pwn:93`), there is no `SeqNo` field in the `Quest` enum, and the query has no `ORDER BY`. Display order comes from the `i = 1 .. MAX_QUESTS` loop, i.e. ascending id. The column is currently decorative.
- **Descriptions seeded by `000010` contain a literal `\n`.** SQLite stores the escape as two characters rather than a line break, so quest 1's description renders a visible `\n` in game. `000011` avoids escapes entirely. Fix the old rows with `UPDATE quest_labels SET desc = replace(desc, '\n', char(10)) WHERE quest_type = 1;`.
- **The combat quest is unreachable for ordinary players.** `/combat` is gated behind `AdminLevel >= 1` (`support/dcmd.pwn:1205`), so quest 14 sits at 0/1 for everyone else. Set `quest_types.active = 0` for id 14 to hide it until the command is opened up.
- **`gPlayerQuests` is sized `MAX_PLAYERS × MAX_QUESTS × 2`** = 12 800 cells (~51 KB) for 23 quests. `MAX_QUESTS` has room to grow, but the per-player cost is paid up front regardless of how many quests exist.
- The label column header reads `Quest ID and Name`, but rows render only the label — no id. Either the header or the row format wants adjusting.
