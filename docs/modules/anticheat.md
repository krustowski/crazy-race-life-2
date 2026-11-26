# Anti-Cheat

Background watchdog that looks for player states the gamemode can never produce: a weapon or ammo the server never handed out, health or armour above 100, and a jetpack. Findings are reverted, logged to the server log and announced to the admins online. Repeat offenders are kicked. It has no player-facing command or menu.

**Source:** `src/modules/anticheat.pwn` (scan, enforcement, reporting), `src/modules/anticheat_ledger.pwn` (weapon ledger + native hooks)

## Overview

### Weapon ledger

No weapon in the gamemode reaches a player except through `GivePlayerWeapon`: team loadouts on spawn and on joining, deathmatch, combat and rampage loadouts, the admin give commands and dialogs, and `/skydive`. There are no weapon-model pickups the client collects on its own (rampage weapon pickups are type 1, scripted only), world interior entrances are disabled (so no Ammu-Nation), and weapons are not saved to the database.

`anticheat_ledger.pwn` hooks `GivePlayerWeapon`, `ResetPlayerWeapons` and `SetPlayerAmmo` (ALS-style `#define` hooks) and keeps a per-player record of:

- every weapon id handed out since the last `ResetPlayerWeapons` (a bitmask), and
- the total ammo handed out per weapon slot. Weapons sharing a slot can share ammo, so the sum is the most the slot can legitimately hold.

The ledger never drops grants on death, so a stale grant can let a cheat slip through but never cause a false positive. It is cleared on connect (`ResetPlayerState` → `ResetAntiCheatState`) and whenever the gamemode calls `ResetPlayerWeapons`.

This covers the "teamless player outside a minigame with a gun" case without a rule of its own: such a player was never handed anything, so any weapon they report is flagged. The same check also catches a team member holding a weapon outside their team's loadout, and a cheat inside a minigame.

### Scan

`AntiCheatScan()` runs every `AC_SCAN_INTERVAL_MS` (3 s). It skips NPCs, players not logged in, admins (`AdminLevel > 0` or RCON), players already being kicked, and anyone not alive (dead, spectating, in class selection). For everyone else it checks:

| Check | Rule | Response |
|---|---|---|
| Jetpack | `SPECIAL_ACTION_USEJETPACK` | Kick right away (server rule) |
| Health / armour | Above `AC_MAX_VITALS` (100.0); nothing in the gamemode sets more | Clamp to 100, warning |
| Weapon never given | Reported in a slot with ammo, or held, but not in the ledger | Strip it, warning |
| Banned heavy weapon never given | Heat-seeker, flamethrower or minigun not in the ledger | Kick right away (server rule) |
| Ammo inflated | Pistols to explosives (slots 2-8, minigun excluded): reported ammo above what the slot was given | Trim to the given amount, warning |

The weapon checks rely on `GetPlayerWeaponData` and `GetPlayerWeapon`. Some reports are always ignored:

- weapons with no ammo, because spent guns linger in their slot;
- ids GTA doesn't use (19-21), which are sync noise;
- weapons the game hands out without the server: fists, the detonator that comes with satchels, and the parachute given when bailing from an aircraft.

For `AC_WEAPON_GRACE_MS` (3 s) plus the player's ping after any ledger change, weapon data isn't trusted while the client applies the change and syncs it back.

A finding is acted on only when two consecutive scans report it (same violation, same weapon), so a single sync glitch never costs a warning.

### Responses

- **Reverting** (`StripUngrantedWeapons`). It snapshots the slots and calls `ResetPlayerWeapons`, then gives back only granted weapons (plus a parachute), with ammo capped at the granted amount, and re-arms the weapon that was in hand. The rest of a legit loadout survives. The strip only uses SA-MP-era natives (no open.mp-only `RemovePlayerWeapon`/`GetWeaponSlot`), so the AMX also loads on servers that implement just the SA-MP set.
- **Warnings.** Each reverted finding counts one warning and tells the offender (`I18N_ANTICHEAT_STRIKE_FMT`). At `AC_MAX_STRIKES` (3) per session the player is kicked and everyone sees `I18N_ANTICHEAT_KICK_FMT`. Instant kicks broadcast the existing `I18N_WEAPON_CHEAT_VIOLATION_FMT` / `I18N_JETPACK_VIOLATION_FMT`. Kicks go through `DelayedKick` so the message reaches the client.
- **Monitoring** (`ReportCheatViolation`). Every finding, kicks included, is printed to the server log with an `[anticheat]` prefix and sent to the admins online as an `[ AC ]` message. The line carries the player, the finding, their team, whether they are in a minigame, and the outcome:

```
[anticheat] Foo (ID: 3): M4 (31) x500 never given | team none, minigame no | reverted, warning 1/3
[anticheat] Bar (ID: 7): Tec9 ammo 2000, given 100 | team Truckerz, minigame no | reverted, warning 2/3
[anticheat] Baz (ID: 4): jetpack | team Police, minigame no | kicked
```

`grep -a "\[anticheat\]" SAMP.LOG` lists every finding.

### IP flood

`AntiFlood()` bans non-NPC players with a ping of 0. It is unchanged and still not scheduled (its `SetTimer` in `timers.pwn` is commented out, as it broke connections in the game menu).

## Key Functions

| Function | Description |
|---|---|
| `public AntiCheatScan()` (`src/modules/anticheat.pwn`) | The periodic scan described above. |
| `FindPlayerViolation(playerid, &detail, &amount)` | First impossible state for a player: vitals, then weapon slots, then the weapon in hand. |
| `JudgeReportedWeapon(playerid, weaponid, ammo)` | Judges one reported weapon against the ledger (`AC_VIOLATION_NONE` / `_WEAPON` / `_AMMO`). Pure, so it is unit tested. |
| `PunishCheatViolation(...)` | Reverts, counts the warning, reports, and kicks when due. |
| `StripUngrantedWeapons(playerid)` | Takes back ungranted weapons and excess ammo, keeping the legit loadout. |
| `ReportCheatViolation(playerid, description[], outcome[])` | Server log line + admin alert. |
| `ResetAntiCheatState(playerid)` | Clears the ledger and warnings, called from `ResetPlayerState` on connect. |
| `RecordWeaponGrant` / `ResetWeaponLedger` / `IsWeaponGranted` / `GetGrantedSlotAmmo` (`src/modules/anticheat_ledger.pwn`) | Ledger primitives used by the hooks and the scan. |
| `AC_GivePlayerWeapon` / `AC_ResetPlayerWeapons` / `AC_SetPlayerAmmo` | The hooks; every call to the native names in the gamemode resolves to these. |

## Commands

None. Admins see findings as `[ AC ]` chat messages.

## Data & Integration

- **Include order:** `anticheat_ledger.pwn` is included from `src/support/includes.pwn` before `db/sqlite.pwn` and `support/i18n.pwn`, because `i18n.pwn` pulls in `player.pwn` and most modules, and a `#define` hook only applies to code after it. It depends on nothing but the natives. `anticheat.pwn` stays at its old spot (after `player.pwn`, whose `gPlayers[]` it reads).
- **Timer:** `gTimers[TIMER_ANTICHEAT]` in `src/support/timers.pwn`, every `AC_SCAN_INTERVAL_MS`.
- **gPlayers[]:** reads `IsLogged`, `AdminLevel`, `TeamID`, `InMinigame`, `Name`, `Locale`; also `gDeathmatch[][InGame]` and `gTeams[][TeamName]` for the report.
- **Database:** none.
- **Localization:** `I18N_ANTICHEAT_STRIKE_FMT`, `I18N_ANTICHEAT_KICK_FMT` (new, `// Anticheat` section), plus the existing `I18N_WEAPON_CHEAT_VIOLATION_FMT`, `I18N_JETPACK_VIOLATION_FMT`, `I18N_IP_FLOOD_VIOLATION_FMT`.
- **Tests:** `tests/test_anticheat.pwn`: the hooks feed the ledger, slot ammo sums, reset, slot lookup, and `JudgeReportedWeapon` verdicts.

## Notes

- **New weapon sources must go through the hooked natives.** Anything that gives a player a weapon another way would be flagged. That includes client-side pickups (weapon-model pickups of type 2, 3, 15 or 22), re-enabling interior entrances (Ammu-Nation), and SA-MP `SetSpawnInfo`/`AddPlayerClass` spawn weapons. Record those grants with `RecordWeaponGrant`.
- **Minigame weapons leak into freeroam.** A rampage aborted while the player is alive leaves them where they are with the rampage guns: `SpawnPlayerDelayed` is a no-op for living players. Combat ends with `SpawnPlayer`, which resets weapons only for team members. These weapons are in the ledger, so the anticheat doesn't flag them. Still, teamless players can legitimately walk around armed after a minigame.
- **Admins are exempt** from every check, as before. An admin giving a non-admin a minigun (`/weapon`) no longer gets the target kicked: that grant is in the ledger. Rampage pickups configured with a heavy weapon are allowed for the same reason.
