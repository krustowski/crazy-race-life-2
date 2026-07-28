# Modules

Each page below documents one gameplay feature from `src/modules/`. For the shared infrastructure these modules build on (pickups, objects, dialogs, timers, networking...), see [Support Systems](../support/world-and-visuals.md). For the central per-player data model shared by almost every module, start with [Player Core](player.md).

## Core

| Module | Source | Summary |
|---|---|---|
| [Player Core](player.md) | `player.pwn` | The `Player` enum and `gPlayers[]` array — central per-player state used by every other module. |
| [Authentication](auth.md) | `auth.pwn` | Login/register dialog flow, password hashing, session state. |
| [Teams](team.md) | `team.pwn` | Team assignment, salaries, team chat, team-restricted commands. |
| [Anti-Cheat](anticheat.md) | `anticheat.pwn` | Timer-driven watchdogs for banned weapons, jetpack use, and IP flood. |
| [Radar](radar.md) | `radar.pwn` | HUD/speed readout and wanted-level-on-kill logic. |
| [NPC Drivers](npcs.md) | `npcs.pwn` | Generic NPC spawn/seat/playback plumbing shared by taxi, tow, trucking and race NPCs. |

## Economy

| Module | Source | Summary |
|---|---|---|
| [Banking](bank.md) | `bank.pwn` | ATM locations and proximity checks (deposit/withdraw logic lives in `player.pwn`). |
| [Drugs](drugz.md) | `drugz.pwn` | Drug catalog, pickups, and druggery point data. |
| [Real Estate](real.md) | `real.pwn` | Property ownership, spawn points, attached vehicles, safehouses. |
| [Police Bribes](bribe.md) | `bribe.pwn` | Wanted-level-reducing bribe pickups. |

## Missions

| Module | Source | Summary |
|---|---|---|
| [Racing](race.md) | `race.pwn` | Race registration, checkpoints, timers, high scores. |
| [Taxi Missions](taxi.md) | `taxi.pwn` | Ad-hoc NPC taxi rides with randomized customers/destinations. |
| [Tow Missions](tow.md) | `tow.pwn` | Vehicle impound service. |
| [Trucking Missions](trucking.md) | `trucking.pwn` | Delivery points with weighted commissions/bonuses. |
| [Combat Missions](combat.md) | `combat.pwn` | Business robbery with NPC shooters *(experimental)*. |
| [Rampage Missions](rampage.md) | `rampage.pwn` | Timed street clashes with NPCs *(experimental)*. |
| [Deathmatch](deathmatch.md) | `deathmatch.pwn` | Arena PvP minigame with no wanted-level penalty. |
| [Tutorial](tutorial.md) | `tutorial.pwn` | New-player onboarding stats *(stub/experimental)*. |
