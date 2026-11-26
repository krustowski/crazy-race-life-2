# Rob Missions

A key-held robbery minigame for the **Robberz** team. A robber standing by a commercial property's offer pickup holds `LALT` (`KEY_WALK`) or `LSHIFT` (`KEY_JUMP`) to rob it for up to 20 seconds. Cash is paid out every second the key stays held. The first robbery starts a Rob Mission that counts robbed properties and money earned, and ends 5 minutes after the last successful robbery.

**Source:** `src/modules/rob.pwn` (~450 lines)

## Overview

Per-player state lives in `gRobMission[playerid]` (`RobMission` enum). Per-property lock times live in `gRobPropertyLockedUntil[]`, indexed like `gProperties[]` and holding `gettime()` timestamps. Nothing about a robbery is stored in the database, only finished missions are (see Scoring).

Flow:

1. `HandlePlayerKeyStateChange` (`modules/player.pwn`) calls `HandleRobberyKeys` before its exact-match `switch (newkeys)`, since robbing has to see both the press and the release. A press counts only for an on-foot member of `TEAM_ROBBERS` within `ROB_PROPERTY_RANGE` (6.0) of a commercial property's `OFFER_POINT` (the blue house pickup). Any other press falls through to the other key handlers.
2. `StartRobbery` refuses when the player is in another minigame (`InMinigame`), owns or rents that property, someone else is robbing it right now, or it is still locked (the message shows the time left). Otherwise it starts the mission if none is running, applies the `SHOP`/`ROB_Loop_Threat` animation and starts a 1s `UpdateRobbery` timer.
3. Each `UpdateRobbery` tick pays out `GetRobberyRate()`: `cost / 80 + random(cost / 160)`, about $980/s on an average (~$63k) commercial property. The money goes straight to the player and shows as a game text with the seconds left. The tick stops the robbery when the player has walked out of range or left the on-foot state, and after 20 ticks (`ROB_DURATION_MS`).
4. `StopRobbery` runs on key release, timeout or walking off. It locks the property for everyone for `ROB_PROPERTY_LOCK_SECONDS` (300). A robbery that paid anything counts as robbed, resets the mission countdown to 5 minutes, raises the robber's wanted level by one (a police bribe takes it down again, see [bribe.md](bribe.md)) and fires `QUEST_EVT_PROPERTY_ROBBED`. It also costs the tenant: `gPropertyCommissionBlockedUntil[arrayid]` (`real.pwn`) is set `ROB_COMMISSION_BLOCK_SECONDS` (300) ahead, and `NotifyRobbedPropertyOwner` tells the tenant, if online, that one of their rented properties was robbed, without saying which. One released before the first tick pays nothing, but the lock applies all the same.
5. `UpdateRobMissionInfoText` is the mission's own 1s clock. It counts down only while no robbery is in progress, redraws the HUD textdraw, and calls `AbortRobMission` when the countdown runs out or the player is no longer in the Robberz team.

The HUD textdraw sits in the bottom right corner (created in `support/texts.pwn`, 14 px above the rampage one, because it has one more line):

```
Robbed:  3
Earned:  $41230
Time:    4:12
```

## Scoring

`AbortRobMission` is the single exit path. It runs when the countdown expires, the player dies (`OnPlayerDeath`), disconnects (`OnPlayerDisconnect`) or leaves the team. It stops a robbery still in progress first, so that robbery's loot is counted. When `Earned > 0` it writes one `high_scores` row:

| Column | Value |
|---|---|
| `type` | `9` (`TYPE_MISSION_ROB` in `high_scores_types`, `000013`) |
| `spec_id` | `RobbedCount`, the number of properties robbed during the mission |
| `value` | `Earned`, the money taken in total |
| `user_id` | `gPlayers[playerid][OrmID]` |

`ShowHighScoresMissionRobDialog` (`support/dialogs.pwn`, "Rob" in `/scores` → Missions) lists the top 10 runs by money earned (the robbed count breaks ties), then each player's best run.

## Key Functions

| Function | Description |
|---|---|
| `public UpdateRobMissionInfoText(playerid)` | The 1s mission clock: countdown (held during a robbery), HUD redraw, team check, auto-abort. |
| `public UpdateRobbery(playerid)` | The 1s robbery tick: range/on-foot check, payout, progress game text, 20 s cutoff. |
| `stock HandleRobberyKeys(playerid, KEY: newkeys, KEY: oldkeys)` | Starts a robbery on a fresh press next to a commercial property, stops one on release. Returns 0 for any key change it does not handle. |
| `stock StartRobbery(playerid, arrayid)` | Checks minigame/owner/busy/lock, starts the mission if needed and the robbery timer. |
| `stock StopRobbery(playerid)` | Ends the robbery in progress, locks the property, counts it when it paid out. |
| `stock NotifyRobbedPropertyOwner(arrayid)` | Sends the online tenant of a robbed property `I18N_ROB_OWNER_NOTICE`, which names no property. No-op for an unrented property or an offline tenant. |
| `stock StartRobMission(playerid)` / `stock AbortRobMission(playerid)` | Mission start (sets `InMinigame`, starts the clock) and the single exit path (saves the score, hides the HUD). |
| `stock SaveRobMissionScore(playerid)` | Writes the `high_scores` row (type 9). No-op when nothing was earned. |
| `stock GetRobberyRate(arrayid)` | One second of loot for a property, scaled by its `cost`. |
| `stock GetRobbablePropertyInRange(playerid)` / `stock bool: IsPlayerAtRobbableProperty(playerid, arrayid)` | Finds the commercial property whose offer pickup the player stands by. |
| `stock bool: IsPropertyBeingRobbed(arrayid)` | Whether another player is robbing that property right now. |

## Team

The Robberz team (`TEAM_ROBBERS`, `teams.id` 10) is added by migration `000013_rob_mission.sql`:

| Field | Value |
|---|---|
| Colour | `9932CCAA` (purple) |
| Skin | 271 (Ryder) |
| Loadout | baseball bat (5) ×1, silenced 9mm (23) ×170, sawn-off (26) ×50, micro Uzi (28) ×300 |
| Salary | $1000 + up to $500, the lowest of all teams, since robbers earn by robbing |
| Map icon | `E_MAPICON_ID_RYDER` at the job pickup (`support/mapicons.pwn`) |

Joining the team prints a one-line hint on how to rob (`I18N_ROB_TEAM_HINT`, sent from `SetPlayerTeamEx`).

## Quests

Migration `000014_rob_quests.sql` adds three quests on `QUEST_EVT_PROPERTY_ROBBED`, which fires once per robbery that paid anything:

| Quest | Target | Reward |
|---|---|---|
| Rob 5 properties | 5 | $20 000 |
| Rob 50 properties | 50 | $150 000 |
| Rob 500 properties | 500 | $1 000 000 |

See [Quests](quest.md).

## Commands

None. Robbing is driven entirely by the held key; leaderboards are under `/scores`.

## Notes

- A property's lock is global: once robbed, nobody can rob it for 5 minutes. The lock is kept in memory only and resets with a server restart, and so does the commission block.
- `SendRealEstateCommission` runs every 5 minutes, so the 5-minute commission block always costs the tenant exactly the next payout from that property; their other properties still pay. A tenant who was offline at the time gets no notice later.
- The rob keys are LALT/LSHIFT under the default on-foot key bindings. A player who rebinds walk or jump uses whatever key those actions are bound to.
