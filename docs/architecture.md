# Architecture

## Boot sequence

The gamemode entry point is `src/main.pwn`, which only does two things: pull in every other file via `#include "support/includes.pwn"`, and implement the top-level SA-MP/open.mp callbacks (`OnGameModeInit`, `OnPlayerConnect`, `OnPlayerSpawn`, `OnPlayerDeath`, `OnDialogResponse`, etc). There is no hook/plugin layer between the server and the gamemode — every callback is a single `public` function in `main.pwn` that calls straight into `stock`/`public` helper functions defined by the modules.

`OnGameModeInit` initializes subsystems in a fixed order:

```text
AddPlayerClass()             → one class; SA-MP needs it before spawn info means anything
InitDB()                     → SQLite connection (src/db/sqlite.pwn)
InitPoliceBribePickups()     → modules/bribe.pwn
InitRampageSlots()           → modules/rampage.pwn
InitRampagePickups()         → modules/rampage.pwn
InitBankLocations()          → modules/bank.pwn
InitDrugValues/Pickups()     → modules/drugz.pwn
InitDruggeryPoints()         → modules/drugz.pwn
InitQuests()                 → modules/quest.pwn
InitTeams()                  → modules/team.pwn
InitRealEstateProperties()   → modules/real.pwn
Race_Init() / InitHighScores → modules/race.pwn
InitTrucking()               → modules/trucking.pwn
InitGasStations()            → modules/fuel.pwn
InitPickups/Objects/Vehicles/Texts/Timers() → support/*.pwn  (InitPickups also calls InitPrizes, modules/prizes.pwn)
InitNPCs()                   → modules/npcs.pwn
InitTaxiStops()              → modules/taxistop.pwn
```

Each `Init*` function is a `stock` that seeds runtime state — usually by reading rows out of SQLite via `DB_*` calls and populating global arrays (pickups, checkpoints, static objects) — rather than a class constructor. See [Database Schema](database.md) for what's actually being loaded.

## Include order (`src/support/includes.pwn`)

There's no build-time dependency resolution: the order in which files are first included **is** the dependency graph. `main.pwn` includes only `support/includes.pwn`, but that list is not the whole story, because many modules `#include` the files they depend on themselves. Each `.pwn` file guards itself with an include-guard define (e.g. `_CRL2_DCMD`) in the same style as the standard library, so double-includes are harmless, but a file used before it's included will fail to compile.

Two pawncc rules shape this graph, and both bite silently:

- **Only the include guard makes `#include` include-once.** Neither `make build` nor `make tests` passes `-Z+`, so pawncc reads a file again at every `#include` of it, and the guard at its top (`#if defined _CRL2_X` / `#endinput`) is what turns the second read into a no-op. A file is therefore compiled where it is *first* included, which is often not its line in `includes.pwn`, and every file needs a guard: `src/db/sqlite.pwn` went without one, so its symbols were defined again at each of its four includes and `make build` failed with `symbol already defined`.
- **Globals cannot be forward-referenced.** A function may call a function defined later in the translation unit (pawncc is two-pass for functions), but reading a global variable before its declaration is `error 017: undefined symbol`. This is why a module that touches `gPlayers[]` must be included after `player.pwn` declares it, and why `MAX_DRUG_TYPES` — needed by the `Player` enum itself — lives in `includes.pwn` rather than in `drugz.pwn`.

The effective order (each file where it is first included, with the file that pulls it in) is:

1. Core defines (`MAX_OBJECTS`, `MAX_PLAYERS`, `MAX_DRUG_TYPES`, `GAMEMODE_NAME`) + `open.mp`/`core`/`float`/`file`/`string` stdlib, then `modules/anticheat_ledger.pwn`. It hooks `GivePlayerWeapon`/`ResetPlayerWeapons`/`SetPlayerAmmo` with `#define`s, which only apply to code after them, so it must precede `support/i18n.pwn`, which pulls in `player.pwn` and most modules.
2. `db/sqlite.pwn`, then `support/i18n.pwn`. The last line of `i18n.pwn` includes `modules/player.pwn` (after the message tables, which player code reads), and `player.pwn` includes most of the gameplay code, so all of this is compiled here, in this order:
    - `team`, `support/helpers`, then `drugz`, included from *inside* `player.pwn` after `gPlayers[]` is declared, because its Drug Mission code reads that array. `drugz` pulls in `support/pickups` (→ `bank`), `quest` and `fence`.
    - `deathmatch`, `combat`.
    - `real`, which pulls in `support/dialogs`, which in turn pulls in `race`, `trucking`, `includes/crazy_race_life_2_version.inc`, `taxi` and `rampage`.
    - `tow` (→ `support/vehicles`), `bribe`, `rob`, `pizza`.
3. Back in `includes.pwn`: `support/net`, `support/http`, `includes/sampctl_build_file.inc`, `support/advert`, `anticheat`, `support/clock`, `auth`, `npcs`, `taxistop`, `fuel`, `radar`, `prizes` (which must precede `support/response`, since that drives its editor dialog), `support/objects` (→ `support/parkour`), `support/texts`, `support/mapicons`, `support/response`, `support/timers`.
4. `support/dcmd.pwn` last, since command handlers call into every module above.

Every other line in `includes.pwn` (`race`, `deathmatch`, `player`, `team`, `real`, `taxi`, `combat`, `bribe`, `tow`, `pizza`, `quest`, `trucking`, `helpers`, `bank`, `pickups`, `vehicles`, `dialogs`) is a no-op by the time it is reached. To check the order after changing an `#include`, compile with a listing and keep the first `#file` line for each file:

```shell
pawncc src/main.pwn -l -isrc -idependencies/omp-stdlib -i. -o/tmp/crl2.lst
grep '^#file' /tmp/crl2.lst | awk '!seen[$0]++'
```

See [Modules](modules/index.md) and [Support Systems](support/world-and-visuals.md) for what each file actually contains.

## Player state

Per-player runtime state lives in a single global array conventionally named `gPlayers[MAX_PLAYERS][...]`, indexed by `playerid` and populated with an enum of fields (team, admin level, locale, cash, drug inventory, mission progress, etc). Modules read and mutate this array directly rather than going through accessor functions — there's no per-module encapsulation, so when tracing a bug touching player state, `grep -rn "gPlayers\[playerid\]\[<Field>\]"` across `src/` is the fastest way to find every call site.

## Spawn lifecycle

Players never see class selection: `OnPlayerConnect` calls `SpawnPlayer()` directly. That means the client has no spawn data of its own, so the gamemode supplies it explicitly with `SetSpawnInfo` before every spawn (`ApplyPlayerSpawnInfo`), rather than spawning first and teleporting afterwards from `OnPlayerSpawn` — the latter races the client's own placement and loses often enough to strand players in the void at `(0, 0)`.

After a death, the respawn is driven by `OnPlayerRequestClass` (the client signalling it has finished dying), with a timer in `OnPlayerDeath` as a fallback only. See [Player Core — Spawning and respawning](modules/player.md#spawning-and-respawning) for the full sequence and the reasoning behind each step.

## Commands (`dcmd`)

Player commands don't use a callback-per-command registry. `OnPlayerCommandText` in `main.pwn` forwards to `LoadDcmdAll` (`src/support/dcmd.pwn`), which expands a `dcmd(name, len, cmdtext)` macro per command. The macro string-compares the command name and, on a match, calls a `dcmd_<name>(playerid, params[])` function — all ~70 of which are implemented directly inside `dcmd.pwn`, not in the feature modules they front. See [Commands Reference](commands.md) for the full list and admin-level gating.

## Localization

User-facing strings are not hardcoded per-callsite; they're looked up through `support/i18n.pwn` by an `I18N_*` key and the player's `PlayerLocale` (`LOCALE_EN`, partial `LOCALE_CZ`), then sent with helpers like `SendClientMessageLocalized`. See [Localization](localization.md).

## Conventions worth knowing before editing code

- **No OOP, no hooks.** Everything is global functions and global arrays. `forward`/`public` pairs are used for functions invoked by name from timers (`SetTimerEx("Foo", ...)`) or the server itself; plain `stock` for everything else.
- **`#if defined _CRL2_TEST_BUILD`** is set by the test harness. It only switches `InitDB()` (`src/db/sqlite.pwn`) to the throwaway `scriptfiles/crl2_test.db` that `make tests` builds from the migrations. Nothing else is stubbed: the tests run on `./omp-server` against the real natives, with NPCs as players (see [Getting Started — Tests](getting-started.md#tests)).
- **Every database call blocks the server.** open.mp's `Databases` component is synchronous on the main thread — there is no async variant in the API this gamemode uses — so a query issued inside a loop stalls every player for its duration. crashdetect reports these as "Long callback execution detected"; treat that warning as a query-count problem first. Prefer filtering in SQL, grouping with window functions, or checking cached state (see [Real Estate — Ownership checks](modules/real.md#ownership-checks)) over re-running a query per item. When a loop has to write row by row, wrap it in `BeginDBTransaction()`/`CommitDBTransaction()` so the batch commits once instead of once per statement (see [Database Schema](database.md#srcdbsqlitepwn-connection-bootstrap)).
- **Coordinates and points are data, not code.** Race checkpoints, property locations, trucking points, and bribe/drug pickups are rows in SQLite (`sql/migrations/`), loaded at `OnGameModeInit` time — adding a new race or property is a migration + data change, not a code change.
- **Admin gating is inline.** There's no role table; every gated command checks `IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] >= N` directly in `dcmd.pwn`.
