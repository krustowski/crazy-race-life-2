# Database Schema

CRL2 persists all game state in a single SQLite database file, `crl2_data.db`, at the repository root. Schema changes are tracked as sequential, goose-style SQL migrations under `sql/migrations/`, and the gamemode itself only ever opens the database and hands the connection handle to the `DB_*` query wrapper — it does not create or alter tables at runtime.

## Migration workflow

- Migration files live in `sql/migrations/`, named `NNNNNN_description.sql` (`000001` through `000009`), each wrapped in `-- +goose up` / `-- +goose Down` markers so the same file carries both the forward migration and its rollback.
- Migrations are applied with a vendored [goose](https://github.com/pressly/goose) binary checked into the repo at `utils/goose` (a statically-linked Go executable, not a system-wide install). The `Makefile` target is:

  ```make
  migrate:
      @./utils/goose -dir ./sql/migrations sqlite3 crl2_data.db up
  ```

- The `run` Makefile target depends on `migrate`, so every deploy (`make run`) applies any pending migrations to `crl2_data.db` before the compiled `.amx` is copied into the server and the container is restarted.
- A separate `schema` target (`@sqlite3 crl2_data.db '.schema' > sql/base.sql`) can dump the live schema to `sql/base.sql` as a point-in-time snapshot; this file is generated on demand and isn't part of the versioned migration history itself.
- Migration `000001` (`000001_base.sql`) is a large bootstrap migration (~1500 lines) that both creates almost every table and seeds them with the game's original reference/location data (drug prices, race definitions, trucking points, property listings, ATM coordinates, combat mission layouts, etc.) via `INSERT` statements alongside the `CREATE TABLE IF NOT EXISTS` statements.
- Several later migrations don't create any table at all — `000003`, `000006`, and `000007` only `INSERT`/`ALTER` existing tables (a new lookup row, a new column, or another new lookup row, respectively).
- `000004_locale_types.sql` is the only migration that alters an existing table's constraints: since SQLite's `ALTER TABLE` cannot add a foreign key to an existing table, it adds the `locale` column with a plain `ALTER TABLE`, then copies `users` into `users_copy`, drops `users`, recreates it with the `locale` column *and* its `FOREIGN KEY` clause, and copies the data back.

## Tables

39 application tables exist across the 9 migrations (plus SQLite's own internal `sqlite_sequence` bookkeeping table, created alongside the rest in `000001` for `AUTOINCREMENT` columns). Grouped by domain:

### Users, Auth & Progress

| Table | Columns | Keys | Introduced |
|---|---|---|---|
| `users` | `id` INTEGER, `nickname` TEXT NOT NULL, `pwdhash` TEXT NOT NULL, `salt` TEXT NOT NULL, `cash` INTEGER NOT NULL, `bank` INTEGER NOT NULL, `adminlvl` INTEGER NOT NULL, `wanted` INTEGER NOT NULL DEFAULT 0, `team` INTEGER NOT NULL, `class` INTEGER NOT NULL, `health` INTEGER NOT NULL, `armour` INTEGER NOT NULL, `spawn` INTEGER NOT NULL, `properties` TEXT, `locale` INTEGER NOT NULL DEFAULT 0 (added in `000004`), `playtime` INTEGER DEFAULT 0 (added in `000006`) | PK `id` (AUTOINCREMENT); FK `locale` → `locale_types.id` | `000001`; altered `000004`, `000006` |
| `locale_types` | `id` INTEGER, `name` TEXT UNIQUE, `lang_name` TEXT | PK `id` (AUTOINCREMENT) | `000004` |
| `tutorials` | `id` INTEGER, `user_id` INTEGER NOT NULL UNIQUE, `active` INTEGER DEFAULT 0, `property_rented_count` INTEGER DEFAULT 0, `property_bought_count` INTEGER DEFAULT 0, `race_finished_count` INTEGER DEFAULT 0, `joined_team` INTEGER DEFAULT 0, `trucking_missions_done` INTEGER DEFAULT 0, `taxi_missions_done` INTEGER DEFAULT 0, `sent_pm` INTEGER DEFAULT 0, `deposited_money_to_bank` INTEGER DEFAULT 0, `deathmatch_played` INTEGER DEFAULT 0 | PK `id` (AUTOINCREMENT); FK `user_id` → `users.id` | `000001` |

### Racing & High Scores

| Table | Columns | Keys | Introduced |
|---|---|---|---|
| `races` | `id` INTEGER, `name` TEXT, `type` INTEGER, `cost_dollars` INTEGER, `prize_dollars` INTEGER, `start_x`/`start_y`/`start_z` REAL | PK `id`; FK `type` → `race_types.id` | `000001` |
| `race_types` | `id` INTEGER, `label` TEXT | PK `id` | `000001` |
| `race_coords` | `id` INTEGER, `race_id` INTEGER, `seq_no` INTEGER, `x`/`y`/`z`/`rot` REAL | PK `id`; FK `race_id` → `races.id` | `000001` |
| `high_scores` | `id` INTEGER, `type` INTEGER, `spec_id` INTEGER, `value` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, `time` INTEGER, `vehicle_model` INTEGER | PK `id`; FK `type` → `high_scores_types.id`, `user_id` → `users.id` | `000001` |
| `high_scores_types` | `id` INTEGER, `name` TEXT | PK `id`. Rows: `1 TYPE_RACE`, `2 TYPE_DEATHMATCH`, `3 TYPE_MISSON_TAXI`, `4 TYPE_MISSION_TRUCKING`, `5 TYPE_MISSION_COMBAT` (`000001`); `6 TYPE_MISSION_TOW` (`000003`); `7 TYPE_MISSION_RAMPAGE`, `8 TYPE_MISSION_DRUG` (`000008`) | `000001`; data added by `000003`, `000008` |

### Teams & Jobs

| Table | Columns | Keys | Introduced |
|---|---|---|---|
| `teams` | `id` INTEGER, `name` TEXT, `color` TEXT, `skins` TEXT, `weapons` TEXT, `ammu` TEXT, `salary_base_dollars` INTEGER NOT NULL, `salary_volatile_dollars` INTEGER NOT NULL, `pickups` TEXT, `menus` TEXT | PK `id` | `000001` |
| `team_coords` | `id` INTEGER, `team_id` INTEGER NOT NULL, `x`/`y`/`z` REAL | PK `id`; FK `team_id` → `teams.id` | `000001` |

### Real Estate & Properties

| Table | Columns | Keys | Introduced |
|---|---|---|---|
| `properties` | `id` INTEGER, `type` INTEGER NOT NULL DEFAULT 1, `user_id` INTEGER NOT NULL, `vehicle_id` INTEGER, `name` TEXT NOT NULL, `cost` INTEGER NOT NULL, `occupied` INTEGER DEFAULT 0, `custom_interior` INTEGER DEFAULT 0, `locked_until_timestamp` INTEGER NOT NULL DEFAULT 0 | PK `id`; FK `type` → `property_types.id`, `user_id` → `users.id`, `vehicle_id` → `vehicles.id` | `000001` |
| `property_types` | `id` INTEGER, `name` TEXT UNIQUE | PK `id`. Rows: `1 PROPERTY_PEROSNAL` [sic], `2 PROPERTY_COMMERCIAL` | `000001` |
| `property_coords` | `id` INTEGER, `property_id` INTEGER NOT NULL, `type` INTEGER, `primary_x`/`primary_y`/`primary_z`/`primary_rot` REAL, `secondary_x`/`secondary_y`/`secondary_z`/`secondary_rot` REAL | PK `id` (AUTOINCREMENT); FK `property_id` → `properties.id`, `type` → `property_coord_types.id` | `000001` |
| `property_coord_types` | `id` INTEGER, `name` TEXT | PK `id`. Rows `1`–`10` (`SPAWN_POINT` ... `SHIRT_POINT`) added in `000001`; row `11 BLACK_MARKET_POINT` added in `000007` | `000001`; data added by `000007` |
| `property_skins` | `id` INTEGER, `property_id` INTEGER NOT NULL, `skin_id` INTEGER NOT NULL | PK `id` (AUTOINCREMENT); FK `property_id` → `properties.id` | `000001` |
| `vehicles` | `id` INTEGER, `model` INTEGER, `color1`/`color2` INTEGER, `components` TEXT, `paintjob` INTEGER | PK `id` | `000001` |

### Trucking

| Table | Columns | Keys | Introduced |
|---|---|---|---|
| `trucking_points` | `id` INTEGER NOT NULL, `name` TEXT, `type` INTEGER NOT NULL | PK `id`; FK `type` → `trucking_facility_types.id` | `000001` |
| `trucking_coords` | `id` INTEGER NOT NULL, `type` INTEGER NOT NULL, `x`/`y`/`z`/`rot` REAL NOT NULL, `trucking_id` INTEGER NOT NULL DEFAULT 0 | PK `id`; FK `type` → `trucking_coord_types.id`, `trucking_id` → `trucking_points.id` | `000001` |
| `trucking_coord_types` | `id` INTEGER UNIQUE NOT NULL, `name` TEXT | no declared PK (has UNIQUE `id`) | `000001` |
| `trucking_facility_types` | `id` INTEGER, `name` TEXT NOT NULL | PK `id`. Rows: `1 FREIGHT`, `2 GAS_STATION` | `000001` |
| `truck_type` | `id` INTEGER NOT NULL, `name` TEXT | PK `id`. Rows: `1 FREIGHT`, `2 GAS` | `000001` |

### Drugs & Black Market

| Table | Columns | Keys | Introduced |
|---|---|---|---|
| `drugz` | `id` INTEGER, `owner_type` INTEGER NOT NULL DEFAULT 2, `owner_id` INTEGER NOT NULL UNIQUE, `cocaine`/`heroin`/`meth`/`fent`/`zaza`/`tobacco`/`pcp`/`paper`/`lighter`/`joint` INTEGER DEFAULT 0 | PK `id`; FK `owner_type` → `drug_owner_type.id` | `000001` |
| `drug_owner_type` | `id` INTEGER, `name` TEXT | PK `id`. Rows: `1 Player`, `2 Property` | `000001` |
| `drug_types` | `id` INTEGER, `name` TEXT | PK `id`. 10 rows (`ZAZA` ... `PCP`) | `000001` |
| `drug_prices` | `id` INTEGER, `name` TEXT, `name_alt` TEXT, `amount` INTEGER, `price` INTEGER NOT NULL | PK `id` | `000001` |
| `drug_coords` | `id` INTEGER, `type` INTEGER NOT NULL, `x`/`y`/`z` REAL | PK `id`; FK `type` → `drug_types.id` | `000001` |
| `black_market_items` | `id` INTEGER, `settler_id` INTEGER NOT NULL, `drug_type` INTEGER NOT NULL, `amount` REAL NOT NULL, `value` REAL NOT NULL | PK `id` (AUTOINCREMENT); FK `settler_id` → `users.id`, `drug_type` → `drug_types.id` | `000005` |
| `druggery_points` | `id` INTEGER, `x`/`y`/`z` REAL NOT NULL, `note` TEXT | PK `id` (AUTOINCREMENT) | `000009` |

### Combat Missions

| Table | Columns | Keys | Introduced |
|---|---|---|---|
| `combat_mission` | `id` INTEGER, `name` TEXT | PK `id`. Rows: `1 Planning Centre`, `2 Biohazard Labs (demo)` | `000001` |
| `combat_coords` | `id` INTEGER, `type` INTEGER NOT NULL DEFAULT 0, `mission_id` INTEGER, `x`/`y`/`z` REAL NOT NULL | PK `id`; FK `mission_id` → `combat_mission.id`, `type` → `combat_coord_types.id` | `000001` |
| `combat_coord_types` | `id` INTEGER, `name` TEXT | PK `id`. Rows: `COORD_NULL`, `COORD_BRIEFCASE`, `COORD_NPC`, `COORD_HEALTH`, `COORD_HELI`, `COORD_EXIT`, `COORD_ROOF`, `COORD_CP`, `COORD_NPC_MAN`, `COORD_DOOR` | `000001` |

### Police Bribes

| Table | Columns | Keys | Introduced |
|---|---|---|---|
| `police_bribe_coords` | `id` INTEGER, `x`/`y`/`z` REAL, `note` TEXT | PK `id` (AUTOINCREMENT) | `000002` |

### Rampage Missions

| Table | Columns | Keys | Introduced |
|---|---|---|---|
| `rampages` | `id` INTEGER, `name` TEXT, `location_type` INTEGER NOT NULL | PK `id` (AUTOINCREMENT); FK `location_type` → `rampage_location_types.id` | `000008` |
| `rampage_location_types` | `id` INTEGER, `name` TEXT | PK `id` (AUTOINCREMENT). Rows: `TYPE_LOCATION_NONE`/`_LV`/`_SF`/`_LS` | `000008` |
| `rampage_coords` | `id` INTEGER, `rampage_id` INTEGER NOT NULL, `type` INTEGER NOT NULL, `weapon_id` INTEGER, `ammo` INTEGER, `primary_x`/`primary_y`/`primary_z` REAL NOT NULL, `secondary_x`/`secondary_y`/`secondary_z` REAL | PK `id` (AUTOINCREMENT); FK `rampage_id` → `rampages.id`, `type` → `rampage_coord_types.id` | `000008` |
| `rampage_coord_types` | `id` INTEGER, `name` TEXT | PK `id` (AUTOINCREMENT). Rows: `TYPE_COORD_NONE`/`_PICKUP`/`_NPC_SPAWN`/`_NPC_MOVE`/`_WEAPON_SPAWN`/`_HEALTH_POINT` | `000008` |

### Prizes & Banking

| Table | Columns | Keys | Introduced |
|---|---|---|---|
| `prize_types` | `id` INTEGER, `name` TEXT | PK `id`. Rows: `1 PRIZE_TIKI`, `2 PRIZE_PUMPKIN` | `000001` |
| `prize_coords` | `id` INTEGER NOT NULL, `type` INTEGER NOT NULL DEFAULT 0, `name` TEXT, `comment` TEXT, `x`/`y`/`z` INTEGER NOT NULL DEFAULT 0.0, `hidden` INTEGER NOT NULL DEFAULT 0 | PK `id`; FK `type` → `prize_types.id` | `000001` |
| `atm_coords` | `id` INTEGER, `x`/`y`/`z` REAL NOT NULL, `comment` TEXT | PK `id` | `000001` |

A couple of the source `CREATE TABLE` statements have minor quirks worth knowing when writing new queries against them: `prize_coords.x`/`y`/`z` are declared `INTEGER` despite storing float coordinates with a `DEFAULT 0.0` (SQLite's dynamic typing means this doesn't actually break anything, but it's inconsistent with every other coordinate table, which uses `REAL`); and `property_types` has a literal typo in its seed data, `PROPERTY_PEROSNAL` instead of `PROPERTY_PERSONAL`.

## `src/db/sql.pwn` — connection bootstrap

This file is tiny (23 lines) and is the entire database bootstrap layer:

```pawn
new DB: gDbConnectionHandle;

#if !defined _CRL2_TEST_BUILD
new gDbFile[16] = "crl2_data.db";
#endif

stock InitDB()
{
#if !defined _CRL2_TEST_BUILD
    gDbConnectionHandle = DB_Open(gDbFile);
    ...
#else
    print("[TEST] InitDB stubbed");
#endif
}
```

- **`gDbConnectionHandle`** (`DB:` handle) is the single global connection handle used by every `DB_ExecuteQuery`/`DB_FreeResultSet` call across the entire codebase — there is no connection pool or per-module handle, just this one global.
- **`InitDB()`** opens `crl2_data.db` (relative to the server's working directory) via `DB_Open` and prints a success/failure message to the console. It is called once, first, from `main.pwn`'s `OnGameModeInit` (before any other `Init*` function), so every later initializer that queries the database can assume `gDbConnectionHandle` is already set.
- **`_CRL2_TEST_BUILD`**: when this define is set (used by the `tests` Makefile target, which compiles `tests/run_tests.pwn` instead of `gamemodes/crl2.amx`), `InitDB()` is replaced with a stub that only prints `"[TEST] InitDB stubbed"` and never opens a real SQLite connection or even declares `gDbFile`. This lets the test harness compile and run without a real `crl2_data.db` on disk, at the cost of `gDbConnectionHandle` staying at its default/null value for any test that doesn't set it up separately.

`DB_Open`, `DB_ExecuteQuery`, `DB_GetFieldIntByName`, `DB_GetFieldFloatByName`, `DB_GetFieldStringByName`, `DB_SelectNextRow`, `DB_FreeResultSet`, `DB_GetRowCount`, etc. are the SQLite query wrapper natives (`a_mysql`-style API, despite the name, backed by SQLite) supplied by the omp-stdlib dependency — gameplay modules across `src/modules/` and `src/support/` call these directly against `gDbConnectionHandle` to read and write the tables above. This page documents the schema and the connection bootstrap; see the individual [Modules](modules/index.md) pages for what each module actually queries.
