# Player Data (Core Player Model)

The central per-player data module for the whole gamemode: defines the `Player` enum and the `gPlayers[MAX_PLAYERS][Player]` array that every other module reads and writes directly, plus the login/load/save pipeline, banking, private messaging, drug-deal/black-market processing, and the global key-press dispatcher (`HandlePlayerKeyStateChange`) that routes input into whichever admin editor or minigame is currently active.

**Source:** `src/modules/player.pwn` (~1674 lines)

## Overview

`player.pwn` is included early in `src/support/includes.pwn` (right after the racing/deathmatch modules, before every other gameplay module) specifically so that the `Player` enum and `gPlayers[]` array exist before `team`, `auth`, `real`, `taxi`, `combat`, `tutorial`, `bribe`, `tow`, and `npcs` are pulled in — several of those files (`real.pwn`, `race.pwn`, `trucking.pwn`, `taxi.pwn`, `tow.pwn`, `bribe.pwn`, `rampage.pwn`) are in turn `#include`d from *inside* this file (lines 638–639, 1022–1028), so `player.pwn` effectively anchors the middle of the whole include graph rather than being a self-contained module.

The player lifecycle is: connect → `ResetPlayerState` clears all per-player minigame/session flags → the auth module (`modules/auth.pwn`) logs the player in → `LoadPlayerData` pulls the `users`/`drugz`/`tutorials` rows for that nickname into `gPlayers[]` and applies them (health, armour, skin, team, wanted level, color) → gameplay happens, with most modules mutating `gPlayers[playerid][...]` directly → `SavePlayerData` persists cash/bank/admin level/wanted/team/skin/health/armour/spawn/properties/locale/playtime plus the drug inventory and tutorial-progress rows back to SQLite. `BatchSavePlayerData` (a periodic timer) calls `SavePlayerData` for every connected, logged-in player as an autosave.

Three other periodic timers live here: `SendPlayerSalary` (team-based income, skipped for AFK players), `UpdatePlayerPlayTime` (accrues `PlayTime`), and `UpdatePlayerScore` (mirrors `GetPlayerMoney` into the scoreboard via `SetPlayerScore`) — see the Notes section for a bug affecting the latter two.

`HandlePlayerKeyStateChange` is the single dispatcher for special key presses (`KEY_JUMP`, `KEY_SECONDARY_ATTACK`, `KEY_SUBMISSION`, `KEY_YES`, `KEY_NO`), and is where cross-cutting minigame checks happen — e.g. `KEY_SUBMISSION` checks, in order, whether the player is trucking, driving a taxi, towing, or a mechanic near a damaged vehicle; `KEY_NO` is the shared "record current position" key for every admin coordinate editor (NPC recording, rampage, race, property, bribe, trucking).

`MAX_PLAYER_PROPERTIES` (7) bounds the `Properties[]` field; `MAX_DRUG_TYPES` (10) bounds `Drugs[]` and is defined in `src/support/includes.pwn:14` — it has to exist before the `Player` enum, while `drugz.pwn` itself is now included *after* `gPlayers[]` (`src/modules/player.pwn:113`) because the Drug Mission code it owns reads that array. See [Drugz — Include position](drugz.md#include-position).

## Spawning and respawning

`SpawnPlayer()` places a player wherever their *spawn info* says. This gamemode spawns players directly from `OnPlayerConnect` rather than through class selection, so without explicit spawn info the client has none to work from and lands at `(0.0, 0.0, 3.1)` — the void near Blueberry Acres. `OnPlayerSpawn` then teleporting them out with `SetPlayerPos` races the client's own spawn placement and only sometimes wins.

`ApplyPlayerSpawnInfo(playerid)` closes that off: it resolves the destination up front — the player's spawn-point property via `GetPlayerPropertySpawnPos` (`modules/real.pwn`), else `SPAWN_DEFAULT_X/Y/Z` (`src/modules/player.pwn:19`, the LV default also used by `OnPlayerSpawn`) — and hands it to the client with `SetSpawnInfo`, preserving the player's current team and skin. It is called before every `SpawnPlayer()` that matters: connect (`main.pwn`), login and registration (`modules/auth.pwn`), and the respawn fallback here. `OnGameModeInit` also registers one `AddPlayerClass` (`src/main.pwn:54`), which SA-MP requires before any spawn info is meaningful.

The respawn path after a death is:

```text
OnPlayerDeath            → schedules SpawnPlayerDelayed after RESPAWN_DELAY_MS (5s), a fallback only
OnPlayerRequestClass     → the client says it has finished dying; spawns logged-in players here
OnPlayerSpawn            → restores health, applies skin/team, repositions as a safety net
```

`OnPlayerRequestClass` refreshes the spawn info before spawning, because skin, team and spawn point can all change during a session. The client sends it once its death sequence completes, which is the only safe moment to respawn — spawning earlier lands mid-sequence and the client re-reports the death it was still playing out, killing the player a second time. `SpawnPlayerDelayed` exists only for clients that never send one; its `IsPlayerAlive()` guard (`support/helpers.pwn:31`) makes it a no-op whenever the normal path already worked, since calling `SpawnPlayer()` on a live player makes the client reload the world.

Health is deliberately **not** restored in `OnPlayerDeath` — doing so while the client is still dying leaves the two sides disagreeing about whether the player is alive. `OnPlayerSpawn` restores it instead.

`SPAWN_DETACH_RETRIES` (5) bounds the detach-and-retry loop for a player who died in a vehicle: death does not fire `OnPlayerExitVehicle`, so they stay attached server-side, and a dead player cannot be removed from a vehicle at all — an unbounded retry would never spawn them.

!!! note "Debug tracing"
    `DEBUG_SPAWN` (`src/support/includes.pwn:39`) gates `[spawn]` trace lines on `OnPlayerRequestClass`, `OnPlayerRequestSpawn`, `OnPlayerSpawn`, `OnPlayerDeath` and `SpawnPlayerDelayed`, printing playerid, player state and position. Set it to `false` to silence them.

### Changing a player's skin

A skin lives in three places, and they drift apart silently if you set only one:

| | what it is | set by |
|---|---|---|
| the live ped | what everyone sees right now | `SetPlayerSkin` |
| `gPlayers[][Skin]` | persisted to `users.class` by `SavePlayerData`; re-applied by `OnPlayerSpawn` | direct assignment |
| the client's spawn info | what the ped looks like the instant it spawns | `SetSpawnInfo`, via `ApplyPlayerSpawnInfo` |

`SetPlayerSkinEx(playerid, skinid)` sets all three and is what every skin change should call. Setting only the live ped means the skin is reverted by the next respawn and never reaches the database — which is exactly what `SetPlayerTeamEx` used to do, so a team skin looked right until the player next died.

Current call sites: `SetPlayerTeamEx` (team skin, `src/modules/player.pwn:1628` — invoked *after* `SetPlayerTeam` so the spawn-info refresh carries the new team), `SelectPropertySkin` (property wardrobe, `src/modules/real.pwn:2225`), `/skin` (`src/support/dcmd.pwn`), and the admin skin dialog (`src/support/response.pwn`).

The two remaining bare `SetPlayerSkin` calls — in `OnPlayerSpawn` and `LoadPlayerData` — are *apply* sites that push the already-cached `gPlayers[][Skin]` onto the ped, so they correctly stay as they are.

## Player Data Model

Every field of the `Player` enum (`src/modules/player.pwn:44`), backing `gPlayers[MAX_PLAYERS][Player]` (`src/modules/player.pwn:114`) — 50 fields in total:

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
| `stock LoadPlayerData(playerid)` (`src/modules/player.pwn:197`) | Loads `users`, `drugz`, and `tutorials` rows for a logged-in player into `gPlayers[]` and applies them to the live player (health, skin, team, wanted, color). |
| `stock SavePlayerData(playerid)` (`src/modules/player.pwn:339`) | Persists cash/bank/admin/wanted/team/skin/health/armour/spawn/properties/locale/playtime plus drug inventory and tutorial stats back to SQLite. |
| `public BatchSavePlayerData()` (`src/modules/player.pwn:174`) | Periodic autosave — calls `SavePlayerData` for every connected, logged-in player. |
| `public SendPlayerSalary()` (`src/modules/player.pwn:461`) | Periodic team-based income payout, skipping AFK players. |
| `public UpdatePlayerPlayTime()` (`src/modules/player.pwn:503`) | Periodic accrual of `PlayTime` for connected, logged-in players. |
| `public UpdatePlayerScore()` (`src/modules/player.pwn:518`) | Periodic scoreboard sync (`SetPlayerScore` from `GetPlayerMoney`). |
| `public GivePlayerWeaponEx(playerid, timerid, weaponid, ammo)` (`src/modules/player.pwn:190`) | Timer callback that (re)gives a weapon after a death-related delay and clears the matching `OnDeathGunsTimer` slot. |
| `stock ExtractPropperties(input[], properties[])` (`src/modules/player.pwn:316`) | Parses the comma-separated `users.properties` string back into an int array. |
| `stock OnPlayerPrivMsg(playerid, receiverid, text[])` (`src/modules/player.pwn:533`) | Sends a `/pm`, charging the sender $10 and playing tones/gametext on both ends. |
| `stock MovePlayerToPlayer(playerid, targetid, reversed)` (`src/modules/player.pwn:590`) | Admin teleport helper — warps one player (or their vehicle) to another, blocked during deathmatch/combat. |
| `stock SetPlayerVehicleNitro(playerid, targetid)` (`src/modules/player.pwn:648`) | Admin helper that installs a NoS component on a target's vehicle. |
| `stock DepositMoneyToBankAccount(playerid, amount)` / `WithdrawMoneyFromBankAccount` (`src/modules/player.pwn:704,724`) | Implements `/bank depo`/`/bank draw`, moving funds between `Cash` (via `GivePlayerMoney`) and `Bank`. |
| `stock ProcessDealOffer(playerid)` / `CleanDealCounterparts` (`src/modules/player.pwn:744,791`) | Executes an accepted dealer-to-player drug sale (money + inventory transfer) and clears both sides' deal-selection fields. |
| `stock ProcessBlackMarketOffer(playerid, listitem)` (`src/modules/player.pwn:794`) | Buys a listed black-market offer, crediting the seller's bank (even if offline) and the buyer's drug inventory. |
| `stock ProcessNewBlackMarketOffer(playerid)` (`src/modules/player.pwn:878`) | Lists a new black-market sell offer from the player's own drug inventory. |
| `stock bool: IsPlayerInTeam(playerid, teamid)` (`src/modules/player.pwn:907`) | Convenience check against `gPlayers[][TeamID]`. |
| `stock ApplyPlayerSpawnInfo(playerid)` (`src/modules/player.pwn:926`) | Resolves where the player should appear (their spawn-point property, else the `SPAWN_DEFAULT_*` position) and hands it to the client via `SetSpawnInfo` **before** spawning. See [Spawning and respawning](#spawning-and-respawning). |
| `stock SetPlayerSkinEx(playerid, skinid)` (`src/modules/player.pwn:941`) | The only correct way to change a skin: updates the live ped, the cached `gPlayers[][Skin]`, **and** the client's spawn info. See [Changing a player's skin](#changing-a-players-skin). |
| `public SpawnPlayerDelayed(playerid)` (`src/modules/player.pwn:951`) | Fallback respawn timer. Skips a player who is already alive, bounds its detach-and-retry loop, and applies spawn info before calling `SpawnPlayer`. |
| `stock HandlePlayerKeyStateChange(playerid, newkeys, oldkeys)` (`src/modules/player.pwn:1016`) | Central special-key dispatcher for minigame shortcuts and every admin coordinate editor's "record position" key. |
| `stock ResetPlayerState(playerid)` (`src/modules/player.pwn:1577`) | Resets all per-session minigame/editor flags on connect (auth, deathmatch, drug mission, trucking, towing, racing, combat, taxi, locale, NPC recording). |

## Commands

Several commands surfaced elsewhere in `dcmd.pwn` call directly into this file: `/bank` → `DepositMoneyToBankAccount`/`WithdrawMoneyFromBankAccount`, `/pm` → `OnPlayerPrivMsg`, `/givecash` (admin-gate-free but self-funded transfer), `/lvl` (`AdminLevel` ≥ 4, sets another player's `AdminLevel` and calls `SavePlayerData`), `/hide` (`TEAM_ADMINZ` only, toggles `Hidden`), `/radio` (`AdminLevel` ≥ 3, toggles `Listening`), `/nitro` (calls `SetPlayerVehicleNitro`), `/npcrec` (`AdminLevel` ≥ 4, toggles `NPCRecording`/`EditingMode`). See [Commands Reference](../commands.md) for the full list and exact admin-level gating.

## Data & Integration

- **`gPlayers[]`:** this file defines the array and touches essentially every field at some point (see the Player Data Model table above); it is the canonical read/write site for `IsLogged`, `Cash`/`Bank`, `Drugs[]`, `Properties[]`, `TutorialStats`, and all of the transient dialog-flow fields (`ClickedPlayerID`, `SelectedDrugID`, `NewRaceID`, etc).
- **Database tables:** `users` (core profile — cash, bank, adminlvl, wanted, team, class/skin, health, armour, spawn, properties, locale, playtime), `drugz` (per-player drug inventory, upserted via `ON CONFLICT`), `tutorials` (onboarding progress, upserted), `black_market_items` (inserted/deleted by the black-market offer functions). See [Database Schema](../database.md).
- **Calls into / called from:** `modules/drugz.pwn` (drug catalog/pickups and the Drug Mission — included *after* `gPlayers[]` is declared), `modules/team.pwn` (`gTeams[]`, `TEAM_*` constants), `modules/tutorial.pwn` (`Tutorial` enum), `modules/real.pwn`, `modules/race.pwn`, `modules/trucking.pwn`, `modules/taxi.pwn`, `modules/tow.pwn`, `modules/bribe.pwn`, `modules/rampage.pwn`, and `modules/deathmatch.pwn`/`modules/combat.pwn` (all `#include`d from inside this file). `support/i18n.pwn` for every localized message. `radar.pwn`'s `HandleCarKill` reads/writes `WantedLevel`.

## Notes

- `ExtractPropperties` (note the typo, kept as-is since it's the real function name) assumes exactly `MAX_PLAYER_PROPERTIES` comma-separated tokens in the stored string; a malformed `users.properties` value could read past the array via the `token1`/`token2` split loop.
- `ID` and `Jailed` are declared on the `Player` enum but have no other reference anywhere in `src/` — both appear to be unused/vestigial fields.
- The Drug Mission (`ToggleDrugMission`, `CheckDrugzPickup`, `UpdateDrugMissionInfoText`) no longer lives here — it moved to [`drugz.pwn`](drugz.md) alongside the rest of the drug economy. `UpdateBlackMarketRatio` is the one drug function still defined in this file.
