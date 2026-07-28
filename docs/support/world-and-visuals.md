# World & Visuals

Shared world-building infrastructure: static map objects, pickups, static vehicle spawns, on-screen texts/3D-ish HUD labels, and client-side map icons. Gameplay modules (races, real estate, missions, teams) create their own pickups and icons through the primitives these files expose rather than calling the raw natives directly.

## Objects (`src/support/objects.pwn`, ~516 lines)

Almost the entire file is a single function, `InitObjects()`, consisting of several hundred hardcoded `CreateObject(...)` calls that decorate the map: an admin house/elevator shaft near the Las Venturas pyramid, and large blocks of custom scenery credited "MADE BY KOMPRY - MTA" scattered across San Fierro docks, Las Venturas garages, and other add-on locations. The only object whose id is kept around is `gAdminElevator`, the physical elevator platform later driven by the `/elevator` admin subcommand in `src/support/dcmd.pwn` (`MoveObject`/`StopObject` on `gAdminElevator`). The file `#include`s `support/parkour.pwn` at the top and `InitObjects()` calls `InitParkour()` as its last statement, so the parkour course's geometry is created as part of the same startup step even though it lives in a separate file.

**Key functions:**

| Function | Description |
|---|---|
| `stock InitObjects()` (`src/support/objects.pwn:15`) | Creates every static decorative map object (admin house, SF/LS/LV add-on scenery) and finishes by calling `InitParkour()`. |

## Pickups (`src/support/pickups.pwn`, ~484 lines)

Defines the pickup model-id constants (`PICKUP_BRIEFCASE`, `PICKUP_HOUSE_GREEN`, `PICKUP_DRUG_*`, etc.) and the SA-MP/open.mp pickup-type constants (`PICKUP_TYPE_ALWAYS`, `PICKUP_TYPE_RESPAWN_30_SECONDS`, ...) used across the codebase. `InitPickups()` spawns the fixed set of world pickups that don't belong to a specific gameplay module: the admin room health pack, the Hackerz interior entrance/exit/money-bag pickups, one ATM pickup per entry in `gBankLocation` (from `modules/bank.pwn`), a per-team join pickup plus join/leave menu built from a `team_coords`/`teams` join query, a handful of legacy hardcoded property doors, and the SF Centrum / Bank LS teleport pickup pairs. `InitPrizes()` separately loads the tiki/pumpkin "hidden prize" pickups from the `prize_coords` table (`WHERE hidden = 0`) into `gPrizes[MAX_PRIZES]`; `UpdatePrize` marks a prize row `hidden = 1` in the database and pays out $10M (tiki) or $1.5M (pumpkin). `CreateDeathMoneyPickup`/`CheckDeathMoneyPickup` implement a small ring buffer (`gDeathMoneyPickups[MAX_DEATH_MONEY_PICKUPS]`, 128 slots) of "money bag" pickups dropped at a player's death position holding their cash, redeemable by whoever picks them up first. `CheckBlackMarketPickup` and `CheckGenericPickup` are dispatch helpers called from `main.pwn`'s `OnPlayerPickUpPickup` to route a touched `pickupid` to the right handler (black market dialog, SF Centrum/Bank LS teleports, Hackerz interior, admin room heal/doors).

The actual `CreatePickup` retry logic lives in `EnsurePickupCreated` (`src/support/helpers.pwn:226`), not in this file — pickups.pwn and every gameplay module that spawns a pickup call into that shared helper.

`gAdminDoorDown`/`gAdminDoorUp` are declared (lines 52-53) and checked in `CheckGenericPickup`, but nothing in the codebase ever assigns them a real pickup id — those two branches are effectively dead code.

**Key functions:**

| Function | Description |
|---|---|
| `public InitPickups()` (`src/support/pickups.pwn:98`) | Spawns admin/Hackerz/bank/team/legacy-property pickups and builds per-team join menus from the database. |
| `stock InitPrizes()` (`src/support/pickups.pwn:241`) | Loads non-hidden tiki/pumpkin prize pickups from `prize_coords` into `gPrizes`. |
| `stock UpdatePrize(playerid, prizeid)` (`src/support/pickups.pwn:294`) | Marks a prize collected in the database and pays out the tiki/pumpkin reward. |
| `stock CreateDeathMoneyPickup(playerid)` (`src/support/pickups.pwn:339`) | Drops the dying player's cash as a pickup at their position and resets their money. |
| `stock CheckDeathMoneyPickup(playerid, pickupid)` (`src/support/pickups.pwn:367`) | Redeems a death-money pickup for whichever player touches it. |
| `stock CheckBlackMarketPickup(playerid, pickupid)` (`src/support/pickups.pwn:388`) | Opens the black market dialog if the touched pickup is the druggery market spot. |
| `stock CheckGenericPickup(playerid, pickupid)` (`src/support/pickups.pwn:398`) | Dispatches all other fixed world pickups (druggery entrance, prizes, SF Centrum/Bank LS teleports, admin room/doors, Hackerz). |

## Vehicles (`src/support/vehicles.pwn`, ~475 lines)

`InitVehicles()` places roughly 150 static spawn vehicles across the map via `AddStaticVehicle(...)` — taxis at train stations and airports, a San Fierro tram, tow trucks at the SF docks, boats for the Bayside race, desert carts for the El Quebrados race, and large unlabeled blocks of vehicles (garages, police helicopters, an off-road area) carried over from the original map design, many still bearing their original Czech comments (`garaz`, `letiste venturas`). At the end it loops every vehicle slot up to `MAX_VEHICLES` and stamps `VEHICLE_PLATE` ("--CRL2--") onto all of them via `SetVehicleNumberPlate`. The file also defines `gVehicleNames[]`, a lookup table of ~212 human-readable vehicle model names (Landstalker, Bravura, ... Utility Trailer) used elsewhere to print a friendly name for a vehicle model.

**Key functions:**

| Function | Description |
|---|---|
| `public InitVehicles()` (`src/support/vehicles.pwn:11`) | Spawns all static map vehicles and stamps the `--CRL2--` plate onto every vehicle slot. |

`gVehicleNames[]` (`src/support/vehicles.pwn:261`) is a data table, not a function — it maps a vehicle model id (offset from 400) to its display name.

## Texts (`src/support/texts.pwn`, ~83 lines)

`InitTexts()` creates the two global, not-per-player TextDraws: `gGameModeText` (the bottom-left "CrazyRaceLife2" branding label, drawn with the `MINIMAP_TEXT` string) and `gClockText` (the top-right in-game clock, owned and redrawn by `src/support/clock.pwn`'s `DrawClockText`). `AddTexts(playerid)` is called once per connecting human player (it skips NPCs) to create that player's private set of HUD TextDraws — mission/race/tow/rampage/drug-mission info texts and a vehicle-state text — then shows `gClockText` and `gGameModeText` to them.

**Key functions:**

| Function | Description |
|---|---|
| `public InitTexts()` (`src/support/texts.pwn:16`) | Creates the shared `gGameModeText` and `gClockText` TextDraws. |
| `public AddTexts(playerid)` (`src/support/texts.pwn:35`) | Creates a connecting player's per-player HUD TextDraws and shows the clock/branding text to them. |

## Map Icons (`src/support/mapicons.pwn`, ~259 lines)

Defines the `E_MAPICON_ID_*` enum, a large set of constants mirroring the client's built-in GTA map icon IDs (ammu-nation, police, hospital, save house, and around 60 others). `AddMapicons(playerid)` is the single function in the file, called once per player after a successful login (from `modules/auth.pwn`). It lays down every client-side map icon the player should see: one per ATM (`gBankLocation`), one per named race start point (`gRaces`), a handful of hardcoded "property for sale" markers, the tow mission dock, a save-house icon for each real-estate property the player owns, one team-join icon per row in `team_coords`/`teams` (icon chosen per `PLAYER_TEAM` via a `switch`), and one icon per trucking petrol station (`trucking_coords WHERE type = 2`). Icon indices are assigned locally via an incrementing `mapiconid` counter and all use `MAPICON_LOCAL` scope.

**Key functions:**

| Function | Description |
|---|---|
| `public AddMapicons(playerid)` (`src/support/mapicons.pwn:78`) | Draws every client-side map icon for a just-authenticated player (ATMs, races, housing, teams, trucking). |

## Models (`src/support/models.pwn`, ~27 lines)

Defines `DOWNLOAD_REQUEST_*` constants and a single stock, `InitVehicleModels()`, intended to register custom vehicle models (via `AddSimpleModel`) served from `gModelsUrl` ("https://cdn.vxn.dev/samp"). Every statement inside the function is commented out, so it currently just `return 1`s. The file is not pulled in by `support/includes.pwn` (`#include "support/models.pwn"` there is commented out) and the call to `InitVehicleModels()` in `main.pwn`'s `OnGameModeInit` is likewise commented out — this is dead/unfinished code kept for future custom-vehicle work, not part of the running gamemode.

**Key functions:**

| Function | Description |
|---|---|
| `stock InitVehicleModels()` (`src/support/models.pwn:17`) | Stub for registering custom vehicle models; body is fully commented out and the function is never called. |

## Used By

- [Real Estate](../modules/real.md), [Rampage Missions](../modules/rampage.md), [Drugs](../modules/drugz.md), [Combat Missions](../modules/combat.md), [Trucking Missions](../modules/trucking.md), [Deathmatch](../modules/deathmatch.md), and [Police Bribes](../modules/bribe.md) all call `EnsurePickupCreated` (`src/support/helpers.pwn`) to spawn their own gameplay pickups using the model/type constants defined here.
- [Tow Missions](../modules/tow.md) reads `gVehicleNames[]` to print a human-readable vehicle model name.
- [Authentication](../modules/auth.md) calls `AddMapicons` right after a player logs in.
- [Racing](../modules/race.md) is read by `AddMapicons` (race start points) and includes `support/mapicons.pwn` for the `E_MAPICON_ID_RACE_TOURNAMENT` icon.
