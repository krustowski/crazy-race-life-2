# Architecture

## Boot sequence

The gamemode entry point is `src/main.pwn`, which only does two things: pull in every other file via `#include "support/includes.pwn"`, and implement the top-level SA-MP/open.mp callbacks (`OnGameModeInit`, `OnPlayerConnect`, `OnPlayerSpawn`, `OnPlayerDeath`, `OnDialogResponse`, etc). There is no hook/plugin layer between the server and the gamemode — every callback is a single `public` function in `main.pwn` that calls straight into `stock`/`public` helper functions defined by the modules.

`OnGameModeInit` initializes subsystems in a fixed order:

```text
AddPlayerClass()             → one class; SA-MP needs it before spawn info means anything
InitDB()                     → SQLite connection (src/db/sql.pwn)
InitPoliceBribePickups()     → modules/bribe.pwn
InitRampagePickups()         → modules/rampage.pwn
InitBankLocations()          → modules/bank.pwn
InitDrugValues/Pickups()     → modules/drugz.pwn
InitDruggeryPoints()         → modules/drugz.pwn
InitTeams()                  → modules/team.pwn
InitRealEstateProperties()   → modules/real.pwn
Race_Init() / InitHighScores → modules/race.pwn
InitTrucking()                → modules/trucking.pwn
InitPickups/Objects/Vehicles/Texts/Timers() → support/*.pwn  (InitPickups also calls InitPrizes, modules/prizes.pwn)
InitNPCs()                    → modules/npcs.pwn
```

Each `Init*` function is a `stock` that seeds runtime state — usually by reading rows out of SQLite via `DB_*` calls and populating global arrays (pickups, checkpoints, static objects) — rather than a class constructor. See [Database Schema](database.md) for what's actually being loaded.

## Include order (`src/support/includes.pwn`)

There's no build-time dependency resolution — file order in `includes.pwn` **is** the dependency graph. Each `.pwn` file guards itself with an include-guard define (e.g. `_CRL2_DCMD`) in the same style as the standard library, so double-includes are harmless, but a file used before it's included will fail to compile.

Two pawncc rules shape this graph, and both bite silently:

- **`#include` is include-once.** The build passes `-Z+` (compatibility mode), under which pawncc reads each file at most once — a second `#include` of the same path is a no-op, not a re-read. Splitting a module across two include points therefore cannot work: it compiles cleanly and emits nothing.
- **Globals cannot be forward-referenced.** A function may call a function defined later in the translation unit (pawncc is two-pass for functions), but reading a global variable before its declaration is `error 017: undefined symbol`. This is why a module that touches `gPlayers[]` must be included after `player.pwn` declares it, and why `MAX_DRUG_TYPES` — needed by the `Player` enum itself — lives in `includes.pwn` rather than in `drugz.pwn`. The current order is roughly:

1. Core defines (`MAX_OBJECTS`, `MAX_PLAYERS`, `GAMEMODE_NAME`) + `open.mp`/`core`/`float`/`file`/`string` stdlib.
2. `db/sql.pwn`, `support/i18n.pwn`, `support/net.pwn`, `support/http.pwn` — low-level infrastructure with no dependencies on gameplay state.
3. Generated version headers (`includes/crazy_race_life_2_version.inc`, `includes/sampctl_build_file.inc`).
4. `support/advert.pwn`, `modules/anticheat.pwn`, `support/clock.pwn`.
5. `modules/race.pwn`, `modules/deathmatch.pwn`.
6. The player-data core, `modules/player.pwn`, then everything that reads/writes `gPlayers[]`: `team`, `auth`, `real`, `taxi`, `combat`, `tutorial`, `bribe`, `tow`, `npcs`. `modules/drugz.pwn` is included from *inside* `player.pwn`, after `gPlayers[]` is declared, because its Drug Mission code reads that array.
7. `modules/trucking.pwn`.
8. `support/helpers.pwn`, `modules/radar.pwn`.
9. `modules/bank.pwn`, `modules/prizes.pwn` — the latter must precede `support/response.pwn`, which drives its editor dialog.
10. World-building support: `pickups`, `objects`, `vehicles`, `texts`, `mapicons`, `dialogs`, `response`, `timers`.
11. `support/dcmd.pwn` last, since command handlers call into every module above.

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
- **`#if defined _CRL2_TEST_BUILD`** gates code that shouldn't run under the test harness (e.g. skipping the real SQLite connection in `src/db/sql.pwn`) — check for this define before assuming a code path always runs.
- **Every database call blocks the server.** open.mp's `Databases` component is synchronous on the main thread — there is no async variant in the API this gamemode uses — so a query issued inside a loop stalls every player for its duration. crashdetect reports these as "Long callback execution detected"; treat that warning as a query-count problem first. Prefer filtering in SQL, grouping with window functions, or checking cached state (see [Real Estate — Ownership checks](modules/real.md#ownership-checks)) over re-running a query per item.
- **Coordinates and points are data, not code.** Race checkpoints, property locations, trucking points, and bribe/drug pickups are rows in SQLite (`sql/migrations/`), loaded at `OnGameModeInit` time — adding a new race or property is a migration + data change, not a code change.
- **Admin gating is inline.** There's no role table; every gated command checks `IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] >= N` directly in `dcmd.pwn`.
