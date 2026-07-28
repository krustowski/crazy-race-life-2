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

Pawn-level tests live under `tests/` (with stub includes in `tests/includes/`). The build system treats a `_CRL2_TEST_BUILD` define specially — for example `src/db/sql.pwn` skips the real SQLite connection and stubs it out under test builds so tests don't require a live database file.

## Documentation Tooling

This documentation site is built with [MkDocs](https://www.mkdocs.org/) and the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme.

```shell
pip install mkdocs mkdocs-material

mkdocs serve   # local preview at http://127.0.0.1:8000
mkdocs build   # static site output in site/
```
