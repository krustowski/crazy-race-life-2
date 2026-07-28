# Radar (Speed Cameras & Vehicle HUD)

Drives the per-player vehicle-status HUD (health + a speed-derived number) and an optional speed-camera fine system for driving through marked zones too fast. Also owns `HandleCarKill`, the wanted-level bump applied when one player kills another while driving.

**Source:** `src/modules/radar.pwn` (~170 lines)

## Overview

Every 300ms, a repeating timer (`gTimers[TIMER_ON_RADAR_CHECKPOINT]`, armed in `src/support/timers.pwn:36`) fires `OnRadarCheckpoint()`, which loops all connected, non-NPC players currently in a vehicle. For each, it computes the 3D distance moved since the last tick (against the cached `gPlayerPosition[playerid]`) and turns that into a `radarValue` (`distance * 11000`) used as a speed proxy; the HUD textdraw `gVehicleStatesText[playerid]` is redrawn every tick showing vehicle health and `radarValue / 1400`, in red once that exceeds 65 (`I18N_HID_STATS_RED_FMT`) or green otherwise (`I18N_HID_STATS_GREEN_FMT`).

If the master switch `gRadarEnabled` is on, the same tick also checks whether the player is inside one of 11 hardcoded speed-camera zones (`gRadarPositions[][4]`, all in Las Venturas) via `IsPlayerInSphere`. A player caught speeding (`radarValue / 1400 > 65`) while driving (`PLAYER_STATE_DRIVER`) and not already flagged (`gRadarCaught[playerid] == 0`) is fined `RADAR_FEE` (500), gets a red message + sound, and `gRadarCaught` is latched until `OffRadarCheckpoint` clears it 5 seconds later (preventing repeat fines from lingering in the same zone).

`HandleCarKill(playerid, killerid, reason)` runs on every `OnPlayerDeath` with a valid killer (called from `main.pwn`): it always increments the killer's `WantedLevel`. If additionally the killer was driving, the victim was on foot, and the death reason wasn't `WEAPON_VEHICLE` (i.e. not a plain roadkill), it broadcasts a "car kill violation" message to all players, hides the victim's vehicle-status HUD, force-respawns the killer (via `SpawnPlayerDelayed`), and plays a sound — treating that specific combination as a more serious infraction than an ordinary roadkill.

## Key Functions

| Function | Description |
|---|---|
| `public OnRadarCheckpoint()` (`src/modules/radar.pwn:47`) | 300ms tick: updates every driving player's HUD text and, if `gRadarEnabled`, checks/fines speeding through camera zones. |
| `public OffRadarCheckpoint(playerid)` (`src/modules/radar.pwn:127`) | Timer callback that clears a player's `gRadarCaught` latch 5s after a fine. |
| `stock HandleCarKill(playerid, killerid, reason)` (`src/modules/radar.pwn:132`) | Bumps the killer's wanted level on every kill; additionally broadcasts/force-respawns for driver-vs-pedestrian non-roadkill kills. |

## Commands

None — this module has no `dcmd_*` handler. It is purely timer- and callback-driven (`OnRadarCheckpoint` timer, `HandleCarKill` from `OnPlayerDeath`).

## Data & Integration

- **`gPlayers[]` fields:** `WantedLevel` (incremented in `HandleCarKill`, then pushed to the client via `SetPlayerWantedLevel`). Money is debited via `GivePlayerMoney(i, -RADAR_FEE)`, not a direct `Cash` field write.
- **Database:** none — camera zone coordinates (`gRadarPositions`) are a hardcoded constant array, not loaded from SQLite.
- **Calls into:** localization (`I18N_HID_STATS_RED_FMT`, `I18N_HID_STATS_GREEN_FMT`, `I18N_RADAR_FEE_FMT`, `I18N_CARKILL_VIOLATION_FMT` — see [Localization](../localization.md)), `player.pwn`'s `SpawnPlayerDelayed`.
- **Called from:** `src/support/timers.pwn` (arms the 300ms `OnRadarCheckpoint` timer) and `src/main.pwn`'s `OnPlayerDeath` (calls `HandleCarKill`).

## Notes

- `gRadarEnabled` is declared `false` and never reassigned anywhere else in the codebase (confirmed by search) — the speed-camera fine system is fully wired up but permanently switched off; only the HUD health/speed textdraw is actually live in the current build.
- The commented-out `Text:KPH[MAX_PLAYERS]`/`Text:KPHR[MAX_PLAYERS]` declarations (lines 23–24) suggest an earlier, more detailed speed-HUD design that was collapsed into the single `gVehicleStatesText`.
