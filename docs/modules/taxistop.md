# Taxi Stops

Rides in the ambient NPC taxis. "Call Taxi" on the phone sets a checkpoint at the nearest commercial property that an NPC taxi stops at for at least 5 seconds, and says when the next cab gets there. The player waits there and gets in as a passenger. While they ride, the driver announces each stop he pulls up at and the one after it.

**Source:** `src/modules/taxistop.pwn` (~610 lines)

## Overview

### Where the taxis stop

The 16 taxi NPCs ([npcs.md](npcs.md)) loop through ten recordings each, `NPC_TRACK_TAXI_NN_0` to `_9`, and each segment starts where the previous one ended. `utils/taxistops/taxi_stops.py` reads them as one continuous loop per taxi and lists every spot where the cab stands still (speed < 0.01) for at least 5 s. A stop that starts at the end of one segment and goes on into the next counts once, with both parts of its duration. The output is migration `000019`, which fills two tables:

- `taxi_tracks`: how long each segment plays (`duration_ms`).
- `taxi_stops`: 182 stops, each at `time_ms` into segment `segment_no`, lasting `duration_ms`, with the cab's position and heading (`rot`).

`InitTaxiStops()` (called from `OnGameModeInit` after `InitNPCs()`) adds up `taxi_tracks` into where each segment starts in the taxi's loop (`gTaxiSegmentStart`) and how long the loop is (`gTaxiLoopMs`, 13–42 minutes). It then pairs every stop with the nearest commercial property (`properties.type = 2`) whose `OFFER_POINT` is within `TAXI_STOP_PROPERTY_RANGE` (40 m). That is one query: `MIN()` over the squared distance, with SQLite taking the property columns from the row that has the minimum. Stops with no property in range are left out. 159 of the 182 are loaded. Most of the rest are the cab's spawn spot. Because the pairing happens at load, a property built later with the in-game editor is picked up at the next restart.

Each loaded stop (`TaxiStop`) keeps its taxi, its time into the loop (`LoopMs`), its duration, the property's id and name, and a **curb point**. The checkpoint goes there and not on the road where the cab halts. It is `TAXI_STOP_CURB_OFFSET` (3.5 m) to the side of the cab that faces the property. That keeps the player off the road and puts them next to a passenger door. It also keeps them off the property's offer pickup, which would open the buy dialog.

### Where a taxi is now

`npcs.pwn` stores `GetTickCount()` in `gTaxiPlaybackTick[]` every time a taxi starts a segment. `GetTaxiLoopTime(taxiIdx)` adds the time since then to the segment's start in the loop. This resynchronises on every segment, so drift cannot build up. It is `-1` while the taxi is not driving (not spawned yet, or its `taxi_tracks` are incomplete). From that:

- `GetTaxiNextStop(taxiIdx)` is the first stop after the current time, wrapping to the first one.
- `GetTaxiStopETA(stopid)` is how long until that taxi pulls up there next.
- `GetTaxiStopSoonestETA(stopid)` is the soonest any taxi pulls up at the stop. Stops of the same property within `TAXI_STOP_MERGE_RANGE` (25 m) of each other count as one stop (`IsSameTaxiStop`), whichever taxi serves them.

### Calling a taxi

The phone's "Call Taxi" (`DIALOG_PHONE_OPTIONS`, item 3) calls `CallTaxi()` and closes the phone. It is refused during a minigame (`InMinigame`) or a pizza delivery, because pizza uses the same checkpoint. Otherwise it picks the stop nearest to the player among taxis that are driving, sets a `TAXI_STOP_CP_SIZE` (3.0) checkpoint at its curb point, and tells the player the property's name, the distance and the soonest ETA. Calling again replaces the checkpoint.

Entering the checkpoint (`CheckTaxiStopCheckpoint()`, from `OnPlayerEnterCheckpoint` after pizza) removes it. If a cab is standing at the stop right then (`IsTaxiStandingAtStop`), the player is told to get in. Otherwise they are told how long until the next one. Getting into any NPC taxi also removes a pending checkpoint, unless a pizza delivery has taken the checkpoint over since.

### Riding

`OnPlayerStateChange` calls `StartTaxiRide()` when a player becomes a passenger. If the vehicle is one of `gTaxiVehicle[]` (`GetTaxiIndexByVehicle`) and the taxi has stops, the driver welcomes them and announces the next stop with its ETA. The announcement is a chat message plus the taxi mission's "Next destination" GameText. A 1 s timer (`UpdateTaxiRide`) then watches the announced stop's ETA. Once the cab pulls up, the ETA jumps up by a whole loop. The tick takes a jump of more than half a loop as the arrival. The driver names the stop, and the next one is announced. This also works for a taxi with a single stop. The ride ends (`StopTaxiRide`) when the player leaves the vehicle, when the driver NPC is gone, or on disconnect.

Rides are free.

### Quests

Two quest events fire from here ([quest.md](quest.md)). `CheckTaxiStopCheckpoint()` fires `QUEST_EVT_TAXI_STOP_REACHED` when the player reaches the stop they called ("Call a taxi"). The `UpdateTaxiRide` tick fires `QUEST_EVT_TAXI_RIDE_STOP` each time the cab pulls up at the announced stop ("Ride a taxi", "Ride through 10 taxi stops").

## Key Functions

| Function | Description |
|---|---|
| `stock InitTaxiStops()` | Loads `taxi_tracks` and the stops that serve a commercial property; works out curb points. |
| `stock CallTaxi(playerid)` | The phone's "Call Taxi": checkpoint at the nearest stop, plus its ETA. |
| `stock CheckTaxiStopCheckpoint(playerid)` | Arrival at the called stop: removes the checkpoint, says whether a cab is there or when the next one comes. |
| `stock StartTaxiRide(playerid, vehicleid)` | A player got in as a passenger; starts the announcements if it is an NPC taxi. Returns 0 otherwise. |
| `public UpdateTaxiRide(playerid)` | The 1 s passenger tick: detects arrival at the announced stop, announces the next one. |
| `stock StopTaxiRide(playerid)` / `ResetTaxiPassenger(playerid)` | End a ride / also forget a pending call (connect and disconnect). |
| `stock GetTaxiLoopTime(taxiIdx)` | How far into its loop of recordings the taxi is, in ms, or `-1`. |
| `stock GetTaxiNextStop(taxiIdx)` / `GetTaxiStopETA(stopid)` / `GetTaxiStopSoonestETA(stopid)` | The taxi's next stop / ms until it gets to one / ms until any taxi gets to that stop. |
| `stock GetNearestTaxiStop(X, Y, Z, &distance)` | Nearest stop (by curb point) whose taxi is driving, or `-1`. |

## Commands

None. The feature is reached through `/phone` (or the `KEY_YES` phone) → "Call Taxi", and by getting into an NPC taxi as a passenger (`G`).

## Data & Integration

- **Database:** `taxi_tracks` and `taxi_stops` (migration `000019`), read once at startup and joined with `properties`/`property_coords`. See [../database.md](../database.md).
- **Generator:** `utils/taxistops/taxi_stops.py`. Rerun it when the taxi recordings change. With `--data-only` it prints the `DELETE` + `INSERT` part for a new migration. See its README.
- **Calls into:** `quest.pwn` (`FireQuestEvent`), `npcs.pwn` (`gTaxiVehicle[]`, `gTaxiDriverNPC[]`, `gTaxiPlaybackNo[]`, `gTaxiPlaybackStarted[]`, `gTaxiPlaybackTick[]`, `GetTaxiIndexByVehicle`), `pizza.pwn` (`gPizzaMission[][Active]`) and `real.pwn` constants (`OFFER_POINT`, `PROPERTY_TYPE_COMMERCIAL`).
- **Called from:** `main.pwn` (`OnGameModeInit`, `OnPlayerStateChange`, `OnPlayerEnterCheckpoint`, `OnPlayerDisconnect`), `player.pwn` (`ResetPlayerState`) and `response.pwn` (phone menu).
- **Localization:** the `I18N_TAXI_CALL_*` and `I18N_TAXI_RIDE_*` keys at the end of the `// Taxi` section. The ride banner reuses `I18N_TAXI_MISS_NEXT_DESTINATION`.

## Notes

- The phone picks the **nearest** stop, not the one with the shortest wait. A stop served by only one taxi can be a whole loop away (up to ~42 minutes for taxi 0). The ETA in the message tells the player.
- ETAs assume the NPC plays its recording in real time and that the next segment starts as soon as the previous one ends, which is what `TaxiNPC_StartNextPlayback()` does. If a player hijacks a cab and its playback stops, the announcements for it are off until the NPC drives again.
- The call uses the player's position as is. Called from inside a property interior, that is the interior's position, not the building's.
- The human Taximen team's phone call (`CheckTaxiDriversOnline()` in `team.pwn`) is still a stub. The phone no longer calls it.
