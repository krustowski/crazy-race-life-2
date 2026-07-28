# NPC Driver Plumbing

Generic lifecycle plumbing for the server-controlled "driver" NPCs used by the race, taxi, and trucking minigames: creating their vehicles and `NPC_Create` bots, spawning them into their seats, and looping their recorded-playback (`.rec`) files forever. It does not implement any of the taxi/trucking/race mission logic itself — see [taxi.md](taxi.md), [trucking.md](trucking.md), and [race.md](race.md) for what players actually do with these NPCs.

**Source:** `src/modules/npcs.pwn` (~423 lines)

## Overview

Three parallel sets of state track the three NPC kinds — race (`gRaceDriverNPC`/`gRaceVehicle`, `MAX_RACE_DRIVERS` = 2), taxi (`gTaxiDriverNPC`/`gTaxiVehicle`, `MAX_TAXI_DRIVERS` = 16), and truck (`gTruckDriverNPC`/`gTruckVehicle`/`gTruckTrailer`, `MAX_TRUCK_DRIVERS` = 2) — each with its own static spawn-coordinate table (`gRaceSpawnData`, `gTaxiSpawnData`, `gTruckSpawnData`) and a `*PlaybackNo`/`*PlaybackStarted` pair used to cycle through recording files. Truck NPCs additionally spawn a trailer vehicle (`PETROL_VEHICLE_ID`) alongside the tractor (`TRUCK_VEHICLE_ID`).

The lifecycle is driven entirely by SA-MP/open.mp NPC callbacks in `src/main.pwn`, which call back into this file:

1. `InitNPCs()` (called once from `OnGameModeInit` in `main.pwn:73`) creates every race/taxi/truck vehicle and its matching `NPC_Create()` bot up front.
2. `OnNPCCreate` (`main.pwn`) fires per bot and, via three staggered one-shot timers (100/200/300 ms), calls `Race_SpawnNPC` / `Taxi_SpawnNPC` / `Truck_SpawnNPC`, which position the NPC at its spawn row, set its skin, and call `NPC_Spawn`.
3. `OnNPCSpawn` (`main.pwn`) puts the NPC in its vehicle's driver seat (`DRIVER_SEAT` = 0) and, after a 1s timer, calls `Race_StartInitialPlayback` / `Taxi_StartInitialPlayback` / `Truck_StartInitialPlayback`, which starts recording file `NPC_TRACK_<KIND>_<idx:02d>_0`.
4. `OnNPCPlaybackEnd` (`main.pwn`) calls all three `*NPC_StartNextPlayback()` stocks unconditionally (each is a no-op if the `npcid` doesn't map to that kind); each advances to the next playback file in sequence, wrapping back to `_0` after `NUM_PLAYBACK_FILES` (10) segments for taxi/truck, or always resetting to `_0` for race (single-loop track).

`ENABLE_NPC_MARKER` (compile-time `false`) toggles whether spawned driver NPCs get a visible blip color (`RACE_NPC_MARKER_COLOR` etc.) or stay invisible on the map (`0x00000000`) — currently disabled, i.e. driver NPCs are invisible on the radar/map by design.

Note that combat/"rampage" NPCs (spawned and killed via `OnNPCRespawn`/`OnNPCDeath` in `main.pwn`) are a separate system owned by `modules/rampage.pwn`, not this file.

## Key Functions

| Function | Description |
|---|---|
| `stock InitNPCs()` (`src/modules/npcs.pwn:129`) | One-time setup: creates all race/taxi/truck vehicles (and truck trailers) and their `NPC_Create()` bots. |
| `stock GetRaceIndexByNPC(npcid)` / `GetTaxiIndexByNPC` / `GetTruckIndexByNPC` (`src/modules/npcs.pwn:90,103,116`) | Reverse-lookup an NPC id back to its slot index in the relevant array, or `-1`. |
| `public Race_SpawnNPC(npcid)` / `Taxi_SpawnNPC` / `Truck_SpawnNPC` (`src/modules/npcs.pwn:228,245,267`) | Forwarded, timer-invoked: position + skin the NPC at its spawn row, then `NPC_Spawn`. |
| `public Race_StartInitialPlayback(npcid)` / `Taxi_StartInitialPlayback` / `Truck_StartInitialPlayback` (`src/modules/npcs.pwn:289,306,330`) | Forwarded, timer-invoked once per NPC: starts the first (`_0`) recording file and marks playback started so it isn't restarted. |
| `stock RaceNPC_StartNextPlayback(npcid)` / `TaxiNPC_StartNextPlayback` / `TruckNPC_StartNextPlayback` (`src/modules/npcs.pwn:347,370,398`) | Called from `OnNPCPlaybackEnd`; advances to the next `NPC_TRACK_<KIND>_<idx>_<seq>` file, wrapping after `NUM_PLAYBACK_FILES`. |

## Commands

None — this file has no `dcmd_*` handlers. It is driven entirely by the `OnGameModeInit`/`OnNPCCreate`/`OnNPCSpawn`/`OnNPCPlaybackEnd` callbacks in `src/main.pwn` and internal timers.

## Data & Integration

- **`gPlayers[]`:** not touched by this file at all — these are NPC-only globals (`gRaceDriverNPC`, `gTaxiDriverNPC`, `gTruckDriverNPC`, etc.), indexed by NPC slot, not `playerid`.
- **Database:** none — spawn coordinates are hardcoded constant arrays in this file, not loaded from SQLite (contrast with `race.pwn`'s DB-driven race coordinates).
- **Calls into:** `open.mp`'s NPC API (`NPC_Create`, `NPC_SetPos`, `NPC_SetSkin`, `NPC_Spawn`, `NPC_StartPlayback`) and vehicle creation (`CreateVehicle`, `AddStaticVehicleEx`).
- **Called from:** `src/main.pwn`'s `OnGameModeInit`, `OnNPCCreate`, `OnNPCSpawn`, and `OnNPCPlaybackEnd` callbacks (all via `SetTimerEx` or direct call).
- **Related modules:** the taxi/trucking/race missions a player actually interacts with (`IsPlayerInTaxiCab`, `CheckPlayerForTruckingMission`, etc.) live in [taxi.md](taxi.md), [trucking.md](trucking.md), and [race.md](race.md) respectively, and consume `gTaxiVehicle[]`/`gTruckVehicle[]`/`gRaceVehicle[]` indirectly through vehicle model/position checks rather than through this file's functions.

## Notes

- A large commented-out `OnFilterScriptExit` block (lines 206–225) suggests this file was ported from a standalone filterscript and never fully adapted to run as part of the single gamemode — NPC/vehicle cleanup on unload is currently dead code.
- Several comments (`// #if TRAIN_DEBUG ... TrainStationNames[trainIdx] ...`) are leftover copy-paste from an earlier train-NPC implementation this file was adapted from; they don't reflect any train feature actually present here.
- `DEBUG` (line 6) is defined but unused within this file.
