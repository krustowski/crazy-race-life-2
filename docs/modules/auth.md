# Authentication

Implements the account login/registration flow players go through on connect: hashing and verifying passwords against the `users` table, creating new accounts, and kicking off the post-auth player load (properties, mapicons, spawn). It is the gate between a raw SA-MP connection and an active `gPlayers` session.

**Source:** `src/modules/auth.pwn` (~181 lines)

## Overview

Three entry points cover the whole flow:

1. `ShowAuthDialog` queries `users` by nickname; if a row exists it shows `DIALOG_LOGIN` (password-style dialog), otherwise it shows `DIALOG_REGISTER`. A commented-out line hints at a planned login timeout (`SECONDS_TO_LOGIN`) that isn't currently wired up.
2. `SetPlayerAccountLogin` re-fetches `pwdhash`/`salt` for the nickname, hashes the submitted text with `SHA256_Hash` using the stored salt, and compares it to the stored hash with `strcmp`. On mismatch it sends a "Wrong password" system message and returns 0. On success it sets `gPlayers[playerid][IsLogged] = true`, stores the row's `id` into `gPlayers[playerid][OrmID]`, then calls `LoadPlayerData`, `LoadPlayerProperties`, `AddMapicons`, `TogglePlayerControllable(playerid, true)`, and `SpawnPlayer`.
3. `SetPlayerAccountRegistration` first re-checks the nickname isn't already registered (defensive double-check), generates a 16-character random ASCII salt (values 33-126), hashes the submitted password, and `INSERT`s a new `users` row with default starting values: cash `10000`, bank `0`, adminlvl `0`, wanted `0`, team `0`, class `0`, health/armour `100.0`, spawn `0`, properties `"0,0,0,0,0"`. It then re-queries for the new row's `id` to populate `gPlayers[playerid][OrmID]`, marks the player logged in, calls `LoadPlayerData`, sets health to 100.0, and spawns the player.

There are no commands here — the flow is purely dialog + timer driven.

## Key Functions

| Function | Description |
|---|---|
| `stock SetPlayerAccountLogin(playerid, const text[])` (`src/modules/auth.pwn:13`) | Verifies a submitted password against the stored SHA-256 hash/salt for the player's nickname; on success marks the player logged in and spawns them. |
| `stock SetPlayerAccountRegistration(playerid, const text[])` (`src/modules/auth.pwn:63`) | Creates a new `users` row with default stats for a not-yet-registered nickname, logs the player in, and spawns them. |
| `public ShowAuthDialog(playerid)` (`src/modules/auth.pwn:152`) | Looks up whether the player's nickname is already registered and shows either the login or registration password dialog. |

## Commands

This module has no directly associated `/command` — it is driven by the `DIALOG_LOGIN`/`DIALOG_REGISTER` dialogs (defined in `src/support/dialogs.pwn`, handled in `src/support/response.pwn`) and by a one-shot timer. See [Commands Reference](../commands.md) if a related admin command exists (e.g. account management), though auth itself is dialog-only.

## Data & Integration

- **gPlayers[] fields:** `Name` (read, for the nickname lookup), `OrmID` (write, the DB row id), `IsLogged` (write, marks the session authenticated).
- **Database:** the `users` table — `SELECT` for existing hash/salt/id, `INSERT` on registration. See [../database.md](../database.md) for schema.
- **Integration:** `ShowAuthDialog` is scheduled from `main.pwn`'s `OnPlayerConnect` handler via `gPlayers[playerid][LoginTimer] = Timer: SetTimerEx("ShowAuthDialog", 500, false, "i", playerid)` (a direct call is commented out just above it). Dialog responses are handled in `src/support/response.pwn` (`DIALOG_LOGIN`/`DIALOG_REGISTER` cases), which call `SetPlayerAccountLogin`/`SetPlayerAccountRegistration` and re-show the dialog with an error message on failure. Calls into `LoadPlayerData`/`LoadPlayerProperties` (player.pwn) and `AddMapicons` (mapicons.pwn) after successful auth.

## Notes

- The login-timeout mechanism (`Player[playerid][LoginTimer] = SetTimerEx("OnLoginTimeout", ...)`) referenced in a comment in `ShowAuthDialog` and the `PlayTimeTimer` setup commented out in `SetPlayerAccountRegistration` are both unimplemented/disabled — players are never auto-kicked for not logging in within a time limit.
- Password comparison uses `strcmp` directly on hash strings (not a constant-time compare), and the salt is plain printable ASCII (33-126) generated with `random()`, not a cryptographically secure RNG.
