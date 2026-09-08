# Teams

Defines the ten job/faction teams a player can belong to (mechanics, admins, police, truckers, taxi drivers, garbagemen, pizza guys, hackers, drug dealers, or none) and loads each team's skins, starting weapons, salary and colour from the database. The actual join/leave interaction (pickups and menus) is implemented elsewhere and simply consumes the data this module loads.

**Source:** `src/modules/team.pwn` (~192 lines)

## Overview

`PLAYER_TEAM` enumerates `TEAM_NONE` through `TEAM_DEALERS` (10 values total). Each team is described by a `Team` struct: `ID`, `TeamName`, `Color`, up to 5 `Skins`, up to `MAX_TEAM_WEAPONS` (11) starting `Weapons`/`Ammo` pairs, `SalaryBase`/`SalaryVolatile`, plus arrays of world `Pickups` (`MAX_TEAM_PICKUPS` = 16) and SA:MP `Menus` (`MAX_TEAM_MENUS` = 16). `InitTeams()` (called once at startup) loads every row of the `teams` table into `gTeams[]`, converting the stored hex colour string with `HexToInt`, and parsing comma-separated skin/weapon/ammo strings with `ExtractSkinsFromString`/`ExtractWeaponsAmmuFromString`.

The team-selection **pickups and per-team join/leave menus** are actually built in `support/pickups.pwn` (one pickup + a 3-item `CreateMenu` — "Join team"/"Leave team"/"Cancel" — per team, from `team_coords`), and the menu selection itself is handled in `main.pwn`'s `OnPlayerSelectedMenuRow`, which sets `gPlayers[playerid][TeamID]`, colour, skin and starting loadout. `team.pwn` itself contributes no join/leave logic — it is purely data loading plus string-parsing helpers.

## Key Functions

| Function | Description |
|---|---|
| `stock InitTeams()` (`src/modules/team.pwn:51`) | Loads all team rows (name, color, skins, weapons, ammo, salary) from the database. |
| `stock HexToInt(const string[])` (`src/modules/team.pwn:116`) | Parses a hex colour string into an integer. |
| `stock ExtractSkinsFromString(const input[], ints[5])` (`src/modules/team.pwn:136`) | Splits a comma-separated skin-ID string into an array. |
| `stock ExtractWeaponsAmmuFromString(const input[], ints[MAX_TEAM_WEAPONS])` (`src/modules/team.pwn:157`) | Splits a comma-separated weapon/ammo string into an array. |
| `stock CheckTaxiDriversOnline()` / `CheckCarMechanicsOnline()` / `CheckPizzaguysOnline()` (`src/modules/team.pwn:178`, `:183`, `:188`) | Unimplemented stubs — always return 0. |

## Commands

No dedicated `/command` is defined for teams. Team membership is chosen entirely through world pickups (model 1581) that open a per-team SA:MP menu ("Join team"/"Leave team"/"Cancel"), resolved in `main.pwn`. See [Commands Reference](../commands.md) for the full command list.

## Data & Integration

`gPlayers[playerid][TeamID]` is read/written by `main.pwn` and `modules/player.pwn`, not by `team.pwn` itself — see [player.md](player.md). `gTeams[]` is consumed by `support/pickups.pwn` (pickup/menu creation), `support/dialogs.pwn`, `modules/player.pwn`, and `main.pwn` (join/leave, salary payout, colour/skin assignment). Database table: `teams` — see [../database.md](../database.md).

## Notes

- `ExtractSkinsFromString` and `ExtractWeaponsAmmuFromString` are byte-for-byte identical implementations aside from the array size — a candidate for de-duplication.
- `CheckTaxiDriversOnline`, `CheckCarMechanicsOnline` and `CheckPizzaguysOnline` are dead code: each unconditionally `return 0` and are not called anywhere else in the codebase.
