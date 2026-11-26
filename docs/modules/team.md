# Teams

A player can belong to one of ten job/faction teams, or to none. The team sets the player's colour on the radar and nametag, their skin, the weapons they get back after every death, a salary paid every five minutes, and access to a handful of team-only commands and minigames. All the data (name, colour, skins, loadout, salary) lives in the `teams` table; `src/modules/team.pwn` only loads it. The team-only checks are spread across the modules that own each feature.

**Source:** `src/modules/team.pwn` (~193 lines), plus the checks listed under [Team by team](#team-by-team)

## Teams at a glance

| ID | Team | Colour | Skin | Loadout | Salary / 5 min | Team-only features | Join pickups |
|---|---|---|---|---|---|---|---|
| 0 | *(none)* | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#FFFFFF"></span> `FFFFFF` | — | — | — | — | — |
| 1 | Mechanics | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#008B8B"></span> `008B8B` | 50 | Knife, Tec-9 ×500 | $1,800–2,799 | `/fix`, repair key | 9, Pay 'n' Spray icon |
| 2 | Adminz | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#29FF06"></span> `29FF06` | 29 | Tec-9 ×1000 | $2,100–3,649 | `/hide` | 1, no icon |
| 3 | Police | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#0000BB"></span> `0000BB` | 285 | AK-47 ×500, M4 ×100, Tec-9 ×111 | $1,500–2,499 | `/search`, `/wanted` | 6, police icon |
| 4 | Truckerz | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#FF66FF"></span> `FF66FF` | 50 | Tec-9 ×100 | $1,150–2,149 | none (see below) | 1, no icon |
| 5 | Taximen | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#008000"></span> `008000` | 107 | Baseball bat, AK-47 ×100, M4 ×1000 | $1,500–2,699 | Taxi missions | 8, car impound icon |
| 6 | Dustmen | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#A52A2A"></span> `A52A2A` | 230 | Knife, Tec-9 ×10 | $1,500–1,749 | none | 1, no icon |
| 7 | Pizzaboyz | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#ADFF2F"></span> `ADFF2F` | 250 | Knife, Desert Eagle ×111 | $1,250–1,749 | Pizza minigame *(unfinished)* | 1, pizza icon |
| 8 | Hackerz | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#FFFFFF"></span> `FFFFFF` | 170 | Knife, Desert Eagle ×111 | $1,500–2,399 | Hack property vehicle locks | 1, no icon |
| 9 | Dealerz | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#FF8C00"></span> `FF8C00` | 29 | Knife, Tec-9 ×100 | $2,150–3,949 | `/deal`, `/drug`, market updates | 1, Madd Dogg icon |
| 10 | Robberz | <span style="display:inline-block;width:1em;height:1em;vertical-align:middle;border:1px solid #888;background:#9932CC"></span> `9932CC` | 271 | Baseball bat, silenced 9mm ×170, sawn-off ×50, micro Uzi ×300 | $1,000–1,499 | Property robbery | 1, Ryder icon |

Colours are stored as `RRGGBBAA` with alpha `AA`. The table shows them without the alpha. The salary range is `salary_base_dollars` plus `random(salary_volatile_dollars)`. The Truckerz colour was `FF0000` (red) until migration `000021`, see [Colours](#colours).

## What every team member gets

These apply to every team; the next section lists what each team adds on top.

- **Colour.** `SetPlayerColor` gives the player the team colour on login (`LoadPlayerData`), on joining (`SetPlayerTeamEx`) and on every spawn (`OnPlayerSpawn`). It colours the radar blip, the map marker and the nametag.
- **Team chat.** A chat line that starts with `!` goes only to online members of the sender's team, prefixed `[Team Chat]` in the team colour (`OnPlayerText` in `main.pwn`). Players without a team cannot use it; their `!` line goes to public chat.
- **Salary.** `SendPlayerSalary` runs every 5 minutes (`TIMER_SEND_PLAYER_SALARY`) and pays every logged-in team member who is not AFK, as cash, with a chat line and a game text.
- **Loadout.** On every spawn the player's weapons are reset and the team's weapons are given back 2 seconds later. Joining a team gives the loadout the same way, without the reset.
- **Skin.** Joining sets the skin to the team's first skin (`skins` holds five slots, only the first is used). Leaving does not change the skin back.
- **No friendly fire.** `SetPlayerTeam` puts the player in the SA:MP team with the same id. SA:MP blocks weapon damage between players of the same team, and damage to a vehicle driven by a teammate.
- **Druggery zones.** A druggery zone (`property_coords` type 8) of an owned property is drawn as a gang zone in the owner's team colour (`RedrawRealZones` in `real.pwn`). Joining a team, buying or selling a property redraws them for everyone.
- **Saved.** The team id is stored in `users.team` and restored on login. Joining saves the player straight away.
- **Quest.** Joining fires `QUEST_EVT_TEAM_JOINED`, which completes the "Join a team" quest (see [Quests](quest.md)).
- **Account dialog.** `/acc` shows the team name and id.

## Joining and leaving

Every row of `team_coords` is a team pickup: model 1581 (the ID card), created in `support/pickups.pwn`. Walking into one opens that team's menu with three rows: *Join team*, *Leave team* and *Cancel* (`OnPlayerSelectedMenuRow` in `main.pwn`).

- **Join team** calls `SetPlayerTeamEx`, which applies everything in the previous section. It announces "Player X joined the Y team!" to all players. There are no requirements, not even for Adminz: anyone who reaches a pickup can join. Joining while already in a team switches teams straight away.
- **Leave team** removes the player from their current team, whichever team's pickup they used. It resets their weapons, sets the colour to white and puts them in SA:MP team 0.
- Map icons mark the pickups of six teams (see the table). The pickups of Adminz, Truckerz, Dustmen and Hackerz have no map icon.

## Team by team

### Mechanics (1)

- **`/fix`** repairs the vehicle the mechanic is sitting in, for free. **`/fix [playerID]`** repairs the vehicle of another player who is driving within 10 units and is below full health, and pays the mechanic $1,500–2,499 (`dcmd_fix` in `support/dcmd.pwn`).
- **Repair key.** The sub-mission key (`2` / Num `+`) repairs every damaged vehicle within 7.5 units that has a player inside, the mechanic's own included. It pays $1,500–2,499 for each one with another player inside (`HandlePlayerKeyStateChange` in `player.pwn`). The key runs the first of these that applies: trucking, taxi, tow, pizza, repair. A mechanic in a truck therefore starts a trucking mission instead.
- The phone's "Car mechanic" option is meant to find an online mechanic, but `CheckCarMechanicsOnline()` is a stub that always says nobody is online.

### Adminz (2)

- **`/hide`** toggles the player's radar blip and map marker, by setting the alpha of their colour to `00` and back to `AA` (`dcmd_hide`). The nametag stays.
- Team membership gives no admin rights. Admin commands check `AdminLevel` or RCON login, never the team (see [Commands Reference](../commands.md)). It also works the other way round: an admin outside the team cannot use `/hide`.

### Police (3)

- **`/search [playerID] drunk`** checks a player within 15 units. If the target is driving with a drunk level above 1999, they are thrown out of the car, the car is locked for them, they are fined $25,000 and the officer gets a $4,000–9,999 bonus. Otherwise both sides get a negative result. The usage text offers a `drugz` mode, but the handler ignores the second word and always runs the drunk check.
- **`/wanted`** lists the wanted players. It is also open to admins (`AdminLevel` ≥ 1 or RCON).
- Nothing else treats police differently: kills raise the killer's wanted level the same way for every team (`RaisePlayerWantedLevel` in `radar.pwn`).

### Truckerz (4)

- No team-only command or mission. Trucking missions (`/truck`, or the sub-mission key in a truck with a trailer) are open to every player, see [Trucking Missions](trucking.md).
- What the team does get: its salary, loadout, colour and team chat.
- The ambient NPC truck drivers wear the Truckerz colour: `TRUCK_NPC_MARKER_COLOR` in `npcs.pwn` reads it from `gTeams[]` when each NPC spawns, so a colour change in the database reaches them too.
- The team pickup is in east Las Venturas, about 45 m from where `/dwarp` (open to everyone) drops players.

### Taximen (5)

- **Taxi missions** need the Taximen team and a taxi cab. Start one with `/taxi` or with the sub-mission key in a cab. Players outside the team get `I18N_TAXI_MISS_WRONG_TEAM` (see [Taxi Missions](taxi.md)).
- The ambient NPC taxi drivers wear the Taximen colour (`TAXI_NPC_MARKER_COLOR`).
- The phone's "Call Taxi" does not look for Taximen players. It points to the nearest NPC taxi stop (see [Taxi Stops](taxistop.md)).

### Dustmen (6)

- No team-only features. `TEAM_GARBAGEMEN` is not checked anywhere: there is no garbage job yet. The team gives only its salary, loadout, colour and team chat.

### Pizzaboyz (7)

- **Pizza minigame.** The sub-mission key starts a delivery, or resets one in progress (see [Pizza Delivery](pizza.md)). It is unfinished and pays nothing yet.
- The phone's "Pizza delivery" option calls `CheckPizzaguysOnline()`, a stub that always says nobody is online.

### Hackerz (8)

- **Lock hacking.** The phone's vehicle lock option (`Y`, or `/phone`) works for a hacker on any property vehicle within 7.5 units, not only their own (`response.pwn`). If the car's alarm is on, or on a 1-in-4 roll, the hack fails and sets the alarm off. Otherwise it unlocks and starts a locked car, or locks an unlocked one.
- The team colour is white, the same as players without a team, so on the radar a hacker cannot be told from a teamless player.

### Dealerz (9)

- **`/deal`** sells drugs from the dealer's pocket to another player: pick a drug, an amount, a price per unit and a buyer. The money and drugs change hands once the buyer accepts (`ProcessDealOffer` in `player.pwn`).
- **`/drug`** starts or ends the Drug Mission, a timed run collecting drug pickups (see [Drugs](drugz.md)).
- **Market updates.** Each time the black market ratio changes (every 3 minutes), online dealers get a chat line with the new ratio (`UpdateBlackMarketRatio`), plus an extra line when the daily boom peaks at 100 (see [Market ratio](drugz.md#market-ratio)).
- **The fence.** At a druggery point (skull pickup) a dealer can sell drugs straight to the server, at 60% of the market price, up to 5000 units and $1000000 per hour (see [Fence](fence.md)).

### Robberz (10)

- **Robbery.** A robber on foot by a commercial property's offer pickup holds `LALT` or `LSHIFT` to rob it for up to 20 seconds. Each robbery raises the robber's wanted level. Leaving the team ends the Rob Mission (see [Rob Missions](rob.md)).
- Joining prints a hint on how to rob (`I18N_ROB_TEAM_HINT`).
- The lowest salary of all teams, since robbers earn by robbing.

## Colours

Players see team colours next to the markers the gamemode uses for other things, so a team colour has to stay clear of those:

| Colour | Used for |
|---|---|
| Red | Race and mission checkpoints (`SetPlayerRaceCheckpoint`, `SetPlayerCheckpoint`) |
| Yellow `FFFF00` | Taxi and pizza customers, combat targets (`SetPlayerMarkerForPlayer`, `COLOR_YELLOW`) |
| White `FFFFFF` | Players without a team, and Hackerz |
| Random | NPC racers roll a new RGB colour on every spawn (`RACE_NPC_MARKER_COLOR`) |
| Alpha `00` | Hidden blips: Adminz under `/hide`, train drivers and other NPCs |

Truckerz used to be pure red `FF0000`, so a trucker looked like a checkpoint on the radar. Migration `000021_truckerz_color.sql` moves the team to light magenta `FF66FF`. That is the only hue family no team or marker uses yet. Its nearest neighbour is the darker Robberz purple `9932CC`, and it also stays clear of red under red-green colour blindness, because of its strong blue part. The new colour reaches the NPC truck drivers by itself, through `TRUCK_NPC_MARKER_COLOR`.

When you set a team colour:

- Write it as upper-case `RRGGBBAA` with alpha `AA`. `HexToInt` reads only the digits `0-9` and the upper-case letters `A-F`, so lower-case letters come out wrong.
- The server reads `teams` once, at startup (`InitTeams`). A new colour takes effect after a restart, after the migration has reached the database the server actually uses.
- `/admincol` lets admins pick light green, blue, red, orange or white for themselves. Those colours are not reserved for any team.

## Implementation

`PLAYER_TEAM` enumerates `TEAM_NONE` through `TEAM_ROBBERS` (11 values; `TEAM_ROBBERS` comes from `000013`, see [Rob Missions](rob.md)). Each team is a `Team` struct: `ID`, `TeamName`, `Color`, up to 5 `Skins`, up to `MAX_TEAM_WEAPONS` (11) `Weapons`/`Ammo` pairs, `SalaryBase`/`SalaryVolatile`, and the team's pickups (`MAX_TEAM_PICKUPS` = 16) and menus (`MAX_TEAM_MENUS` = 16).

`InitTeams()` runs once at startup and fills `gTeams[]` from the `teams` table. Its `while (DB_SelectNextRow(result))` loop moves past the first row before reading anything, so the stub row id 0 is skipped and `gTeams[0]` holds team id 1. That is why every lookup reads `gTeams[TeamID - 1]`. It also means `MAX_TEAMS` (10) must equal the number of real teams: an 11th team needs `MAX_TEAMS` raised as well. The colour string is converted with `HexToInt`; the skin, weapon and ammo lists are comma-separated strings split by `ExtractSkinsFromString` and `ExtractWeaponsAmmuFromString`.

`team.pwn` contains no join or leave logic. The pickups and menus are built in `support/pickups.pwn`, the menu choice is handled in `main.pwn` (`OnPlayerSelectedMenuRow`), and `SetPlayerTeamEx` and `IsPlayerInTeam` live in `modules/player.pwn`.

### Key functions

| Function | Description |
|---|---|
| `stock InitTeams()` (`src/modules/team.pwn:52`) | Loads every team row (name, colour, skins, weapons, ammo, salary) into `gTeams[]`. |
| `stock HexToInt(const string[])` (`src/modules/team.pwn:117`) | Parses an upper-case hex colour string into an integer. |
| `stock ExtractSkinsFromString(const input[], ints[5])` (`src/modules/team.pwn:137`) | Splits a comma-separated skin-ID string into an array. |
| `stock ExtractWeaponsAmmuFromString(const input[], ints[MAX_TEAM_WEAPONS])` (`src/modules/team.pwn:158`) | Splits a comma-separated weapon or ammo string into an array. |
| `stock CheckTaxiDriversOnline()` / `CheckCarMechanicsOnline()` / `CheckPizzaguysOnline()` (`src/modules/team.pwn:179`, `:184`, `:189`) | Stubs that always return 0. |
| `stock SetPlayerTeamEx(playerid, teamid)` (`src/modules/player.pwn:1865`) | Joins a team; `teamid` is the `gTeams[]` index, not the team id. |
| `stock bool: IsPlayerInTeam(playerid, PLAYER_TEAM: teamid)` (`src/modules/player.pwn:1060`) | The team check used by taxi, pizza, mechanics, hackers and robbers. Commands in `dcmd.pwn` compare `gPlayers[playerid][TeamID]` directly. |

### Data & integration

`gPlayers[playerid][TeamID]` holds the team id; `main.pwn` and `modules/player.pwn` write it (see [Player Core](player.md)). `gTeams[]` is read by `support/pickups.pwn` (pickups and menus), `support/dialogs.pwn` (account dialog), `modules/player.pwn` (join, salary, login colour), `modules/npcs.pwn` (NPC marker colours) and `main.pwn` (spawn, team chat, menus). `real.pwn` reads `teams.color` straight from the database for the druggery zones, and so does the map UI in `utils/mapui`. Tables: `teams` and `team_coords`, see [Database Schema](../database.md).

## Notes

- **Teamless players share team 0.** Players without a team are put in SA:MP team 0, not `NO_TEAM` (255). By SA:MP rules, players in the same team cannot hurt each other with weapons, so teamless players should not be able to shoot each other either, in deathmatch too. This has not been checked in game.
- **Adminz is open to everyone.** Joining has no `AdminLevel` check, so `/hide` is available to anyone who reaches the Adminz pickup (on a rooftop in Las Venturas).
- **`/hide` keeps its flag across spawns.** A respawn restores the visible team colour, and so does leaving the team, but `Hidden` stays set. The next `/hide` then reports "reverted" and leaves the player visible.
- **Hackerz look teamless.** Both use white `FFFFFF`.
- **Shared skins.** Mechanics and Truckerz both use skin 50; Adminz and Dealerz both use skin 29.
- **Leaving is not saved straight away.** Unlike joining, *Leave team* does not call `SavePlayerData` or redraw the druggery zones. The change reaches the database with the next periodic save.
- **One menu per pickup.** `pickups.pwn` creates a new menu for every pickup row and keeps only the last in `Menus[0]`, so teams with several pickups leave unused menus behind (30 menus in total today; SA:MP allows 128).
- `ExtractSkinsFromString` and `ExtractWeaponsAmmuFromString` are identical apart from the array size, a candidate for de-duplication.
