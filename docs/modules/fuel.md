# Petrol Stations

A prototype fuel economy. Every petrol station has a fuel tank of its own. NPC truck drivers fill it up when they stop at the station with their tanker trailer hitched. Players buy fuel from the tank with `/fuel`, at that station's own price per litre. Nothing consumes fuel yet: this is groundwork for vehicles that will need to visit a station to refill.

**Source:** `src/modules/fuel.pwn` (~470 lines)

## Overview

Stations are not a separate list. Every `trucking_points` row of type `FT_GAS_STATION` (2) is one. It is placed at its `CT_CHECKPOINT` coordinate (the checkpoint trucking missions deliver to) and at its `CT_INFO_PICKUP` coordinate. `InitGasStations()` (called from `OnGameModeInit` after `InitTrucking()`) loads them into `gGasStations[]` (`GasStation` enum, up to `MAX_GAS_STATIONS` = 32) from the trucking tables alone. `LoadGasStationStock()` then fills in each station's stock from `gas_stations`. A station without a row there, such as one made with the trucking editor, keeps the defaults: half full, 10000 L capacity, $5/L. It gets its row on the first save after its stock changes.

If `gas_stations` cannot be read at all (migration `000018` not applied to the database the server opens), the stations still work on those defaults. The startup log then says `Database error: cannot read gas_stations ...` and nothing is saved. Either way the log ends with `Gas stations initialized: <count>`.

The tank shows on the station's info pickup label, under the orange name `InitTrucking()` puts there (it now keeps the label in `gTruckingPoints[id][InfoLabel]`):

```
Xoomer PS San Fierro ID 1
Tank: 5000 / 10000 L (50%)
$5 / L  /fuel
```

The label is redrawn whenever the stock changes. A station without an info pickup gets a label of its own at its checkpoint.

### NPC tankers top the stations up

`UpdateGasStations()` runs every second (`TIMER_UPDATE_GAS_STATIONS` in `support/timers.pwn`). For each truck NPC (`gTruckDriverNPC[]`, see [npcs.md](npcs.md)) it pumps `TANKER_PUMP_RATE_BASE + random(TANKER_PUMP_RATE_VOLATILE + 1)` litres (40–120 L) into the nearest station when all of these hold:

- the truck is within `GAS_STATION_RANGE` (60.0) of a station's checkpoint or info pickup (`NPC_GetPos`);
- it moved less than `TANKER_STILL_DISTANCE` (1.0) since the previous tick, so a tanker driving past does not count;
- the cab has a trailer of model `PETROL_VEHICLE_ID` (584, the tanker) attached (`IsTrailerAttachedToVehicle` + `GetVehicleTrailer`).

The amount is capped by the room left in the tank.

The truck recordings run from one station to the next. A truck used to stand there only for the few seconds left at the end of a recording. So `TruckNPC_StartNextPlayback()` (`npcs.pwn`) now holds the truck for `TRUCK_UNLOAD_MS` (30 s) when a segment ends within range of a station that has room. That works out to about 2400 L per stop. A segment that ends further out does not stop. That is 3 of the 30 current recordings: `NPC_TRACK_TRUCK_00_0` (290 m from station 11), `_01_0` (72 m from station 12) and `_01_9` (101 m from station 6).

Set `FUEL_DEBUG` to `true` to print each truck's station, distance moved and tanker state every second. A test run showed the server does see the NPC trucks' trailers as attached during playback (`tanker=1`).

### Players buy fuel

`/fuel` (`BuyFuel()`) works for the driver of any vehicle within `GAS_STATION_RANGE` of a station's checkpoint or info pickup. It sells one fill-up of `FUEL_FILL_UP_LITRES` (60). It sells less when the station has less in stock or the player cannot pay for the full amount. The cost is litres × the station's price. It refuses when the station is dry, and says to wait for a tanker.

Every sale fires `QUEST_EVT_FUEL_BOUGHT` with the litres sold as the amount ([quest.md](quest.md)). "Fill up at a petrol station" (target 1) is met by any purchase, and "Buy 1000 litres of fuel" counts litres.

## Key Functions

| Function | Description |
|---|---|
| `stock InitGasStations()` | Loads the stations from the trucking tables, then their stock, and adds the tank to their labels. |
| `stock LoadGasStationStock()` | Reads `gas_stations` over the defaults. Without the table, leaves the defaults and turns saving off. |
| `public UpdateGasStations()` | The 1s tick: standing NPC tankers pump into stations. |
| `stock GetGasStationInRange(Float: X, Float: Y, Float: Z)` | Nearest station within `GAS_STATION_RANGE` of its checkpoint or info pickup, or `-1`. Also used by `npcs.pwn` to decide on the unload stop. |
| `stock GetGasStationRoom(stationid)` | Litres the station's tank can still take. |
| `stock PumpFuelIntoGasStation(stationid, litres)` | Adds fuel, capped at capacity; returns the litres added. |
| `stock BuyFuel(playerid)` | The `/fuel` handler. |
| `stock SaveGasStationData()` | Upserts the stock of every station that changed. Called from `AutosaveData()` (every 3 minutes) and `OnGameModeExit`. Does nothing when `gas_stations` could not be read. |

## Commands

| Command | Description |
|---|---|
| `/fuel` | Buys a fill-up at the nearest petrol station, as a driver. |

## Data & Integration

- **Database:** `gas_stations` (migration `000018`), in the database the server opens, `scriptfiles/crl2_data.db` (see [database.md](../database.md)): `trucking_id` (PK, FK → `trucking_points.id`), `fuel`, `capacity` (litres), `price` ($ per litre). The migration seeds the 19 existing stations half full, at prices between $3 and $7 (`3 + (id * 7) % 5`). Only `fuel` is written back. Change `capacity` and `price` in the database.
- **Localization:** the `// Fuel` section of `support/i18n.pwn` (`I18N_FUEL_*`). The station labels are English only, like the other world labels.
- **Calls into:** `quest.pwn` (`FireQuestEvent`), `npcs.pwn` globals (`gTruckDriverNPC[]`, `gTruckVehicle[]`, `MAX_TRUCK_DRIVERS`, `PETROL_VEHICLE_ID`) and `trucking.pwn` (`CT_CHECKPOINT`, `CT_INFO_PICKUP`, `FT_GAS_STATION`, `gTruckingPoints[][InfoLabel]`).

## Notes

- Fuel is only sold, never used: vehicles do not track a fuel level yet. A fill-up is a fixed amount, not "what the tank is missing". Adding a per-vehicle level and consumption is the next step toward vehicles that must refuel.
- Only NPC trucks fill the stations. A player's petrol trucking delivery (`MT_PETROL`) does not add fuel yet.
- A truck NPC whose recordings are missing never leaves its spawn. Every truck spawns near a station, so it would keep that station topped up.
- The trailer comes unhitched for 12 s during `NPC_TRACK_TRUCK_02_6` (114–127 s, trailer id 0 in the recording). If playback carries that over, truck 2 may lose its tanker partway through that segment. It would then stop pumping until the trailer is hitched again.
