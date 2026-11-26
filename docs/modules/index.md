# Modules

Each page below documents one gameplay feature from `src/modules/`. For the shared infrastructure these modules build on (pickups, objects, dialogs, timers, networking...), see [Support Systems](../support/world-and-visuals.md). For the central per-player data model shared by almost every module, start with [Player Core](player.md).

## Core

| Module | Source | Summary |
|---|---|---|
| [Player Core](player.md) | `player.pwn` | The `Player` enum and `gPlayers[]` array — central per-player state used by every other module. |
| [Authentication](auth.md) | `auth.pwn` | Login/register dialog flow, password hashing, session state. |
| [Teams](team.md) | `team.pwn` | Team assignment, salaries, team chat, team-restricted commands. |
| [Anti-Cheat](anticheat.md) | `anticheat.pwn` | Scan for impossible states (weapons/ammo the server never gave, health/armour over 100, jetpack) against a ledger of hooked weapon grants; reverts, warns, kicks, logs and alerts admins. |
| [Radar](radar.md) | `radar.pwn` | HUD/speed readout and wanted-level-on-kill logic. |
| [NPC Drivers](npcs.md) | `npcs.pwn` | Generic NPC spawn/seat/playback plumbing shared by taxi, tow, trucking and race NPCs. |
| [Taxi Stops](taxistop.md) | `taxistop.pwn` | Phone "Call Taxi" navigates to the nearest NPC taxi stop; the driver announces a passenger's next stop. |
| [Quests](quest.md) | `quest.pwn` | Database-defined onboarding/achievement checklist driven by `FireQuestEvent` from ten other modules. |

## Economy

| Module | Source | Summary |
|---|---|---|
| [Banking](bank.md) | `bank.pwn` | ATM locations and proximity checks (deposit/withdraw logic lives in `player.pwn`). |
| [Drugs](drugz.md) | `drugz.pwn` | Drug catalog, pickups, druggery point data, and the black market ratio with its daily boom. |
| [Fence](fence.md) | `fence.pwn` | The server buys drugz off Dealerz at the druggery points, within hourly unit and dollar limits; sales push the ratio down. |
| [Real Estate](real.md) | `real.pwn` | Property ownership, spawn points, attached vehicles, safehouses. |
| [Police Bribes](bribe.md) | `bribe.pwn` | Wanted-level-reducing bribe pickups. |
| [Petrol Stations](fuel.md) | `fuel.pwn` | Station fuel tanks topped up by NPC tankers, sold to players with `/fuel` *(prototype)*. |
| [Prizes](prizes.md) | `prizes.pwn` | Hidden Tiki/Pumpkin treasure pickups, plus the admin show/hide editor. |

## Missions

| Module | Source | Summary |
|---|---|---|
| [Racing](race.md) | `race.pwn` | Race registration, checkpoints, timers, high scores. |
| [Pizza Delivery](pizza.md) | `pizza.pwn` | Animation-driven pizza handover minigame for Pizzaboyz. **Unfinished** — pays nothing yet. |
| [Taxi Missions](taxi.md) | `taxi.pwn` | Ad-hoc NPC taxi rides with randomized customers/destinations. |
| [Tow Missions](tow.md) | `tow.pwn` | Vehicle impound service. |
| [Trucking Missions](trucking.md) | `trucking.pwn` | Delivery points with weighted commissions/bonuses. |
| [Combat Missions](combat.md) | `combat.pwn` | Business robbery with NPC shooters *(experimental)*. |
| [Rampage Missions](rampage.md) | `rampage.pwn` | Timed street clashes with NPCs *(experimental)*. |
| [Rob Missions](rob.md) | `rob.pwn` | Robberz hold up commercial properties for cash while a key is held. |
| [Deathmatch](deathmatch.md) | `deathmatch.pwn` | Arena PvP minigame with no wanted-level penalty. |
