# Commands Reference

Every `/command` is dispatched through the `dcmd(name, len, cmdtext)` macro defined at `src/support/dcmd.pwn:10`, expanded once per command inside `public LoadDcmdAll(playerid, cmdtext[])` (`src/support/dcmd.pwn:14`). A match calls a `dcmd_<name>(playerid, const params[])` function — all 72 of them (40 player-facing, 32 admin-gated) are implemented directly in `src/support/dcmd.pwn`, not in the feature modules they front. See [Architecture](architecture.md#commands-dcmd) for the general pattern.

## Player Commands

These are declared under the `//--------------[ COMMON COMMANDS ]-------------|` banner at `src/support/dcmd.pwn:15` and implemented from `src/support/dcmd.pwn:101` onward. "Player" here means no `AdminLevel` check gates the command — several are still restricted to a specific **team** (noted in the description), which is a separate mechanic from admin levels.

| Command | Description | Subcommands |
|---|---|---|
| `/acc` | Opens the player's account info dialog. | — |
| `/admins` | Lists admins currently online. | — |
| `/afk` | Toggles Away-From-Keyboard: freezes controls, appends `_AFK` to the player's name, and announces the change to everyone. Blocked while registered/in a deathmatch match. | — |
| `/animoff` | Clears all animations and special actions on the player. | — |
| `/bank` | Deposit/withdraw/check balance at an ATM. Must be standing at a bank/ATM location ([`modules/bank.md`](modules/bank.md)). | `depo [amount]`, `draw [amount]`, `balance` |
| `/cmd` | Opens the common commands list dialog. | — |
| `/credits` | Shows gamemode credits and version info. | — |
| `/dance` | Plays a dance animation (`1`-`4` as an argument). Blocked while in a vehicle. | — |
| `/deal` | **Dealerz team only.** Opens the dealer offer dialog. | — (dialog-driven) |
| `/deathmatch` | Opens the deathmatch options dialog ([`modules/deathmatch.md`](modules/deathmatch.md)). | — (dialog-driven) |
| `/drug` | Toggles the drug mission on/off for the player ([`modules/drugz.md`](modules/drugz.md)). | — |
| `/drugz` | Shows the player's pocket drug inventory dialog. | — |
| `/dwarp` | Teleports the player (or their vehicle, if driving) to a shared warp point near the racing area; blocked while inside a property. Broadcast to all players. | — |
| `/fix` | **Mechanics team only.** Repairs the caller's own vehicle for free, or a nearby target's vehicle for a cash commission (target must be within 10 units and below full health). | `[playerID]` (optional) |
| `/fork` | Toggles the forklift control scheme. Only usable while driving a forklift (vehicle model 530). | — |
| `/givecash` | Transfers cash from the caller to another connected player. | `[playerID] [amount]` |
| `/help` | Opens the server help dialog. | — |
| `/hide` | **Adminz team only.** Toggles the player's visibility on the map/radar (alpha-channel trick on their blip color). | — |
| `/kill` | Commits suicide; announced to all players. | — |
| `/lay` | Plays a laying-down animation. Blocked while in a vehicle. | — |
| `/locale` | Opens the language-selection dialog. See [Localization](localization.md). | — |
| `/locate` | Prints the caller's current coordinates, facing angle, and interior ID. | — |
| `/lock` | Locks the current vehicle against every other player. Blocked during an active taxi mission. | — |
| `/phone` | Opens the phone options dialog and plays a phone-holding animation/attached prop. | — |
| `/pm` | Sends a private message to another connected player. | `[playerID] [text]` |
| `/port` | Opens the teleport/warp-locations dialog. Blocked inside a property or an active minigame. | — |
| `/prizes` | Shows info about the Tiki and Pumpkin map prizes. | — |
| `/property` | Opens the real estate dialog hub ([`modules/real.md`](modules/real.md)). | — (dialog-driven) |
| `/race` | Opens the race list, or the race options dialog if already registered for one ([`modules/race.md`](modules/race.md)). | — (dialog-driven) |
| `/rules` | Shows the server rules dialog. | — |
| `/scores` | Opens the High Scores dialog. | — |
| `/search` | **Police team only.** Checks a nearby target for drunk driving (fines and locks their car if over the legal limit, pays the officer a bonus). The usage string advertises a `drugz` mode but no such branch exists in the handler — see [Notes](#notes). | `[playerID] [drugz/drunk]` (`drugz` unimplemented) |
| `/skydive` | Gives the player a parachute and teleports them above the LV pyramid. | — |
| `/taxi` | Starts a taxi mission, or ends the active one ([`modules/taxi.md`](modules/taxi.md)). | — (dialog-driven) |
| `/text` | Sends a public "aimed" message naming both sender and a target player, visible to everyone. | `[playerID] [text]` |
| `/tow` | Toggles the tow mission on/off ([`modules/tow.md`](modules/tow.md)). | — |
| `/truck` | Starts a trucking mission, or aborts the active one ([`modules/trucking.md`](modules/trucking.md)). | — |
| `/tut` | Opens the tutorial dialog ([`modules/tutorial.md`](modules/tutorial.md)). | — |
| `/unlock` | On foot: unlocks and starts a nearby owned property vehicle within 7.5 units. In a vehicle (as driver): unlocks the current vehicle for everyone. | — |
| `/wanted` | **Police team, or `AdminLevel` ≥ 1 / RCON.** Opens the wanted-players list dialog. | — |

## Admin Commands

Declared under the `//--------------[ ADMIN COMMANDS ]-------------|` banner at `src/support/dcmd.pwn:58` and implemented from `src/support/dcmd.pwn:908` onward. Every gate below was read directly from the `if (!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < N) { ... }` check inside each `dcmd_<name>` body — **not** from the trailing `//rcon + lvl N` comments in the dispatch table, which disagree with the code for 12 of these 32 commands (see [Notes](#notes)). In every case, `IsPlayerAdmin(playerid)` (RCON) alone is sufficient to bypass the level check.

### Level 1
| Command | Description |
|---|---|
| `/acmd` | Opens the admin commands list dialog. |
| `/admincol` | Sets the caller's nametag/marker color from a 5-color admin palette. |
| `/casino` | Teleports the caller into the casino interior. |
| `/ccmd` | Only prints the `/cam` usage string — see [Notes](#notes) for why this looks incomplete. |
| `/clear` | Flushes the chat box for every connected player. |
| `/flip` | Flips upright and fully repairs the caller's own vehicle, or (with a `playerID`) a target's vehicle. |
| `/hp` | Restores 100 HP + 100 armour to a target player; blocked if the target is in a deathmatch match. |
| `/nitro` | Installs a nitro upgrade on a target's vehicle. |

### Level 2
| Command | Description |
|---|---|
| `/cam` | Attaches the caller's camera to one of three fixed positions (`0`-`3`), or detaches it back to normal. |
| `/countdown` | Starts (or cancels, if already running) a shared on-screen countdown for all players. |
| `/get` | Teleports a target player to the caller, or opens a player picker if no ID is given. |
| `/goto` | Teleports the caller to a target player, or opens a player picker if no ID is given. |
| `/skin` | Sets a target player's skin ID (`0`-`311`). |

### Level 3
| Command | Description |
|---|---|
| `/combat` | Opens the combat missions dialog, or aborts the caller's active combat mission ([`modules/combat.md`](modules/combat.md)). |
| `/crime` | Plays a GTA "crime report" police-radio sound (code `3`-`22`) for the caller. |
| `/drunk` | Sets a target player's drunk level (`0`-`50000`). |
| `/elevator` | Moves the admin elevator object. | 
| `/kick` | Kicks a target player from the server, broadcasting a message first. |
| `/packet` | Reports a target player's packet loss to the caller. |
| `/radio` | Toggles a hardcoded internet radio stream for the caller. |
| `/reset` | Resets a target player's cash to the default. |
| `/spectate` | Toggles spectator mode onto a target player, or exits spectate mode. |
| `/vehicle` | Spawns a vehicle by model ID (`400`-`611`) at the caller's position and enters it. |
| `/weapon` | Gives a target player a single weapon (1000 ammo) by numeric ID; blocked if the target is in a deathmatch match. |
| `/weapons` | Gives a target (or the caller, if no valid target) a fixed 5-weapon pack; blocked if the target is in a deathmatch match. |

`/elevator` subcommands: `up`, `down`, `stop`.

### Level 4
| Command | Description |
|---|---|
| `/ban` | Bans a target player (SA-MP native `Ban()`, IP-based), broadcasting a message first. |
| `/edit` | Opens the game editors hub dialog (property/race/trucking point editors). |
| `/fakechat` | Broadcasts a fake public chat line attributed to a target player. |
| `/lvl` | Sets a target player's admin level (`0`-`5`); the caller's own level must exceed the target's current level. |
| `/npcrec` | Opens the NPC route recording dialog, or stops an active recording session ([`modules/npcs.md`](modules/npcs.md)). |
| `/restart` | Starts (or cancels, if already running) a server-restart countdown; defaults to 60 seconds. |
| `/zone` | Draws colored gang-zone overlays over every occupied property, read live from the database. |

### RCON / Level 5
No `dcmd_` handler in `dcmd.pwn` gates specifically on level 5. Every admin command's guard is the same `!IsPlayerAdmin(playerid) && gPlayers[playerid][AdminLevel] < N` shape, so a full RCON admin (`IsPlayerAdmin(playerid) == true`) bypasses **every** level check regardless of their stored `AdminLevel`, and no command requires more than level 4. Level 5 exists only as an assignable value — `/lvl` accepts `0`-`5` — but nothing in `dcmd.pwn` checks for it.

## Notes

**The `dcmd` macro's matching trick.** `dcmd(name, len, cmdtext)` compares `cmdtext[1]` (skipping the leading `/`) against the stringized command name case-insensitively (`strcmp(..., true, len)`) for exactly `len` characters, then requires the character right after the name to be either `0` (end of string, no arguments — dispatches with `params = ""`) or a literal space (`32`, dispatches with `params = cmdtext[len+2]`, skipping the space). Two consequences worth knowing: command names are matched **case-insensitively** (`/RACE` and `/race` both work), and `len` is a hand-maintained literal in each `dcmd(...)` call in `LoadDcmdAll` — if it drifted from the actual name length, that command would silently stop matching or match the wrong prefix.

**Discrepancies vs. the README's "Vademecum" section.**

- The README's player command list is missing two commands that exist in code: `/drug` (toggle the drug mission) and `/fork` (forklift control toggle).
- The README's Admin Command List only covers levels 1-4 and is missing 6 commands that exist in code at those same levels: `/casino` and `/ccmd` (level 1), `/combat` and `/radio` (level 3), `/npcrec` and `/zone` (level 4).
- Neither the README nor the in-file dispatch-table comments mention that RCON (`IsPlayerAdmin`) universally bypasses every level check — this is implicit in every handler's `if` condition, not documented anywhere as a rule.

**Trailing dispatch-table comments (`//rcon + lvl N`) vs. actual code.** The comments next to each `dcmd(...)` call in `LoadDcmdAll` (`src/support/dcmd.pwn:60-91`) do not reliably reflect the level actually enforced inside the handler body. 12 of the 32 admin commands disagree:

| Command | Dispatch-table comment says | Code actually checks |
|---|---|---|
| `/casino` | lvl 3 | lvl 1 |
| `/combat` | lvl 4 | lvl 3 |
| `/elevator` | lvl 4 | lvl 3 |
| `/fakechat` | lvl 2 | lvl 4 |
| `/get` | lvl 3 | lvl 2 |
| `/goto` | lvl 3 | lvl 2 |
| `/nitro` | lvl 3 | lvl 1 |
| `/radio` | lvl 4 | lvl 3 |
| `/reset` | lvl 4 | lvl 3 |
| `/skin` | lvl 3 | lvl 2 |
| `/spectate` | lvl 2 | lvl 3 |
| `/vehicle` | lvl 4 | lvl 3 |

Every level cited in this page's tables comes from the `gPlayers[playerid][AdminLevel] < N` check inside the corresponding `dcmd_<name>` function, not from these comments.

**`/ccmd` looks incomplete.** Its handler (`src/support/dcmd.pwn:1079`) does nothing but `return SendUsageMessage(playerid, "/cam [0-3]")` — it has no functionality distinct from printing `/cam`'s usage string. This may be dead code or an abandoned alias.

**`/search`'s advertised `drugz` mode doesn't exist.** Its usage message reads `/search [playerID] [drugz/drunk]`, but the handler (`src/support/dcmd.pwn:684`) only ever implements the drunk-driving check; the second token is parsed but never inspected.

See [Architecture](architecture.md#commands-dcmd) for how `dcmd.pwn` fits into the rest of the gamemode's boot sequence and include order.
