# Player Data (Core Player Model)

The central per-player data module for the whole gamemode: defines the `Player` enum and the `gPlayers[MAX_PLAYERS][Player]` array that every other module reads and writes directly, plus the login/load/save pipeline, banking, private messaging, drug-deal/black-market processing, and the global key-press dispatcher (`HandlePlayerKeyStateChange`) that routes input into whichever admin editor or minigame is currently active.

**Source:** `src/modules/player.pwn` (~1633 lines)

## Overview

`player.pwn` is included early in `src/support/includes.pwn` (right after the racing/deathmatch modules, before every other gameplay module) specifically so that the `Player` enum and `gPlayers[]` array exist before `drugz`, `team`, `auth`, `real`, `taxi`, `combat`, `tutorial`, `bribe`, `tow`, and `npcs` are pulled in — several of those files (`real.pwn`, `race.pwn`, `trucking.pwn`, `taxi.pwn`, `tow.pwn`, `bribe.pwn`, `rampage.pwn`) are in turn `#include`d from *inside* this file (lines 638–639, 1022–1028), so `player.pwn` effectively anchors the middle of the whole include graph rather than being a self-contained module.

The player lifecycle is: connect → `ResetPlayerState` clears all per-player minigame/session flags → the auth module (`modules/auth.pwn`) logs the player in → `LoadPlayerData` pulls the `users`/`drugz`/`tutorials` rows for that nickname into `gPlayers[]` and applies them (health, armour, skin, team, wanted level, color) → gameplay happens, with most modules mutating `gPlayers[playerid][...]` directly → `SavePlayerData` persists cash/bank/admin level/wanted/team/skin/health/armour/spawn/properties/locale/playtime plus the drug inventory and tutorial-progress rows back to SQLite. `BatchSavePlayerData` (a periodic timer) calls `SavePlayerData` for every connected, logged-in player as an autosave.

Three other periodic timers live here: `SendPlayerSalary` (team-based income, skipped for AFK players), `UpdatePlayerPlayTime` (accrues `PlayTime`), and `UpdatePlayerScore` (mirrors `GetPlayerMoney` into the scoreboard via `SetPlayerScore`) — see the Notes section for a bug affecting the latter two.

`HandlePlayerKeyStateChange` is the single dispatcher for special key presses (`KEY_JUMP`, `KEY_SECONDARY_ATTACK`, `KEY_SUBMISSION`, `KEY_YES`, `KEY_NO`), and is where cross-cutting minigame checks happen — e.g. `KEY_SUBMISSION` checks, in order, whether the player is trucking, driving a taxi, towing, or a mechanic near a damaged vehicle; `KEY_NO` is the shared "record current position" key for every admin coordinate editor (NPC recording, rampage, race, property, bribe, trucking).

`MAX_PLAYER_PROPERTIES` (7) bounds the `Properties[]` field; `MAX_DRUG_TYPES` (10, from `drugz.pwn`) bounds `Drugs[]`.

## Player Data Model

Every field of the `Player` enum (`src/modules/player.pwn:31`), backing `gPlayers[MAX_PLAYERS][Player]` (`src/modules/player.pwn:100`) — 50 fields in total:

| Field | Type | Purpose |
|---|---|---|
| `ID` | int | Declared but not referenced anywhere else in the codebase (appears vestigial). |
| `OrmID` | int | The row id of this player's `users` table record; used as the FK for `drugz`, `tutorials`, `high_scores`, `black_market_items`. |
| `Name[MAX_PLAYER_NAME]` | string | Cached nickname, used as the `WHERE nickname = ...` key for DB lookups. |
| `PasswordHash[65]` | string | Stored password hash for the auth system (`modules/auth.pwn`). |
| `PasswordSalt[17]` | string | Per-account salt paired with `PasswordHash`. |
| `LoginAttempts` | int | Failed-login counter used by the auth flow. |
| `TeamID` | `PLAYER_TEAM:` | The player's faction (dealers/police/mechanics/none/etc — see `modules/team.pwn`). |
| `Skin` | int | Current player skin/model id. |
| `Cash` | int | Snapshot of cash loaded from `users.cash` at login and given via `GivePlayerMoney`; not kept in sync afterward — live balance is read with `GetPlayerMoney`, which is what `SavePlayerData` writes back. |
| `Bank` | int | Bank account balance (separate from carried cash), adjusted by `/bank depo`/`/bank draw` and black-market settlements. |
| `Health` (Float) | float | Health value loaded from/saved to the DB row. |
| `Armour` (Float) | float | Armour value loaded from/saved to the DB row. |
| `AdminLevel` | int | Staff privilege level (0–5) gating admin commands (`/lvl`, `/kick`, `/ban`, etc.). |
| `WantedLevel` | int | Police wanted stars; mirrors `SetPlayerWantedLevel`/`GetPlayerWantedLevel`, incremented by `radar.pwn`'s `HandleCarKill`. |
| `SpawnPoint` | int | Id of the player's selected spawn location. |
| `Locale` | `PlayerLocale:` | `LOCALE_EN`/`LOCALE_CZ` — selects which row of `gI18nMessages` is used. See [Localization](../localization.md). |
| `IsLogged` | bool | True after successful login/registration; gates autosave inclusion and most gameplay. |
| `AFK` | bool | Away-from-keyboard flag; excludes the player from `SendPlayerSalary` payouts. |
| `Hidden` | bool | Toggled by `/hide` (admin-only); alpha-fades the player's blip color. |
| `Spectating` | bool | True while the player is in spectate mode. |
| `Jailed` | bool | Declared but not referenced anywhere else in the codebase (appears vestigial). |
| `InsideProperty` | bool | True while inside an owned/rented real-estate interior; blocks `/dwarp`, `/port`, etc. |
| `EditingMode` | bool | True while an admin is in one of the coordinate-recording editors; routes `KEY_NO` in `HandlePlayerKeyStateChange`. |
| `DialogShown` | bool | Tracks whether a follow-up input dialog (e.g. bank deposit/withdraw amount) is currently open. |
| `Listening` | bool | Toggled by the admin-only `/radio` command to start/stop an internet radio audio stream. |
| `InMinigame` | bool | Central mutex flag — true whenever racing, drug-missioning, in a deathmatch, or in combat; checked by other modules to block overlapping activities. |
| `SwitchedControllers` | bool | Enables an extra velocity boost on `KEY_JUMP` for a specific vehicle model (530) in `HandlePlayerKeyStateChange`. |
| `AcceptedDeal` | bool | True once the counterpart has accepted a proposed drug deal; checked by `ProcessDealOffer`. |
| `PlayTime` | int | Cumulative milliseconds played; persisted to `users.playtime`. |
| `Drugs[MAX_DRUG_TYPES]` | int[10] | Per-type drug inventory (zaza/tobacco/paper/joint/lighter/cocaine/heroin/meth/fent/pcp); persisted to the `drugz` table. See [Drugz](drugz.md). |
| `Properties[MAX_PLAYER_PROPERTIES]` | int[7] | Owned property ids (`modules/real.pwn`); persisted as a comma-joined string in `users.properties`. |
| `OnDeathGunsTimer[11]` | `Timer:`[] | Pending "regive weapon after death" timer handles, one slot per weapon (see `GivePlayerWeaponEx`). |
| `LoginTimer` | `Timer:` | Handle for the login/registration timeout timer. |
| `PlayTimeTimer` | `Timer:` | Handle for the player's play-time accrual timer. |
| `TutorialStats[Tutorial]` | nested struct | Onboarding-checklist progress (rented/bought property, races finished, joined team, trucking/taxi missions done, sent a PM, bank deposit made, deathmatch played); persisted to the `tutorials` table. |
| `ClickedPlayerID` | int | Last player id selected via an online-player-list dialog. |
| `PMTargetID` | int | Target playerid for a pending `/pm`-style dialog flow. |
| `PropertyOwnedID` | int | Currently selected/owned property id in the real-estate dialog flow. |
| `DealPlayerTargetID` | int | The counterpart playerid in a pending drug deal. |
| `SelectedDrugID` | `DrugType:` | The drug type currently selected in the deal/black-market flow. |
| `SelectedDrugAmount` | int | Quantity selected in the pending deal/offer. |
| `SelectedDrugValue` | int | Unit price selected in the pending deal/offer. |
| `SelectedSkinID` | int | Skin id selected in the skin-change dialog flow. |
| `NewRaceID` | int | Race id being created/edited in the race editor dialog flow. |
| `RacesHSOffset` | int | Pagination offset into the high-scores races list dialog. |
| `NPCRecording` | bool | True while an admin is recording an NPC playback track. |
| `NPCRecordNo` | int | Sequential number appended to the current NPC recording's filename. |
| `NPCRecordSuffix[16]` | string | Filename suffix (kind, e.g. `RACE_00`) for the recording in progress. |
| `OnlinePlayerList[MAX_PLAYERS]` | int[] | Precomputed mapping from a dialog's list-item index to actual playerid. |
| `SkinOp` | `SkinOperation:` | Current step of the skin-management dialog flow (`SKIN_OP_NONE`/`NEW`/`SELECT`/`DELETE`). |

## Key Functions

| Function | Description |
|---|---|
| `stock LoadPlayerData(playerid)` (`src/modules/player.pwn:199`) | Loads `users`, `drugz`, and `tutorials` rows for a logged-in player into `gPlayers[]` and applies them to the live player (health, skin, team, wanted, color). |
| `stock SavePlayerData(playerid)` (`src/modules/player.pwn:390`) | Persists cash/bank/admin/wanted/team/skin/health/armour/spawn/properties/locale/playtime plus drug inventory and tutorial stats back to SQLite. |
| `public BatchSavePlayerData()` (`src/modules/player.pwn:176`) | Periodic autosave — calls `SavePlayerData` for every connected, logged-in player. |
| `public SendPlayerSalary()` (`src/modules/player.pwn:512`) | Periodic team-based income payout, skipping AFK players. |
| `public UpdatePlayerPlayTime()` (`src/modules/player.pwn:554`) | Periodic accrual of `PlayTime` for connected, logged-in players. |
| `public UpdatePlayerScore()` (`src/modules/player.pwn:569`) | Periodic scoreboard sync (`SetPlayerScore` from `GetPlayerMoney`). |
| `public GivePlayerWeaponEx(playerid, timerid, weaponid, ammo)` (`src/modules/player.pwn:192`) | Timer callback that (re)gives a weapon after a death-related delay and clears the matching `OnDeathGunsTimer` slot. |
| `stock ToggleDrugMission(playerid)` (`src/modules/player.pwn:318`) | Starts/stops the timed drug-collection minigame for `TEAM_DEALERS` players; backs `/drug`. |
| `stock ExtractPropperties(input[], properties[])` (`src/modules/player.pwn:367`) | Parses the comma-separated `users.properties` string back into an int array. |
| `public OnPlayerPrivMsg(playerid, receiverid, text[])` (`src/modules/player.pwn:584`) | Sends a `/pm`, charging the sender $10 and playing tones/gametext on both ends. |
| `stock MovePlayerToPlayer(playerid, targetid, reversed)` (`src/modules/player.pwn:641`) | Admin teleport helper — warps one player (or their vehicle) to another, blocked during deathmatch/combat. |
| `stock SetPlayerVehicleNitro(playerid, targetid)` (`src/modules/player.pwn:699`) | Admin helper that installs a NoS component on a target's vehicle. |
| `stock DepositMoneyToBankAccount(playerid, amount)` / `WithdrawMoneyFromBankAccount` (`src/modules/player.pwn:744,764`) | Implements `/bank depo`/`/bank draw`, moving funds between `Cash` (via `GivePlayerMoney`) and `Bank`. |
| `stock CheckDrugzPickup(playerid, pickupid)` (`src/modules/player.pwn:784`) | Awards a random amount of the matching drug type when a world drug pickup (from `drugz.pwn`) is picked up. |
| `stock ProcessDealOffer(playerid)` / `CleanDealCounterparts` (`src/modules/player.pwn:813,860`) | Executes an accepted dealer-to-player drug sale (money + inventory transfer) and clears both sides' deal-selection fields. |
| `stock ProcessBlackMarketOffer(playerid, listitem)` (`src/modules/player.pwn:874`) | Buys a listed black-market offer, crediting the seller's bank (even if offline) and the buyer's drug inventory. |
| `stock ProcessNewBlackMarketOffer(playerid)` (`src/modules/player.pwn:958`) | Lists a new black-market sell offer from the player's own drug inventory. |
| `stock bool: IsPlayerInTeam(playerid, teamid)` (`src/modules/player.pwn:987`) | Convenience check against `gPlayers[][TeamID]`. |
| `public SpawnPlayerDelayed(playerid)` (`src/modules/player.pwn:1003`) | Detaches a player from any vehicle first (working around open.mp's `SpawnPlayer` killing in-vehicle players) before spawning them. |
| `stock HandlePlayerKeyStateChange(playerid, newkeys, oldkeys)` (`src/modules/player.pwn:1030`) | Central special-key dispatcher for minigame shortcuts and every admin coordinate editor's "record position" key. |
| `stock ResetPlayerState(playerid)` (`src/modules/player.pwn:1579`) | Resets all per-session minigame/editor flags on connect (auth, deathmatch, drug mission, trucking, towing, racing, combat, taxi, locale, NPC recording). |

## Commands

Several commands surfaced elsewhere in `dcmd.pwn` call directly into this file: `/drug` → `ToggleDrugMission`, `/bank` → `DepositMoneyToBankAccount`/`WithdrawMoneyFromBankAccount`, `/pm` → `OnPlayerPrivMsg`, `/givecash` (admin-gate-free but self-funded transfer), `/lvl` (`AdminLevel` ≥ 4, sets another player's `AdminLevel` and calls `SavePlayerData`), `/hide` (`TEAM_ADMINZ` only, toggles `Hidden`), `/radio` (`AdminLevel` ≥ 3, toggles `Listening`), `/nitro` (calls `SetPlayerVehicleNitro`), `/npcrec` (`AdminLevel` ≥ 4, toggles `NPCRecording`/`EditingMode`). See [Commands Reference](../commands.md) for the full list and exact admin-level gating.

## Data & Integration

- **`gPlayers[]`:** this file defines the array and touches essentially every field at some point (see the Player Data Model table above); it is the canonical read/write site for `IsLogged`, `Cash`/`Bank`, `Drugs[]`, `Properties[]`, `TutorialStats`, and all of the transient dialog-flow fields (`ClickedPlayerID`, `SelectedDrugID`, `NewRaceID`, etc).
- **Database tables:** `users` (core profile — cash, bank, adminlvl, wanted, team, class/skin, health, armour, spawn, properties, locale, playtime), `drugz` (per-player drug inventory, upserted via `ON CONFLICT`), `tutorials` (onboarding progress, upserted), `black_market_items` (inserted/deleted by the black-market offer functions). See [Database Schema](../database.md).
- **Calls into / called from:** `modules/drugz.pwn` (drug catalog/pickups — included before the `Player` enum so `MAX_DRUG_TYPES` is available), `modules/team.pwn` (`gTeams[]`, `TEAM_*` constants), `modules/tutorial.pwn` (`Tutorial` enum), `modules/real.pwn`, `modules/race.pwn`, `modules/trucking.pwn`, `modules/taxi.pwn`, `modules/tow.pwn`, `modules/bribe.pwn`, `modules/rampage.pwn`, and `modules/deathmatch.pwn`/`modules/combat.pwn` (all `#include`d from inside this file). `support/i18n.pwn` for every localized message. `radar.pwn`'s `HandleCarKill` reads/writes `WantedLevel`.

## Notes

- **`UpdatePlayerPlayTime` and `UpdatePlayerScore` both have a loop bug:** instead of `continue`-ing past a disconnected/not-logged-in player slot, they `return 1` from inside the `for` loop on the first such slot (`src/modules/player.pwn:558-561` and `:573-576`). Since `IsPlayerConnected`/`IsLogged` is false for every unused slot, and slots aren't guaranteed to fill in order, either function can silently stop updating play time or scoreboard for all higher-index players the moment it hits one empty/not-yet-logged-in slot below them. `BatchSavePlayerData` (line ~181) has the equivalent check but correctly uses `continue`, confirming this is inconsistent with the intended pattern.
- `ExtractPropperties` (note the typo, kept as-is since it's the real function name) assumes exactly `MAX_PLAYER_PROPERTIES` comma-separated tokens in the stored string; a malformed `users.properties` value could read past the array via the `token1`/`token2` split loop.
- `ID` and `Jailed` are declared on the `Player` enum but have no other reference anywhere in `src/` — both appear to be unused/vestigial fields.
- The commented-out `//SendClientMessageLocalized(playerid, I18N_DRUG_MISS_ABORTED);`-style lines around `ToggleDrugMission` suggest the drug-mission start/stop messages were migrated from chat messages to gametext-only and the old calls were left in as comments rather than removed.
