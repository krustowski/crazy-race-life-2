# Anti-Cheat

Background protection system that periodically scans connected players for banned weapons, jetpack usage, and IP-based connection flooding, then kicks or bans offenders. It has no player-facing command or menu — it runs silently as a server-side watchdog.

**Source:** `src/modules/anticheat.pwn` (~146 lines)

## Overview

The module defines three `public` timer callbacks, each iterating `MAX_PLAYERS`/`GetMaxPlayers()` and skipping disconnected players:

- `AntiCheatWeapon` inspects weapon slot 7 (`t_WEAPON_SLOT: 7`) via `GetPlayerWeaponData` and flags weapon IDs `36`, `37`, `38` (the SA-MP "minigun/heat-seeking" class of banned weapons). On detection it broadcasts a localized violation message to every connected player and kicks the offender with `Kick(i)`, unless `IsPlayerAdmin(i)` is true.
- `AntiJetPack` checks `GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK`, broadcasts a violation message, plays a sound (`1056`) on the offender, and kicks them (again exempting server admins via `IsPlayerAdmin`).
- `AntiFlood` looks for connected players with `GetPlayerPing(i) == 0` (a common flood/desync signature), excluding NPCs (`IsPlayerNPC`/`NPC_IsValid`), then fetches their IP with `GetPlayerIp`, broadcasts a violation message, plays the same warning sound, and calls `Ban(i)` directly (no admin exemption), also printing the message to console.

None of the three functions are called from within this file — they are wired up as recurring timers elsewhere (see Data & Integration). There are no thresholds/cooldowns beyond the timer intervals themselves and the hardcoded weapon IDs.

## Key Functions

| Function | Description |
|---|---|
| `public AntiCheatWeapon()` (`src/modules/anticheat.pwn:14`) | Scans all players' weapon slot 7 for banned weapon IDs 36/37/38; kicks non-admin offenders. |
| `public AntiJetPack()` (`src/modules/anticheat.pwn:58`) | Detects players using the jetpack special action; kicks non-admin offenders. |
| `public AntiFlood()` (`src/modules/anticheat.pwn:100`) | Detects zero-ping (non-NPC) connections and bans the associated IP. |

## Commands

This module has no directly associated `/command` — it is driven entirely by recurring server timers.

## Data & Integration

- **gPlayers[]:** none directly (all checks use native SA-MP player state functions, not the `gPlayers` array).
- **Database:** none.
- **Integration:** `AntiCheatWeapon` is scheduled from `src/support/timers.pwn` (`gTimers[TIMER_ANTICHEAT_WEAPON] = SetTimer("AntiCheatWeapon", 30 * SECOND_MS, true)`). `AntiFlood` is registered in the same file but currently commented out (`//gTimers[TIMER_ANTIFLOOD] = SetTimer("AntiFlood", 1 * SECOND_MS, true);`). Uses `GetLocalizedString`/`SendClientMessageLocalized`-style lookups (`I18N_WEAPON_CHEAT_VIOLATION_FMT`, `I18N_JETPACK_VIOLATION_FMT`, `I18N_IP_FLOOD_VIOLATION_FMT`) documented in [../localization.md](../localization.md). Included from `src/support/includes.pwn` right after the advertisement module, before racing/deathmatch.

## Notes

- `AntiFlood`'s ban trigger (`GetPlayerPing(i) > 0` skip, i.e. only ping-0 players are checked) combined with it being disabled by default in `timers.pwn` suggests it is either experimental or considered unreliable/prone to false positives — worth confirming before re-enabling.
- `Kick`/`Ban` calls are immediate and unconditional (aside from the `IsPlayerAdmin` exemption on the first two checks) — there is no warning count or grace period.
