# Tutorial

A guidance subsystem intended to walk new players through the game's core features and track their onboarding progress. As shipped, the source file itself contains only the shared data structure — the actual dialog flow and tracking logic live in other files.

**Source:** `src/modules/tutorial.pwn` (~25 lines)

## Overview

The file defines a single enum, `Tutorial`, embedded into every player's record as `gPlayers[playerid][TutorialStats]` (declared in `modules/player.pwn`): an `Active` flag plus counters/flags for `PropertyRentedCount`, `PropertyBoughtCount`, `RaceFinishedCount`, `JoinedTeam`, `TruckingMissionsDone`, `TaxiMissionsDone`, `SentPM`, `DepositedMoneyToBank`, and `DeathmatchPlayed`. `tutorial.pwn` declares no functions of its own — loading these fields from the database (columns `active`, `property_rented_count`, `property_bought_count`, `race_finished_count`, `joined_team`, `trucking_missions_done`, `taxi_missions_done`, `sent_pm`, `deposited_money_to_bank`, `deathmatch_played`) and saving them back happens in `modules/player.pwn`, and the player-facing "tutorial" dialogs (`ShowTutorialMainDialog`, `ShowTutorialStatsDialog`) that read these counters live in `support/dialogs.pwn`.

## Key Functions

None — `tutorial.pwn` contains only the `Tutorial` enum definition (`src/modules/tutorial.pwn:11`), no functions.

## Commands

`/tut` (access level "all") opens the tutorial dialog via `ShowTutorialMainDialog` (defined in `support/dialogs.pwn`, not in this file). See [Commands Reference](../commands.md) for full details.

## Data & Integration

Defines the `Tutorial` enum consumed as `gPlayers[playerid][TutorialStats]` — see [player.md](player.md). Its fields are loaded from and saved to the `users`-related player row (columns listed above) by `modules/player.pwn`; no dedicated table exists for tutorial data — see [../database.md](../database.md). Displayed and updated through `support/dialogs.pwn`.

## Notes

- Listed as **experimental** ("Work in progress") in the project README. The module is effectively a stub: it only declares the shared enum, with no mission logic, triggers, or reward flow of its own.
- Beyond loading/saving, the only place any `TutorialStats` field is mutated elsewhere in the codebase is `support/response.pwn`, which flips `Active` to `true` (presumably a "start tutorial" dialog button). None of the progress counters (`PropertyRentedCount`, `PropertyBoughtCount`, `RaceFinishedCount`, `TruckingMissionsDone`, `TaxiMissionsDone`, `SentPM`, `DepositedMoneyToBank`, `DeathmatchPlayed`) are ever incremented anywhere in the project — the tutorial stats dialog displays counters that never move.
