# Getting Started

## Prerequisites

CRL2 uses [`sampctl`](https://github.com/Southclaws/sampctl) for package management and building the Pawn source into an `.amx` gamemode.

```shell
dnf install sampctl
```

## Building

From the repository root:

```shell
sampctl ensure
sampctl build

# or simply
make build
```

The debug output (`DebugPrint()` and a few trace lines) is compiled out by default. To build with it:

```shell
sampctl build debug   # the "debug" build in pawn.json
make build DEBUG=1    # the same
make tests DEBUG=1    # the test build, likewise
```

Both pass `DEBUG_ENABLED=1` to pawncc on the command line. They do not use a sampctl `constants` entry on purpose: sampctl writes those into the generated `sampctl_build_file.inc`, where they would stay for later builds, including `make tests`, which does not regenerate that file.

`sampctl ensure` pulls the dependencies declared in `pawn.json` (and pinned in `pawn.lock`) into `dependencies/` — this includes `open.mp`/`samp-stdlib`, YSI-Includes, `SA-MP-MySQL`, `Dini`, and a few small utility includes (`code-parse`, `indirection`, `md-sort`).

A successful build produces a compiled `.amx` gamemode file in the `gamemodes/` directory (e.g. `gamemodes/crl2.amx`).

## Running

Copy the compiled `.amx` into the `gamemodes/` directory of your SA-MP/open.mp server, then reference it in the server config.

**`server.cfg`** (SA-MP):

```text
gamemode0 crl2
```

**`config.json`** (open.mp):

```json
{
  "pawn": {
    "main_scripts": ["crl2 1"]
  }
}
```

The gamemode connects to a bundled SQLite database file (`crl2_data.db` in the repo root) on `OnGameModeInit` — see [Database Schema](database.md) for the schema and how migrations are applied.

To run the server in Docker, `compose.yml` starts it as `samp-server`, serving `/opt/open.mp/data`, next to a MariaDB container. It names no image of its own: set `OMP_SERVER_IMAGE` in `.env` to the open.mp server image to run, or compose stops with an error. `make run` then applies the migrations, copies `gamemodes/crl2.amx` into `/opt/open.mp/data/gamemodes/` and restarts the container.

### Airline filterscript

`filterscripts/airline.pwn` is an optional filterscript, separate from the gamemode. It flies two AT-400s as NPCs, back to back between Las Venturas and San Fierro, playing the recordings `AIR_LVSF` and `AIR_SFLV`. Build it with:

```shell
make airline
```

This writes the two recordings into `npcmodes/recordings/` with `utils/airline/gen_recordings.py`, then compiles `filterscripts/airline.amx`. Both outputs are gitignored. Copy the AMX into the server's `filterscripts/` and the recordings into its `npcmodes/recordings/`, then load it next to the gamemode (`filterscripts airline` in `server.cfg`; on open.mp, `"side_scripts": ["filterscripts/airline"]` under `pawn`). `python3 utils/airline/check_route.py` checks the recordings: where the legs meet, how close the planes come, the flight dynamics, and with `--cadb` the clearance over the terrain.

Loaded before the gamemode, the airline takes vehicle IDs 1 and 2 and two NPC slots. The taxi and pizza missions count every NPC (`NPC_GetAll`), so they get two fewer customers.

### Web portal

The stats dashboard, the map and these docs run as a web portal in front of the same database. `make portal` starts it locally, given the portal's gitignored `Makefile.local`; see [Web Portal](portal.md).

## Local Development

### Connecting with open.mp on Linux

```shell
-h "95.216.7.113" -p "39876" -n "krusty" -g "C:\\Program Files (x86)\\Rockstar Games\\GTA San Andreas\\"
```

### Manual NPC connection

NPC drivers (taxi, trucking, race) are normally spawned by the gamemode itself (see [NPC Drivers](modules/npcs.md)), but a bot can be attached manually for testing using the bundled `samp-npc` binary:

```shell
./samp-npc -h "127.0.0.1" -p "39876" -n "[NPC]taxi" -m "taxi"
```

### Telegram webhook (server announcements)

Server events can be relayed to a Telegram chat via [`adnanh/webhook`](https://github.com/adnanh/webhook). Fill in the bot token and chat ID in `configs/webhook.sh`, then run:

```shell
webhook -hooks configs/webhook.json -verbose &
```

## Tests

Pawn-level tests live under `tests/` (helpers in `tests/includes/`). Run them with:

```shell
make tests
```

This compiles `tests/run_tests.pwn` to `gamemodes/crl2test.amx`, rebuilds `scriptfiles/crl2_test.db` from `sql/migrations`, and runs the suite on `./omp-server`. Results go to `log.txt`; the target prints them and fails unless every test passed.

Nothing is mocked: the tests call the real open.mp natives. Test players are NPCs, so money, health, weapons and connection state come from the server itself. The whole suite runs inside `main()`, before the server's first tick, which shapes how tests are written:

- **Test players are pooled.** `NPC_Destroy()` only takes effect on a later tick, so a destroyed NPC would hold its slot to the end of the run. `DestroyTestPlayer()` returns the NPC to a pool, and `CreateTestPlayer()` hands it out again, renamed and reset to a fresh connection's state (money, weapons, wanted level, interior, checkpoints). Player ids therefore repeat between tests, and neither `ResetPlayerState()` nor the pool wipes `gPlayers[]` or a module's own per-player arrays, so a test sets up whatever state it relies on.
- **Mind the NPC limit.** NPCs the code under test creates (taxi customers, rampage gunmen, combat NPCs) are real and stay until the run ends, all counting towards the test server's `maxnpc` (50). A full combat mission takes over 20. Exercise such code once, and drive the rest of a test by setting state.
- **No driving, no ticks.** An NPC never gets into a vehicle or moves inside `main()`, so entry points that want a driver (`Race_RegisterPlayer`, `SetPlayerTaxiMission`, `CheckPlayerForTruckingMission`) are tested from the state they leave behind. Timers never fire either: a test checks that the code stops the timers it started (`IsValidTimer()`), with `TestIdleTimer` for timers of its own.
- **A run time error ends the suite.** An out-of-bounds index aborts `main()`, and `make tests` stops on it and fails. A crash fix gets a test that shows the abort first.

crashdetect logs a "Long callback execution detected" warning for the run; that is expected. The `ASSERT_*` macros stringify their argument into a `printf` format and cut it at a parenthesised macro, so pass them variables rather than expressions containing string literals, calls with several arguments, or constants such as `INVALID_PICKUP` and `INVALID_NPC_ID`.

## Documentation Tooling

This documentation site is built with [MkDocs](https://www.mkdocs.org/) and the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme.

```shell
pip install mkdocs mkdocs-material

mkdocs serve   # local preview at http://127.0.0.1:8000
mkdocs build   # static site output in site/
make docs      # the same as mkdocs build
```

The [Web Portal](portal.md) serves the built `site/` publicly at `/docs/`, and the navigation's "Portal sign-in" entry links to its `/login`. That link only works under the portal, so it is dead in `mkdocs serve`.

The pages cite code as `` `src/modules/tow.pwn:125` ``, and those numbers go stale whenever the code above them moves. Check them after changing code:

```shell
make docs-check            # fails when a reference no longer points at the code it names
make docs-check FIX=1      # rewrites the ones it can follow to their new line
make docs-check VERBOSE=1  # also lists the references it cannot check
```

A reference is checked against the code name written just before it (`` `stock AbortTowMission(playerid)` (`src/modules/tow.pwn:125`) ``), or elsewhere in the same sentence, within two lines. A function's own table row is held to its definition. `FIX=1` follows a drifted line through git history the way `git blame` does, or falls back to the function's definition, and only writes a number when the name is really there. A renamed or deleted function is reported for a human to fix. Write new references the same way, with the name just before the location, so they can be checked. The script is `utils/docscheck/check_line_refs.py`.
